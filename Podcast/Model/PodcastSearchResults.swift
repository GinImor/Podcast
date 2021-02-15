//
//  PodcastSearchResults.swift
//  Podcast
//
//  Created by Gin Imor on 2/15/21.
//  Copyright © 2021 Brevity. All rights reserved.
//

import Foundation

struct PodcastSearchResults: Decodable {
  let resultCount: Int
  let results: [Podcast]
}
