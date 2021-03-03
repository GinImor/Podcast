//
//  ItunesUserDefault.swift
//  Podcast
//
//  Created by Gin Imor on 3/3/21.
//  Copyright © 2021 Brevity. All rights reserved.
//

import Foundation

struct ItunesUserDefault {
  
  static var shared = ItunesUserDefault()
  
  private(set) var savedPodcasts: [Podcast]! {
    didSet { savePodcasts() }
  }
  
  init() {
    self.savedPodcasts = fetchPodcasts()
  }
  
  func contains(podcast: Podcast) -> Bool {
    return savedPodcasts.contains {
      $0.trackName == podcast.trackName && $0.artistName == podcast.artistName
    }
  }
  
  mutating func savePodcast(_ podcast: Podcast) {
    guard savedPodcasts != nil else { return }
    savedPodcasts.append(podcast)
  }
  
  mutating func deletePodcast(_ podcast: Podcast) {
    guard savedPodcasts != nil else { return }
    savedPodcasts.removeAll { $0.trackName == podcast.trackName && $0.artistName == podcast.artistName }
  }
  
  func savePodcasts() {
    do {
      let data = try NSKeyedArchiver.archivedData(withRootObject: savedPodcasts!, requiringSecureCoding: false)
      UserDefaults.standard.set(data, forKey: UserDefaultsKey.podcasts)
    } catch {
      print("encode error: \(error)")
    }
  }
  
  func fetchPodcasts() -> [Podcast]? {
    guard let data = UserDefaults.standard.object(forKey: UserDefaultsKey.podcasts) as? Data else { return [] }
    do {
      let podcasts = try NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(data) as! [Podcast]
      return podcasts
    } catch {
      print("decode error: \(error)")
      return nil
    }
  }
  
}
