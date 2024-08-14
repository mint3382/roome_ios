//
//  NextButton.swift
//  roome
//
//  Created by minsong kim on 5/22/24.
//

import UIKit
import Lottie

class NextButton: UIButton {
    private let loadingAnimationView = LottieAnimationView(name: "loadingButton")
    private let loadingBackgroundView: UIView = {
        let view = UIView()
        view.backgroundColor = .roomeMain
        
//        view.layer.cornerRadius = 10
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    override init(frame: CGRect = .zero) {
        super.init(frame: frame)
        self.layer.cornerRadius = 10
        self.setTitle("다음", for: .normal)
        self.titleLabel?.font = .boldTitle3
        self.isEnabled = false
        self.translatesAutoresizingMaskIntoConstraints = false
    }
    
    convenience init(title: String, backgroundColor: UIColor, tintColor: UIColor) {
        self.init()
        self.setTitle(title, for: .normal)
        self.isEnabled = true
        self.backgroundColor = backgroundColor
        self.tintColor = tintColor
        self.setTitleColor(tintColor, for: .normal)
    }
    
    override var isEnabled: Bool {
        didSet {
            if isEnabled {
                self.backgroundColor = .roomeMain
                self.setTitleColor(.white, for: .normal)
            } else {
                self.backgroundColor = .disable
                self.setTitleColor(.disableTint, for: .normal)
            }
        }
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func loadingButton() {
        self.isEnabled = false
        self.addSubview(loadingBackgroundView)
        self.addSubview(loadingAnimationView)
        
        NSLayoutConstraint.activate([
            loadingBackgroundView.topAnchor.constraint(equalTo: self.topAnchor),
            loadingBackgroundView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            loadingBackgroundView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            loadingBackgroundView.trailingAnchor.constraint(equalTo: self.trailingAnchor)
        ])
        
        loadingBackgroundView.layer.cornerRadius = self.layer.cornerRadius
        
        loadingAnimationView.loopMode = .loop
        loadingAnimationView.frame = CGRect(x: 0, y: 0, width: 80, height: 50)
        loadingAnimationView.center = CGPoint(x: self.bounds.width / 2, y: self.bounds.height / 2)
        
        loadingAnimationView.contentMode = .scaleAspectFit
        loadingAnimationView.play()
    }
    
    func stopLoading() {
        loadingBackgroundView.removeFromSuperview()
        loadingAnimationView.removeFromSuperview()
        self.isEnabled = true
    }
}
