//
//  UIFontMetrics+.swift
//  roome
//
//  Created by minsong kim on 6/7/24.
//

import UIKit

extension UIFontMetrics {
    static func customFont(with name: Font.Name, of size: Font.Size, for style: UIFont.TextStyle) -> UIFont {
    let font = UIFont.pretandard(with: name, of: size)
    
    return UIFontMetrics(forTextStyle: style).scaledFont(for: font)
  }
}
