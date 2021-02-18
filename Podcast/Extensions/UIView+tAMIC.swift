//
//  UIView+tAMIC.swift
//  IntermediateTraining
//
//  Created by Gin Imor on 1/31/21.
//  Copyright © 2021 Brevity. All rights reserved.
//

import UIKit

extension UIView {
  
  var tAMIC: Bool {
    get { translatesAutoresizingMaskIntoConstraints }
    set { translatesAutoresizingMaskIntoConstraints = newValue }
  }
  
  func disableTAMIC() {
    tAMIC = false
  }
}
