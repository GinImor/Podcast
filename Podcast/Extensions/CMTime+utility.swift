//
//  CMTime+utility.swift
//  Podcast
//
//  Created by Gin Imor on 2/17/21.
//  Copyright © 2021 Brevity. All rights reserved.
//

import AVKit

extension CMTime {
  
  var preciseSec: Float64 { CMTimeGetSeconds(self) }
  var seconds: Int { Int(preciseSec) }
  
  func toTimeString() -> String {
    var result = ""
    var remaining = seconds
    for _ in 0...1 {
      result = String(format: ":%02d", remaining % 60) + result
      remaining /= 60
    }
    return String(format: "%02d", remaining) + result
  }
  
  func devidedBy(_ divider: CMTime) -> Float {
    return Float(preciseSec / divider.preciseSec)
  }
  
}
