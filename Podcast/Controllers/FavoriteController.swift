//
//  FavoriteController.swift
//  Podcast
//
//  Created by Gin Imor on 2/22/21.
//  Copyright © 2021 Brevity. All rights reserved.
//

import UIKit

class FavoriteController: UICollectionViewController {
  
  var favorites: [Podcast] = []
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    setupCollectionView()
  }
  
  private func setupCollectionView() {
    collectionView.backgroundColor = .systemBackground
    collectionView.register(FavoritePodcastCell.self, forCellWithReuseIdentifier: CellID.favorite)
    setupFlowLayout()
  }
  
  private func setupFlowLayout() {
    let flowLayout = collectionViewLayout as! UICollectionViewFlowLayout
    let itemWidth = (collectionView.bounds.width - 3 * 16) / 2
    
    flowLayout.itemSize = CGSize(width: itemWidth, height: itemWidth)
    flowLayout.minimumLineSpacing = 16
    flowLayout.sectionInset = UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16)
  }
  
  override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return 5 // favorites.count
  }
  
  override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CellID.favorite, for: indexPath)
    
    cell.backgroundColor = .red
    return cell
  }
}

