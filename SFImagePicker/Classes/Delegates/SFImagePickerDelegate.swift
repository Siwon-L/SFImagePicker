//
//  SFImagePickerDelegate.swift
//  Pods-SFImagePicker_Example
//
//  Created by 이시원 on 2022/11/09.
//

import Foundation

public protocol SFImagePickerDelegate: AnyObject {
  func picker(picker: SFImagePicker, results: [SFImageManager])
}

