//
//  SFPickerSelection.swift
//  SFImagePicker
//
//  Created by 이시원 on 2022/11/06.
//

import Foundation

public struct SFPickerSelection {
  public var max: Int?
  public var min: Int
  
  init(
    max: Int? = nil,
    min: Int = 1
  ) {
    self.max = max
    self.min = min
  }
}
