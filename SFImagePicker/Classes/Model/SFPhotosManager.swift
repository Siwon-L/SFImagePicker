//
//  SFPhotosManager.swift
//  SFImagePicker
//
//  Created by 이시원 on 2023/08/13.
//

import Photos

final class SFPhotosManager {
  private var fetchResult: PHFetchResult<PHAsset>?
  private let settings = SFPickerSettings.shared
  let imageManager: PHCachingImageManager = .init()
  let photosLibrary = PHPhotoLibrary.shared()
  
  var selectedItems = [SFAssetItem]() {
    didSet {
      selectedAction(selectedItems)
    }
  }
  
  var assetCount: Int? {
    fetchResult?.count
  }
  
  var selectedAction: ([SFAssetItem]) -> Void = {_ in}
  
  var selectedImageManager: [SFImageManager] {
    selectedItems.compactMap { $0.imageManager }
  }
  
  var selectedItemCount: Int {
    selectedItems.count
  }
  
  var selectedItemIndexPaths: [IndexPath] {
    selectedItems.map {
      IndexPath(row: $0.index, section: 0)
    }
  }
  
  func getAsset(at: Int) -> PHAsset? {
    fetchResult?.object(at: at)
  }
  
  func getItem(id: String) -> SFAssetItem? {
    return selectedItems.first {
      $0.assetIdentifier == id
    }
  }
  
  func getItemIndex(id: String) -> Int? {
    return selectedItems.firstIndex {
      $0.assetIdentifier == id
    }
  }
  
  
    
  func permissionCheck(_ collectionView: UICollectionView) {
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
            collectionView.reloadData()
          }
        default:
          break
        }
      }
    case .authorized, .limited:
      requestCollection()
      collectionView.reloadData()
    default:
      return
    }
  }
  
  func select(indexPath: IndexPath) -> SFAssetItem? {
    guard let asset = fetchResult?.object(at: indexPath.row) else { return nil }
    return SFAssetItem(
      index: indexPath.row,
      assetIdentifier: asset.localIdentifier,
      imageManager: .init(
        asset: asset,
        manager: imageManager,
        fatchOptions: settings.fetchOptions.options
      )
    )
  }
  
  @discardableResult
  func deSelect(indexPath: IndexPath) -> SFAssetItem? {
    if let positionIndex = selectedItems.firstIndex(where: {
      $0.assetIdentifier == fetchResult?.object(at: indexPath.row).localIdentifier
    }) {
      return selectedItems.remove(at: positionIndex)
    }
    return nil
  }
  
  func itemAppend(_ item: SFAssetItem) {
    selectedItems.append(item)
  }
  
  func requestCollection() {
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
}

