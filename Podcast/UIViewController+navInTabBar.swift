//
//  UIViewController+navInTabBar.swift
//  Podcast
//
//  Created by Gin Imor on 2/14/21.
//  Copyright © 2021 Brevity. All rights reserved.
//

import UIKit

extension UIViewController {
  
  func wrapInNav(tabBarTitle: String, tabBarImage: UIImage) -> UINavigationController {
    let nav = UINavigationController(rootViewController: self)
    
    nav.tabBarItem.title = tabBarTitle
    nav.tabBarItem.image = tabBarImage
    navigationItem.title = tabBarTitle
    return nav
  }
}
