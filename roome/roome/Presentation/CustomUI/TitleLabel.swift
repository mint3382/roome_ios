//
//  TitleLabel.swift
//  roome
//
//  Created by minsong kim on 5/22/24.
//

import UIKit

class TitleLabel: UILabel {
    private var padding = UIEdgeInsets(top: 20, left: 24, bottom: 0, right: 24)

    convenience init(text: String) {
        self.init()
        self.text = text
        self.numberOfLines = 2
        self.font = UIFont().pretendardBold(size: .headline2)
        self.translatesAutoresizingMaskIntoConstraints = false
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
}
