//
//  SettingCell.swift
//  roome
//
//  Created by minsong kim on 6/21/24.
//

import UIKit

class SettingCell: UITableViewCell {
    var state: Statable?
    
    let label: UILabel = {
        let label = PaddingLabel(padding: UIEdgeInsets(top: 20, left: 6, bottom: 20, right: 0))
        label.font = .regularBody1
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    private var viewModel: SettingViewModel?
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureLabel()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        if selected {
            viewModel?.input.selectCell.send(state)
        }
    }

    private func configureLabel() {
        self.addSubview(label)
        
        NSLayoutConstraint.activate([
            label.leadingAnchor.constraint(equalTo: contentView.layoutMarginsGuide.leadingAnchor),
            label.topAnchor.constraint(equalTo: contentView.layoutMarginsGuide.topAnchor),
            label.trailingAnchor.constraint(equalTo: contentView.layoutMarginsGuide.trailingAnchor),
            label.bottomAnchor.constraint(equalTo: contentView.layoutMarginsGuide.bottomAnchor)
        ])
    }
    
    func changeTitle(text: String?) {
        label.text = text
    }
    
    func changeState(_ state: Statable?) {
        self.state = state
    }
    
    func setViewModel(viewModel: SettingViewModel) {
        self.viewModel = viewModel
    }
}
