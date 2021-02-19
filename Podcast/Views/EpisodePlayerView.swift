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
  
  static var shared: EpisodePlayerView = {
    Bundle.main.loadNibNamed("EpisodePlayerView", owner: nil, options: nil)?.first as! EpisodePlayerView
  }()
  
  var willDismiss: (() -> Void)?
  var willPopulateWithEpisode: ((Episode) -> Void)?
  

  @IBOutlet weak var miniView: UIView!
  @IBOutlet weak var fullSizeView: UIStackView!
  
  @IBOutlet weak var miniEpisodeImageView: UIImageView!
  @IBOutlet weak var miniEpisodeTitleLabel: UILabel!
  @IBOutlet weak var miniPlayButton: UIButton!
  
  
  @IBOutlet weak var episodeImageView: UIImageView! {
    didSet {
      episodeImageView.layer.cornerRadius = episodeImageView.bounds.width * 0.05
      episodeImageView.layer.masksToBounds = true
      shrinkEpisodeImageView()
    }
  }
  
  @IBOutlet weak var timeControlSlider: UISlider!
  @IBOutlet weak var elapsedTimeLabel: UILabel!
  @IBOutlet weak var totalTimeLabel: UILabel!
  @IBOutlet weak var episodeTitleLabel: UILabel!
  @IBOutlet weak var authorLabel: UILabel!
  @IBOutlet weak var playButton: UIButton!
  @IBOutlet weak var volumeSlider: UISlider!
  
  @IBAction func dismiss(_ sender: Any) {
    willDismiss?()
  }
  
  @IBAction func timeChanged(_ sender: Any) {
    let percentage = timeControlSlider.value
    let seekFloatTime = Float64(percentage) * episodePlayer.currentItem!.duration.preciseSec
    let seekCMTime = CMTimeMakeWithSeconds(seekFloatTime, preferredTimescale: 1)
    episodePlayer.seek(to: seekCMTime)
  }
  @IBAction func timeControlDown(_ sender: Any) { playerSwitchToPaused() }
  @IBAction func timeControlUpInside(_ sender: Any) { playerSwitchToPlay() }
  @IBAction func timeControlUpOutside(_ sender: Any) { playerSwitchToPlay() }
  
  @IBAction func goBacward(_ sender: Any) { goBy(delta: -15) }
  
  // notice player status will change without notice
  @IBAction func playOrPause(_ sender: UIButton) {
    if episodePlayer.timeControlStatus == .paused {
      playerSwitchToPlay()
    } else {
      playerSwitchToPaused()
    }
  }
  
  override func awakeFromNib() {
    super.awakeFromNib()
    
    miniView.addTopBorder(withColor: .lightGray, borderWidth: 0.5)
  }
  
  private func setPlayButtonImage(named: String) {
    playButton.setImage(UIImage(systemName: named), for: .normal)
    miniPlayButton.setImage(UIImage(systemName: named), for: .normal)
  }
  
  private func playerSwitchToPlay() {
    episodePlayer.play()
    setPlayButtonImage(named: "pause")
    animateEpisodeImageView(shrink: false)
  }
  
  private func playerSwitchToPaused() {
    episodePlayer.pause()
    setPlayButtonImage(named: "play")
    animateEpisodeImageView(shrink: true)
  }
  
  @IBAction func goForward(_ sender: Any) { goBy(delta: 15) }
  
  @IBAction func minimizeVolume(_ sender: Any) { volumeChangeTo(0.0) }
  @IBAction func volumeChanged(_ sender: Any) { volumeChangeTo(volumeSlider.value) }
  @IBAction func maximizeVolume(_ sender: Any) { volumeChangeTo(1.0) }
  
  var episode: Episode! {
    didSet {
      setupTimeObserver()
      
      elapsedTimeLabel.text = "00:00:00"
      totalTimeLabel.text = "--:--:--"
      timeControlSlider.value = 0
      
      episodeTitleLabel.text = episode.title
      miniEpisodeTitleLabel.text = episode.title
      authorLabel.text = episode.author
      
      episodeImageView.sd_setImage(with: URL(string: episode.imageUrl))
      miniEpisodeImageView.image = episodeImageView.image
      playEpisode(episode)
    }
  }
  
  let episodePlayer: AVPlayer = {
    let player = AVPlayer()
    return player
  }()
  
  var boundaryTimeObserver: Any?
  var periodicTimeObserver: Any?
  
  func setupTimeObserver() {
    removeTimeObserver()
    addTimeObserver()
  }
  
  func addTimeObserver() {
    addBoundaryTimeObserver()
    addPeriodicTimeObserver()
  }
  
  func removeTimeObserver() {
    removeBoundaryTimeObserver()
    removePeriodicTimeObserver()
  }
  
  func addBoundaryTimeObserver() {
    let nsValues = [NSValue(time: CMTime(value: 1, timescale: 3))]
    boundaryTimeObserver = episodePlayer.addBoundaryTimeObserver(forTimes: nsValues, queue: nil) { [unowned self] in
      self.animateEpisodeImageView(shrink: false)
      self.totalTimeLabel.text = self.episodePlayer.currentItem?.duration.toTimeString()
    }
  }
  
  func removeBoundaryTimeObserver() {
    guard let boundaryTimeObserver = self.boundaryTimeObserver else { return }
    episodePlayer.removeTimeObserver(boundaryTimeObserver)
    self.boundaryTimeObserver = nil
  }
  
  func addPeriodicTimeObserver() {
    let interval = CMTimeMake(value: 1, timescale: 2)
    periodicTimeObserver = episodePlayer.addPeriodicTimeObserver(forInterval: interval, queue: nil, using: { [unowned self] (elapsedTime) in
      self.elapsedTimeLabel.text = elapsedTime.toTimeString()
      let percentage = elapsedTime.devidedBy(self.episodePlayer.currentItem!.duration)
      self.timeControlSlider.value = percentage
    })
  }
  
  func removePeriodicTimeObserver() {
    guard let periodicTimeObserver = self.periodicTimeObserver else { return }
    episodePlayer.removeTimeObserver(periodicTimeObserver)
    self.periodicTimeObserver = nil
  }
  
  private func playEpisode(_ episode: Episode) {
    setPlayButtonImage(named: "pause")
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
  
  private func goBy(delta: Float64) {
    let seekCMTime = episodePlayer.currentTime() + CMTimeMakeWithSeconds(delta, preferredTimescale: 1)
    episodePlayer.seek(to: seekCMTime)
  }
  
  private func volumeChangeTo(_ volume: Float) {
    episodePlayer.volume = volume
    volumeSlider.value = volume
  }
}
