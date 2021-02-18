//
//  iTunesService.swift
//  Podcast
//
//  Created by Gin Imor on 2/15/21.
//  Copyright © 2021 Brevity. All rights reserved.
//

import Foundation
import Alamofire
import FeedKit

class ItunesService {
  
  static let shared = ItunesService()
  
  private let baseItunesSearchUrl = "https://itunes.apple.com/search"
  private var lastSearchText = ""
  
  func fetchPodcasts(searchText: String, completion: @escaping ([Podcast]) -> Void) {
    guard searchText != "" else { return }
    let parameters = ["term": searchText, "media": "podcast"]
    lastSearchText = searchText
    
    AF.request(baseItunesSearchUrl, parameters: parameters, encoding: URLEncoding.default).responseDecodable(of: PodcastSearchResults.self) { (dataResponse) in
      if self.lastSearchText == searchText {
        
        switch dataResponse.result {
        case .success(let podcastSearchResults):
          completion(podcastSearchResults.results)
        case .failure(let afError):
          print("error", afError)
        }
      }
    }

  }
  
  func fetchEpisodes(podcast: Podcast?, completion: @escaping ([Episode]) -> Void) {
    guard let feedUrlString = podcast?.feedUrl, let feedUrl = URL(string: feedUrlString) else { return }
    let feedParser = FeedParser(URL: feedUrl)
    
    feedParser.parseAsync(queue: .global(qos: .userInitiated)) { (result) in
      switch result {
      case .success(let feed):
        guard let rssFeed = feed.rssFeed else { return }
        
        DispatchQueue.main.async {
          let altImageUrl = podcast?.artworkUrl ?? ""
          let episodes = rssFeed.items?.map{ Episode(rssFeedItem: $0, altImageUrl: altImageUrl) } ?? []
          completion(episodes)
        }
      case .failure(let parserError):
        print("parser error", parserError)
      }
    }
  }
  
}
