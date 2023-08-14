//
//  SFDetailImageViewController.swift
//  SFImagePicker
//
//  Created by 이시원 on 2023/07/13.
//

import UIKit

final class SFDetailImageViewController: UIViewController, Alertable {
  private let mainView: SFImageDetailView
  private let settings: SFPickerSettings = .shared
  private let photosManager: SFPhotosManager
  private let currentIndexPath: IndexPath
  weak var delegate: DetailViewDelegate?
  
  
  override func viewDidLoad() {
    super.viewDidLoad()
    mainView.imageCollectionView.dataSource = self
    mainView.imageCollectionView.delegate = self
    mainView.cancelButton.target = self
    mainView.cancelButton.action = #selector(cancelButtomDidTap)
    configuerUI()
    bindAction()
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    mainView.imageCollectionView.layoutIfNeeded()
    mainView.imageCollectionView.scrollToItem(at: currentIndexPath, at: .bottom, animated: false)
  }
  
  init(
    photosManager: SFPhotosManager,
    imageCount: Int,
    indexPath: IndexPath
  ) {
    self.photosManager = photosManager
    self.currentIndexPath = indexPath
    self.mainView = .init(totalImageCount: imageCount)
    super.init(nibName: nil, bundle: nil)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  @objc
  private func cancelButtomDidTap() {
    dismiss(animated: true)
  }
}

// MARK: - Methods

extension SFDetailImageViewController {
  private func configuerUI() {
    view.backgroundColor = .black
    view.addSubview(mainView)
    mainView.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      mainView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
      mainView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
      mainView.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor),
      mainView.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor)
    ])
    mainView.selectionIndicator.circleColor = settings.ui.selectedIndicatorColor
    mainView.selectionIndicator.textColor = settings.ui.selectedIndicatorTextColor
  }
  
  private func bindAction() {
    mainView.indicatorButtonDidTap = { [weak self] indexPath in
      guard let self = self else { return }
      self.delegate?.detailView(didSelectItemAt: indexPath)
      guard let asset = self.photosManager.getAsset(at: indexPath.row) else { return }
      
      let item = self.photosManager.getItem(id: asset.localIdentifier)

      if item == nil {
        if let selectionLimit = settings.selection.max {
          if selectionLimit <= photosManager.selectedItemCount {
            let message = "이미지는 최대 \(selectionLimit)장까지 첨부할 수 있습니다."
            let alert = makeAlert(message: message)
            present(alert, animated: true)
          }
        }
      }
      
      if let index = photosManager.getItemIndex(id: asset.localIdentifier) {
        self.mainView.selectionIndicator.setNumber(index + 1)
      } else {
        self.mainView.selectionIndicator.setNumber(nil)
      }
    }
    
    mainView.imageDidScroll = { [weak self] indexPath in
      guard let self = self else { return }
      guard let asset = self.photosManager.getAsset(at: indexPath.row) else { return }
      if let index = self.photosManager.getItemIndex(id: asset.localIdentifier) {
        self.mainView.selectionIndicator.setNumber(index + 1)
      } else {
        self.mainView.selectionIndicator.setNumber(nil)
      }
    }
  }
}

// MARK: - UICollectionViewDataSource & Delegate

extension SFDetailImageViewController: UICollectionViewDataSource, UICollectionViewDelegate {
  func collectionView(
    _ collectionView: UICollectionView,
    numberOfItemsInSection section: Int
  ) -> Int {
    return photosManager.assetCount ?? 0
  }
  
  func collectionView(
    _ collectionView: UICollectionView,
    cellForItemAt indexPath: IndexPath
  ) -> UICollectionViewCell {
    let cell = mainView.imageCollectionView.dequeueReusableCell(
      withReuseIdentifier: SFImageCell.identifier,
      for: indexPath
    ) as? SFImageCell ?? SFImageCell()
    
    guard let asset = photosManager.getAsset(at: indexPath.row) else { return SFImageCell() }
    cell.representedAssetIdentifier = asset.localIdentifier
    cell.imageView.contentMode = .scaleAspectFit
    cell.selectionIndicator.isHidden = true
    
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
    
    return cell
  }
}
