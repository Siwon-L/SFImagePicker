//
//  SFPickerUI.swift
//  SFImagePicker
//
//  Created by 이시원 on 2022/11/06.
//

import UIKit

public struct SFPickerUI {
  public var selectedIndicatorColor: UIColor
  public var selectedIndicatorTextColor: UIColor
  
  init(
    selectedIndicatorColor: UIColor = .systemBlue,
    selectedIndicatorTextColor: UIColor = .white
  ) {
    self.selectedIndicatorColor = selectedIndicatorColor
    self.selectedIndicatorTextColor = selectedIndicatorTextColor
  }
}
