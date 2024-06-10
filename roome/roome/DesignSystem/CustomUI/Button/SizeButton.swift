//
//  SizeButton.swift
//  roome
//
//  Created by minsong kim on 6/3/24.
//

import UIKit

class SizeButton: UIButton {
    override init(frame: CGRect = .zero) {
        super.init(frame: frame)
        self.tintColor = .label
        self.setTitleColor(.label, for: .normal)
        self.layer.cornerRadius = 10
        self.titleLabel?.font = .boldTitle3
        self.translatesAutoresizingMaskIntoConstraints = false
        self.backgroundColor = .clear
        self.layer.borderWidth = 2
    }
    
    convenience init(title: String, isSelected: Bool) {
        self.init()
        self.setTitle(title, for: .normal)
        self.isSelected = isSelected
    }
    
    override var isSelected: Bool {
        didSet {
            if isSelected {
                self.layer.borderColor = UIColor.roomeMain.cgColor
            } else {
                self.layer.borderColor = UIColor.gray.cgColor
            }
        }
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
