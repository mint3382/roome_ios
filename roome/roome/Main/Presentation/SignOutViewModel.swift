//
//  SignOutViewModel.swift
//  roome
//
//  Created by minsong kim on 6/4/24.
//

import Foundation
import Combine
import AuthenticationServices
import KakaoSDKUser

class SignOutViewModel: NSObject {
    struct Input {
        let tapSignOutButton: AnyPublisher<Void, Never>
    }
    
    struct Output {
        let next: AnyPublisher<Void, Error>
        let handleSignOut: AnyPublisher<Void, Never>
    }
    
    let loginUseCase: LoginUseCase?
    var goToNext = PassthroughSubject<Void, Error>()

    init(loginUseCase: LoginUseCase) {
        self.loginUseCase = loginUseCase
    }
    
    func transform(_ input: Input) -> Output {
        let signOutHandled = input.tapSignOutButton
            .compactMap { [weak self] _ in
                if KeyChain.read(key: .isAppleLogin) == "true" {
                    self?.handleAppleSignOut()
                } else {
                    self?.handleKakaoSignOut()
                }
            }.eraseToAnyPublisher()
        
        let next = goToNext
            .eraseToAnyPublisher()
        
        return Output(next: next, handleSignOut: signOutHandled)
            
    }
    
    func handleAppleSignOut() {
        let appleIDProvider = ASAuthorizationAppleIDProvider()
        let request = appleIDProvider.createRequest()
        request.requestedScopes = [.fullName, .email]
        
        let authorizationController = ASAuthorizationController(authorizationRequests: [request])
        authorizationController.delegate = self
        authorizationController.performRequests()
    }
    
    func handleKakaoSignOut() {
        UserApi.shared.unlink { [self] error in
            if let error {
                print(error)
            } else {
                print("unlink() success")
                
                let bodyJSON: [String: Any] = ["provider": LoginProvider.kakao.name,
                                               "code": "null"]
                
                //탈퇴 시켜줘
                Task {
                    do {
                        try await self.loginUseCase?.signOutWithAPI(body: bodyJSON)
                        KeyChain.delete(key: .accessToken)
                        KeyChain.delete(key: .refreshToken)
                        goToNext.send()
                    } catch(let error) {
                        goToNext.send(completion: .failure(error))
                    }
                }
            }
        }
    }
}

extension SignOutViewModel: ASAuthorizationControllerDelegate {
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        guard let credential = authorization.credential as? ASAuthorizationAppleIDCredential else {
            return
        }
        //TODO: - 도메인에 넘겨줄 body Type 따로 정의해서 분리하기
        let bodyJSON: [String: Any] = ["provider": LoginProvider.apple.name,
                                        "code": String(data: credential.authorizationCode ?? Data(), encoding: .utf8) ?? ""]
        //키체인에 유저 정보 삭제
        KeyChain.delete(key: .isAppleLogin)
        KeyChain.delete(key: .appleUserID)
        
        Task {
            do {
                try await loginUseCase?.signOutWithAPI(body: bodyJSON)
                KeyChain.delete(key: .accessToken)
                KeyChain.delete(key: .refreshToken)
                goToNext.send()
            } catch(let error) {
                goToNext.send(completion: .failure(error))
            }
        }
    }
}
