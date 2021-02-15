//
//  PodcastCell.swift
//  Podcast
//
//  Created by Gin Imor on 2/15/21.
//  Copyright © 2021 Brevity. All rights reserved.
//

import UIKit

class PodcastCell: UITableViewCell {
  
  @IBOutlet weak var podcastImageView: UIImageView!
  @IBOutlet weak var trackNameLabel: UILabel!
  @IBOutlet weak var artistNameLabel: UILabel!
  @IBOutlet weak var episodeCountLabel: UILabel!
  
  var podcast: Podcast! {
    didSet {
      trackNameLabel.text = podcast.trackName
      artistNameLabel.text = podcast.artistName
    }
  }
  
}
