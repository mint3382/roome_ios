//
//  ButtonCell.swift
//  roome
//
//  Created by minsong kim on 5/23/24.
//

import UIKit

class ButtonCell: UICollectionViewCell {
    let titleLabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.addSubview(titleLabel)
        contentView.layer.borderColor = UIColor.gray.cgColor
        contentView.layer.borderWidth = 2
        contentView.layer.cornerRadius = 10
        contentView.layer.masksToBounds = true
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            titleLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            titleLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        self.isHighlighted = false
    }
    
    override var isSelected: Bool {
        didSet {
            if isSelected {
                contentView.layer.borderColor = UIColor.roomeMain.cgColor
            } else {
                contentView.layer.borderColor = UIColor.gray.cgColor
            }
        }
    }
    
    func changeTitle(_ text: String) {
        titleLabel.text = text
        titleLabel.font = UIFont().pretendardBold(size: .label)
    }
}
