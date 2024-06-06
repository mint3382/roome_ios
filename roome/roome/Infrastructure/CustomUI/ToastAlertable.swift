//
//  ToastAlertable.swift
//  roome
//
//  Created by minsong kim on 5/24/24.
//

import UIKit

protocol ToastAlertable where Self: UIViewController {
    var nextButton: NextButton { get set }
}

extension ToastAlertable {
    func showToast(count: Int) {
        let toastLabel = PaddingLabel(frame: CGRect(
            x: self.nextButton.frame.minX,
            y: self.nextButton.frame.minY - 25,
            width: self.nextButton.frame.width,
            height: self.nextButton.frame.height
        ))
        
        toastLabel.text = "최대 \(count)개까지 선택할 수 있어요."
        toastLabel.backgroundColor = UIColor.gray
        toastLabel.textColor = UIColor.white
        toastLabel.font = .regularBody2
        toastLabel.textAlignment = .left
        toastLabel.alpha = 1.0
        toastLabel.layer.cornerRadius = 10
        toastLabel.clipsToBounds = true
        toastLabel.numberOfLines = 0
        
        self.view.addSubview(toastLabel)
        UIView.animate(withDuration: 5.0, delay: 0.1, options: .curveEaseOut, animations: {
            toastLabel.alpha = 0.0
        }, completion: { _ in
            toastLabel.removeFromSuperview()
        })
    }
}
