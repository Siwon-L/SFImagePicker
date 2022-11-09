//
//  XButton.swift
//  SFImagePicker_Example
//
//  Created by 이시원 on 2022/11/09.
//  Copyright © 2022 CocoaPods. All rights reserved.
//

import UIKit

import SnapKit

public final class XButton: UIButton {
  private let xmarkImageView: UIImageView = {
    let ximage = UIImage(systemName: "x.circle.fill")
    let imageView = UIImageView(image: ximage)
    imageView.clipsToBounds = true
    return imageView
  }()
  
  public init() {
    super.init(frame: .zero)
    configureUI()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  private func configureUI() {
    let size: CGFloat = 25
    xmarkImageView.layer.cornerRadius = size / 2.0
    xmarkImageView.backgroundColor = .white
    xmarkImageView.tintColor = .black
    addSubview(xmarkImageView)
    self.snp.makeConstraints {
      $0.width.height.equalTo(size)
    }
    xmarkImageView.snp.makeConstraints {
      $0.center.equalToSuperview()
      $0.width.height.equalTo(self.snp.width)
    }
  }
}
