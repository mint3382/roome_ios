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
        let tappedLogout = PassthroughSubject<Void, Never>()
        let tappedWithdrawal = PassthroughSubject<Void, Never>()
    }
    
    struct Output {
        let handleTermsDetail = PassthroughSubject<Void, Never>()
        let handleLogoutButton = PassthroughSubject<Void, Never>()
        let handleWithdrawalButton = PassthroughSubject<Void, Never>()
        let handleLogout = PassthroughSubject<Void, Error>()
        let handleWithdrawal = PassthroughSubject<Void, Error>()
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
                        self?.output.handleLogoutButton.send()
                    case .withdrawal:
                        self?.output.handleWithdrawalButton.send()
                    }
                }
            }
            .store(in: &cancellables)
        
        input.tappedLogout
            .sink { [weak self] _ in
                if KeyChain.read(key: .isAppleLogin) == "true" {
                    self?.handleAppleLogout()
                } else {
                    self?.handleKakaoLogout()
                }
            }
            .store(in: &cancellables)
        
        input.tappedWithdrawal
            .sink { [weak self] _ in
                if KeyChain.read(key: .isAppleLogin) == "true" {
                    self?.handleAppleSignOut()
                } else {
                    self?.handleKakaoSignOut()
                }
            }
            .store(in: &cancellables)
    }
    
    func handleAppleLogout() {
        Task {
            do {
                try await self.loginUseCase?.logoutWithAPI()
                KeyChain.delete(key: .accessToken)
                KeyChain.delete(key: .refreshToken)
                KeyChain.delete(key: .isAppleLogin)
                KeyChain.delete(key: .hasToken)
                self.output.handleLogout.send()
            } catch(let error) {
                self.output.handleLogout.send(completion: .failure(error))
            }
        }
    }
    
    func handleKakaoLogout() {
        UserApi.shared.logout { (error) in
            if let error {
                print(error)
                self.output.handleLogout.send(completion: .failure(error))
            } else {
                print("logout success")
                Task {
                    do {
                        try await self.loginUseCase?.logoutWithAPI()
                        KeyChain.delete(key: .accessToken)
                        KeyChain.delete(key: .refreshToken)
                        KeyChain.delete(key: .hasToken)
                        self.output.handleLogout.send()
                    } catch(let error) {
                        self.output.handleLogout.send(completion: .failure(error))
                    }
                }
            }
        }
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
                
                let bodyJSON: [String: Any?] = ["provider": LoginProvider.kakao.name,
                                               "code": nil]
                
                //탈퇴 시켜줘
                Task {
                    do {
                        try await self.loginUseCase?.signOutWithAPI(body: bodyJSON)
                        KeyChain.delete(key: .accessToken)
                        KeyChain.delete(key: .refreshToken)
                        KeyChain.delete(key: .hasToken)
                        output.handleWithdrawal.send()
                    } catch(let error) {
                        output.handleWithdrawal.send(completion: .failure(error))
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
        
        Task {
            do {
                try await loginUseCase?.signOutWithAPI(body: bodyJSON)
                //키체인에 유저 정보 삭제
                KeyChain.delete(key: .accessToken)
                KeyChain.delete(key: .refreshToken)
                KeyChain.delete(key: .hasToken)
                KeyChain.delete(key: .isAppleLogin)
                KeyChain.delete(key: .appleUserID)
                output.handleWithdrawal.send()
            } catch(let error) {
                output.handleWithdrawal.send(completion: .failure(error))
            }
        }
    }
}
