//
//  UILabel+.swift
//  roome
//
//  Created by minsong kim on 6/4/24.
//

import UIKit

//profile View 구현시 사용하는 Label
extension UILabel {
    convenience init (description: String?, textColor: UIColor = .white, font: UIFont = UIFont().pretendardRegular(size: .body1)) {
        self.init(frame: .zero)
        self.text = description
        self.textColor = textColor
        self.font = font
        self.adjustsFontSizeToFitWidth = true
        self.minimumScaleFactor = 0.7
        self.translatesAutoresizingMaskIntoConstraints = false
    }
}

