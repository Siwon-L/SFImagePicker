
import Photos
import UIKit

public final class SFImagePicker: UIViewController, Alertable {
  private let photosManager = SFPhotosManager()
  public weak var delegate: SFImagePickerDelegate?
  private let mainView = SFImagePickerView()
  public let settings = SFPickerSettings.shared
  
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
    photosManager.selectedAction = { [weak self] items in
      guard let self = self else { return }
      self.mainView.setSelectionCount(items.count)
      self.mainView.addButton.isEnabled = items.count >= self.settings.selection.min
    }
    photosManager.photosLibrary.register(self)
  }
  
  public override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    photosManager.permissionCheck(mainView.photoCollectionView)
  }
  
  @objc
  private func addButtomDidTap() {
    let assetManagers = photosManager.selectedImageManager
    delegate?.picker(picker: self, results: assetManagers)
    onFinish?(assetManagers)
    dismiss(animated: true)
  }
  
  @objc
  private func cancelButtomDidTap() {
    delegate?.picker(picker: self, results: [])
    onCancel?(photosManager.selectedImageManager)
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
    if let removeItem = photosManager.deSelect(indexPath: indexPath) {
      guard let removeItemImageManager = removeItem.imageManager else { return }
      onDeSelction?(removeItemImageManager)
      mainView.photoCollectionView.reloadItems(at: photosManager.selectedItemIndexPaths + [indexPath])
    }
  }
  
  private func select(indexPath: IndexPath) {
    guard let newSelecedItem = photosManager.select(indexPath: indexPath) else { return }
    guard let newItemImageManager = newSelecedItem.imageManager else { return }
    
    if let selectionLimit = settings.selection.max {
      if selectionLimit > photosManager.selectedItemCount {
        photosManager.itemAppend(newSelecedItem)
        onSelection?(newItemImageManager)
      } else {
        let message = "이미지는 최대 \(selectionLimit)장까지 첨부할 수 있습니다."
        let alert = makeAlert(message: message)
        present(alert, animated: true)
      }
    } else {
      photosManager.itemAppend(newSelecedItem)
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
    return photosManager.assetCount ?? 0
  }
  
  public func collectionView(
    _ collectionView: UICollectionView,
    cellForItemAt indexPath: IndexPath
  ) -> UICollectionViewCell {
    let cell = mainView.photoCollectionView.dequeueReusableCell(
      withReuseIdentifier: SFImageCell.identifier,
      for: indexPath
    ) as? SFImageCell ?? SFImageCell()
    
    guard let asset = photosManager.getAsset(at: indexPath.row) else { return cell }
    cell.representedAssetIdentifier = asset.localIdentifier
    cell.selectionIndicator.circleColor = settings.ui.selectedIndicatorColor
    cell.selectionIndicator.textColor = settings.ui.selectedIndicatorTextColor
    let item = self.photosManager.getItem(id: asset.localIdentifier)
    cell.indicatorButtonDidTap = { [weak self] in
      guard let self = self else { return }
      if item != nil {
        self.deSelect(indexPath: indexPath)
      } else {
        self.select(indexPath: indexPath)
      }
    }
    
    photosManager.imageManager.requestImage(
      for: asset,
      targetSize: cell.bounds.size,
      contentMode: .aspectFill,
      options: nil
    ) { image, _ in
      if cell.representedAssetIdentifier == asset.localIdentifier && image != nil {
        cell.imageView.image = image
      }
    }
    
    if let index = photosManager.getItemIndex(id: asset.localIdentifier) {
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
    guard let imageCount = photosManager.assetCount else { return }
    let vc = SFDetailImageViewController(photosManager: photosManager, imageCount: imageCount, indexPath: indexPath)
    vc.delegate = self
    vc.modalPresentationStyle = .fullScreen
    self.present(vc, animated: true)
  }
}

//MARK: - DetailViewDelegate

extension SFImagePicker: DetailViewDelegate {
  func detailView(didSelectItemAt indexPath: IndexPath) {
    guard let asset = photosManager.getAsset(at: indexPath.row) else { return }
    let item = photosManager.getItem(id: asset.localIdentifier)
    if item != nil {
      deSelect(indexPath: indexPath)
    } else {
      select(indexPath: indexPath)
    }
  }
}

// MARK: - PHPhotoLibraryChangeObserver

extension SFImagePicker: PHPhotoLibraryChangeObserver {
  public func photoLibraryDidChange(_ changeInstance: PHChange) {
    photosManager.requestCollection()
    DispatchQueue.main.async {
      self.mainView.photoCollectionView.reloadData()
    }
  }
}
