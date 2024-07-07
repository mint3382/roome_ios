//
//  UIFont+.swift
//  roome
//
//  Created by minsong kim on 5/17/24.
//

import UIKit

extension UIFont {
    static func pretandard(with: Font.Name, of: Font.Size) -> UIFont {
        guard let font = UIFont(name: with.file, size: of.rawValue) else {
            return .systemFont(ofSize: of.rawValue)
        }
        return font
    }
}

extension UIFont {
    static var boldSpecial: UIFont {
        return UIFontMetrics.customFont(with: .pretendardBold, of: ._50, for: .largeTitle)
    }
    
    static var regularHeadline1: UIFont {
        return UIFontMetrics.customFont(with: .pretendardRegular, of: ._32, for: .title1)
    }
    
    static var boldHeadline1: UIFont {
        return UIFontMetrics.customFont(with: .pretendardBold, of: ._32, for: .title1)
    }
    
    static var regularHeadline2: UIFont {
        return UIFontMetrics.customFont(with: .pretendardRegular, of: ._28, for: .title2)
    }
    
    static var boldHeadline2: UIFont {
        return UIFontMetrics.customFont(with: .pretendardBold, of: ._28, for: .title2)
    }
    
    static var regularHeadline3: UIFont {
        return UIFontMetrics.customFont(with: .pretendardRegular, of: ._24, for: .title3)
    }
    
    static var boldHeadline3: UIFont {
        return UIFontMetrics.customFont(with: .pretendardBold, of: ._24, for: .title3)
    }
    
    static var boldTitle1: UIFont {
        return UIFontMetrics.customFont(with: .pretendardBold, of: ._22, for: .subheadline)
    }
    
    static var boldTitle2: UIFont {
        return UIFontMetrics.customFont(with: .pretendardBold, of: ._20, for: .body)
    }
    
    static var boldTitle3: UIFont {
        return UIFontMetrics.customFont(with: .pretendardBold, of: ._16, for: .callout)
    }
    
    static var boldTitle4: UIFont {
        return UIFontMetrics.customFont(with: .pretendardBold, of: ._14, for: .footnote)
    }
    
    static var regularBody1: UIFont {
        return UIFontMetrics.customFont(with: .pretendardRegular, of: ._16, for: .callout)
    }
    
    static var regularBody2: UIFont {
        return UIFontMetrics.customFont(with: .pretendardRegular, of: ._14, for: .footnote)
    }
    
    static var regularBody3: UIFont {
        return UIFontMetrics.customFont(with: .pretendardRegular, of: ._12, for: .caption1)
    }
    
    static var boldLabel: UIFont {
        return UIFontMetrics.customFont(with: .pretendardBold, of: ._14, for: .footnote)
    }
    
    static var mediumCaption: UIFont {
        return UIFontMetrics.customFont(with: .pretendardMedium, of: ._11, for: .caption2)
    }
}
