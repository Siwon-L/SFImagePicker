//
//  SFImageDatailView.swift
//  SFImagePicker
//
//  Created by 이시원 on 2023/07/11.
//

import UIKit

final class SFImageDatailView: UIView {
  private(set) lazy var imageCollectionView: UICollectionView = {
    let collectionView = UICollectionView(
      frame: .zero,
      collectionViewLayout: collectionViewLayout 
    )
    collectionView.isScrollEnabled = false
    return collectionView
  }()
  
  init() {
    super.init(frame: .zero)
    configureUI()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  private func configureUI() {
    addSubview(imageCollectionView)
    imageCollectionView.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      imageCollectionView.topAnchor.constraint(equalTo: self.topAnchor),
      imageCollectionView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
      imageCollectionView.centerXAnchor.constraint(equalTo: self.centerXAnchor),
      imageCollectionView.widthAnchor.constraint(equalTo: self.widthAnchor)
    ])
  }
  
}

extension SFImageDatailView {
  private var collectionViewLayout: UICollectionViewCompositionalLayout {
    let itemSize = NSCollectionLayoutSize(
      widthDimension: .fractionalWidth(1),
      heightDimension: .fractionalHeight(1)
    )
    let item = NSCollectionLayoutItem(layoutSize: itemSize)
    
    let groupSize = NSCollectionLayoutSize(
      widthDimension: .fractionalHeight(1),
      heightDimension: .fractionalHeight(1)
    )
    let group = NSCollectionLayoutGroup.horizontal(
      layoutSize: groupSize,
      subitems: [item]
    )
    
    let section = NSCollectionLayoutSection(group: group)
    section.orthogonalScrollingBehavior = .paging
    return UICollectionViewCompositionalLayout(section: section)
  }
}
