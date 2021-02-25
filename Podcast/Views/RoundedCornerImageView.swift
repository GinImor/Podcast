//
//  RoundedCornerImageView.swift
//  Podcast
//
//  Created by Gin Imor on 2/24/21.
//  Copyright © 2021 Brevity. All rights reserved.
//

import UIKit

class RoundedCornerImageView: UIImageView {
  
  required init?(coder: NSCoder) {
    super.init(coder: coder)
    setupStandardCornerRadius()
  }
}
