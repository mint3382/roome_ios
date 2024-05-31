//
//  BackgroundColor.swift
//  roome
//
//  Created by minsong kim on 5/24/24.
//

import Foundation
import UIKit

enum BackgroundColorDTO: Int, CaseIterable {
    case gradientRed = 1
    case gradientPink
    case gradientGreen
    case gradientBlue
    case gradientPurple
    case solidBlack
    
    var definition: BackgroundColor {
        switch self {
        case .gradientRed:
            BackgroundColor(mode: .gradient, shape: .linear, direction: .tlBR, startColor: Color.red.startCode, endColor: Color.red.endCode)
        case .gradientPink:
            BackgroundColor(mode: .gradient, shape: .linear, direction: .tlBR, startColor: Color.pink.startCode, endColor: Color.pink.endCode)
        case .gradientGreen:
            BackgroundColor(mode: .gradient, shape: .linear, direction: .tlBR, startColor: Color.green.startCode, endColor: Color.green.endCode)
        case .gradientBlue:
            BackgroundColor(mode: .gradient, shape: .linear, direction: .topBottom, startColor: Color.blue.startCode, endColor: Color.blue.endCode)
        case .gradientPurple:
            BackgroundColor(mode: .gradient, shape: .linear, direction: .tlBR, startColor: Color.purple.startCode, endColor: Color.purple.endCode)
        case .solidBlack:
            BackgroundColor(mode: .solid, shape: .none, direction: .none, startColor: Color.black.startCode, endColor: Color.black.endCode)
        }
    }
}

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

enum Color {
    case red
    case pink
    case green
    case blue
    case purple
    case black
    
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
