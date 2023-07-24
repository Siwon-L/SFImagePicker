
import Photos
import UIKit

private var key: Void?

public extension UIView {
  var imageID: UUID? {
      get { objc_getAssociatedObject(self, &key) as? UUID }
      set { objc_setAssociatedObject(self, &key, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC) }
    }
}

public final class SFImagePicker: UIViewController, Alertable {
  public weak var delegate: SFImagePickerDelegate?
  private var fetchResult: PHFetchResult<PHAsset>?
  private let imageManager: PHCachingImageManager = .init()
  private let mainView = SFImagePickerView()
  public let settings = SFPickerSettings()
  
  private var selectedItems = [SFAssetItem]() {
    didSet {
      mainView.setSelectionCount(selectedItems.count)
      mainView.addButton.isEnabled = selectedItems.count >= settings.selection.min
    }
  }
  var onSelection: ((_ imageManager: SFImageManager) -> Void)?
  var onDeSelction: ((_ imageManager: SFImageManager) -> Void)?
  var onFinish: ((_ imageManagers: [SFImageManager]) -> Void)?
  var onCancel: ((_ imageManagers: [SFImageManager]) -> Void)?
  
  public override func viewDidLoad() {
    super.viewDidLoad()
    configureUI()
    mainView.photoCollectionView.dataSource = self
    mainView.photoCollectionView.delegate = self
    mainView.addButton.action = #selector(addButtomDidTap)
    mainView.addButton.target = self
    mainView.cancelButton.action = #selector(cancelButtomDidTap)
    mainView.cancelButton.target = self
    PHPhotoLibrary.shared().register(self)
  }
  
  public override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    permissionCheck()
  }
  
  private func permissionCheck() {
    let photoAuthorizationStatus = PHPhotoLibrary.authorizationStatus(for: .readWrite)
    switch photoAuthorizationStatus {
    case .notDetermined:
      PHPhotoLibrary.requestAuthorization(
        for: .readWrite
      ) { [weak self] status in
        switch status {
        case .authorized:
          self?.requestCollection()
          DispatchQueue.main.async {
            self?.mainView.photoCollectionView.reloadData()
          }
        default:
          break
        }
      }
    case .authorized, .limited:
      requestCollection()
      mainView.photoCollectionView.reloadData()
    default:
      return
    }
  }
  
  private func requestCollection() {
    let cameraRoll: PHFetchResult<PHAssetCollection> = PHAssetCollection
      .fetchAssetCollections(
        with: .smartAlbum,
        subtype: .smartAlbumUserLibrary,
        options: nil
      )
    
    guard let cameraRollCollection = cameraRoll.firstObject else { return }
    let fetchOptions = PHFetchOptions()
    fetchOptions.sortDescriptors = [
      NSSortDescriptor(
        key: "creationDate",
        ascending: false
      )
    ]
    fetchResult = PHAsset.fetchAssets(in: cameraRollCollection, options: fetchOptions)
  }
  
  @objc
  private func addButtomDidTap() {
    let assetManagers = selectedItems.compactMap { $0.imageManager }
    delegate?.picker(picker: self, results: assetManagers)
    onFinish?(assetManagers)
    dismiss(animated: true)
  }
  
  @objc
  private func cancelButtomDidTap() {
    delegate?.picker(picker: self, results: [])
    onCancel?(selectedItems.compactMap { $0.imageManager })
    dismiss(animated: true)
  }
}

// MARK: - UI

extension SFImagePicker {
  private func configureUI() {
    view.backgroundColor = .systemBackground
    view.addSubview(mainView)
    mainView.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      mainView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
      mainView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
      mainView.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor),
      mainView.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor)
    ])
  }
}

extension SFImagePicker {
  private func deSelect(indexPath: IndexPath) {
    if let positionIndex = selectedItems.firstIndex(where: {
      $0.assetIdentifier == fetchResult?.object(at: indexPath.row).localIdentifier
    }) {
      let removeItem = selectedItems.remove(at: positionIndex)
      guard let removeItemImageManager = removeItem.imageManager else { return }
      onDeSelction?(removeItemImageManager)
      let selectedIndexPaths = selectedItems.map {
        IndexPath(row: $0.index, section: 0)
      }
      mainView.photoCollectionView.reloadItems(at: selectedIndexPaths + [indexPath])
    }
  }
  
