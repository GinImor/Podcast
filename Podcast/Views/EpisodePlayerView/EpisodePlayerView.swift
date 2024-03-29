//
//  episodePlayerView.swift
//  Podcast
//
//  Created by Gin Imor on 2/17/21.
//  Copyright © 2021 Brevity. All rights reserved.
//

import UIKit
import AVKit
import MediaPlayer

class EpisodePlayerView: UIView {
  
  static func newView() -> EpisodePlayerView {
    Bundle.main.loadNibNamed("EpisodePlayerView", owner: nil, options: nil)?.first as! EpisodePlayerView
  }
  
  private let episodePlayer: AVPlayer = {
    let player = AVPlayer()
    return player
  }()
  
  /// Delegation
  var willCollapse: (() -> Void)?
  var willPopulateWithEpisode: ((Episode, [Episode]) -> Void)?
  
  /// Factor that decide whether or not perfom animation
  var didEnterBackground: Bool = false
  
  var episodes: [Episode] = []
  
  ///Display Content
  var episode: Episode! {
    didSet {
      setupTimeObserver()
      
      elapsedTimeLabel.text = "00:00:00"
      totalTimeLabel.text = "--:--:--"
      timeControlSlider.value = 0
      
      episodeTitleLabel.text = episode.title
      miniEpisodeTitleLabel.text = episode.title
      authorLabel.text = episode.author
      
      setupNowPlayingInfoTitle()
      
      let imageURL = URL(string: episode.imageUrl)
      episodeImageView.sd_setImage(with: imageURL)
      miniEpisodeImageView.sd_setImage(with: imageURL) { (image, _, _, _) in
        self.setupNowPlayingInfoImage(image)
      }
      
      playEpisode(episode)
    }
  }
  
  
  // MARK: - IBOutlet
  
  @IBOutlet weak var miniView: UIView!
  @IBOutlet weak var fullSizeView: UIStackView!
  
  @IBOutlet weak var miniEpisodeImageView: UIImageView!
  @IBOutlet weak var miniEpisodeTitleLabel: UILabel!
  @IBOutlet weak var miniPlayButton: UIButton!
  
  @IBOutlet weak var episodeImageView: UIImageView!
  
  @IBOutlet weak var timeControlSlider: UISlider!
  @IBOutlet weak var elapsedTimeLabel: UILabel!
  @IBOutlet weak var totalTimeLabel: UILabel!
  @IBOutlet weak var episodeTitleLabel: UILabel!
  @IBOutlet weak var authorLabel: UILabel!
  @IBOutlet weak var playButton: UIButton!
  @IBOutlet weak var muteVolumeButton: UIButton!
  @IBOutlet weak var volumeSlider: UISlider!
  @IBOutlet weak var fullVolumeButton: UIButton!
  
  @IBOutlet weak var fullSizeViewBottomToSuperViewBottom: NSLayoutConstraint!
  
  @IBAction func collapse(_ sender: Any) {
    willCollapse?()
  }
  
  @IBAction func timeChanged(_ sender: Any) {
    let percentage = timeControlSlider.value
    let seekFloatTime = Float64(percentage) * episodePlayer.currentItem!.duration.preciseSec
    let seekCMTime = CMTimeMakeWithSeconds(seekFloatTime, preferredTimescale: 1)
    episodePlayer.seek(to: seekCMTime)
  }
  @IBAction func timeControlDown(_ sender: Any) { playerSwitchToPlay(false) }
  @IBAction func timeControlUpInside(_ sender: Any) { playerSwitchToPlay(true) }
  @IBAction func timeControlUpOutside(_ sender: Any) { playerSwitchToPlay(true) }
  
  @IBAction func goBacward(_ sender: Any) { goBy(delta: -15) }
  
  // notice player status will change without notice
  @IBAction func playOrPause(_ sender: Any? = nil) {
    if episodePlayer.timeControlStatus == .paused {
      playerSwitchToPlay(true)
    } else {
      playerSwitchToPlay(false)
    }
  }
  
  @IBAction func goForward(_ sender: Any) { goBy(delta: 15) }
  
  @IBAction func minimizeVolume(_ sender: Any) { volumeChangeTo(0.0) }
  @IBAction func volumeChanged(_ sender: Any) { volumeChangeTo(volumeSlider.value) }
  @IBAction func maximizeVolume(_ sender: Any) { volumeChangeTo(1.0) }
  
  
  // MARK: - View Life Cycle
  
  override func awakeFromNib() {
    super.awakeFromNib()
    
    setupBasicAppearance()
    setupAudioSession()
    setupRemoteCommand()
    observePlayerControlState()
    setupNotifications()
  }
  
  
  // MARK: - Basic Appearance Set Up
  
