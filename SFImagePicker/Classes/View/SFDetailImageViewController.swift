//
//  SFDetailImageViewController.swift
//  SFImagePicker
//
//  Created by 이시원 on 2023/07/13.
//

import UIKit
import Photos

final class SFDetailImageViewController: UIViewController {
  private let mainView: SFImageDetailView
  private let fetchResult: PHFetchResult<PHAsset>
  private let imageManager: PHCachingImageManager = .init()
  private let settings: SFPickerSettings
  private var selectedItems: [SFAssetItem]
  private let currentIndexPath: IndexPath
  
  
  override func viewDidLoad() {
    super.viewDidLoad()
    mainView.imageCollectionView.dataSource = self
    mainView.imageCollectionView.delegate = self
    mainView.cancelButton.target = self
    mainView.cancelButton.action = #selector(cancelButtomDidTap)
    configuerUI()
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    mainView.imageCollectionView.layoutIfNeeded()
    mainView.imageCollectionView.scrollToItem(at: currentIndexPath, at: .bottom, animated: false)
  }
  
  init(
    fetchResult: PHFetchResult<PHAsset>,
    settings: SFPickerSettings,
    selectedItems: [SFAssetItem],
    indexPath: IndexPath
  ) {
    self.fetchResult = fetchResult
    self.settings = settings
    self.selectedItems = selectedItems
    self.currentIndexPath = indexPath
    self.mainView = .init(totalImageCount: fetchResult.count)
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
  }
}

// MARK: - UICollectionViewDataSource & Delegate

extension SFDetailImageViewController: UICollectionViewDataSource, UICollectionViewDelegate {
  func collectionView(
    _ collectionView: UICollectionView,
    numberOfItemsInSection section: Int
  ) -> Int {
    return fetchResult.count
  }
  
  func collectionView(
    _ collectionView: UICollectionView,
    cellForItemAt indexPath: IndexPath
  ) -> UICollectionViewCell {
    let cell = mainView.imageCollectionView.dequeueReusableCell(
      withReuseIdentifier: SFImageCell.identifier,
      for: indexPath
    ) as? SFImageCell ?? SFImageCell()
    
    let asset = fetchResult.object(at: indexPath.row)
    cell.representedAssetIdentifier = asset.localIdentifier
    cell.selectionIndicator.circleColor = settings.ui.selectedIndicatorColor
    cell.imageView.contentMode = .scaleAspectFit
    cell.selectionIndicator.isHidden = true
    
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
