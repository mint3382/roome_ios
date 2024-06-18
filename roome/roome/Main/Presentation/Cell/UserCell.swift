//
//  UserCell.swift
//  roome
//
//  Created by minsong kim on 6/18/24.
//

import UIKit

class UserCell: UICollectionViewCell {
    private let userButton: LabelButton = {
        let button = LabelButton(frame: .zero, isDetailButton: true, font: .boldTitle3)
        let image = UIImage(systemName: "person.circle.fill")?.changeImageColor(.white).resize(newWidth: 50)
        let detailImage = UIImage(systemName: "chevron.right")?.changeImageColor(.white).resize(newWidth: 12)
        let name = UserContainer.shared.user?.data.nickname ?? "닉네임"
        button.updateMainButton(title: name, image: image, color: .white, padding: 16)
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
        configuration.contentInsets = NSDirectionalEdgeInsets(top: 5, leading: 20, bottom: 5, trailing: 20)
        configuration.title = "프로필 카드"
        configuration.titleAlignment = .center
        
        let button = UIButton(configuration: configuration)
        button.translatesAutoresizingMaskIntoConstraints = false
        
        return button
    }()
    
    private let shareButton: UIButton = {
        var configuration = UIButton.Configuration.plain()
        configuration.baseForegroundColor = .white
        configuration.contentInsets = NSDirectionalEdgeInsets(top: 5, leading: 20, bottom: 5, trailing: 20)
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
        configureButton()
        configureLine()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        shareButton.titleLabel?.font = .boldTitle4
        cardButton.titleLabel?.font = .boldTitle4
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
        contentView.addSubview(userButton)
        
        NSLayoutConstraint.activate([
            userButton.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 0.9),
            userButton.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: 0.6),
            userButton.topAnchor.constraint(equalTo: self.topAnchor),
            userButton.centerXAnchor.constraint(equalTo: self.centerXAnchor)
        ])
    }
    
    func configureLine() {
        contentView.addSubview(lineView)
        
        NSLayoutConstraint.activate([
            lineView.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 0.8),
            lineView.heightAnchor.constraint(equalToConstant: 2),
            lineView.bottomAnchor.constraint(equalTo: cardButton.topAnchor),
            lineView.centerXAnchor.constraint(equalTo: self.centerXAnchor)
        ])
    }
    
    
    func configureButton() {
        contentView.addSubview(cardButton)
        contentView.addSubview(shareButton)
        
        NSLayoutConstraint.activate([
            cardButton.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 0.5),
            cardButton.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: 0.4),
            cardButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            
            shareButton.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 0.5),
            shareButton.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: 0.4),
            shareButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            shareButton.leadingAnchor.constraint(equalTo: cardButton.trailingAnchor)
        ])
    }
}
