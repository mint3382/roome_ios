//
//  UIStackView+.swift
//  roome
//
//  Created by minsong kim on 6/3/24.
//

import UIKit

//profile view 구현시 사용하는 stackView
extension UIStackView {
    convenience init(axis: NSLayoutConstraint.Axis, alignment: UIStackView.Alignment = .leading, spacing: CGFloat = 4) {
        self.init()
        self.axis = axis
        self.distribution = .fillProportionally
        self.alignment = alignment
        self.spacing = spacing
        self.translatesAutoresizingMaskIntoConstraints = false
    }
}
