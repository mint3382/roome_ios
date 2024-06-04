//
//  UIStackView+.swift
//  roome
//
//  Created by minsong kim on 6/3/24.
//

import UIKit

//profile view 구현시 사용하는 stackView
extension UIStackView {
    convenience init(number: Int) {
        self.init()
        self.axis = .horizontal
        self.distribution = .fillProportionally
        self.alignment = .center
        self.spacing = 4
    }
}
