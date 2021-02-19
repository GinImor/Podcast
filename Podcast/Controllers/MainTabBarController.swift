//
//  MainTabBarController.swift
//  Podcast
//
//  Created by Gin Imor on 2/14/21.
//  Copyright © 2021 Brevity. All rights reserved.
//

import UIKit

class MainTabBarController: UITabBarController {
  
  let episodePlayerView = EpisodePlayerView.shared
  var playerViewTopToSuperViewTopConstraint: NSLayoutConstraint!
  var playerViewTopToTabBarTopConstraint: NSLayoutConstraint!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    setupBarAppearance()
    setupChileVCs()
    setupPlayerView()
    
//    view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(expandPlayerViewToTop)))
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
  
  private func setupPlayerView() {
    view.insertSubview(episodePlayerView, belowSubview: tabBar)
    
    episodePlayerView.disableTAMIC()
    
    playerViewTopToSuperViewTopConstraint =
      episodePlayerView.topAnchor.constraint(equalTo: view.topAnchor, constant: view.bounds.height)
    playerViewTopToTabBarTopConstraint =
      tabBar.topAnchor.constraint(equalTo: episodePlayerView.topAnchor, constant: 64)
    
    NSLayoutConstraint.activate([
      playerViewTopToSuperViewTopConstraint,
      episodePlayerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
      view.trailingAnchor.constraint(equalTo: episodePlayerView.trailingAnchor),
      episodePlayerView.heightAnchor.constraint(equalToConstant: view.bounds.height)
    ])
    
    episodePlayerView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(expandPlayerViewToTop)))
    episodePlayerView.addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(handlePan(_:))))
    
    episodePlayerView.willDismiss = { [unowned self] in
      self.narrowPlayerViewAboveTabBar()
    }
    episodePlayerView.willPopulateWithEpisode = { [unowned self] (episode) in
      if self.episodePlayerView.episode != episode {
        self.episodePlayerView.episode = episode
      }
      self.expandPlayerViewToTop()
    }
  }
  
  var isMiniPlayerView: Bool { playerViewTopToTabBarTopConstraint.isActive }
  
  @objc func handlePan(_ pan: UIPanGestureRecognizer) {
    let translationY = pan.translation(in: self.view).y
    let percentage = abs(translationY / (self.view.frame.height/2))
    
    switch pan.state {
    case .began:
      print(translationY, pan.velocity(in: self.view).y)
    case .changed:
      
      if isMiniPlayerView && translationY > 0 || !isMiniPlayerView && translationY < 0 {
        return
      }
      episodePlayerView.transform = CGAffineTransform(translationX: 0, y: translationY)
      
      episodePlayerView.miniView.alpha = isMiniPlayerView ? 1 - percentage : percentage
      episodePlayerView.fullSizeView.alpha = isMiniPlayerView ? percentage : 1 - percentage
    case .ended:

      let velocityY = pan.velocity(in: self.view).y
      UIView.animate(withDuration: 0.3) {
        self.episodePlayerView.transform = .identity
      }
      if percentage > 0.5 || (isMiniPlayerView && velocityY < -500 || !isMiniPlayerView && velocityY > 500) {
        if self.isMiniPlayerView {
          self.expandPlayerViewToTop()
        } else {
          self.narrowPlayerViewAboveTabBar()
        }
      } else {
        UIView.animate(withDuration: 0.3) {
          self.episodePlayerView.miniView.alpha = self.isMiniPlayerView ? 1 : 0
          self.episodePlayerView.fullSizeView.alpha = self.isMiniPlayerView ? 0 : 1
        }
      }
    default:
      break
    }
  }
  
  @objc func expandPlayerViewToTop() {
    episodePlayerView.gestureRecognizers?.first?.isEnabled = false
    playerViewTopToTabBarTopConstraint.isActive = false
    playerViewTopToSuperViewTopConstraint.isActive = true
    playerViewTopToSuperViewTopConstraint.constant = 0
    animatePlayerViewLayoutChange(expanding: true)
  }
  
  @objc func narrowPlayerViewAboveTabBar() {
    playerViewTopToSuperViewTopConstraint.isActive = false
    playerViewTopToTabBarTopConstraint.isActive = true
    animatePlayerViewLayoutChange(expanding: false)
    episodePlayerView.gestureRecognizers?.first?.isEnabled = true
  }
  
  private func animatePlayerViewLayoutChange(expanding: Bool) {
    UIView.animate(
      withDuration: 0.7,
      delay: 0.0,
      usingSpringWithDamping: 0.7,
      initialSpringVelocity: 0.0,
      options: .curveEaseOut,
      animations: {
        if expanding {
          self.view.layoutIfNeeded()
          self.tabBar.transform = CGAffineTransform(translationX: 0, y: self.tabBar.frame.height)
        } else {
          // because playerView layout rely on tabBar, so need to put tabBar in place first
          self.tabBar.transform = .identity
          self.view.layoutIfNeeded()
        }
        self.episodePlayerView.miniView.alpha = expanding ? 0.0 : 1.0
        self.episodePlayerView.fullSizeView.alpha = expanding ? 1.0 : 0.0
      }
    )
  }
  
}
