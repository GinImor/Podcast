//
//  FavoriteController.swift
//  Podcast
//
//  Created by Gin Imor on 2/22/21.
//  Copyright © 2021 Brevity. All rights reserved.
//

import UIKit

class FavoritesController: UICollectionViewController {
  
  var favorites: [Podcast] {
    ItunesUserDefault.shared.savedPodcasts
  }
  
  var allowSelectingItem: Int = 0
  var needToReload = false
  
  let podcastNameLabel = FavoritePodcastCell.podcastNameLabel()
  let authorNameLabel = FavoritePodcastCell.authorNameLabel()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    addGestursRecognizor()
    setupCollectionView()
    setupNotification()
  }
  
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    if needToReload {
      collectionView.reloadData()
      needToReload = false
    }
  }
  
  private func setupNotification() {
    NotificationCenter.default.addObserver(forName: .favoritePodcastsDidChange, object: nil, queue: nil) { (_) in
      self.needToReload = true
    }
  }
  
  private func addGestursRecognizor() {
    let longPress = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPress(_:)))
    longPress.delegate = self
    collectionView.addGestureRecognizer(longPress)
  }
  
  @objc private func handleLongPress(_ longPress: UILongPressGestureRecognizer) {
    switch longPress.state {
    case .ended:
      guard let indexPath = indexPathForGestureRecognizer(longPress) else { return }
      
      let actionSheet = UIAlertController(title: "Delete this podcast?", message: nil, preferredStyle: .actionSheet)
      actionSheet.addAction(UIAlertAction(title: "Yes", style: .destructive, handler: { (_) in
        ItunesUserDefault.shared.deletePodcast(self.favoriteFor(indexPath: indexPath))
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
  
  private func indexPathForGestureRecognizer(_ gestureRecognizer: UIGestureRecognizer) -> IndexPath? {
    let location = gestureRecognizer.location(in: collectionView)
    return collectionView.indexPathForItem(at: location)
  }
  
  override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return favorites.count
  }
  
  private func favoriteFor(indexPath: IndexPath) -> Podcast {
    let lastItem = favorites.count - 1
    return favorites[lastItem - indexPath.item]
  }
  
  override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CellID.favorite, for: indexPath) as! FavoritePodcastCell
    
    cell.podcast = favoriteFor(indexPath: indexPath)
    return cell
  }
}

extension FavoritesController {
  
  override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    if indexPath.item == allowSelectingItem {
      let episodesController = EpisodesController()
      episodesController.podcast = favoriteFor(indexPath: indexPath)
      navigationController?.pushViewController(episodesController, animated: true)
    }
  }
}

extension FavoritesController {
  
  override func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
    allowSelectingItem = -1
  }
  
  override func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
    guard let allowSelectingCell = collectionView.visibleCells.max(by: { $0.alpha < $1.alpha }),
      let allowSelectingIndexPath = collectionView.indexPath(for: allowSelectingCell) else { return }
    allowSelectingItem = allowSelectingIndexPath.item
  }
}

extension FavoritesController: UIGestureRecognizerDelegate {
  
  func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
    let indexPath = indexPathForGestureRecognizer(gestureRecognizer)
    return allowSelectingItem == indexPath?.item
  }
}
