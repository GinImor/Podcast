//
//  ItunesNotificationCenter.swift
//  Podcast
//
//  Created by Gin Imor on 3/4/21.
//  Copyright © 2021 Brevity. All rights reserved.
//

import Foundation

struct ItunesNotificationCenter {
  
  static let `default` = ItunesNotificationCenter()
  
  var nc: NotificationCenter { NotificationCenter.default }
  
  func observeForDidSelectEpisode(completion: @escaping (Episode, [Episode]) -> Void) {
    nc.addObserver(forName: .didSelectEpisode, object: nil, queue: nil) { (notification) in
      guard let userInfo = notification.userInfo,
        let episode = userInfo["episode"] as? Episode,
        let episodes = userInfo["episodes"] as? [Episode] else { return }
      completion(episode, episodes)
    }
  }
  
  func postForDidSelectEpisode(_ episode: Episode, episodes: [Episode]) {
    let userInfo: [String : Any] = ["episode": episode, "episodes": episodes]
    NotificationCenter.default.post(name: .didSelectEpisode, object: nil, userInfo: userInfo)
  }
}

