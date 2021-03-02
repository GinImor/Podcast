//
//  FavoriteEpisodeCell.swift
//  Podcast
//
//  Created by Gin Imor on 2/22/21.
//  Copyright © 2021 Brevity. All rights reserved.
//

import UIKit

class FavoritePodcastCell: UICollectionViewCell {
  
  static func podcastNameLabel() -> UILabel {
    let label = UILabel()
    label.font = UIFont.preferredFont(forTextStyle: .title2)
    label.textAlignment = .center
    label.text = "Podcast Name"
    return label
  }
  
  static func authorNameLabel() -> UILabel {
    let label = UILabel()
    label.font = UIFont.preferredFont(forTextStyle: .body)
    label.textAlignment = .center
    label.textColor = .secondaryLabel
    label.text = "Podcast Author Name"
    return label
  }
  
  let podcastImageView = UIImageView(image: #imageLiteral(resourceName: "appicon"))
  let podcastNameLabel = FavoritePodcastCell.podcastNameLabel()
  let podcastAuthorNameLabel = FavoritePodcastCell.authorNameLabel()
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    setupViewAppearance()
    setupViewLayout()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  private func setupViewAppearance() {
    self.layer.cornerRadius = 12
    self.layer.masksToBounds = true
    
    self.layer.borderWidth = 3.0
    self.layer.borderColor = UIColor.primaryColor.cgColor
    
    self.backgroundColor = .systemBackground
  }
  
  private func setupViewLayout() {
    let stackView = UIStackView.verticalStack(
      arrangedSubviews: [podcastImageView, podcastNameLabel, podcastAuthorNameLabel],
      pinToSuperview: self
    )
    
    stackView.alignment = .center
    stackView.distribution = .fill
    stackView.isLayoutMarginsRelativeArrangement = true
    stackView.directionalLayoutMargins.bottom = 8
    
    podcastImageView.heightAnchor.constraint(equalTo: podcastImageView.widthAnchor, multiplier:   1.0).isActive = true
    podcastImageView.pinToSuperviewHorizontalEdges()
    podcastNameLabel.pinToSuperviewHorizontalEdges(defaultSpacing: UIView.defaultPadding)
    podcastAuthorNameLabel.pinToSuperviewHorizontalEdges(defaultSpacing: UIView.defaultPadding)
    
    podcastNameLabel.text = "abcdeabcgdeabcdefgabcdeabfcdgeabcdfgeabcdeabcfdeagbcfdeabcgfdeagbcdeabgcdeabcdeabcdeabcdef"
    podcastAuthorNameLabel.text = "abcgdef"
  }
  
}
