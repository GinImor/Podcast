//
//  ItunesNotificationCenter.swift
//  Podcast
//
//  Created by Gin Imor on 3/4/21.
//  Copyright © 2021 Brevity. All rights reserved.
//

import Foundation

extension Notification.Name {
  static let didUpdateProgress = Notification.Name(rawValue: "didUpdateProgress")
  static let didSelectEpisode = Notification.Name(rawValue: "didSelectEpisode")
  static let favoritePodcastsDidChange = Notification.Name("favoritePodcastsDidChange")
  static let downloadEpisodesDidChange = Notification.Name("downloadEpisodesDidChange")
}

struct ItunesNotificationCenter {
  
  enum Key {
    static var episode: String { "episode" }
    static var episodes: String { "episodes" }
    static var progress: String { "progress" }
  }
  
  static let `default` = ItunesNotificationCenter()
  
  var nc: NotificationCenter { NotificationCenter.default }
  
  func observeForDidSelectEpisode(completion: @escaping (Episode, [Episode]) -> Void) {
    nc.addObserver(forName: .didSelectEpisode, object: nil, queue: nil) { (notification) in
      guard let userInfo = notification.userInfo,
        let episode = userInfo[Key.episode] as? Episode,
        let episodes = userInfo[Key.episodes] as? [Episode] else { return }
      completion(episode, episodes)
    }
  }
  
  func postForDidSelectEpisode(_ episode: Episode, episodes: [Episode]) {
    let userInfo: [String: Any] = [Key.episode: episode, Key.episodes: episodes]
    NotificationCenter.default.post(name: .didSelectEpisode, object: nil, userInfo: userInfo)
  }
  
  func observeForDidUpdateProgress(completion: @escaping (Progress, Episode) -> Void) {
    nc.addObserver(forName: .didUpdateProgress, object: nil, queue: nil) { (notification) in
      guard let userInfo = notification.userInfo,
        let progress = userInfo[Key.progress] as? Progress,
        let episode = userInfo[Key.episode] as? Episode else { return }
      completion(progress, episode)
    }
  }
  
  func postForDidUpdateProgress(_ progress: Progress, for episode: Episode) {
    let userInfo: [String: Any] = [Key.progress: progress, Key.episode: episode]
    nc.post(name: .didUpdateProgress, object: nil, userInfo: userInfo)
  }
  
}

