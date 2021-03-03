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
  
  let podcastNameLabel = FavoritePodcastCell.podcastNameLabel()
  let authorNameLabel = FavoritePodcastCell.authorNameLabel()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    addGestursRecognizor()
    setupCollectionView()
    fetchData()
  }
  
  private func fetchData() {
    guard let podcasts = ItunesUserDefault.fetchPodcasts() else { return }
    favorites = podcasts
  }
  
  private func addGestursRecognizor() {
    let longPress = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPress(_:)))
    collectionView.addGestureRecognizer(longPress)
  }
  
  @objc private func handleLongPress(_ longPress: UILongPressGestureRecognizer) {
    switch longPress.state {
    case .ended:
      let position = longPress.location(in: collectionView)
      guard let indexPath = collectionView.indexPathForItem(at: position) else { return }
      
      let actionSheet = UIAlertController(title: "Delete this podcast?", message: nil, preferredStyle: .actionSheet)
      actionSheet.addAction(UIAlertAction(title: "Yes", style: .destructive, handler: { (_) in
        self.favorites.remove(at: indexPath.item)
        self.collectionView.deleteItems(at: [indexPath])
        self.collectionView.collectionViewLayout.invalidateLayout()
        print("deleted index path: \(indexPath)")
        
      }))
      actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel))
      
      present(actionSheet, animated: true)
    default: ()
    }
  }
  
  private func setupCollectionView() {
    collectionView.backgroundColor = .systemBackground
    collectionView.register(FavoritePodcastCell.self, forCellWithReuseIdentifier: CellID.favorite)
    setupCarouselViewLayout(collectionViewLayout as! CarouselViewLayout)
  }
  
  private func setupCarouselViewLayout(_ layout: CarouselViewLayout) {
    let hInset: CGFloat = collectionView.frame.width * 0.1
    let itemWidth = floor(collectionView.frame.width - 2 * hInset)
    let labelPadding = 2 * UIView.defaultPadding
    let boundingRect = CGRect(x: 0, y: 0, width: itemWidth - labelPadding, height: CGFloat(MAXFLOAT))
    let podcastNameHeight = podcastNameLabel.textRect(forBounds: boundingRect, limitedToNumberOfLines: 1).height
    let authorNameHeight = authorNameLabel.textRect(forBounds: boundingRect, limitedToNumberOfLines: 1).height
    let itemHeight = ceil(itemWidth + podcastNameHeight + authorNameHeight) + 16 + 8
    
    layout.minimumLineSpacing = -itemHeight / 2
    layout.itemSize = CGSize(width: itemWidth, height: itemHeight)
  }
  
  override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return favorites.count
  }
  
  override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CellID.favorite, for: indexPath) as! FavoritePodcastCell
    
    cell.podcast = favorites[indexPath.item]
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
    collectionView.visibleCells.forEach { (cell) in
      print("alpha: \(cell.alpha)")
    }
  }
}

extension FavoriteController: UICollectionViewDelegateFlowLayout {
  
  
}