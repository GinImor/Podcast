//
//  PodcastCell.swift
//  Podcast
//
//  Created by Gin Imor on 2/15/21.
//  Copyright © 2021 Brevity. All rights reserved.
//

import UIKit
import SDWebImage

class PodcastCell: UITableViewCell {
  
  @IBOutlet weak var podcastImageView: UIImageView!
  @IBOutlet weak var trackNameLabel: UILabel!
  @IBOutlet weak var artistNameLabel: UILabel!
  @IBOutlet weak var episodeCountLabel: UILabel! {
    didSet { episodeCountLabel.textColor = .primaryColor }
  }
  
  var podcast: Podcast! {
    didSet {
      trackNameLabel.text = podcast.trackName
      artistNameLabel.text = podcast.artistName
      
      let trackCount = podcast.trackCount ?? 0
      episodeCountLabel.text = "\(trackCount) episode\(trackCount > 1 ? "s" : "")"
      
      guard let artworkUrlString = podcast.artworkUrl?.toHttps(),
      let artworkUrl = URL(string: artworkUrlString) else { return }
      
      podcastImageView.sd_setImage(with: artworkUrl, completed: nil)
    }
  }
  
}
