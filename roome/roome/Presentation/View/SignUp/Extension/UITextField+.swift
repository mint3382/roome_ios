//
//  UITextField+.swift
//  roome
//
//  Created by minsong kim on 5/18/24.
//

import UIKit
import Combine

extension UITextField {
    var publisher: AnyPublisher<String, Never> {
        NotificationCenter.default.publisher(for: UITextField.textDidChangeNotification, object: self)
            .compactMap{ $0.object as? UITextField}
            .map{ $0.text ?? "" }
            .eraseToAnyPublisher()
    }
}
