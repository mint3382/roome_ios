//
//  AgreeButton.swift
//  roome
//
//  Created by minsong kim on 7/13/24.
//

import UIKit

class AgreeButton: UIButton {
    private let agreeImageView: UIImageView = {
        let view = UIImageView(image: UIImage(systemName: "checkmark.circle.fill")?.changeImageColor(.disable).resize(newWidth: 24))
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    private let agreeTitleLabel: UILabel = {
        let label = UILabel()
        label.font = .regularBody2
        label.textColor = .label
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()

    
    override init(frame: CGRect = .zero) {
        super.init(frame: frame)
        self.translatesAutoresizingMaskIntoConstraints = false
        self.backgroundColor = .clear
    }
    
    convenience init(title: String, image: UIImage? = nil) {
        self.init()
        configureUI()
        self.agreeTitleLabel.text = title
        
        if let image {
            agreeImageView.image = image
        }
    }
    
    override var isSelected: Bool {
        didSet {
            if isSelected {
                self.agreeImageView.image = UIImage(systemName: "checkmark.circle.fill")?.changeImageColor(.roomeMain).resize(newWidth: 24)
            } else {
                self.agreeImageView.image = UIImage(systemName: "checkmark.circle.fill")?.changeImageColor(.disable).resize(newWidth: 24)
            }
        }
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureUI() {
        self.addSubview(agreeImageView)
        self.addSubview(agreeTitleLabel)
        
        NSLayoutConstraint.activate([
            agreeImageView.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor),
            agreeImageView.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor),
            
            agreeTitleLabel.leadingAnchor.constraint(equalTo: agreeImageView.trailingAnchor, constant: 8),
            agreeTitleLabel.centerYAnchor.constraint(equalTo: agreeImageView.centerYAnchor)
        ])
    }
}
