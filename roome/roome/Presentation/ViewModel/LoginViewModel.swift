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

class LoginViewModel: NSObject {
    struct LoginInput {
        let apple: AnyPublisher<Void, Never>
        let kakao: AnyPublisher<Void, Never>
    }
    
    struct LoginOutput {
        let state: AnyPublisher<Void, Never>
    }
    
    let loginUseCase: LoginUseCase?

    init(loginUseCase: LoginUseCase) {
        self.loginUseCase = loginUseCase
    }
    
    func transform(_ input: LoginInput) -> LoginOutput {
        let apple = input.apple
            .dropFirst()
            .handleEvents(receiveOutput:  { [weak self] _ in
                self?.pushedAppleLoginButton()
            })
            .eraseToAnyPublisher()
        
        let kakao = input.kakao
            .dropFirst()
            .handleEvents(receiveOutput:  { [weak self] _ in
                self?.pushedKakaoLoginButton()
            })
            .eraseToAnyPublisher()
        
        let state = Publishers.Merge(apple, kakao)
            .dropFirst()
            .eraseToAnyPublisher()
        
        return LoginOutput(state: state)
            
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
                }
            }
        } else { 
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
        //키체인에 유저 정보 저장
        KeyChain.create(key: .userID, data: credential.user)
        
        //서버에 idToken 전달, 서버 접근 토큰 요청
        Task {
            await loginUseCase?.loginWithAPI(body: bodyJSON, decodedDataType: LoginDTO.self)
        }
    }
}
