//
//  episodePlayerView.swift
//  Podcast
//
//  Created by Gin Imor on 2/17/21.
//  Copyright © 2021 Brevity. All rights reserved.
//

import UIKit

class EpisodePlayerView: UIView {
  @IBOutlet weak var episodeImageView: UIImageView!
  @IBOutlet weak var episodeTitleLabel: UILabel!
  @IBOutlet weak var authorLabel: UILabel!
  
  @IBAction func dismiss(_ sender: Any) {
    removeFromSuperview()
  }
  
  var episode: Episode! {
    didSet {
      episodeTitleLabel.text = episode.title
      authorLabel.text = episode.author
      
      episodeImageView.sd_setImage(with: URL(string: episode.imageUrl))
      episodeImageView.layer.cornerRadius = episodeImageView.bounds.width * 0.05
      episodeImageView.layer.masksToBounds = true
    }
  }
  
}
