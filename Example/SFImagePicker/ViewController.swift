//
//  ViewController.swift
//  SFImagePicker
//
//  Created by 91936941 on 11/05/2022.
//  Copyright (c) 2022 91936941. All rights reserved.
//

import UIKit
import SFImagePicker
import SnapKit


class ViewController: UIViewController {
  let picker = SFImagePicker()
  @IBOutlet weak var imageStackView: UIStackView!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    // Do any additional setup after loading the view, typically from a nib.
  }
  
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    picker.settings.selection.max = 3
    picker.settings.selection.min = 2
    picker.settings.ui.selectedIndicatorColor = .green
    picker.settings.ui.selectedIndicatorTextColor = .black
    presentImagePicker(
      picker,
      animated: true) { imageManager in
        imageManager.request(
          size: .init(width: 100, height: 100))
        { image, _ in
          if let imageView = self.imageStackView.subviews.first(where: { view in
            let view = view as! ImageView
            return view.imageID == imageManager.assetID
          }) as? ImageView {
            imageView.image = image!
            return
          }
            let imageView = ImageView(image: image!)
            imageView.imageID = imageManager.assetID
            self.addView([imageView])
          }
      } onDeSelction: { imageManager in
        guard let imageView = self.imageStackView.subviews.first(where: { view in
          let view = view as! ImageView
          return view.imageID == imageManager.assetID
        }) as? ImageView else{ return }
        
        imageView.removeButtonDidTap()
      }
  }
  
  func addView(_ views: [UIView]) {
    views.forEach { view in
      imageStackView.addArrangedSubview(view)
      view.snp.makeConstraints {
        $0.width.equalTo(view.snp.height)
        $0.height.equalTo(100)
      }
    }
  }
}
