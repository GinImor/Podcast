//
//  EpisodeCellTableViewCell.swift
//  Podcast
//
//  Created by Gin Imor on 2/16/21.
//  Copyright © 2021 Brevity. All rights reserved.
//

import UIKit

class EpisodeCell: UITableViewCell {

  @IBOutlet weak var episodeImageView: UIImageView!
  @IBOutlet weak var pubDateLabel: UILabel! {
    didSet { pubDateLabel.textColor = .primaryColor }
  }
  @IBOutlet weak var titleLabel: UILabel!
  @IBOutlet weak var descriptionLabel: UILabel!
  @IBOutlet weak var progressView: UIProgressView! {
    didSet {
      progressView.progressTintColor = .primaryColor
    }
  }
  
  var episode: Episode! {
    didSet {
      pubDateLabel.text = DateFormatter.m3D2Y4.string(from: episode.pubDate)
      titleLabel.text = episode.title
      descriptionLabel.text = episode.description
      episodeImageView.sd_setImage(with: URL(string: episode.imageUrl.toHttps()))
    }
  }
}
