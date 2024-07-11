//
//  WithdrawalCollectionViewCell.swift
//  roome
//
//  Created by minsong kim on 7/11/24.
//

import UIKit

class WithdrawalCollectionViewCell: UICollectionViewListCell {
    static let id = "WithdrawalCollectionViewCell"
    private let label: UILabel = {
        let label = PaddingLabel(padding: UIEdgeInsets(top: 19, left: 24, bottom: 19, right: 24))
        label.textColor = .label
        label.font = .regularBody1
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configureLabel()
        accessories = [.disclosureIndicator(options: .init(reservedLayoutWidth: .custom(50)))]
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override var isSelected: Bool {
        didSet {
            self.backgroundColor = .systemBackground
        }
    }
    
    func configureCell(title: String) {
        label.text = title
    }
    
    private func configureLabel() {
        self.addSubview(label)
        self.backgroundColor = .systemBackground
        
        NSLayoutConstraint.activate([
            label.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            label.topAnchor.constraint(equalTo: contentView.topAnchor),
            label.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            label.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            label.centerXAnchor.constraint(equalTo: contentView.centerXAnchor)
        ])
    }
}
