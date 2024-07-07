//
//  ProfileLabel.swift
//  roome
//
//  Created by minsong kim on 6/3/24.
//

import UIKit

class ProfileLabel: UILabel {
    private var padding = UIEdgeInsets(top: 4.0, left: 8.0, bottom: 4.0, right: 8.0)

    convenience init(padding: UIEdgeInsets = UIEdgeInsets(top: 6.0, left: 12.0, bottom: 6.0, right: 12.0) , text: String?, isIntroduceLine: Bool = false, font: UIFont = .boldTitle3) {
        self.init()
        self.text = text
        self.font = font
        self.adjustsFontSizeToFitWidth = true
        self.minimumScaleFactor = 0.7
        configureLabel()
        if isIntroduceLine {
            self.padding = UIEdgeInsets(top: 2, left: 6, bottom: 2, right: 6)
            self.layer.cornerRadius = 8
        } else {
            self.padding = padding
            self.layer.cornerRadius = 15
        }
    }

    override func drawText(in rect: CGRect) {
        super.drawText(in: rect.inset(by: padding))
    }

    override var intrinsicContentSize: CGSize {
        var contentSize = super.intrinsicContentSize
        contentSize.height += padding.top + padding.bottom
        contentSize.width += padding.left + padding.right

        return contentSize
    }
    
    func configureLabel() {
        self.backgroundColor = UIColor(red: 1, green: 1, blue: 1, alpha: 0.2)
        self.textColor = .white
        self.clipsToBounds = true
    }
    
    func updateFont(font: UIFont) {
        self.font = font
    }
}
