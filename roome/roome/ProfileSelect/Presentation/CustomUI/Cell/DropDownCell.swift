//
//  DropDownCell.swift
//  roome
//
//  Created by minsong kim on 6/6/24.
//

import UIKit

class DropDownCell: UITableViewCell {
    let label: UILabel = {
        let label = PaddingLabel()
        label.font = .regularBody2
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.clipsToBounds = true
        self.layer.cornerRadius = 10
        self.layer.borderColor = UIColor.clear.cgColor
        configureLabel()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func configureLabel() {
        self.addSubview(label)
        
        NSLayoutConstraint.activate([
            label.leadingAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.leadingAnchor),
            label.topAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.topAnchor),
            label.trailingAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.trailingAnchor),
            label.bottomAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
    func changeTitle(text: String) {
        label.text = text
    }
}
