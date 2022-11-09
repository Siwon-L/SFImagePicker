//
//  SFPickerFetchOptions.swift
//  SFImagePicker
//
//  Created by 이시원 on 2022/11/06.
//

import Photos

public final class SFPickerFetchOptions {
  let options = PHImageRequestOptions()
  
  public var isSynchronous: Bool {
    get {
      return options.isSynchronous
    }
    set {
      options.isSynchronous = newValue
    }
  }
}