  private func setupBasicAppearance() {
    miniView.addTopBorder(withColor: .lightGray, borderWidth: 0.5)
    if UIScreen.main.bounds.height > 700 {
      episodeTitleLabel.font = UIFont.preferredFont(forTextStyle: .title1)
    }
    authorLabel.textColor = .primaryColor
    muteVolumeButton.tintColor = .primaryColor
    fullVolumeButton.tintColor = .primaryColor
  }
  // MARK: - KVO
  
  private func observePlayerControlState() {
    episodePlayer.addObserver(self, forKeyPath: "timeControlStatus", options: .new, context: nil)
    episodePlayer.addObserver(self, forKeyPath: "rate", options: .new, context: nil)
  }
  
  override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
    if keyPath == "timeControlStatus" {
      setEnvironmentAccordingly()
      print("controlStatus:", episodePlayer.timeControlStatus.rawValue)
    } else if keyPath == "rate" {
      print("rate:", episodePlayer.rate)
    }
  }
  
  // MARK: - Notification
  
  private func setupNotifications() {
    let nc = NotificationCenter.default
    let inc = ItunesNotificationCenter.default
    
    nc.addObserver(self,
                   selector: #selector(handleInterruption),
                   name: AVAudioSession.interruptionNotification,
                   object: nil)

    inc.observeForDidSelectEpisode { [weak self] in
      self?.willPopulateWithEpisode?($0, $1)
    }
    
    nc.addObserver(forName: UIApplication.didEnterBackgroundNotification, object: nil, queue: nil) { (_) in
      self.didEnterBackground = true
    }
    nc.addObserver(forName: UIApplication.willEnterForegroundNotification, object: nil, queue: nil) { (_) in
      self.didEnterBackground = false
    }
  }

  @objc func handleInterruption(notification: Notification) {
    guard let userInfo = notification.userInfo,
        let typeValue = userInfo[AVAudioSessionInterruptionTypeKey] as? UInt,
        let type = AVAudioSession.InterruptionType(rawValue: typeValue) else {
            return
    }
    switch type {
    case .began:
      break
    case .ended:
      guard let optionsValue = userInfo[AVAudioSessionInterruptionOptionKey] as? UInt else { return }
      let options = AVAudioSession.InterruptionOptions(rawValue: optionsValue)
      if options.contains(.shouldResume) {
        playerSwitchToPlay(true)
      } else {
      }
    default: ()
    }
  }
  
  // MARK: - Background Mode
  
  private func setupAudioSession() {
    do {
      try AVAudioSession.sharedInstance().setCategory(.playback)
      try AVAudioSession.sharedInstance().setActive(true)
    } catch {
      print(error)
    }
  }
  
  
  // MARK: - Remote Command Center
  
  private func setupRemoteCommand() {
    let remoteCommandCenter = MPRemoteCommandCenter.shared()
    
    UIApplication.shared.beginReceivingRemoteControlEvents()
    
    remoteCommandCenter.playCommand.isEnabled = true
    remoteCommandCenter.playCommand.addTarget { (_) -> MPRemoteCommandHandlerStatus in
      self.playerSwitchToPlay(true)
      return .success
    }
    
    remoteCommandCenter.pauseCommand.isEnabled = true
    remoteCommandCenter.pauseCommand.addTarget { (_) -> MPRemoteCommandHandlerStatus in
      self.playerSwitchToPlay(false)
      return .success
    }
    
    remoteCommandCenter.togglePlayPauseCommand.isEnabled = true
    remoteCommandCenter.togglePlayPauseCommand.addTarget { (_) -> MPRemoteCommandHandlerStatus in
      self.playOrPause()
      return .success
    }
    
    remoteCommandCenter.nextTrackCommand.addTarget { (_) -> MPRemoteCommandHandlerStatus in
      self.jumpTrackBy(+1)
      return .success
    }
    
    remoteCommandCenter.previousTrackCommand.addTarget { (_) -> MPRemoteCommandHandlerStatus in
      self.jumpTrackBy(-1)
      return .success
    }
  }
  
  @objc private func jumpTrackBy(_ step: Int) {
    guard var currentEpisodeIndex = episodes.firstIndex(of: episode) else { return }
    let tempEpisodeIndex = currentEpisodeIndex + step
    
    if tempEpisodeIndex < 0 {
      currentEpisodeIndex = episodes.count - 1
    } else if tempEpisodeIndex > episodes.count - 1 {
      currentEpisodeIndex = 0
    } else {
      currentEpisodeIndex = tempEpisodeIndex
    }
    
    episode = episodes[currentEpisodeIndex]
  }
  
  // MARK: - Now Playing Info
  
  private var nowPlayingInfo: [String: Any]! {
    get { MPNowPlayingInfoCenter.default().nowPlayingInfo}
    set {
      MPNowPlayingInfoCenter.default().nowPlayingInfo = newValue
    }
  }
  
  private func setupNowPlayingInfoTitle() {
    var nowPlayingInfo = [String: Any]()
    
    nowPlayingInfo[MPMediaItemPropertyTitle] = episode.title
    nowPlayingInfo[MPMediaItemPropertyArtist] = episode.author
    
    MPNowPlayingInfoCenter.default().nowPlayingInfo = nowPlayingInfo
  }
   
  private func setupNowPlayingInfoImage(_ image: UIImage?) {
    if let image = image {
      let itemArtwork = MPMediaItemArtwork(boundsSize: image.size) { (_) -> UIImage in
        image
      }
      nowPlayingInfo[MPMediaItemPropertyArtwork] = itemArtwork
    }
  }
  
  private func setupLockScreenPlayDuration() {
    guard let currentItem = episodePlayer.currentItem else { return }
    nowPlayingInfo[MPMediaItemPropertyPlaybackDuration] = currentItem.duration.preciseSec
  }
  
  private func setupLockScreenPlayElapsedTime() {
    nowPlayingInfo[MPNowPlayingInfoPropertyElapsedPlaybackTime] = episodePlayer.currentTime().preciseSec
    print(episodePlayer.currentTime().preciseSec)
  }
   
  
  // MARK: - Play Control
  
  /// initial play
  private func playEpisode(_ episode: Episode) {
    let playUrl: URL
    if let fileURL = ItunesFileManager.default.fileURLForName(episode.fileName)
    {
      playUrl = fileURL
      print("playing offline, playURL: \(playUrl)")
    } else {
      playUrl = URL(string: episode.streamUrl) ?? URL(string: "")!
      print("playing online, playURL: \(playUrl)")
    }
    
    let playerItem = AVPlayerItem(url: playUrl)
    episodePlayer.replaceCurrentItem(with: playerItem)
    episodePlayer.automaticallyWaitsToMinimizeStalling = true
    episodePlayer.play()
  }
  
  private func playerSwitchToPlay(_ play: Bool) {
    play ? episodePlayer.play() : episodePlayer.pause()
    setEnvironmentAccordingly()
  }

  private func setEnvironmentAccordingly() {
    setNowPlayingPlayback()
    setPlayButtonAndImageViewAccordingly()
  }
  
  private func setPlayButtonAndImageViewAccordingly() {
    if episodePlayer.timeControlStatus != .paused  {
      setPlayButtonImage(named: "pause")
      animateEpisodeImageView(shrink: false)
    } else {
      setPlayButtonImage(named: "play")
      animateEpisodeImageView(shrink: true)
    }
  }
  
  private func setNowPlayingPlayback() {
    setupLockScreenPlayElapsedTime()
    if episodePlayer.timeControlStatus == .playing {
      nowPlayingInfo[MPNowPlayingInfoPropertyPlaybackRate] = 1.0
    } else {
      nowPlayingInfo[MPNowPlayingInfoPropertyPlaybackRate] = 0.0
    }
  }
  
  private func setPlayButtonImage(named: String) {
    let image = UIImage(systemName: named)
    playButton.setImage(image, for: .normal)
    miniPlayButton.setImage(image, for: .normal)
  }

  
  // MARK: - Time Observer
  
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
      self.setupLockScreenPlayDuration()
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
  
 
  // MARK: - Episode Image View Shrink Effect
  
  private var shrinkScale: CGFloat { 0.8 }

  private func shrinkEpisodeImageView() {
    episodeImageView.transform = CGAffineTransform(scaleX: shrinkScale, y: shrinkScale)
  }
  
  private func unshrinkEpisodeImageView() {
    episodeImageView.transform = .identity
  }
  
  private func shrinkEpisodeImageView(_ shrink: Bool) {
    if shrink { self.shrinkEpisodeImageView() }
    else { self.unshrinkEpisodeImageView() }
  }
  
  private func animateEpisodeImageView(shrink: Bool) {
    if fullSizeView.alpha != 1.0 || didEnterBackground {
      UIView.performWithoutAnimation {
        self.shrinkEpisodeImageView(shrink)
      }
    }
    else {
      UIView.animate(
        withDuration: 0.5,
        delay: 0.0,
        usingSpringWithDamping: 0.5,
        initialSpringVelocity: 0.0,
        options: .curveEaseOut,
        animations:  {
          self.shrinkEpisodeImageView(shrink)
        }
      )
    }
  }
  
  
  // MARK: - Go Forward or Backward
  
  private func goBy(delta: Float64) {
    let seekCMTime = episodePlayer.currentTime() + CMTimeMakeWithSeconds(delta, preferredTimescale: 1)
    episodePlayer.seek(to: seekCMTime)
  }
  
  
  // MARK: - Volume Control
  private func volumeChangeTo(_ volume: Float) {
    episodePlayer.volume = volume
    volumeSlider.value = volume
  }
}
