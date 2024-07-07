//
//  InternetMonitor.swift
//  roome
//
//  Created by minsong kim on 6/28/24.
//

import UIKit
import Network

class InternetMonitor {
    private let monitor = NWPathMonitor()
    private var monitorQueue = DispatchQueue.global()
    
    func startMonitoring() {
        monitor.pathUpdateHandler = { path in
            if path.status == .satisfied {
                DispatchQueue.main.async {
                    (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.isConnect = true
                }
            } else {
                DispatchQueue.main.async {
                    (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.isConnect = false
                }
            }
        }
        
        monitor.start(queue: monitorQueue)
    }
}
