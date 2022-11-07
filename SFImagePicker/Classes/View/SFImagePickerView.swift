//
//  SFImagePickerView.swift
//  Pods-SFImagePicker_Example
//
//  Created by 이시원 on 2022/11/07.
//

import UIKit

final class MSImagePickerView: UIView {
  let navigationBar = UINavigationBar()
  let navigationitem = UINavigationItem(title: "사진첩")
  let addButton: UIBarButtonItem = {
    let barButton = UIBarButtonItem()
    barButton.title = "0 add"
    barButton.setTitleTextAttributes(
      [.font: UIFont.boldSystemFont(ofSize: 18)],
      for: .normal
    )
    barButton.isEnabled = false
    return barButton
  }()
  let cancelButton = UIBarButtonItem(
    barButtonSystemItem: .cancel,
    target: nil,
    action: nil
  )
  
  private(set) lazy var photoCollectionView: UICollectionView = {
    let collectionView = UICollectionView(
      frame: .zero,
      collectionViewLayout: collectionViewLayout
    )
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
    navigationitem.rightBarButtonItems = [addButton]
    navigationitem.leftBarButtonItems = [cancelButton]
    navigationBar.items = [navigationitem]
    
    addSubview(navigationBar)
    addSubview(photoCollectionView)
    navigationBar.translatesAutoresizingMaskIntoConstraints = false
    photoCollectionView.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      navigationBar.topAnchor.constraint(equalTo: self.topAnchor),
      navigationBar.rightAnchor.constraint(equalTo: self.rightAnchor),
      navigationBar.leftAnchor.constraint(equalTo: self.leftAnchor),
      navigationBar.bottomAnchor.constraint(equalTo: photoCollectionView.topAnchor)
    ])
    
    NSLayoutConstraint.activate([
      photoCollectionView.bottomAnchor.constraint(equalTo: self.safeAreaLayoutGuide.bottomAnchor),
      photoCollectionView.leftAnchor.constraint(equalTo: self.leftAnchor),
      photoCollectionView.rightAnchor.constraint(equalTo: self.rightAnchor)
    ])
    
    photoCollectionView.register(
      SFImageCell.self,
      forCellWithReuseIdentifier: SFImageCell.identifier
    )
  }
  
  private var collectionViewLayout: UICollectionViewCompositionalLayout {
    let fraction: CGFloat = 1 / 3
    
    let itemSize = NSCollectionLayoutSize(
      widthDimension: .fractionalWidth(fraction),
      heightDimension: .fractionalHeight(1)
    )
    let item = NSCollectionLayoutItem(layoutSize: itemSize)
    item.contentInsets = NSDirectionalEdgeInsets(
      top: 1,
      leading: 1,
      bottom: 1,
      trailing: 1
    )
    
    let groupSize = NSCollectionLayoutSize(
      widthDimension: .fractionalWidth(1),
      heightDimension: .fractionalWidth(fraction)
    )
    let group = NSCollectionLayoutGroup.horizontal(
      layoutSize: groupSize,
      subitems: [item]
    )
    
    let section = NSCollectionLayoutSection(group: group)
    return UICollectionViewCompositionalLayout(section: section)
  }
  
  func setSelectionCount(_ number: Int) {
    addButton.title = "\(number) add"
  }
}
