//
//  ProfileStateLineView.swift
//  roome
//
//  Created by minsong kim on 5/22/24.
//

import UIKit

class ProfileStateLineView: UIView {
    let colorCount: CGFloat
    let grayCount: CGFloat
    lazy var bar = (frame.width / 11) * 0.8
    lazy var space = (frame.width / 11) * 0.2
    
    init(pageNumber: CGFloat, frame: CGRect) {
        self.colorCount = pageNumber
        self.grayCount = 11 - pageNumber
        super.init(frame: frame)
        self.backgroundColor = .clear
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func draw(_ rect: CGRect) {
        drawGrayLine()
        drawColorLine()
    }
    
    func drawColorLine() {
        let path = UIBezierPath()
        let end = (frame.width / CGFloat(11)) * colorCount
        
        let pattern: [CGFloat] = [bar, space]
        UIColor.roomeMain.set()
        path.move(to: CGPoint(x: 5, y: 10))
        path.addLine(to: CGPoint(x: end, y: 10))
        path.lineWidth = 2
        path.lineCapStyle = .round
        path.setLineDash(pattern, count: pattern.count, phase: 0)
        path.stroke()
        
        let lineLayer = CAShapeLayer()
        lineLayer.frame = bounds
        lineLayer.path = path.cgPath
        self.layer.addSublayer(lineLayer)
    }
    
    func drawGrayLine() {
        let path = UIBezierPath()
        let start = (frame.width / CGFloat(11)) * colorCount
        
        let pattern: [CGFloat] = [bar, space]
        UIColor.disableTint.set()
        path.move(to: CGPoint(x: start + space, y: 10))
        path.addLine(to: CGPoint(x: frame.width - 2, y: 10))
        path.lineWidth = 2
        path.lineCapStyle = .round
        path.setLineDash(pattern, count: pattern.count, phase: 0)
        path.stroke()
        
        let lineLayer = CAShapeLayer()
        lineLayer.frame = bounds
        lineLayer.path = path.cgPath
        self.layer.addSublayer(lineLayer)
    }
}

