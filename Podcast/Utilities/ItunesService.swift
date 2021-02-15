//
//  iTunesService.swift
//  Podcast
//
//  Created by Gin Imor on 2/15/21.
//  Copyright © 2021 Brevity. All rights reserved.
//

import Foundation
import Alamofire

class ItunesService {
  
  let baseItunesSearchUrl = "https://itunes.apple.com/search"
  
  static let shared = ItunesService()
  
  func fetchPodcasts(searchText: String, completion: @escaping ([Podcast]) -> Void) {
    let parameters = ["term": searchText, "media": "podcast"]
    
    AF.request(baseItunesSearchUrl, parameters: parameters, encoding: URLEncoding.default).responseDecodable(of: PodcastSearchResults.self) { (dataResponse) in
      switch dataResponse.result {
      case .success(let podcastSearchResults):
        completion(podcastSearchResults.results)
      case .failure(let afError):
        print("error", afError)
      }
    }

  }
}
