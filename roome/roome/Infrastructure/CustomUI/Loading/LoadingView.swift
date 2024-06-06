//
//  LoadingView.swift
//  roome
//
//  Created by minsong kim on 6/3/24.
//

import UIKit
import Lottie

class LoadingView: UIView {
    private let animationView = LottieAnimationView(name: "waiting")
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "선택하신 정보에 따라\n프로필을 생성 중이에요"
        label.textColor = .label
        label.font = UIFont().pretendardBold(size: .headline3)
        label.textAlignment = .center
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .systemBackground
        configureAnimationView()
        configureTitleLabel()
        animationView.play()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureAnimationView() {
        self.addSubview(animationView)
        animationView.frame = CGRect(x: 0, y: 0, width: 200, height: 200)
        animationView.center = CGPoint(x: self.bounds.width / 2, y: self.bounds.height / 2.5)
        animationView.contentMode = .scaleAspectFit
        animationView.loopMode = .loop
    }
    
    func configureTitleLabel() {
        self.addSubview(titleLabel)
        
        NSLayoutConstraint.activate([
            titleLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            titleLabel.topAnchor.constraint(equalTo: animationView.bottomAnchor)
        ])
    }
}
