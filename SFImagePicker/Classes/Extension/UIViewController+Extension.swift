//
//  UIViewController+Extension.swift
//  Pods-SFImagePicker_Example
//
//  Created by 이시원 on 2022/11/09.
//

import UIKit

public extension UIViewController {
  func presentImagePicker(
    _ picker: SFImagePicker,
    animated: Bool,
    onSelection: ((SFImageManager) -> Void)?,
    onDeSelction: ((SFImageManager) -> Void)?,
    onFinish: (([SFImageManager]) -> Void)?) {
      picker.onSelection = onSelection
      picker.onDeSelction = onDeSelction
      picker.onFinish = onFinish
      
      self.present(picker, animated: animated)
  }
}
