//
//  DateFormatter+customInstance.swift
//  IntermediateTraining
//
//  Created by Gin Imor on 2/3/21.
//  Copyright © 2021 Brevity. All rights reserved.
//

import Foundation

extension DateFormatter {
  
  static let m3D2Y4: DateFormatter = {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "MMM dd, YYYY"
    return dateFormatter
  }()
  
  static let m2sD2sY4: DateFormatter = {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "MM/dd/yyyy"
    return dateFormatter
  }()
}
