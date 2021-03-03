//
//  Podcast.swift
//  Podcast
//
//  Created by Gin Imor on 2/14/21.
//  Copyright © 2021 Brevity. All rights reserved.
//

import Foundation

class Podcast: NSObject, NSCoding, Decodable {
  
  static var trackNameKey: String { "trackName" }
  static var artistNameKey: String { "artistName" }
  static var artworkUrlKey: String { "artworkUrl" }
  
  func encode(with coder: NSCoder) {
    coder.encode(trackName, forKey: Podcast.trackNameKey)
    coder.encode(artistName, forKey: Podcast.artistNameKey)
    coder.encode(artworkUrl, forKey: Podcast.artworkUrlKey)
  }
  
  required init?(coder: NSCoder) {
    self.trackName = coder.decodeObject(forKey: Podcast.trackNameKey) as? String
    self.artistName = coder.decodeObject(forKey: Podcast.artistNameKey) as? String
    self.artworkUrl = coder.decodeObject(forKey: Podcast.artworkUrlKey) as? String
    self.feedUrl = nil
    self.trackCount = nil
  }
  
  let trackName: String?
  let artistName: String?
  let artworkUrl: String?
  let feedUrl: String?
  let trackCount: Int?
  
  private enum CodingKeys: String, CodingKey {
    case trackName
    case artistName
    case artworkUrl = "artworkUrl600"
    case feedUrl
    case trackCount
  }
}
