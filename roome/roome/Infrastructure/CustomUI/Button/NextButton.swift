//
//  NextButton.swift
//  roome
//
//  Created by minsong kim on 5/22/24.
//

import UIKit

class NextButton: UIButton {
    override init(frame: CGRect = .zero) {
        super.init(frame: frame)
        self.tintColor = .white
        self.layer.cornerRadius = 10
        self.setTitle("다음", for: .normal)
        self.titleLabel?.font = UIFont().pretendardBold(size: .title2)
        self.isEnabled = false
        self.translatesAutoresizingMaskIntoConstraints = false
        self.backgroundColor = .gray
    }
    
    convenience init(title: String, backgroundColor: UIColor, tintColor: UIColor) {
        self.init()
        self.setTitle(title, for: .normal)
        self.isEnabled = true
        self.backgroundColor = backgroundColor
        self.tintColor = tintColor
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
