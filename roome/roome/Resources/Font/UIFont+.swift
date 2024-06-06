//
//  UIFont+.swift
//  roome
//
//  Created by minsong kim on 5/17/24.
//

import UIKit

extension UIFont {
    static func pretandard(name: Font.Name, size: Font.Size) -> UIFont {
        guard let font = UIFont(name: name.file, size: size.rawValue) else {
            return .systemFont(ofSize: size.rawValue)
        }
        return font
    }
}

extension UIFont {
    static var boldSpecial: UIFont {
        return .pretandard(name: .pretendardBold, size: ._50)
    }
    
    static var regularHeadline1: UIFont {
        return .pretandard(name: .pretendardRegular, size: ._32)
    }
    
    static var boldHeadline1: UIFont {
        return .pretandard(name: .pretendardBold, size: ._32)
    }
    
    static var regularHeadline2: UIFont {
        return .pretandard(name: .pretendardRegular, size: ._28)
    }
    
    static var boldHeadline2: UIFont {
        return .pretandard(name: .pretendardBold, size: ._28)
    }
    
    static var regularHeadline3: UIFont {
        return .pretandard(name: .pretendardRegular, size: ._24)
    }
    
    static var boldHeadline3: UIFont {
        return .pretandard(name: .pretendardBold, size: ._24)
    }
    
    static var boldTitle1: UIFont {
        return .pretandard(name: .pretendardBold, size: ._22)
    }
    
    static var boldTitle2: UIFont {
        return .pretandard(name: .pretendardBold, size: ._20)
    }
    
    static var boldTitle3: UIFont {
        return .pretandard(name: .pretendardBold, size: ._16)
    }
    
    static var boldTitle4: UIFont {
        return .pretandard(name: .pretendardBold, size: ._14)
    }
    
    static var regularBody1: UIFont {
        return .pretandard(name: .pretendardRegular, size: ._16)
    }
    
    static var regularBody2: UIFont {
        return .pretandard(name: .pretendardRegular, size: ._14)
    }
    
    static var regularBody3: UIFont {
        return .pretandard(name: .pretendardRegular, size: ._12)
    }
    
    static var boldLabel: UIFont {
        return .pretandard(name: .pretendardBold, size: ._14)
    }
    
    static var mediumCaption: UIFont {
        return .pretandard(name: .pretendardMedium, size: ._11)
    }
}
