//
//  MyProfileCell.swift
//  roome
//
//  Created by minsong kim on 6/18/24.
//

import UIKit

class MyProfileCell: UICollectionViewCell {
    private let optionLabel: UILabel = {
        let label = UILabel()
        label.font = .mediumCaption
        label.textColor = .gray
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    private let stackView: UIStackView = {
        let stack = UIStackView(axis: .vertical, alignment: .trailing)
        
        return stack
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureShadow()
        configureContentView()
        configureOptionLabel()
        configureStackView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func updateOption(text: String?) {
        optionLabel.text = text
    }
    
    func updateSelects(_ selects: [String?], isBig: Bool) {
        if isBig {
            let label = UILabel()
            label.font = .boldTitle1
            label.text = selects[0] != "NONE" ? selects[0] : "-"
            stackView.addArrangedSubview(label)
        } else {
            selects.forEach { select in
                let label = UILabel()
                label.font = .boldLabel
                label.text = select ?? "-"
                stackView.addArrangedSubview(label)
            }
        }
    }
    
    private func configureShadow() {
        layer.shadowColor = UIColor.label.cgColor
        layer.shadowOpacity = 0.2
        layer.shadowRadius = 5
        layer.shadowOffset = CGSize(width: 0, height: 2)
    }
    
    private func configureContentView() {
        contentView.backgroundColor = .systemBackground
        contentView.layer.borderColor = UIColor.disable.cgColor
        contentView.layer.cornerRadius = 10
        contentView.layer.masksToBounds = true
    }
    
    private func configureOptionLabel() {
        contentView.addSubview(optionLabel)
        
        NSLayoutConstraint.activate([
            optionLabel.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 0.85),
            optionLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            optionLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 12)
        ])
    }
    
    private func configureStackView() {
        contentView.addSubview(stackView)
        
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(greaterThanOrEqualTo: optionLabel.bottomAnchor),
            stackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -16),
            stackView.leadingAnchor.constraint(equalTo: optionLabel.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: optionLabel.trailingAnchor)
        ])
    }
}
