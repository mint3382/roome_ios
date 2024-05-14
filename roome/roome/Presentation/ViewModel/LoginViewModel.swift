//
//  LoginViewModel.swift
//  roome
//
//  Created by minsong kim on 5/14/24.
//

import Foundation
import Combine
import AuthenticationServices

protocol LoginViewModelInput {
    func pushedAppleLoginButton()
}

protocol LoginViewModelOutput {
    var loginPublisher: PassthroughSubject<Void, Error> { get set}
}

class LoginViewModel: NSObject, LoginViewModelInput, LoginViewModelOutput {
    var loginPublisher = PassthroughSubject<Void, Error>()
    
    override init() {
        super.init()
    }
    
    func pushedAppleLoginButton() {
        let appleIDProvider = ASAuthorizationAppleIDProvider()
        let request = appleIDProvider.createRequest()
        request.requestedScopes = [.fullName, .email]
        
        let authorizationController = ASAuthorizationController(authorizationRequests: [request])
        authorizationController.delegate = self
        authorizationController.performRequests()
    }
}

extension LoginViewModel: ASAuthorizationControllerDelegate {
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        guard let credential = authorization.credential as? ASAuthorizationAppleIDCredential else {
            return
        }
        
        loginPublisher.send()
    }
}
