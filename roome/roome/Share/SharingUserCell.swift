//
//  SharingUserCell.swift
//  roome
//
//  Created by minsong kim on 6/26/24.
//

import UIKit
import Combine

class SharingUserCell: UICollectionViewCell {
    private let userLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .boldTitle3
        
        return label
    }()
    
    private let lineView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .line
        
        return view
    }()
    
    private let cardButton: UIButton = {
        var configuration = UIButton.Configuration.plain()
        configuration.baseForegroundColor = .white
        configuration.title = "프로필 카드"
        configuration.titleAlignment = .center
        
        let button = UIButton(configuration: configuration)
        button.translatesAutoresizingMaskIntoConstraints = false
        
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configureShadow()
        configureContentView()
        configureUserLabel()
        configureButton()
        configureLine()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        cardButton.titleLabel?.font = .boldTitle4
    }
    
    func updateNickname(_ nickname: String) {
        userLabel.text = nickname
    }
    
    func cardButtonPublisher() -> AnyPublisher<Void, Never> {
        cardButton.publisher(for: .touchUpInside).eraseToAnyPublisher()
    }
    
    private func configureShadow() {
        layer.shadowColor = UIColor.label.cgColor
        layer.shadowOpacity = 0.5
        layer.shadowRadius = 5
        layer.shadowOffset = CGSize(width: 0, height: 2)
    }
    
    private func configureContentView() {
        contentView.layer.cornerRadius = 10
        contentView.layer.masksToBounds = true
        contentView.backgroundColor = .roomeMain
    }
    
    private func configureUserLabel() {
        contentView.addSubview(userLabel)
        
        NSLayoutConstraint.activate([
            userLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 24),
            userLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -24),
            userLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 12),
            userLabel.heightAnchor.constraint(equalToConstant: 40)
        ])
    }
    
    func configureLine() {
        contentView.addSubview(lineView)
        
        NSLayoutConstraint.activate([
            lineView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 24),
            lineView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -24),
            lineView.heightAnchor.constraint(equalToConstant: 2),
            lineView.bottomAnchor.constraint(equalTo: cardButton.topAnchor),
            lineView.centerXAnchor.constraint(equalTo: self.centerXAnchor)
        ])
    }
    
    func configureButton() {
        contentView.addSubview(cardButton)
        
        NSLayoutConstraint.activate([
            cardButton.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: 0.4),
            cardButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            cardButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 24),
            cardButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -24)
        ])
    }
}
