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
  
  var allowSelectingItem: Int = 0
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    setupCollectionView()
  }
  
  private func setupCollectionView() {
    collectionView.backgroundColor = .systemBackground
    collectionView.register(FavoritePodcastCell.self, forCellWithReuseIdentifier: CellID.favorite)
    setupCarouselViewLayout(collectionViewLayout as! CarouselViewLayout)
  }
  
  private func setupCarouselViewLayout(_ layout: CarouselViewLayout) {
    let hInset: CGFloat = collectionView.frame.width * 0.1
    let itemWidth = floor(collectionView.frame.width - 2 * hInset)
    let itemHeight = itemWidth + 2 * 30
    
    layout.minimumLineSpacing = -itemHeight / 2
    layout.itemSize = CGSize(width: itemWidth, height: itemHeight)
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

extension FavoriteController {
  
  override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    if indexPath.item == allowSelectingItem {
      print("did select item: \(indexPath.item)")
    }
  }
}

extension FavoriteController {
  
  override func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
    allowSelectingItem = -1
  }
  
  override func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
    guard let allowSelectingCell = collectionView.visibleCells.max(by: { $0.alpha < $1.alpha }),
      let allowSelectingIndexPath = collectionView.indexPath(for: allowSelectingCell) else { return }
    allowSelectingItem = allowSelectingIndexPath.item
    print("allow selecting item: \(allowSelectingItem)")
  }
}
