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
    let orientation: Orientations
    let color: Color
}

enum Mode: String {
    case gradient = "gradient"
    case solid = "solid"
}

enum Shape: String {
    case linear = "linear"
    case radial = "radial"
    case angular = "angular"
    case null = "null"
    
    var type: CAGradientLayerType {
        switch self {
        case .linear:
            CAGradientLayerType.axial
        case .radial:
            CAGradientLayerType.radial
        case .angular:
            CAGradientLayerType.conic
        case .null:
            CAGradientLayerType.axial
        }
    }
}

enum Orientations: String {
    case topBottom = "TOP_BOTTOM"
    case trBL = "TR_BL"
    case rightLeft = "RIGHT_LEFT"
    case brTL = "BR_TL"
    case bottomTOP = "BOTTOM_TOP"
    case blTR = "BL_TR"
    case leftRight = "LEFT_RIGHT"
    case tlBR = "TL_BR"
    case null = "null"
    
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
        case .null:
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
    
    var hexCode: (start: String, end: String) {
        switch self {
        case .red:
            ("#FF453C", "#FFACB3")
        case .pink:
            ("#FF60BF", "#FFACB3")
        case .green:
            ("#ADF695", "#42AC5D")
        case .blue:
            ("#81A2EB", "#4EC1E6")
        case .purple:
            ("#2E2E8D", "#73549D")
        case .black:
            ("#000000", "#000000")
        }
    }
    
    var uiColor: [CGColor] {
        switch self {
        case .red:
            [UIColor(hexCode: self.hexCode.start).cgColor, UIColor(hexCode: self.hexCode.end).cgColor]
        case .pink:
            [UIColor(hexCode: self.hexCode.start).cgColor, UIColor(hexCode: self.hexCode.end).cgColor]
        case .green:
            [UIColor(hexCode: self.hexCode.start).cgColor, UIColor(hexCode: self.hexCode.end).cgColor]
        case .blue:
            [UIColor(hexCode: self.hexCode.start).cgColor, UIColor(hexCode: self.hexCode.end).cgColor]
        case .purple:
            [UIColor(hexCode: self.hexCode.start).cgColor, UIColor(hexCode: self.hexCode.end).cgColor]
        case .black:
            [UIColor(hexCode: self.hexCode.start).cgColor, UIColor(hexCode: self.hexCode.end).cgColor]
        }
    }
}
