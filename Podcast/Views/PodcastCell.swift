//
//  PodcastCell.swift
//  Podcast
//
//  Created by Gin Imor on 2/15/21.
//  Copyright © 2021 Brevity. All rights reserved.
//

import UIKit

class PodcastCell: UITableViewCell {
  
  @IBOutlet weak var podcastImageView: UIImageView!
  @IBOutlet weak var trackNameLabel: UILabel!
  @IBOutlet weak var artistNameLabel: UILabel!
  @IBOutlet weak var episodeCountLabel: UILabel!
  
  var podcast: Podcast! {
    didSet {
      trackNameLabel.text = podcast.trackName
      artistNameLabel.text = podcast.artistName
      
      let trackCount = podcast.trackCount ?? 0
      episodeCountLabel.text = "\(trackCount) episode\(trackCount > 1 ? "s" : "")"
      
      guard let artworkUrlString = podcast.artworkUrl,
      let artworkUrl = URL(string: artworkUrlString) else { return }
      
      URLSession.shared.dataTask(with: artworkUrl) { (data, response, error) in
        if let error = error {
          print(error)
        }
        
        guard let httpUrlResponse = response as? HTTPURLResponse, (200...209).contains(httpUrlResponse.statusCode) else { return }
        
        guard let data = data, let image = UIImage(data: data) else { return }
        
        DispatchQueue.main.async {
          self.podcastImageView.image = image
        }
      }.resume()
    }
  }
  
}
