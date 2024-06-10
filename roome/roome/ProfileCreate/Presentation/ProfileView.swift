//
//  ProfileView.swift
//  roome
//
//  Created by minsong kim on 6/3/24.
//

import UIKit

class ProfileView: UIView {
    private let gradientLayer = CAGradientLayer()
    private let profile = UserContainer.shared.profile
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.translatesAutoresizingMaskIntoConstraints = false
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        configureBackgroundColor()
        configureStackView()
        configureIntroduceStackView()
        configureMBTILable()
        configureSignature()
    }
    
    private func configureBackgroundColor() {
        gradientLayer.frame = self.bounds
        
        guard let color = profile?.data.color else {
            return
        }
        let backgroundColor = BackgroundColor(
            mode: Mode(rawValue: color.mode) ?? .gradient,
            shape: Shape(rawValue: color.shape) ?? .linear,
            direction: Direction(rawValue: color.direction) ?? .tlBR,
            startColor: color.startColor,
            endColor: color.endColor)
        
        gradientLayer.colors = backgroundColor.color
        gradientLayer.type = backgroundColor.shape.type
        gradientLayer.startPoint = backgroundColor.direction.point.start
        gradientLayer.endPoint = backgroundColor.direction.point.end
        
        self.layer.addSublayer(gradientLayer)
    }
    
    private let introduceStackView = UIStackView(axis: .horizontal, alignment: .center)
    
    private let stackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.distribution = .fillEqually
        stack.alignment = .leading
        stack.spacing = 2
        stack.translatesAutoresizingMaskIntoConstraints = false
        
        return stack
    }()
    
    private let lineStackView1 = UIStackView(axis: .horizontal, alignment: .center)
    private let lineStackView2 = UIStackView(axis: .horizontal, alignment: .center)
    private let lineStackView3 = UIStackView(axis: .horizontal, alignment: .center)
    private let lineStackView4 = UIStackView(axis: .horizontal, alignment: .center)
    private let lineStackView5 = UIStackView(axis: .horizontal, alignment: .center)
    private let lineStackView6 = UIStackView(axis: .horizontal, alignment: .center)
    
    private func configureIntroduceStackView() {
        let nickname = UserContainer.shared.user?.data.nickname
        let nicknameLabel = UILabel(description: nickname, font: .boldTitle2)
        
        let roomCount = ProfileLabel(text: profile?.data.count, isIntroduceLine: true)
        
        introduceStackView.addArrangedSubview(nicknameLabel)
        introduceStackView.addArrangedSubview(roomCount)
        introduceStackView.translatesAutoresizingMaskIntoConstraints = false
        
        self.addSubview(introduceStackView)
        
        NSLayoutConstraint.activate([
            introduceStackView.leadingAnchor.constraint(equalTo: stackView.leadingAnchor),
            introduceStackView.topAnchor.constraint(equalTo: self.topAnchor, constant: 24)
        ])
    }
    
    func configureMBTILable() {
        guard profile?.data.mbti != "NONE" else {
            return
        }
        
        let mbtiLabel = ProfileLabel(text: profile?.data.mbti, isIntroduceLine: true)
        mbtiLabel.translatesAutoresizingMaskIntoConstraints = false
        
        self.addSubview(mbtiLabel)
        
        NSLayoutConstraint.activate([
            mbtiLabel.trailingAnchor.constraint(equalTo: stackView.trailingAnchor),
            mbtiLabel.topAnchor.constraint(equalTo: introduceStackView.topAnchor)
        ])
    }
    
    func configureSignature() {
        let label = UILabel(description: "©Roome", font: .mediumCaption)
        label.textAlignment = .right
        
        self.addSubview(label)
        
        NSLayoutConstraint.activate([
            label.trailingAnchor.constraint(equalTo: stackView.trailingAnchor),
            label.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -24)
        ])
    }
    
    private func configureStackView() {
        self.addSubview(stackView)
        
        configureLineStackView1()
        configureLineStackView2()
        configureLineStackView3()
        configureLineStackView4()
        configureLineStackView5()
        configureLineStackView6()
        
        stackView.addArrangedSubview(lineStackView1)
        stackView.addArrangedSubview(lineStackView2)
        stackView.addArrangedSubview(lineStackView3)
        stackView.addArrangedSubview(lineStackView4)
        stackView.addArrangedSubview(lineStackView5)
        stackView.addArrangedSubview(lineStackView6)
        
        NSLayoutConstraint.activate([
            stackView.centerYAnchor.constraint(equalTo: self.centerYAnchor, constant: 12),
            stackView.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            stackView.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 0.8),
            stackView.heightAnchor.constraint(equalTo: self.widthAnchor, multiplier: 0.7)
        ])
    }
    
    private func configureLineStackView1() {
        let labels = profile?.data.preferredGenres.compactMap { ProfileLabel(text: $0.title) }
        let textLabel = UILabel(description: "좋아해요")
        
        labels?.forEach { lineStackView1.addArrangedSubview($0) }
        lineStackView1.addArrangedSubview(textLabel)
    }
    
    private func configureLineStackView2() {
        let textLabel1 = UILabel(description: "강점은")
        let labels = profile?.data.userStrengths.compactMap { ProfileLabel(text: $0.title) }
        let textLabel2 = UILabel(description: "입니다")
        
        lineStackView2.addArrangedSubview(textLabel1)
        labels?.forEach { lineStackView2.addArrangedSubview($0) }
        lineStackView2.addArrangedSubview(textLabel2)
    }
    
    private func configureLineStackView3() {
        let labels = profile?.data.themeImportantFactors.compactMap { ProfileLabel(text: $0.title) }
        let textLabel = UILabel(description: "중요해요")
        
        labels?.forEach { lineStackView3.addArrangedSubview($0) }
        lineStackView3.addArrangedSubview(textLabel)
    }
    
    private func configureLineStackView4() {
        let positionLabel = (profile?.data.horrorThemePosition
            .map { ProfileLabel(text: $0.title) }!)!
        let hintLabel = (profile?.data.hintUsagePreference
            .map { ProfileLabel(text: $0.title) }!)!
        
        lineStackView4.addArrangedSubview(positionLabel)
        lineStackView4.addArrangedSubview(hintLabel)
    }
    
    private func configureLineStackView5() {
        let lockLabel = (profile?.data.deviceLockPreference
            .map { ProfileLabel(text: $0.title) }!)!
        let activityLabel = (profile?.data.activity
            .map { ProfileLabel(text: $0.title) }!)!
        
        lineStackView5.addArrangedSubview(lockLabel)
        lineStackView5.addArrangedSubview(activityLabel)
    }
    
    private func configureLineStackView6() {
        let labels = profile?.data.themeDislikedFactors.compactMap { ProfileLabel(text: $0.title) }
        let textLabel = UILabel(description: "싫어요")
        
        labels?.forEach { lineStackView6.addArrangedSubview($0) }
        lineStackView6.addArrangedSubview(textLabel)
    }
}

extension ProfileView {
    func asImage() -> UIImage {
        let renderer = UIGraphicsImageRenderer(size: frame.size)
        return renderer.image { context in
            layer.render(in: context.cgContext)
        }
    }
}
