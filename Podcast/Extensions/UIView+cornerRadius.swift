//
//  UIView+cornerRadius.swift
//  Podcast
//
//  Created by Gin Imor on 2/24/21.
//  Copyright © 2021 Brevity. All rights reserved.
//

import UIKit

extension UIView {
  
  func setupStandardCornerRadius() {
    layer.cornerRadius = ceil(min(bounds.width, bounds.height) * 0.05)
    layer.masksToBounds = true
  }
}
