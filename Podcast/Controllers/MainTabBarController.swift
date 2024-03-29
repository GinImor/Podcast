//
//  MainTabBarController.swift
//  Podcast
//
//  Created by Gin Imor on 2/14/21.
//  Copyright © 2021 Brevity. All rights reserved.
//

import UIKit

class MainTabBarController: UITabBarController {
  
  let episodePlayerView = EpisodePlayerView.newView()
  var playerViewTopToSuperViewBottomConstraint: NSLayoutConstraint!
  
  var isMiniPlayerView = false
  var topConstant: CGFloat { -view.frame.height }
  var lowConstant: CGFloat { -(tabBar.frame.height+64)}
  var initialConstantY: CGFloat { isMiniPlayerView ? lowConstant : topConstant }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    setupBarAppearance()
    setupChileVCs()
    setupPlayerView()
  }
  
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    
    episodePlayerView.fullSizeViewBottomToSuperViewBottom.constant =
      view.bounds.height * 0.55 + view.window!.safeAreaInsets.bottom
  }
  
  private func setupBarAppearance() {
    tabBar.tintColor = .primaryColor
  }
  
  private func setupChileVCs() {
    let favorites = FavoritesController(collectionViewLayout: CarouselViewLayout())
    let search = PodcastSearchController()
    let downloads = DownloadsController()
    
    let favoriteImage = UIImage(systemName: "heart.circle.fill")!
    let searchImage = UIImage(systemName: "magnifyingglass.circle.fill")!
    let downloadImage = UIImage(systemName: "square.and.arrow.down.fill")!
    viewControllers = [
      favorites.wrapInNav(tabBarTitle: "Favourites", tabBarImage: favoriteImage),
      search.wrapInNav(tabBarTitle: "Search", tabBarImage: searchImage),
      downloads.wrapInNav(tabBarTitle: "Downloads", tabBarImage: downloadImage)
    ]
  }
  
  private func setupPlayerView() {
    view.insertSubview(episodePlayerView, belowSubview: tabBar)
    
    episodePlayerView.disableTAMIC()
    
    playerViewTopToSuperViewBottomConstraint =
      episodePlayerView.topAnchor.constraint(equalTo: view.bottomAnchor, constant: 0)
    
    NSLayoutConstraint.activate([
      playerViewTopToSuperViewBottomConstraint,
      episodePlayerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
      view.trailingAnchor.constraint(equalTo: episodePlayerView.trailingAnchor),
      episodePlayerView.heightAnchor.constraint(equalToConstant: view.bounds.height * 1.5)
    ])
    
    episodePlayerView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(expandPlayerViewToTop)))
    episodePlayerView.addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(handlePan(_:))))
    
    episodePlayerView.willCollapse = { [unowned self] in
      self.narrowPlayerViewAboveTabBar()
    }
    episodePlayerView.willPopulateWithEpisode = { [unowned self] (episode, episodes) in
      if self.episodePlayerView.episode != episode {
        self.episodePlayerView.episode = episode
      }
      // while palying current episode, the user maybe exit the EpisodesController
      // and back again, and the podcast may updated, so no matter the user chosen
      // the same episodes or not, need to update the episodes
      self.episodePlayerView.episodes = episodes
      self.expandPlayerViewToTop()
    }
  }
  
  @objc func handlePan(_ pan: UIPanGestureRecognizer) {
    let translationY = pan.translation(in: self.view).y
    let rawPercentage = translationY / (self.view.frame.height/2)
    let percentage = abs(rawPercentage)
    
    switch pan.state {
    case .began:
      isMiniPlayerView = episodePlayerView.miniView.alpha == 1.0
    case .changed:
      
      if isMiniPlayerView && translationY > 0 || !isMiniPlayerView && translationY < 0 {
        return
      }
      
      episodePlayerView.transform = CGAffineTransform(translationX: 0, y: translationY)
      
      episodePlayerView.miniView.alpha = isMiniPlayerView ? 1 - percentage : percentage
      episodePlayerView.fullSizeView.alpha = isMiniPlayerView ? percentage : 1 - percentage
    case .ended:
      let velocityY = pan.velocity(in: self.view).y
      
      if isMiniPlayerView && (velocityY < -500 || rawPercentage < -0.5) {
        self.expandPlayerViewToTop()
      } else if !isMiniPlayerView && (velocityY > 500 || rawPercentage > 0.5) {
        self.narrowPlayerViewAboveTabBar()
      } else if isMiniPlayerView {
        self.narrowPlayerViewAboveTabBar()
      } else {
        self.expandPlayerViewToTop()
      }
    default:
      break
    }
  }
  
  @objc func expandPlayerViewToTop() {
    episodePlayerView.gestureRecognizers?.first?.isEnabled = false
    playerViewTopToSuperViewBottomConstraint.constant = topConstant
    animatePlayerViewLayoutChange(expanding: true)
  }
  
  @objc func narrowPlayerViewAboveTabBar() {
    episodePlayerView.gestureRecognizers?.first?.isEnabled = true
    playerViewTopToSuperViewBottomConstraint.constant = lowConstant
    animatePlayerViewLayoutChange(expanding: false)
  }
  
  private func animatePlayerViewLayoutChange(expanding: Bool) {
    UIView.animate(
      withDuration: 0.7,
      delay: 0.0,
      usingSpringWithDamping: 0.7,
      initialSpringVelocity: 0.0,
      options: .curveEaseOut,
      animations: {
        self.view.layoutIfNeeded()
        self.episodePlayerView.transform = .identity
        
        self.tabBar.alpha = expanding ? 0.0 : 1.0
        self.episodePlayerView.miniView.alpha = expanding ? 0.0 : 1.0
        self.episodePlayerView.fullSizeView.alpha = expanding ? 1.0 : 0.0
      }
    )
  }
  
}
