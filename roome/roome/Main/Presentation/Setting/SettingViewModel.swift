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

class SettingViewModel: NSObject {
    struct Input {
        let selectCell = PassthroughSubject<Statable?, Never>()
    }
    
    struct Output {
        let handleTermsDetail = PassthroughSubject<Void, Never>()
//        let handleTermsPersonal = PassthroughSubject<Void, Never>()
        let handleLogout = PassthroughSubject<Void, Never>()
        let handleWithdrawel = PassthroughSubject<Void, Never>()
    }
    
    let input: Input
    let output: Output
    
    private var cancellables = Set<AnyCancellable>()
    
    init(loginUseCase: LoginUseCase) {
        self.loginUseCase = loginUseCase
        self.input = Input()
        self.output = Output()
        super.init()
        settingBind()
    }
    
    let loginUseCase: LoginUseCase?
    var goToNext = PassthroughSubject<Void, Error>()
    var termsState: TermsDetailStates?
    
    func settingBind() {
        input.selectCell
            .sink { [weak self] state in
                if let state = state as? SettingDTO.Terms {
                    switch state {
                    case .service:
                        self?.termsState = .service
                    case .personal:
                        self?.termsState = .personal
                    }
                    self?.output.handleTermsDetail.send()
                } else if let state = state as? SettingDTO.SignOut {
                    switch state {
                    case .logout:
                        self?.output.handleLogout.send()
                    case .withdrawl:
                        self?.output.handleWithdrawel.send()
                    }
                }
            }
            .store(in: &cancellables)
    }
    
//    func transform(_ input: Input) -> Output {
//        let signOutHandled = input.tapSignOutButton
//            .compactMap { [weak self] _ in
//                if KeyChain.read(key: .isAppleLogin) == "true" {
//                    self?.handleAppleSignOut()
//                } else {
//                    self?.handleKakaoSignOut()
//                }
//            }.eraseToAnyPublisher()
//        
//        let next = goToNext
//            .eraseToAnyPublisher()
//        
//        return Output(next: next, handleSignOut: signOutHandled)
//            
//    }
    
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
                
                let bodyJSON: [String: Any?] = ["provider": LoginProvider.kakao.name,
                                               "code": nil]
                
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

extension SettingViewModel: ASAuthorizationControllerDelegate {
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
