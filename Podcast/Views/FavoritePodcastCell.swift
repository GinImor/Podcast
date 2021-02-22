//
//  FavoriteEpisodeCell.swift
//  Podcast
//
//  Created by Gin Imor on 2/22/21.
//  Copyright © 2021 Brevity. All rights reserved.
//

import UIKit

class FavoritePodcastCell: UICollectionViewCell {
  
  let podcastImageView = UIImageView(image: #imageLiteral(resourceName: "appicon"))
  let podcastNameLabel = UILabel()
  let podcastAuthorNameLabel = UILabel()
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    setupViewLayout()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  private func setupViewLayout() {
    UIStackView.verticalStack(
      arrangedSubviews: [podcastImageView, podcastNameLabel, podcastAuthorNameLabel],
      pinToSuperview: self
    )
    
    podcastNameLabel.text = "abcde"
    podcastAuthorNameLabel.text = "abcde"
  }
  
}
