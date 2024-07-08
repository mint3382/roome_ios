//
//  UserCell.swift
//  roome
//
//  Created by minsong kim on 6/18/24.
//

import UIKit
import Combine

class UserCell: UICollectionViewCell {
    private let userImageButton: UIButton = {
        let button = UIButton()
        button.setImage(UserContainer.shared.userImage, for: .normal)
        button.sizeToFit()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.cornerRadius = 25
        button.clipsToBounds = true
        
        return button
    }()
    
    private let userLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = UserContainer.shared.user?.data.nickname ?? "닉네임"
        label.font = .boldTitle3
        
        return label
    }()
    
    private let detailButton: UIButton = {
        var configuration = UIButton.Configuration.plain()
        configuration.image = UIImage(resource: .rightArrow).changeImageColor(.white).resize(newWidth: 24)
        configuration.imagePlacement = .trailing
        
        let button = UIButton(configuration: configuration)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.clipsToBounds = true
        
        return button
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
    
    private let shareButton: UIButton = {
        var configuration = UIButton.Configuration.plain()
        configuration.baseForegroundColor = .white
        configuration.title = "카카오로 공유"
        configuration.titleAlignment = .center
        
        let button = UIButton(configuration: configuration)
        button.translatesAutoresizingMaskIntoConstraints = false
        
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configureShadow()
        configureContentView()
        configureUserButton()
        configureLine()
        configureButton()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        shareButton.titleLabel?.font = .boldTitle4
        cardButton.titleLabel?.font = .boldTitle4
//        userImageButton.setNeedsLayout()
        updateUserProfile()
    }
    
    func updateUserProfile() {
        userImageButton.setImage(UserContainer.shared.userImage, for: .normal)
        userLabel.text = UserContainer.shared.user?.data.nickname ?? "닉네임"
    }
    
    func userButtonPublisher() -> AnyPublisher<Void, Never> {
        Publishers.Merge(userImageButton.publisher(for: .touchUpInside),
                          detailButton.publisher(for: .touchUpInside)).eraseToAnyPublisher()
    }
    
    func cardButtonPublisher() -> AnyPublisher<Void, Never> {
        cardButton.publisher(for: .touchUpInside).eraseToAnyPublisher()
    }
    
    func shareButtonPublisher() -> AnyPublisher<Void, Never> {
        shareButton.publisher(for: .touchUpInside).eraseToAnyPublisher()
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
    
    private func configureUserButton() {
        contentView.addSubview(userImageButton)
        contentView.addSubview(userLabel)
        contentView.addSubview(detailButton)
        
        NSLayoutConstraint.activate([
            userImageButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 24),
            userImageButton.widthAnchor.constraint(equalToConstant: 50),
            userImageButton.heightAnchor.constraint(equalToConstant: 50),
            userImageButton.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 24),
            
            userLabel.leadingAnchor.constraint(equalTo: userImageButton.trailingAnchor, constant: 12),
            userLabel.trailingAnchor.constraint(equalTo: detailButton.leadingAnchor, constant: -12),
            userLabel.centerYAnchor.constraint(equalTo: userImageButton.centerYAnchor),
            
            detailButton.widthAnchor.constraint(equalToConstant: 50),
            detailButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -24),
            detailButton.heightAnchor.constraint(equalToConstant: 50),
            detailButton.centerYAnchor.constraint(equalTo: userImageButton.centerYAnchor)
        ])
    }
    
    func configureLine() {
        contentView.addSubview(lineView)
        
        NSLayoutConstraint.activate([
            lineView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 24),
            lineView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -24),
            lineView.heightAnchor.constraint(equalToConstant: 2),
            lineView.topAnchor.constraint(equalTo: userImageButton.bottomAnchor, constant: 12),
            lineView.centerXAnchor.constraint(equalTo: self.centerXAnchor)
        ])
    }
    
    
    func configureButton() {
        contentView.addSubview(cardButton)
        contentView.addSubview(shareButton)
        
        NSLayoutConstraint.activate([
            cardButton.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: 0.4),
            cardButton.topAnchor.constraint(equalTo: lineView.bottomAnchor),
            cardButton.centerXAnchor.constraint(equalTo: contentView.centerXAnchor, constant: -(contentView.frame.width * 0.25)),
            
            shareButton.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: 0.4),
            shareButton.topAnchor.constraint(equalTo: lineView.bottomAnchor),
            shareButton.centerXAnchor.constraint(equalTo: contentView.centerXAnchor, constant: (contentView.frame.width * 0.25)),
        ])
    }
}
