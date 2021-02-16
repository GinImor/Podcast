//
//  EpisodesController.swift
//  Podcast
//
//  Created by Gin Imor on 2/15/21.
//  Copyright © 2021 Brevity. All rights reserved.
//

import UIKit

class EpisodesController: UITableViewController {
  
  var podcast: Podcast?
  var episodes: [Episode] = [Episode(title: "abcdkljsf"), Episode(title: "lfjalfjlkdfj")]
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    setupBarAppearance()
    setupTableView()
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
