//
//  ItunesFileManager.swift
//  Podcast
//
//  Created by Gin Imor on 3/6/21.
//  Copyright © 2021 Brevity. All rights reserved.
//

import Foundation

struct ItunesFileManager {
  
  static let `default` = ItunesFileManager()
  
  private var helper: FileManager { FileManager.default }
  var documentURL: URL? { helper.urls(for: .documentDirectory, in: .userDomainMask).first}
  
  func fileURLForName(_ name: String?) -> URL? {
    guard let fileName = name else { return nil }
    return documentURL?.appendingPathComponent(fileName)
  }
  
  func deleteEpisode(_ episode: Episode) {
    guard let fileURL = fileURLForName(episode.fileName) else { return }
    do {
      try helper.removeItem(at: fileURL)
      print("deleted episode: \(episode)")
    } catch {
      print("delete episode in file system error: \(error)")
    }
  }
}
