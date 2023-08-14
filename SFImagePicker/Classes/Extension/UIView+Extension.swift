//
//  UIView+Extension.swift
//  SFImagePicker
//
//  Created by 이시원 on 2023/08/13.
//

import UIKit

private var key: Void?

public extension UIView {
  var imageID: UUID? {
      get { objc_getAssociatedObject(self, &key) as? UUID }
      set { objc_setAssociatedObject(self, &key, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC) }
    }
}
