//
//  ToastLabel.swift
//  roome
//
//  Created by minsong kim on 5/24/24.
//

import UIKit

class ToastLabel: UILabel {
    private var padding = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        settingLabel()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func settingLabel() {
        self.backgroundColor = UIColor.black
        self.textColor = UIColor.white
        self.font = UIFont().pretendardMedium(size: .body2)
        self.textAlignment = .left
        self.alpha = 1.0
        self.layer.cornerRadius = 10
        self.clipsToBounds = true
        self.numberOfLines = 0
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
