//
//  SFSelectionIndicator.swift
//  Pods-SFImagePicker_Example
//
//  Created by 이시원 on 2022/11/07.
//

import UIKit

final class SFSelectionIndicator: UIView {
  var circleColor: UIColor = .systemBlue
  
  let circle: UIView = {
    let view = UIView()
    return view
  }()
  
  let numberLabel: UILabel = {
    let label = UILabel()
    label.textColor = .white
    label.textAlignment = .center
    label.font = .systemFont(ofSize: 11)
    return label
  }()
  
  init() {
    super.init(frame: .zero)
    configureUI()
    setNumber(nil)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  private func configureUI() {
    addSubview(circle)
    addSubview(numberLabel)
    let circleSize: CGFloat = 20
    circle.layer.cornerRadius = circleSize / 2.0
    circle.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      circle.centerXAnchor.constraint(equalTo: self.centerXAnchor),
      circle.centerYAnchor.constraint(equalTo: self.centerYAnchor),
      circle.widthAnchor.constraint(equalToConstant: circleSize),
      circle.heightAnchor.constraint(equalToConstant: circleSize)
    ])
    
    numberLabel.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      numberLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor),
      numberLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor)
    ])
  }
  
  func setNumber(_ number: Int?) {
    numberLabel.isHidden = (number == nil)
    if let number = number {
      circle.backgroundColor = circleColor
      circle.layer.borderColor = UIColor.clear.cgColor
      circle.layer.borderWidth = 0
      numberLabel.text = "\(number)"
    } else {
      circle.backgroundColor = UIColor.white.withAlphaComponent(0.3)
      circle.layer.borderColor = UIColor.white.cgColor
      circle.layer.borderWidth = 1
      numberLabel.text = ""
    }
  }
}
