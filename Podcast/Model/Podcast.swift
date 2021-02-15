//
//  Podcast.swift
//  Podcast
//
//  Created by Gin Imor on 2/14/21.
//  Copyright © 2021 Brevity. All rights reserved.
//

import Foundation

struct Podcast: Decodable {
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
