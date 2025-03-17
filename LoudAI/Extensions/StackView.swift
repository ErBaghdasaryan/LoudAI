//
//  StackView.swift
//  LoudAI
//
//  Created by Er Baghdasaryan on 17.03.25.
//

import UIKit

public extension UIStackView {
    convenience init(arrangedSubviews: [UIView], axis: NSLayoutConstraint.Axis, spacing: CGFloat) {
        self.init(arrangedSubviews: arrangedSubviews)

        self.axis = axis
        self.spacing = spacing
        self.distribution = .fillEqually
        self.isUserInteractionEnabled = true
    }
}
