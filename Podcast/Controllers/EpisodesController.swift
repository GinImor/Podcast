//
//  EpisodesController.swift
//  Podcast
//
//  Created by Gin Imor on 2/15/21.
//  Copyright © 2021 Brevity. All rights reserved.
//

import UIKit
import FeedKit

class EpisodesController: UITableViewController {
  
  var episodes: [Episode] = []
  
  var podcast: Podcast?
  
  var finishedLoading = false
  var activityIndicator: UIActivityIndicatorView!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    setupActivityIndicator()
    setupBarAppearance()
    setupTableView()
    loadEpisodes()
  }
  
  override func viewWillDisappear(_ animated: Bool) {
    super.viewWillAppear(animated)
    activityIndicator.stopAnimating()
  }
  
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    if !finishedLoading { activityIndicator.startAnimating() }
  }
  
  private func loadEpisodes() {
    guard let feedUrlString = podcast?.feedUrl, let feedUrl = URL(string: feedUrlString) else { return }
      
      let feedParser = FeedParser(URL: feedUrl)
      
      feedParser.parseAsync(queue: .global(qos: .userInitiated)) { (result) in
        switch result {
        case .success(let feed):
          guard let rssFeed = feed.rssFeed else { return }
          
          DispatchQueue.main.async {
            self.episodes = rssFeed.items?.map{ Episode(title: $0.title )} ?? []
            self.tableView.reloadData()
            self.finishedLoading = true
            self.activityIndicator.stopAnimating()
          }
        case .failure(let parserError):
          print("parser error", parserError)
        }
      }
  }
  
  private func setupActivityIndicator() {
    activityIndicator = UIActivityIndicatorView(style: .large)
    activityIndicator.translatesAutoresizingMaskIntoConstraints = false
    
    let navView = self.navigationController!.view!
    navView.addSubview(activityIndicator)
    NSLayoutConstraint.activate([
      activityIndicator.centerXAnchor.constraint(equalTo: navView.centerXAnchor),
      activityIndicator.centerYAnchor.constraint(equalTo: navView.centerYAnchor)
    ])
  }
  
  private func setupBarAppearance() {
    navigationItem.title = podcast?.trackName
  }
  
  private func setupTableView() {
    tableView.tableFooterView = UIView()
    tableView.register(UITableViewCell.self, forCellReuseIdentifier: CellID.episode)
  }
  
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return episodes.count
  }
  
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: CellID.episode, for: indexPath)
    let episode = episodes[indexPath.row]
    
    cell.textLabel?.text = episode.title
    
    return cell
  }
}
