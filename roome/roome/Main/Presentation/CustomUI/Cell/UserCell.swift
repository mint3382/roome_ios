//
//  UserCell.swift
//  roome
//
//  Created by minsong kim on 6/18/24.
//

import UIKit
import Combine

class UserCell: UICollectionViewCell {
    private let userLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = UserContainer.shared.user?.data.nickname ?? "닉네임"
        label.font = .boldTitle3
        
        return label
    }()
    
    private let userImageButton: UIButton = {
        var configuration = UIButton.Configuration.plain()
        configuration.image = UserContainer.shared.userImage.resize(newWidth: 50)
        
        let button = UIButton(configuration: configuration)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.cornerRadius = 25
        button.clipsToBounds = true
        
        return button
    }()
    
    private let userButton: LabelButton = {
        let button = LabelButton(frame: .zero, isDetailButton: true, font: .boldTitle3)
        let detailImage = UIImage(systemName: "chevron.right")?.changeImageColor(.white).resize(newWidth: 12)
        let name = UserContainer.shared.user?.data.nickname ?? "닉네임"
        button.updateMainButton(title: name, image: nil, color: .white, padding: 16)
        button.updateDetailImage(detailImage)
        
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
        configureUserLabel()
//        configureUserButton()
        configureButton()
        configureLine()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        shareButton.titleLabel?.font = .boldTitle4
        cardButton.titleLabel?.font = .boldTitle4
//        userButton.setNeedsLayout()
//        updateUserProfile()
    }
    
    func updateUserProfile() {
        userImageButton.setImage(UserContainer.shared.userImage, for: .normal)
        userButton.updateMainButton(title: UserContainer.shared.user?.data.nickname ?? "닉네임", image: nil)
    }
    
    func userButtonPublisher() -> AnyPublisher<Void, Never> {
        Publishers.Merge3(userImageButton.publisher(for: .touchUpInside),
                          userButton.tappedMainButtonPublisher(),
                          userButton.tappedDetailButtonPublisher()).eraseToAnyPublisher()
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
    
    private func configureUserLabel() {
        contentView.addSubview(userLabel)
        
        NSLayoutConstraint.activate([
            userLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 24),
            userLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -24),
            userLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 12),
            userLabel.heightAnchor.constraint(equalToConstant: 40)
        ])
    }
    
    private func configureUserButton() {
        contentView.addSubview(userImageButton)
        contentView.addSubview(userButton)
        
        NSLayoutConstraint.activate([
            userImageButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 24),
            userImageButton.widthAnchor.constraint(equalToConstant: 50),
            userImageButton.heightAnchor.constraint(equalToConstant: 50),
            userImageButton.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 24),
            
            userButton.leadingAnchor.constraint(equalTo: userImageButton.trailingAnchor, constant: 8),
            userButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -24),
            userButton.heightAnchor.constraint(equalToConstant: 50),
            userButton.topAnchor.constraint(equalTo: userImageButton.topAnchor)
        ])
    }
    
    func configureLine() {
        contentView.addSubview(lineView)
        
        NSLayoutConstraint.activate([
            lineView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 24),
            lineView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -24),
//            lineView.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 0.8),
            lineView.heightAnchor.constraint(equalToConstant: 2),
            lineView.bottomAnchor.constraint(equalTo: cardButton.topAnchor),
            lineView.centerXAnchor.constraint(equalTo: self.centerXAnchor)
        ])
    }
    
    
    func configureButton() {
        contentView.addSubview(cardButton)
        contentView.addSubview(shareButton)
        
        NSLayoutConstraint.activate([
            cardButton.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: 0.4),
            cardButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            cardButton.centerXAnchor.constraint(equalTo: contentView.centerXAnchor, constant: -(contentView.frame.width * 0.25)),
            
            shareButton.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: 0.4),
            shareButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            shareButton.centerXAnchor.constraint(equalTo: contentView.centerXAnchor, constant: (contentView.frame.width * 0.25)),
        ])
    }
}
