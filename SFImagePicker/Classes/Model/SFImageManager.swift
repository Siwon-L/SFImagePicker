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
  private let manager: PHCachingImageManager
  private let fatchOptions: PHImageRequestOptions?
  
  init(
    asset: PHAsset,
    manager: PHCachingImageManager,
    fatchOptions: PHImageRequestOptions?
  ) {
    self.asset = asset
    self.manager = manager
    self.fatchOptions = fatchOptions
  }
  
  public func request(
    size: CGSize,
    completion: @escaping (UIImage?, [AnyHashable : Any]?) -> Void
  ) {
    manager.requestImage(
      for: asset,
      targetSize: size,
      contentMode: .aspectFill,
      options: fatchOptions,
      resultHandler: completion)
  }
}
