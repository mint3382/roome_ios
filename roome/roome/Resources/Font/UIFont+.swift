//
//  UIFont+.swift
//  roome
//
//  Created by minsong kim on 5/17/24.
//

import UIKit

extension UIFont {
    enum FontType {
        case regular
        case bold
        case medium
        
        var name: String {
            switch self {
            case .regular:
                return "Pretendard-Regular"
            case .bold:
                return "Pretendard-Bold"
            case .medium:
                return "Pretendard-Medium"
            }
        }
    }
    
    func pretendardRegular(size: FontSize) -> UIFont {
        return UIFont(name: FontType.regular.name, size: size.number)!
    }
    
    func pretendardBold(size: FontSize) -> UIFont {
        return UIFont(name: FontType.bold.name, size: size.number)!
    }
    
    func pretendardMedium(size: FontSize) -> UIFont {
        return UIFont(name: FontType.medium.name, size: size.number)!
    }
}
