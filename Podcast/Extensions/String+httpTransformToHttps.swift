//
//  String+httpTransformToHttps.swift
//  Podcast
//
//  Created by Gin Imor on 2/17/21.
//  Copyright © 2021 Brevity. All rights reserved.
//

import Foundation

extension String {
  
  func toHttps() -> String {
    self.replacingOccurrences(of: "http://", with: "https://")
  }
}
