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
//        contentView.layer.addSublayer(self.gradientLayer)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        self.isHighlighted = false
    }
    
    func changeColor(_ type: BackgroundColor) {
        self.gradientLayer.colors = type.color
        self.gradientLayer.startPoint = type.direction.point.start
        self.gradientLayer.endPoint = type.direction.point.end
        self.gradientLayer.type = type.shape.type
        contentView.layer.addSublayer(self.gradientLayer)
    }
}
