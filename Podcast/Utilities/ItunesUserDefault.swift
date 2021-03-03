//
//  ItunesUserDefault.swift
//  Podcast
//
//  Created by Gin Imor on 3/3/21.
//  Copyright © 2021 Brevity. All rights reserved.
//

import Foundation

enum ItunesUserDefault {
  
  static func savePodcast(_ podcast: Podcast) {
    guard var podcasts = fetchPodcasts() else { return }
    podcasts.append(podcast)
    do {
      let data = try NSKeyedArchiver.archivedData(withRootObject: podcasts, requiringSecureCoding: false)
      UserDefaults.standard.set(data, forKey: UserDefaultsKey.podcasts)
    } catch {
      print("encode error: \(error)")
    }
  }
  
  static func fetchPodcasts() -> [Podcast]? {
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
