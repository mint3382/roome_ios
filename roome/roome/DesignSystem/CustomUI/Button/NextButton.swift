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
        self.layer.cornerRadius = 10
        self.setTitle("다음", for: .normal)
        self.titleLabel?.font = .boldTitle3
        self.isEnabled = false
        self.translatesAutoresizingMaskIntoConstraints = false
    }
    
    convenience init(title: String, backgroundColor: UIColor, tintColor: UIColor) {
        self.init()
        self.setTitle(title, for: .normal)
        self.isEnabled = true
        self.backgroundColor = backgroundColor
        self.tintColor = tintColor
        self.setTitleColor(tintColor, for: .normal)
    }
    
    override var isEnabled: Bool {
        didSet {
            if isEnabled {
                self.backgroundColor = .roomeMain
                self.setTitleColor(.white, for: .normal)
            } else {
                self.backgroundColor = .disable
                self.setTitleColor(.disableTint, for: .normal)
            }
        }
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
