//
//  SFDetailImageViewController.swift
//  SFImagePicker
//
//  Created by 이시원 on 2023/07/13.
//

import UIKit
import Photos

final class SFDetailImageViewController: UIViewController {
  let mainView = SFImageDetailView()
  private let fetchResult: PHFetchResult<PHAsset>
  private let imageManager: PHCachingImageManager = .init()
  private let settings: SFPickerSettings
  private var selectedItems: [SFAssetItem]
  private let currentIndexPath: IndexPath
  private let xMarkButton = UIButton()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    mainView.imageCollectionView.dataSource = self
    xMarkButton.addTarget(self, action: #selector(xMarkButtomDidTap), for: .touchUpInside)
    configuerUI()
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
    super.init(nibName: nil, bundle: nil)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  @objc
  private func xMarkButtomDidTap() {
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
    
    xMarkButton.setImage(.init(systemName: "xmark"), for: .normal)
    xMarkButton.tintColor = .systemGray6
    view.addSubview(xMarkButton)
    xMarkButton.translatesAutoresizingMaskIntoConstraints = false
    
    NSLayoutConstraint.activate([
      xMarkButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
      xMarkButton.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor, constant: -8),
      xMarkButton.widthAnchor.constraint(equalToConstant: 25),
      xMarkButton.heightAnchor.constraint(equalTo: xMarkButton.widthAnchor)
    ])
    
    if let xMarkImage = xMarkButton.imageView {
      xMarkImage.translatesAutoresizingMaskIntoConstraints = false
      NSLayoutConstraint.activate([
        xMarkImage.widthAnchor.constraint(equalTo: xMarkButton.widthAnchor),
        xMarkImage.heightAnchor.constraint(equalTo: xMarkButton.heightAnchor)
      ])
    }
  }
}

// MARK: - UICollectionViewDataSource

extension SFDetailImageViewController: UICollectionViewDataSource {
  public func collectionView(
    _ collectionView: UICollectionView,
    numberOfItemsInSection section: Int
  ) -> Int {
    return fetchResult.count
  }
  
  public func collectionView(
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
    cell.indicatorButtonDidTap = { [weak self] in
      
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
