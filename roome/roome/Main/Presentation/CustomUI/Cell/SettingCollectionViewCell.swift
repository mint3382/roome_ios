//
//  SettingCollectionViewCell.swift
//  roome
//
//  Created by minsong kim on 6/25/24.
//

import UIKit

class SettingCollectionViewCell: UICollectionViewListCell {
    static let id = "SettingCollectionViewCell"
    private let label: UILabel = {
        let label = PaddingLabel(padding: UIEdgeInsets(top: 19, left: 24, bottom: 19, right: 24))
        label.font = .regularBody1
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    private var viewModel: SettingViewModel?
    var state: SettingItem? {
        didSet {
            switch state {
            case .version:
                accessories = [.label(text: "최신 버전", options: .init(reservedLayoutWidth: .custom(100)))]
            default:
                accessories = [.disclosureIndicator(options: .init(reservedLayoutWidth: .custom(50)))]
                
            }
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configureContentView()
        configureLabel()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureCell(viewModel: SettingViewModel, title: String, state: SettingItem) {
        self.viewModel = viewModel
        self.label.text = title
        self.state = state
    }
    
    private func configureContentView() {
        contentView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            contentView.topAnchor.constraint(equalTo: self.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            contentView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            contentView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -24)
        ])
    }
    
    private func configureLabel() {
        self.addSubview(label)
        
        NSLayoutConstraint.activate([
            label.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            label.topAnchor.constraint(equalTo: contentView.topAnchor),
            label.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            label.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            label.centerXAnchor.constraint(equalTo: contentView.centerXAnchor)
        ])
    }
}
