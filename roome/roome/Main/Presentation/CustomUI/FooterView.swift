//
//  FooterView.swift
//  roome
//
//  Created by minsong kim on 6/25/24.
//

import UIKit

class FooterView: UICollectionReusableView {
    static let id = "FooterView"
    
    private let titleLabel: UILabel = {
        let label = PaddingLabel(padding: UIEdgeInsets(top: 0, left: 24, bottom: 0, right: 24))
        label.font = .regularBody3
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(titleLabel)
        configureLabelUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureLabel(text: String) {
        titleLabel.text = text
    }

    func configureLabelUI() {
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            titleLabel.topAnchor.constraint(equalTo: self.topAnchor),
            titleLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor)
        ])
    }
}