  private func select(indexPath: IndexPath) {
    guard let asset = fetchResult?.object(at: indexPath.row) else { return }
    let newSelectionItem = SFAssetItem(
      index: indexPath.row,
      assetIdentifier: asset.localIdentifier,
      imageManager: .init(
        asset: asset,
        manager: imageManager,
        fatchOptions: settings.fetchOptions.options
      )
    )
    guard let newItemImageManager = newSelectionItem.imageManager else { return }
    if let selectionLimit = settings.selection.max {
      if selectionLimit > selectedItems.count {
        selectedItems.append(newSelectionItem)
        onSelection?(newItemImageManager)
      } else {
        let message = "이미지는 최대 \(selectionLimit)장까지 첨부할 수 있습니다."
        let alert = makeAlert(message: message)
        present(alert, animated: true)
      }
    } else {
      selectedItems.append(newSelectionItem)
      onSelection?(newItemImageManager)
    }
    mainView.photoCollectionView.reloadItems(at: [indexPath])
  }
}

// MARK: - Alert



// MARK: - UICollectionViewDataSource

extension SFImagePicker: UICollectionViewDataSource {
  public func collectionView(
    _ collectionView: UICollectionView,
    numberOfItemsInSection section: Int
  ) -> Int {
    return fetchResult?.count ?? 0
  }
  
  public func collectionView(
    _ collectionView: UICollectionView,
    cellForItemAt indexPath: IndexPath
  ) -> UICollectionViewCell {
    let cell = mainView.photoCollectionView.dequeueReusableCell(
      withReuseIdentifier: SFImageCell.identifier,
      for: indexPath
    ) as? SFImageCell ?? SFImageCell()
    
    guard let asset = fetchResult?.object(at: indexPath.row) else { return cell }
    cell.representedAssetIdentifier = asset.localIdentifier
    cell.selectionIndicator.circleColor = settings.ui.selectedIndicatorColor
    cell.selectionIndicator.textColor = settings.ui.selectedIndicatorTextColor
    cell.indicatorButtonDidTap = { [weak self] in
      guard let self = self else { return }
      
      let cellIsInTheSelectionPool = self.selectedItems.isInselectionPool(
        id: asset.localIdentifier,
        indexPath: indexPath
      )

      if cellIsInTheSelectionPool {
        self.deSelect(indexPath: indexPath)
      } else {
        self.select(indexPath: indexPath)
      }
    }
    
    imageManager.requestImage(
      for: asset,
      targetSize: cell.bounds.size,
      contentMode: .aspectFill,
      options: nil
    ) { image, _ in
      if cell.representedAssetIdentifier == asset.localIdentifier && image != nil {
        cell.imageView.image = image
      }
    }
    
    if let index = selectedItems.firstIndex(
      where: { $0.assetIdentifier == asset.localIdentifier }
    ) {
      cell.selectionIndicator.setNumber(index + 1)
    } else {
      cell.selectionIndicator.setNumber(nil)
    }
    
    return cell
  }
}

// MARK: - UICollectionViewDelegate

extension SFImagePicker: UICollectionViewDelegate {
  public func collectionView(
    _ collectionView: UICollectionView,
    didSelectItemAt indexPath: IndexPath
  ) {
    // 이미지 디테일
    let vc = SFDetailImageViewController(fetchResult: fetchResult!, settings: settings, selectedItems: selectedItems, indexPath: indexPath)
    vc.delegate = self
    vc.modalPresentationStyle = .fullScreen
    self.present(vc, animated: true)
  }
}

//MARK: - DetailViewDelegate

extension SFImagePicker: DetailViewDelegate {
  func detailView(didSelectItemAt indexPath: IndexPath) {
    guard let asset = fetchResult?.object(at: indexPath.row) else { return }
    let cellIsInTheSelectionPool = self.selectedItems.isInselectionPool(
      id: asset.localIdentifier,
      indexPath: indexPath
    )

    if cellIsInTheSelectionPool {
      self.deSelect(indexPath: indexPath)
    } else {
      self.select(indexPath: indexPath)
    }
  }
}

// MARK: - PHPhotoLibraryChangeObserver

extension SFImagePicker: PHPhotoLibraryChangeObserver {
  public func photoLibraryDidChange(_ changeInstance: PHChange) {
    self.requestCollection()
    DispatchQueue.main.async {
      self.mainView.photoCollectionView.reloadData()
    }
  }
}
