//
//  BackgroundColor.swift
//  roome
//
//  Created by minsong kim on 5/24/24.
//

import Foundation
import UIKit

struct BackgroundColor {
    let mode: Mode
    let shape: Shape
    let direction: Direction
    let startColor: String
    let endColor: String
    var color: [CGColor] {
        [UIColor(hexCode: startColor).cgColor, UIColor(hexCode: endColor).cgColor]
    }
}

enum Mode: String {
    case gradient = "gradient"
    case solid = "solid"
}

enum Shape: String {
    case linear = "linear"
    case radial = "radial"
    case angular = "angular"
    case none = "none"
    
    var type: CAGradientLayerType {
        switch self {
        case .linear:
            CAGradientLayerType.axial
        case .radial:
            CAGradientLayerType.radial
        case .angular:
            CAGradientLayerType.conic
        case .none:
            CAGradientLayerType.axial
        }
    }
}

enum Direction: String {
    case topBottom = "topToBottom"
    case trBL = "topRightToBottomLeft"
    case rightLeft = "RIGHT_LEFT"
    case brTL = "bottomRightToTopLeft"
    case bottomTOP = "bottomToTop"
    case blTR = "bottomLeftToTopRight"
    case leftRight = "LEFT_RIGHT"
    case tlBR = "topLeftToBottomRight"
    case none = "none"
    
    var point: (start: CGPoint, end: CGPoint) {
        switch self {
        case .topBottom:
            (CGPoint(x: 0.5, y: 0), CGPoint(x: 0.5, y: 1))
        case .bottomTOP:
            (CGPoint(x: 0.5, y: 1), CGPoint(x: 0.5, y: 0))
        case .leftRight:
            (CGPoint(x: 0, y: 0.5), CGPoint(x: 1, y: 0.5))
        case .rightLeft:
            (CGPoint(x: 1, y: 0.5), CGPoint(x: 0, y: 0.5))
        case .tlBR:
            (CGPoint(x: 0, y: 0), CGPoint(x: 1, y: 1))
        case .trBL:
            (CGPoint(x: 1, y: 0), CGPoint(x: 0, y: 1))
        case .blTR:
            (CGPoint(x: 0, y: 1), CGPoint(x: 1, y: 0))
        case .brTL:
            (CGPoint(x: 1, y: 1), CGPoint(x: 0, y: 0))
        case .none:
            (CGPoint(x: 0, y: 0), CGPoint(x: 1, y: 1))
        }
    }
}

enum Color: String {
    case red = "Gradient Red"
    case pink = "Gradient Pink"
    case green = "Gradient Green"
    case blue = "Gradient Blue"
    case purple = "Gradient Purple"
    case black = "Solid Black"
    
    var startCode: String {
        switch self {
        case .red:
            "#FF453C"
        case .pink:
            "#FF60BF"
        case .green:
            "#ADF695"
        case .blue:
            "#81A2EB"
        case .purple:
            "#2E2E8D"
        case .black:
            "#000000"
        }
    }
    
    var endCode: String {
        switch self {
        case .red:
            "#FFACB3"
        case .pink:
            "#FFACB3"
        case .green:
            "#42AC5D"
        case .blue:
            "#4EC1E6"
        case .purple:
            "#73549D"
        case .black:
            "#000000"
        }
    }
}
