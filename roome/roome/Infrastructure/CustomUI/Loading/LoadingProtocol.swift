//
//  LoadingProtocol.swift
//  roome
//
//  Created by minsong kim on 6/3/24.
//

import UIKit

protocol LoadingProtocol where Self: UIViewController { }

extension LoadingProtocol {
    func show() {
        let scenes = UIApplication.shared.connectedScenes
        let windowScene = scenes.first as? UIWindowScene
        let window = windowScene?.windows.first
        
        let lottieView = LoadingView(frame: window!.frame)
        
        window?.addSubview(lottieView)
    }
    
    func hide() {
        self.removeFromParent()
    }
}
