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
  
  @IBOutlet weak var episodeImageView: UIImageView! {
    didSet {
      episodeImageView.layer.cornerRadius = episodeImageView.bounds.width * 0.05
      episodeImageView.layer.masksToBounds = true
      shrinkEpisodeImageView()
    }
  }
  @IBOutlet weak var episodeTitleLabel: UILabel!
  @IBOutlet weak var authorLabel: UILabel!
  @IBOutlet weak var playButton: UIButton!
  
  @IBAction func dismiss(_ sender: Any) {
    episodePlayer.removeTimeObserver(boundaryTimeObserver!)
    removeFromSuperview()
  }
  
  @IBAction func playOrPause(_ sender: UIButton) {
    if episodePlayer.timeControlStatus == .paused {
      episodePlayer.play()
      playButton.setImage(UIImage(systemName: "pause"), for: .normal)
      animateEpisodeImageView(shrink: false)
    } else {
      episodePlayer.pause()
      playButton.setImage(UIImage(systemName: "play"), for: .normal)
      animateEpisodeImageView(shrink: true)
    }
  }
  
  var episode: Episode! {
    didSet {
      episodeTitleLabel.text = episode.title
      authorLabel.text = episode.author
      
      episodeImageView.sd_setImage(with: URL(string: episode.imageUrl))
      playEpisode(episode)
    }
  }
  
  let episodePlayer: AVPlayer = {
    let player = AVPlayer()
    return player
  }()
  
  var boundaryTimeObserver: Any?
  
  override func awakeFromNib() {
    super.awakeFromNib()
    
    let nsValues = [NSValue(time: CMTime(value: 1, timescale: 3))]
    boundaryTimeObserver = episodePlayer.addBoundaryTimeObserver(forTimes: nsValues, queue: nil) { [unowned self] in
      self.animateEpisodeImageView(shrink: false)
    }
  }
  
  private func playEpisode(_ episode: Episode) {
    guard let audioUrl = URL(string: episode.audioUrl) else { return }
    
    let playerItem = AVPlayerItem(url: audioUrl)
    episodePlayer.replaceCurrentItem(with: playerItem)
    episodePlayer.automaticallyWaitsToMinimizeStalling = false
    episodePlayer.play()
  }
  
  private var shrinkScale: CGFloat { 0.8 }
  
  private func shrinkEpisodeImageView() {
    episodeImageView.transform = CGAffineTransform(scaleX: shrinkScale, y: shrinkScale)
  }
  
  private func unshrinkEpisodeImageView() {
    episodeImageView.transform = .identity
  }
  
  private func animateEpisodeImageView(shrink: Bool) {
    UIView.animate(
      withDuration: 0.5,
      delay: 0.0,
      usingSpringWithDamping: 0.5,
      initialSpringVelocity: 0.0,
      options: .curveEaseOut,
      animations:  {
        if shrink { self.shrinkEpisodeImageView() }
        else { self.unshrinkEpisodeImageView() }
      }
    )
  }
  
  
}
