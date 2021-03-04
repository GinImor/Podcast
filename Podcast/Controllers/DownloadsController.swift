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
    ItunesNotificationCenter.default.observeForDidUpdateProgress { (progress, episode) in
      guard let index = self.downloads.firstIndex(of: episode) else { return }
      
      let indexPath = IndexPath(row: self.rowFor(indexPathRow: index), section: 0)
      guard let cell = self.tableView.cellForRow(at: indexPath) as? EpisodeCell else { return }
      
      cell.progressView.progress = Float(progress.fractionCompleted)
      
      if cell.progressView.isHidden {
        cell.progressView.isHidden = false
      }
      if progress.fractionCompleted == 1.0 {
        cell.progressView.isHidden = true
      }
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
    return downloads[rowFor(indexPathRow: indexPath.row)]
  }
  
  private func rowFor(indexPathRow: Int) -> Int {
    let lastRow = downloads.count - 1
    return lastRow - indexPathRow
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
    let episodes = [Episode](downloads.reversed())
    
    if episode.fileName != nil {
      ItunesNotificationCenter.default.postForDidSelectEpisode(episode, episodes: episodes)
    } else {
      let alert = UIAlertController(title: "Download Not Complete!", message: "Do you want to use your network to play the episode?", preferredStyle: .actionSheet)
      
      alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (_) in
        ItunesNotificationCenter.default.postForDidSelectEpisode(episode, episodes: episodes)
      }))
      alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
      present(alert, animated: true)
    }
  }
}
