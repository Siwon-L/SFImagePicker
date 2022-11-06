//
//  SFImageManager.swift
//  SFImagePicker
//
//  Created by 이시원 on 2022/11/06.
//

import Photos
import UIKit

public final class SFImageManager {
  private let asset: PHAsset
  public let assetID: UUID
  private let manager: PHCachingImageManager
  private let fetchOptions: PHImageRequestOptions?
  
  init(
    asset: PHAsset,
    assetID: UUID = UUID(),
    manager: PHCachingImageManager,
    fatchOptions: PHImageRequestOptions?) {
      self.asset = asset
      self.assetID = assetID
      self.manager = manager
      self.fetchOptions = fatchOptions
    }
  
  public func request(
    size: CGSize,
    completion: @escaping (UIImage?, UUID?) -> Void
  ) {
    manager.requestImage(
      for: asset,
      targetSize: size,
      contentMode: .aspectFill,
      options: fetchOptions
    ) { [weak self] image, _ in
      completion(image, self?.assetID)
    }
  }
}
