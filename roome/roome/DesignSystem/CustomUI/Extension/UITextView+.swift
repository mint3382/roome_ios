//
//  UITextView+.swift
//  roome
//
//  Created by minsong kim on 7/23/24.
//

import Combine
import UIKit

extension UITextView {
    var publisher: AnyPublisher<String, Never> {
        NotificationCenter.default.publisher(
            for: UITextView.textDidChangeNotification, object: self
        )
        .compactMap{ $0.object as? UITextView}
        .map{ $0.text ?? "" }
        .eraseToAnyPublisher()
     }
}
