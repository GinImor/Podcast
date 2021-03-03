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
  
  var podcast: Podcast!
  
  var finishedLoading = false
  var activityIndicator: UIActivityIndicatorView!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    setupActivityIndicator()
    setupBarAppearance()
    setupNavigationBarItems()
    setupTableView()
    loadEpisodes()
  }
  
  override func viewDidDisappear(_ animated: Bool) {
    super.viewDidAppear(animated)
    activityIndicator.stopAnimating()
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    if !finishedLoading { activityIndicator.startAnimating() }
  }
  
  private func setupNavigationBarItems() {
    let fetchButton = UIBarButtonItem(title: "Fetch", style: .plain, target: self, action: #selector(fetch))
    let favoriteButton = UIBarButtonItem(image: UIImage(systemName: "heart"), style: .plain, target: self, action: #selector(favorite))
    navigationItem.rightBarButtonItems = [favoriteButton, fetchButton]
  }
  
  @objc func fetch() {
    let podcasts = ItunesUserDefault.fetchPodcasts()
    podcasts?.forEach({ (pod) in
      print("name: \(pod.trackName ?? "")")
    })
  }
  
  @objc func favorite() {
    ItunesUserDefault.savePodcast(podcast!)
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
