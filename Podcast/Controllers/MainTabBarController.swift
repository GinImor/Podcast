//
//  MainTabBarController.swift
//  Podcast
//
//  Created by Gin Imor on 2/14/21.
//  Copyright © 2021 Brevity. All rights reserved.
//

import UIKit

class MainTabBarController: UITabBarController {
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    setupBarAppearance()
    setupChileVCs()
  }
  
  private func setupBarAppearance() {
    tabBar.tintColor = .primaryColor
  }
  
  private func setupChileVCs() {
    let favorites = ViewController()
    let search = PodcastSearchController()
    let downloads = ViewController()
    
    viewControllers = [
      search.wrapInNav(tabBarTitle: "Search", tabBarImage: #imageLiteral(resourceName: "search")),
      favorites.wrapInNav(tabBarTitle: "Favourites", tabBarImage: #imageLiteral(resourceName: "favorites")),
      downloads.wrapInNav(tabBarTitle: "Downloads", tabBarImage: #imageLiteral(resourceName: "downloads"))
    ]
  }
}
