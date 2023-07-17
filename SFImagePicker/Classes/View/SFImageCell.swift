//
//  SFImageCell.swift
//  Pods-SFImagePicker_Example
//
//  Created by 이시원 on 2022/11/07.
//

import UIKit

final class SFImageCell: UICollectionViewCell {
  var representedAssetIdentifier: String!
  var indicatorButtonDidTap: () -> Void = {}
  
  let imageView: UIImageView = {
    let imageView = UIImageView()
    imageView.contentMode = .scaleAspectFill
    imageView.clipsToBounds = true
    imageView.backgroundColor = .black
    return imageView
  }()
  
  let selectionIndicator = SFSelectionIndicator(size: 20)
  
  override init(frame: CGRect = .zero) {
    super.init(frame: frame)
    selectionIndicator.addTarget(self, action: #selector(indicatorButtonAction), for: .touchUpInside)
    configureUI()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  private func configureUI() {
    addSubview(imageView)
    imageView.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      imageView.topAnchor.constraint(equalTo: self.topAnchor),
      imageView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
      imageView.leftAnchor.constraint(equalTo: self.leftAnchor),
      imageView.rightAnchor.constraint(equalTo: self.rightAnchor)
    ])

    addSubview(selectionIndicator)
    selectionIndicator.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      selectionIndicator.topAnchor.constraint(equalTo: self.topAnchor, constant: 5),
      selectionIndicator.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -5)
    ])
  }
  
  @objc
  private func indicatorButtonAction() {
    indicatorButtonDidTap()
  }
}
