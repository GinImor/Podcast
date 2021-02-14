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
    tabBar.tintColor = .purple
  }
  
  private func setupChileVCs() {
    let favorites = ViewController()
    let search = ViewController()
    let downloads = ViewController()
    
    viewControllers = [
      favorites.wrapInNav(tabBarTitle: "Favourites", tabBarImage: #imageLiteral(resourceName: "favorites")),
      search.wrapInNav(tabBarTitle: "Search", tabBarImage: #imageLiteral(resourceName: "search")),
      downloads.wrapInNav(tabBarTitle: "Downloads", tabBarImage: #imageLiteral(resourceName: "downloads"))
    ]
  }
}
