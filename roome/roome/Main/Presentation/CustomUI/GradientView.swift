//
//  GradientView.swift
//  roome
//
//  Created by minsong kim on 6/19/24.
//

import UIKit

class GradientView: UIView {
    let gradientLayer: CAGradientLayer
    
    init(gradientLayer: CAGradientLayer) {
        self.gradientLayer = gradientLayer
        super.init(frame: .zero)

        self.layer.cornerRadius = 10
        self.layer.borderWidth = 2
        self.layer.borderColor = UIColor.label.cgColor
        self.layer.masksToBounds = true
        self.translatesAutoresizingMaskIntoConstraints = false
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        gradientLayer.frame = self.bounds
    }
}
