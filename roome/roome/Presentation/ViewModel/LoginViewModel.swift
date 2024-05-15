//
//  LoginViewModel.swift
//  roome
//
//  Created by minsong kim on 5/14/24.
//

import Foundation
import Combine
import AuthenticationServices
import KakaoSDKUser

protocol LoginViewModelInput {
    func pushedAppleLoginButton()
}

protocol LoginViewModelOutput {
    var loginPublisher: PassthroughSubject<Void, Error> { get set}
}

class LoginViewModel: NSObject, LoginViewModelInput, LoginViewModelOutput {
    var loginPublisher = PassthroughSubject<Void, Error>()
    let loginUseCase: LoginUseCase?
    
    init(loginUseCase: LoginUseCase) {
        self.loginUseCase = loginUseCase
//        super.init()
    }
    
    func pushedAppleLoginButton() {
        let appleIDProvider = ASAuthorizationAppleIDProvider()
        let request = appleIDProvider.createRequest()
        request.requestedScopes = [.fullName, .email]
        
        let authorizationController = ASAuthorizationController(authorizationRequests: [request])
        authorizationController.delegate = self
        authorizationController.performRequests()
    }
    
    func pushedKakaoLoginButton() {
        if UserApi.isKakaoTalkLoginAvailable() {
            UserApi.shared.loginWithKakaoTalk { (oauthToken, error) in
                if let error {
                    print(error)
                } else {
                    print("loginWithKakaoTalk() success.")
                    //회원가입 성공 시 oauthToken 저장 가능
                    let bodyJSON: [String: Any] = ["provider": LoginProvider.kakao.name,
                                                   "code": "null",
                                                   "idToken": oauthToken?.idToken ?? ""]
                    
                    Task {
                        await self.loginUseCase?.loginWithAPI(body: bodyJSON, decodedDataType: LoginDTO.self)
                    }
                    
                    self.loginPublisher.send()
                }
            }
        } else { //카카오톡 미설치
            print("카카오톡 미설치")
        }
    }
}

extension LoginViewModel: ASAuthorizationControllerDelegate {
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        guard let credential = authorization.credential as? ASAuthorizationAppleIDCredential else {
            return
        }
        //TODO: - 도메인에 넘겨줄 body Type 따로 정의해서 분리하기
        let bodyJSON: [String: Any] = ["provider": LoginProvider.apple.name,
                                        "code": "null",
                                        "idToken": String(data: credential.identityToken ?? Data(), encoding: .utf8) ?? ""]
        Task {
            await loginUseCase?.loginWithAPI(body: bodyJSON, decodedDataType: LoginDTO.self)
        }
        loginPublisher.send()
    }
}
