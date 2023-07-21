//
//  Array+Extension.swift
//  SFImagePicker
//
//  Created by 이시원 on 2023/07/21.
//

import Foundation
import Photos

extension Array where Element: SFAssetItem {
  func isInselectionPool(id: String, indexPath: IndexPath) -> Bool {
    return self.contains {
      $0.assetIdentifier == id
    }
  }
}
