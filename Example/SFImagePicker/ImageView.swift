//
//  ImageView.swift
//  SFImagePicker_Example
//
//  Created by 이시원 on 2022/11/09.
//  Copyright © 2022 CocoaPods. All rights reserved.
//

import UIKit

import SnapKit

final class ImageView: UIView {
  var imageID: UUID?
  
  var image: UIImage {
    get {
      return imageView.image!
    }
    set {
      imageView.image = newValue
    }
  }
  
  private let imageView: UIImageView = {
    let imageView = UIImageView()
    imageView.layer.cornerRadius = 10
    imageView.clipsToBounds = true
    return imageView
  }()
  
  let removeButton = XButton()
  var removeAction: (() -> Void)?
  
  init() {
    super.init(frame: .zero)
    configureUI()
    removeButton.addTarget(
      self,
      action: #selector(removeButtonDidTap),
      for: .touchUpInside
    )
  }
  
  convenience init(image: UIImage) {
    self.init()
    imageView.image = image
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  private func configureUI() {
    addSubview(imageView)
    addSubview(removeButton)
    backgroundColor = .clear
    
    imageView.snp.makeConstraints {
      $0.top.right.equalToSuperview().inset(10)
      $0.bottom.left.equalToSuperview()
    }
    removeButton.snp.makeConstraints {
      $0.top.right.equalToSuperview()
    }
  }
  
  @objc
  func removeButtonDidTap() {
    removeAction?()
    self.removeFromSuperview()
  }
}
