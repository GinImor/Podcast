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
  private(set) var savedEpisodes: [Episode]! {
    didSet { saveEpisodes() }
  }
  
  init() {
    self.savedPodcasts = fetchPodcasts()
    self.savedEpisodes = fetchEpisodes()
    self.cleanUncommitedEpisodes()
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
      print("encode podcasts error: \(error)")
    }
  }
  
  func fetchPodcasts() -> [Podcast]? {
    guard let data = UserDefaults.standard.object(forKey: UserDefaultsKey.podcasts) as? Data else { return [] }
    do {
      let podcasts = try NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(data) as! [Podcast]
      return podcasts
    } catch {
      print("decode podcasts error: \(error)")
      return nil
    }
  }
  
  func contains(episode: Episode) -> Bool {
    return index(of: episode) != nil
  }
  
  func index(of episode: Episode) -> Int? {
    return savedEpisodes.firstIndex {
      $0.title == episode.title && $0.author == episode.author
    }
  }
  
  mutating func saveEpisode(_ episode: Episode) -> Bool {
    guard savedEpisodes != nil, !contains(episode: episode) else { return false }
    savedEpisodes.append(episode)
    return true
  }
  
  mutating func deleteEpisode(_ episode: Episode) {
    guard savedEpisodes != nil else { return }
    savedEpisodes.removeAll { $0.title == episode.title && $0.author == episode.author }
    ItunesFileManager.default.deleteEpisode(episode)
  }
  
  mutating func deleteEpisodes(_ episodes: [Episode]) {
    for episode in episodes {
      deleteEpisode(episode)
    }
  }
  
  mutating func updateEpisode(_ oldEpisode: Episode, with newEpisode: Episode) {
    guard savedEpisodes != nil, let index = index(of: oldEpisode) else { return }
    savedEpisodes[index] = newEpisode
  }
  
  mutating func commitEpisode(_ episode: Episode) {
    guard savedEpisodes != nil, let index = index(of: episode) else { return }
    savedEpisodes[index].commited = true
  }
  
  mutating func cleanUncommitedEpisodes() {
    guard savedEpisodes != nil else { return }
    let uncommitedEpisodes = savedEpisodes.filter { !$0.commited }
    deleteEpisodes(uncommitedEpisodes)
  }
  
  func saveEpisodes() {
    do {
      let data = try JSONEncoder().encode(savedEpisodes)
      UserDefaults.standard.set(data, forKey: UserDefaultsKey.episodes)
    } catch {
      print("encode episodes error: \(error)")
    }
  }
  
  func fetchEpisodes() -> [Episode]? {
    guard let data = UserDefaults.standard.object(forKey: UserDefaultsKey.episodes) as? Data else { return [] }
    do {
      let episodes = try JSONDecoder().decode([Episode].self, from: data)
      return episodes
    } catch {
      print("decode episodes error: \(error)")
      return nil
    }
  }
  
}
