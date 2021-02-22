//
//  PodcastSearchController.swift
//  Podcast
//
//  Created by Gin Imor on 2/14/21.
//  Copyright © 2021 Brevity. All rights reserved.
//

import UIKit
import Alamofire

class PodcastSearchController: UITableViewController {
  
  var podcasts: [Podcast] = []
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    setupSearchbar()
    setupTableView()
  }
  
  // MARK: - For Testing
  
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    navigationItem.searchController?.searchBar.text = "Swift"
    searchBarTextDidEndEditing(navigationItem.searchController!.searchBar)
  }
  
  
  private func setupSearchbar() {
    let searchController = UISearchController(searchResultsController: nil)
    let searchBarTextField = searchController.searchBar.searchTextField
    
    searchController.obscuresBackgroundDuringPresentation = false
    searchController.searchBar.delegate = self
    
    searchBarTextField.layer.borderColor = UIColor.primaryColor.cgColor
    searchBarTextField.layer.borderWidth = 2.0
    searchBarTextField.layer.cornerRadius = 10.0
    searchBarTextField.layer.masksToBounds = true
    
    navigationItem.searchController = searchController
  }
  
  private func setupTableView() {
    tableView.tableFooterView = UIView()
    tableView.estimatedRowHeight = 116
    tableView.rowHeight = UITableView.automaticDimension
    
    let podcastCellNib = UINib(nibName: CellID.podcast, bundle: nil)
    tableView.register(podcastCellNib, forCellReuseIdentifier: CellID.podcast)
  }
  
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return podcasts.count
  }
  
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: CellID.podcast, for: indexPath) as! PodcastCell
    let podcast = podcasts[indexPath.row]
    
    cell.podcast = podcast
    
    return cell
  }
  
}

extension PodcastSearchController: UISearchBarDelegate {
  
  func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
    ItunesService.shared.fetchPodcasts(searchText: searchBar.text ?? "") { podcasts in
      self.podcasts = podcasts
      self.tableView.reloadData()
    }
  }
}


// MARK: - Table View Delegate

extension PodcastSearchController {
  
  override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
    let label = UILabel()
    
    label.text = "No results. Please enter a search query"
    label.textAlignment = .center
    label.textColor = .primaryColor
    label.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
    
    return label
  }
  
  override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
    return podcasts.count == 0 ? 250 : 0
  }
  
  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    let episodesController = EpisodesController()
    
    episodesController.podcast = podcasts[indexPath.row]
    navigationController?.pushViewController(episodesController, animated: true)
  }
}
