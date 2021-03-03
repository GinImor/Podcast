//
//  EpisodesController.swift
//  Podcast
//
//  Created by Gin Imor on 2/15/21.
//  Copyright © 2021 Brevity. All rights reserved.
//

import UIKit
import FeedKit

extension Notification.Name {
  static let favoritePodcastsDidChange = Notification.Name("favoritePodcastsDidChange")
}

class EpisodesController: UITableViewController {
  
  var episodes: [Episode] = []
  
  var podcast: Podcast!
  var isPodcastInitiallyFavorite = false
  var isPodcastFavorite = false {
    didSet {
      if isPodcastFavorite {
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "heart.fill"), style: .plain,
        target: self, action: #selector(favorite))
      } else {
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "heart"), style: .plain,
        target: self, action: #selector(favorite))
      }
    }
  }
  
  var finishedLoading = false
  var activityIndicator: UIActivityIndicatorView!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    setupActivityIndicator()
    setupBarAppearance()
    setupTableView()
    loadEpisodes()
  }
  
  override func viewDidDisappear(_ animated: Bool) {
    super.viewDidAppear(animated)
    activityIndicator.stopAnimating()
    
    if isPodcastInitiallyFavorite != isPodcastFavorite {
      if isPodcastFavorite {
        ItunesUserDefault.shared.savePodcast(podcast)
      } else {
        ItunesUserDefault.shared.deletePodcast(podcast)
      }
      isPodcastInitiallyFavorite.toggle()
      NotificationCenter.default.post(name: .favoritePodcastsDidChange, object: nil)
    }
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    if !finishedLoading { activityIndicator.startAnimating() }
    setupNavigationBarItems()
  }
  
  private func setupNavigationBarItems() {
    if ItunesUserDefault.shared.contains(podcast: podcast) {
      isPodcastInitiallyFavorite = true
      isPodcastFavorite = true
    } else {
      isPodcastInitiallyFavorite = false
      isPodcastFavorite = false
    }
  }
  
  @objc func favorite() {
    isPodcastFavorite.toggle()
  }
  
  private func loadEpisodes() {
    ItunesService.shared.fetchEpisodes(podcast: podcast) { (episodes) in
      self.episodes = episodes
      self.tableView.reloadData()
      self.finishedLoading = true
      self.activityIndicator.stopAnimating()
    }
  }
  
  private func setupActivityIndicator() {
    activityIndicator = UIActivityIndicatorView(style: .large)
    // table view coordinate space origin isn't its bounds origin
    // right below the navigation bar, table view content positioned
    // relative to the coordinate space, so center to table view result
    // in below the believed position
    activityIndicator.centerToSuperviewSafeAreaLayoutGuide(superview: tableView)
  }
  
  private func setupBarAppearance() {
    navigationItem.title = podcast?.trackName
    navigationItem.largeTitleDisplayMode = .never
  }
  
  private func setupTableView() {
    tableView.tableFooterView = UIView()
    tableView.estimatedRowHeight = 116
    tableView.rowHeight = UITableView.automaticDimension
    
    let cellNib = UINib(nibName: CellID.episode, bundle: nil)
    tableView.register(cellNib, forCellReuseIdentifier: CellID.episode)
  }
  
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return episodes.count
  }
  
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: CellID.episode, for: indexPath) as! EpisodeCell
    let episode = episodes[indexPath.row]
    
    cell.episode = episode
    
    return cell
  }
  
  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    let episodePlayerView = EpisodePlayerView.shared
    let episode = episodes[indexPath.row]
    
    episodePlayerView.willPopulateWithEpisode?(episode, episodes)
  }
}
