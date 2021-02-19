//
//  AppDelegate.swift
//  Podcast
//
//  Created by Gin Imor on 2/14/21.
//  Copyright © 2021 Brevity. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {



  func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
    setupNavigationBarAppearance()
    return true
  }

  private func setupNavigationBarAppearance() {
    let barStandardAppearance = UINavigationBarAppearance()
    
    barStandardAppearance.configureWithDefaultBackground()
    barStandardAppearance.titleTextAttributes = [.foregroundColor: UIColor.primaryColor]
    barStandardAppearance.largeTitleTextAttributes = [.foregroundColor: UIColor.primaryColor]
    
    UINavigationBar.appearance().tintColor = .primaryColor
    UINavigationBar.appearance().prefersLargeTitles = true
    UINavigationBar.appearance().standardAppearance = barStandardAppearance
    UINavigationBar.appearance().scrollEdgeAppearance = barStandardAppearance
  }
  
  func applicationDidEnterBackground(_ application: UIApplication) {
    EpisodePlayerView.shared.didEnterBackground = true
  }
  
  func applicationWillEnterForeground(_ application: UIApplication) {
    EpisodePlayerView.shared.didEnterBackground = false
  }
  
  // MARK: UISceneSession Lifecycle

  func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
    // Called when a new scene session is being created.
    // Use this method to select a configuration to create the new scene with.
    return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
  }

  func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
    // Called when the user discards a scene session.
    // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
    // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
  }


}

