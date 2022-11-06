//
//  SFAssetItem.swift
//  SFImagePicker
//
//  Created by 이시원 on 2022/11/06.
//

import Foundation

final class SFAssetItem {
  let index: Int
  let assetIdentifier: String
  let imageManager: SFImageManager
  
  init(
    index: Int,
    assetIdentifier: String,
    imageManager: SFImageManager
  ) {
    self.index = index
    self.assetIdentifier = assetIdentifier
    self.imageManager = imageManager
  }
}
