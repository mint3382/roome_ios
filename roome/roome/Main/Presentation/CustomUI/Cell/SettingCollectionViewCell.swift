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
                if compareVersion() {
                    accessories = [.label(text: "최신 버전", options: .init(reservedLayoutWidth: .custom(100), font: .regularBody1))]
                } else {
                    accessories = [.label(text: "업데이트 하기", options: .init(reservedLayoutWidth: .custom(60), font: .regularBody1)), .disclosureIndicator(options: .init(reservedLayoutWidth: .custom(50)))]
                }
            default:
                accessories = [.disclosureIndicator(options: .init(reservedLayoutWidth: .custom(50)))]
                
            }
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configureLabel()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override var isSelected: Bool {
        didSet {
            self.backgroundColor = .systemBackground
        }
    }
    
    func configureCell(viewModel: SettingViewModel, title: String, state: SettingItem) {
        self.viewModel = viewModel
        self.label.text = title
        self.state = state
    }
    
    func compareVersion() -> Bool {
        let previousVersion = VersionManager.currentVersion
        let latestVersion = VersionManager.currentVersion
        
        if previousVersion == latestVersion {
            return true
        } else {
            return false
        }
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
