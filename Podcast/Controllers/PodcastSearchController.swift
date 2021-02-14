//
//  PodcastSearchController.swift
//  Podcast
//
//  Created by Gin Imor on 2/14/21.
//  Copyright © 2021 Brevity. All rights reserved.
//

import UIKit

enum CellID {
  static let podcast = "podcast cell"
}

class PodcastSearchController: UITableViewController {
  
  var podcasts: [Podcast] = [
    Podcast(name: "ab", authorName: "Gin"),
    Podcast(name: "cd", authorName: "Brevity"),
  ]
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    setupSearchbar()
    setupTableView()
  }
  
  private func setupSearchbar() {
    let searchController = UISearchController(searchResultsController: nil)
    
    navigationItem.hidesSearchBarWhenScrolling = false
    searchController.obscuresBackgroundDuringPresentation = false
    searchController.searchBar.delegate = self
    
    navigationItem.searchController = searchController
  }
  
  private func setupTableView() {
    tableView.tableFooterView = UIView()
    tableView.register(UITableViewCell.self, forCellReuseIdentifier: CellID.podcast)
  }
  
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return podcasts.count
  }
  
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: CellID.podcast, for: indexPath)
    let podcast = podcasts[indexPath.row]
    
    cell.imageView?.image = #imageLiteral(resourceName: "appicon")
    cell.textLabel?.numberOfLines = -1
    cell.textLabel?.text = "\(podcast.name)\n\(podcast.authorName)"
    
    return cell
  }
  
}

extension PodcastSearchController: UISearchBarDelegate {
  
  func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
    print(searchText)
  }
}
