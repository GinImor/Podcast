//
//  episodePlayerView.swift
//  Podcast
//
//  Created by Gin Imor on 2/17/21.
//  Copyright © 2021 Brevity. All rights reserved.
//

import UIKit
import AVKit

class EpisodePlayerView: UIView {
  @IBOutlet weak var episodeImageView: UIImageView!
  @IBOutlet weak var episodeTitleLabel: UILabel!
  @IBOutlet weak var authorLabel: UILabel!
  @IBOutlet weak var playButton: UIButton!
  
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
      
      guard let audioUrl = URL(string: episode.audioUrl) else { return }
      
      let playerItem = AVPlayerItem(url: audioUrl)
      episodePlayer.replaceCurrentItem(with: playerItem)
      episodePlayer.automaticallyWaitsToMinimizeStalling = false
      playOrPause(playButton)
    }
  }
  
  @IBAction func playOrPause(_ sender: UIButton) {
    if episodePlayer.timeControlStatus == .paused {
      episodePlayer.play()
      playButton.setImage(UIImage(systemName: "pause"), for: .normal)
    } else {
      episodePlayer.pause()
      playButton.setImage(UIImage(systemName: "play"), for: .normal)
    }
  }
  
  let episodePlayer: AVPlayer = {
    let player = AVPlayer()
    return player
  }()
  
}
