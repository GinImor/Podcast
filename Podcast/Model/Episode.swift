//
//  Episode.swift
//  Podcast
//
//  Created by Gin Imor on 2/15/21.
//  Copyright © 2021 Brevity. All rights reserved.
//

import Foundation
import FeedKit

struct Episode: Equatable, Codable {
  let title: String?
  let pubDate: Date
  let description: String?
  let author: String?
  let imageUrl: String
  let streamUrl: String
  var fileName: String?
  
  init(rssFeedItem: RSSFeedItem, altImageUrl: String) {
    title = rssFeedItem.title
    pubDate = rssFeedItem.pubDate ?? Date()
    description = rssFeedItem.description
    author = rssFeedItem.iTunes?.iTunesAuthor
    imageUrl = rssFeedItem.iTunes?.iTunesImage?.attributes?.href ?? altImageUrl
    streamUrl = rssFeedItem.enclosure?.attributes?.url ?? ""
  }
}
