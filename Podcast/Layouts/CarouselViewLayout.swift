//
//  CarouselViewLayout.swift
//  Podcast
//
//  Created by Gin Imor on 3/1/21.
//  Copyright © 2021 Brevity. All rights reserved.
//

import UIKit

class CarouselViewLayout: UICollectionViewFlowLayout {
  
  var defaultItemAlpha: CGFloat = 0.5
  var defaultItemScale: CGFloat = 0.5
  var isSetup = false
  
  var initialSafeAreaInsets: UIEdgeInsets!
  
  override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
    return true
  }
  
  override func prepare() {
    super.prepare()
    if !isSetup {
      setupCollectionView()
      isSetup = true
    }
  }
  
  private func setupCollectionView() {
    collectionView?.decelerationRate = .fast
    setContentTopBottomInset()
  }
  
  private func setContentTopBottomInset() {
    guard let collectionView = collectionView else { return }
    
    if initialSafeAreaInsets == nil {
      initialSafeAreaInsets = collectionView.safeAreaInsets
    }
    setContentInset()
  }
  
  private func setContentInset() {
    let itemHeight = self.itemSize.height
    let collectionViewTopHalfSafeAreaHeight = collectionView!.bounds.height/2 - initialSafeAreaInsets.top
    let collectionViewBottomHalfSafeAreaHeight = collectionView!.bounds.height/2 - initialSafeAreaInsets.bottom
    
    let topInset = collectionViewTopHalfSafeAreaHeight - itemHeight/2
    let bottomInset = collectionViewBottomHalfSafeAreaHeight - itemHeight/2
    self.sectionInset = UIEdgeInsets(top: topInset, left: 0, bottom: bottomInset, right: 0)
  }
  
  override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
    let attributesArray = super.layoutAttributesForElements(in: rect)
    var adjustedAttributesArray = [UICollectionViewLayoutAttributes]()
    
    for attributes in attributesArray! {
      let adjustedAttributes = attributes.copy() as! UICollectionViewLayoutAttributes
      adjustLayoutAttributes(adjustedAttributes)
      adjustedAttributesArray.append(adjustedAttributes)
    }
    return adjustedAttributesArray
  }
  
  private func adjustLayoutAttributes(_ layoutAttributes: UICollectionViewLayoutAttributes) {
    let collectionViewHalfHeight = collectionView!.frame.height/2
    let boudingDistance = collectionViewHalfHeight * 0.7
    let itemCenterY = layoutAttributes.center.y
    let normalizedItemCenterY = itemCenterY - collectionView!.contentOffset.y
    
    let distanceFromCenter = abs(normalizedItemCenterY - collectionViewHalfHeight)
    let boundedDistanceFromCenter = min(distanceFromCenter, boudingDistance)
    let ratio = (boudingDistance - boundedDistanceFromCenter) / boudingDistance
    
    let alpha = ratio * (1 - defaultItemAlpha) + defaultItemAlpha
    let scale = ratio * (1 - defaultItemScale) + defaultItemScale
    
    layoutAttributes.alpha = alpha
    layoutAttributes.transform3D = CATransform3DScale(CATransform3DIdentity, scale, scale, 1)
    layoutAttributes.zIndex = Int(alpha * 10)
  }
  
  override func targetContentOffset(forProposedContentOffset proposedContentOffset: CGPoint, withScrollingVelocity velocity: CGPoint) -> CGPoint {
    guard let collectionView = collectionView, !collectionView.isPagingEnabled,
      let layoutAttributesArray = layoutAttributesForElements(in: collectionView.bounds)
      else { return proposedContentOffset }

    let proposedContentOffsetOriginY = proposedContentOffset.y + collectionView.bounds.height/2
    let centeringAttributes = layoutAttributesArray.min {
      return abs($0.center.y - proposedContentOffsetOriginY) < abs($1.center.y - proposedContentOffsetOriginY)
    }!

    let targetContentOffsetY = centeringAttributes.center.y - collectionView.bounds.height/2
    let targetContentOffset = CGPoint(x: proposedContentOffset.x, y: targetContentOffsetY)
    
    return targetContentOffset
  }
  
}

