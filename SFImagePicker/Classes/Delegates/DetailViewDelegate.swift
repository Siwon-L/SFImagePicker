//
//  DetailViewDelegate.swift
//  SFImagePicker
//
//  Created by 이시원 on 2023/07/24.
//

import Foundation

protocol DetailViewDelegate: AnyObject {
  func detailView(didSelectItemAt indexPath: IndexPath)
}
