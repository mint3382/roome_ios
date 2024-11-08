//
//  ColorPaletteCell.swift
//  roome
//
//  Created by minsong kim on 5/24/24.
//

import UIKit

class ColorPaletteCell: UICollectionViewCell {
    private var gradientLayer = CAGradientLayer()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        gradientLayer.frame = contentView.bounds
        contentView.layer.borderWidth = 0
        contentView.layer.cornerRadius = 10
        contentView.layer.masksToBounds = true
        
        self.layer.borderColor = UIColor(white: 1.0, alpha: 0.32).cgColor
        self.layer.borderWidth = 4
        self.layer.cornerRadius = 10
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override var isSelected: Bool {
        didSet {
            if isSelected {
                self.layer.borderColor = UIColor.roomeMain.cgColor
            } else {
                self.layer.borderColor = UIColor(white: 1.0, alpha: 0.32).cgColor
            }
        }
    }
    
    func changeColor(_ type: BackgroundColor) {
        self.gradientLayer.colors = type.color
        self.gradientLayer.startPoint = type.direction.point.start
        self.gradientLayer.endPoint = type.direction.point.end
        self.gradientLayer.type = type.shape.type
        contentView.layer.addSublayer(self.gradientLayer)
    }
}
