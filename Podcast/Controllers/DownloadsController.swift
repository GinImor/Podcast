//
//  DownloadController.swift
//  Podcast
//
//  Created by Gin Imor on 3/3/21.
//  Copyright © 2021 Brevity. All rights reserved.
//

import UIKit

class DownloadsController: UITableViewController {
  
  var downloads: [Episode] {
    ItunesUserDefault.shared.savedEpisodes
  }
  
  private var needToReload = false
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    setupTableView()
    setupNotification()
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    if needToReload {
      tableView.reloadData()
      needToReload = false
    }
  }
  
  private func setupNotification() {
    NotificationCenter.default.addObserver(forName: .downloadEpisodesDidChange, object: nil, queue: nil) { (_) in
      self.needToReload = true
    }
  }
  
  private func setupTableView() {
    tableView.tableFooterView = UIView()
    tableView.estimatedRowHeight = 116
    tableView.rowHeight = UITableView.automaticDimension
    
    let cellNib = UINib(nibName: CellID.episode, bundle: nil)
    tableView.register(cellNib, forCellReuseIdentifier: CellID.episode)
  }
  
  private func downloadFor(indexPath: IndexPath) -> Episode {
    let lastRow = downloads.count - 1
    return downloads[lastRow - indexPath.row]
  }
  
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return downloads.count
  }
  
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: CellID.episode, for: indexPath) as! EpisodeCell
    
    cell.episode = downloadFor(indexPath: indexPath)
    return cell
  }
  
  override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
    if editingStyle == .delete {
      ItunesUserDefault.shared.deleteEpisode(downloadFor(indexPath: indexPath))
      tableView.deleteRows(at: [indexPath], with: .automatic)
    }
  }
  
  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    let episode = downloadFor(indexPath: indexPath)
    let userInfo: [String: Any] =
      ["episode": episode, "episodes": [Episode](downloads.reversed())]
    NotificationCenter.default.post(name: .didSelectEpisode, object: nil, userInfo: userInfo)
  }
}
