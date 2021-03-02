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
    setupRoundedCorner()
    setupViewLayout()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  private func setupRoundedCorner() {
    self.layer.cornerRadius = 12
    self.layer.masksToBounds = true
  }
  
  private func setupViewLayout() {
    let stackView = UIStackView.verticalStack(
      arrangedSubviews: [podcastImageView, podcastNameLabel, podcastAuthorNameLabel],
      pinToSuperview: self
    )
    
    stackView.alignment = .center
    
    podcastImageView.heightAnchor.constraint(equalTo: podcastImageView.widthAnchor, multiplier:   1.0).isActive = true
    podcastNameLabel.heightAnchor.constraint(equalTo: podcastAuthorNameLabel.heightAnchor, multiplier: 1.0).isActive = true
    
    podcastImageView.pinToSuperviewHorizontalEdges()
    podcastNameLabel.pinToSuperviewHorizontalEdges(defaultSpacing: UIView.defaultPadding)
    podcastAuthorNameLabel.pinToSuperviewHorizontalEdges(defaultSpacing: UIView.defaultPadding)
    
    podcastNameLabel.text = "abcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcde"
    podcastAuthorNameLabel.text = "abcde"
  }
  
}
