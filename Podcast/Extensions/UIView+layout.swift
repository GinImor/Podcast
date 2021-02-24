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
  
  public static let defaultPadding: CGFloat = 10.0

  /// Creates a new instance of the receiver class, configured for use with Auto Layout.
  /// - Returns: An instance of the receiver class.
  public static func autolayoutNew() -> Self {
    let view = self.init(frame: .zero)
    view.translatesAutoresizingMaskIntoConstraints = false
    return view
  }
  
  func pinToSuperviewEdges() {
    guard let superview = superview else { return }
    disableTAMIC()
    NSLayoutConstraint.activate([
      topAnchor.constraint(equalTo: superview.topAnchor),
      leadingAnchor.constraint(equalTo: superview.leadingAnchor),
      trailingAnchor.constraint(equalTo: superview.trailingAnchor),
      bottomAnchor.constraint(equalTo: superview.bottomAnchor)
    ])
  }
  
  func centerToSuperviewSafeAreaLayoutGuide() {
    guard let superview = superview else { return }
    disableTAMIC()
    NSLayoutConstraint.activate([
      centerXAnchor.constraint(equalTo: superview.safeAreaLayoutGuide.centerXAnchor),
      centerYAnchor.constraint(equalTo: superview.safeAreaLayoutGuide.centerYAnchor)
    ])
  }
  
  func centerToSuperviewSafeAreaLayoutGuide(superview: UIView) {
    superview.addSubview(self)
    centerToSuperviewSafeAreaLayoutGuide()
  }
}
