//
//  DIContainer.swift
//  roome
//
//  Created by minsong kim on 5/21/24.
//

import Foundation

class DIContainer {
    static let shared = DIContainer()
    
    private init() {}
    
    private var dependencies: [String: Any] = [:]
    
    func register<T>(_ type: T.Type, dependency: Any) {
        let key = String(describing: type)
        dependencies[key] = dependency
    }
    
    func registerDetail(key: String, dependency: Any) {
        dependencies[key] = dependency
    }
    
    func resolve<T>(_ type: T.Type) -> T {
        let key = String(describing: type)
        
        guard let value = dependencies[key] as? T else {
            fatalError()
        }
        
        return value
    }
    
    func resolveDetail<T>(_ type: T.Type, key: String) -> T {
        guard let value = dependencies[key] as? T else {
            fatalError()
        }
        
        return value
    }
    
    func resolveAll() {
        dependencies = [:]
        self.register(SplashView.self, dependency: SplashView())
    }
}
