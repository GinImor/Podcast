//
//  Episode.swift
//  Podcast
//
//  Created by Gin Imor on 2/15/21.
//  Copyright © 2021 Brevity. All rights reserved.
//

import Foundation
import FeedKit

struct Episode {
  let title: String
  let pubDate: Date
  let description: String
  
  init(rssFeedItem: RSSFeedItem) {
    title = rssFeedItem.title ?? ""
    pubDate = rssFeedItem.pubDate ?? Date()
    description = rssFeedItem.description ?? ""
  }
}
