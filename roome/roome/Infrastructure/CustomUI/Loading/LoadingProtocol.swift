//
//  LoadingProtocol.swift
//  roome
//
//  Created by minsong kim on 6/3/24.
//

import UIKit

protocol LoadingProtocol where Self: UIViewController { }

extension LoadingProtocol {
    func show() -> LoadingView {
        let scenes = UIApplication.shared.connectedScenes
        let windowScene = scenes.first as? UIWindowScene
        let window = windowScene?.windows.first
        
        let loadingView = LoadingView(frame: window!.frame)
        
        window?.addSubview(loadingView)
        
        return loadingView
    }
    
    func hide(loadingView: LoadingView) {
        loadingView.removeFromSuperview()
    }
}
