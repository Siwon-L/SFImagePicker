//
//  SFPickerSettings.swift
//  SFImagePicker
//
//  Created by 이시원 on 2022/11/06.
//

import Foundation

public final class SFPickerSettings {
  public let fetchOptions: SFPickerFetchOptions
  public var ui: SFPickerUI
  public var selection: SFPickerSelection
  
  init(
    fetchOptions: SFPickerFetchOptions = .init(),
    ui: SFPickerUI = .init(),
    selection: SFPickerSelection = .init()
  ) {
    self.fetchOptions = fetchOptions
    self.ui = ui
    self.selection = selection
  }
}
