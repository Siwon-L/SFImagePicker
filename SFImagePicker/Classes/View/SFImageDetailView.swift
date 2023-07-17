//
//  SFImageDetailView.swift
//  SFImagePicker
//
//  Created by 이시원 on 2023/07/11.
//

import UIKit

final class SFImageDetailView: UIView {
  private(set) lazy var imageCollectionView: UICollectionView = {
    let collectionView = UICollectionView(
      frame: .zero,
      collectionViewLayout: collectionViewLayout 
    )
    collectionView.isScrollEnabled = false
    return collectionView
  }()
  let navigationBar = UINavigationBar()
  let navigationItem = UINavigationItem()
  let cancelButton = UIBarButtonItem(image: .init(systemName: "xmark"), style: .plain, target: nil, action: nil)
  let selectIndecator = SFSelectionIndicator(size: 30)
  
  init() {
    super.init(frame: .zero)
    configureUI()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  private func configureUI() {
    let appearance = UINavigationBarAppearance()
    appearance.backgroundColor = .black.withAlphaComponent(0.3)
    appearance.backgroundEffect = nil
    appearance.titleTextAttributes = [.foregroundColor: UIColor.white]
    navigationBar.standardAppearance = appearance
    navigationItem.leftBarButtonItem = cancelButton
    navigationBar.items = [navigationItem]
    navigationBar.tintColor = .white

    
    addSubview(imageCollectionView)
    imageCollectionView.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      imageCollectionView.leftAnchor.constraint(equalTo: self.leftAnchor),
      imageCollectionView.rightAnchor.constraint(equalTo: self.rightAnchor),
      imageCollectionView.widthAnchor.constraint(equalTo: self.widthAnchor),
      imageCollectionView.topAnchor.constraint(equalTo: self.topAnchor),
      imageCollectionView.bottomAnchor.constraint(equalTo: self.bottomAnchor)
    ])
    
    imageCollectionView.register(
      SFImageCell.self,
      forCellWithReuseIdentifier: SFImageCell.identifier
    )
    
    addSubview(navigationBar)
    navigationBar.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      navigationBar.topAnchor.constraint(equalTo: self.topAnchor),
      navigationBar.rightAnchor.constraint(equalTo: self.rightAnchor),
      navigationBar.leftAnchor.constraint(equalTo: self.leftAnchor),
    ])
    
    
    addSubview(selectIndecator)
    selectIndecator.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      selectIndecator.topAnchor.constraint(equalTo: navigationBar.bottomAnchor, constant: 8),
      selectIndecator.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -8)
    ])
  }
  
}

extension SFImageDetailView {
  private var collectionViewLayout: UICollectionViewCompositionalLayout {
    let itemSize = NSCollectionLayoutSize(
      widthDimension: .fractionalWidth(1),
      heightDimension: .fractionalHeight(1)
    )
    let item = NSCollectionLayoutItem(layoutSize: itemSize)
    
    let groupSize = NSCollectionLayoutSize(
      widthDimension: .fractionalWidth(1),
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
