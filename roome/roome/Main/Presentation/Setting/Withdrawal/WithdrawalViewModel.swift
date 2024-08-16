//
//  WithdrawalViewModel.swift
//  roome
//
//  Created by minsong kim on 7/12/24.
//

import Foundation
import Combine
import AuthenticationServices
import KakaoSDKUser

class WithdrawalViewModel: NSObject {
    struct Input {
        let tappedWithdrawal = PassthroughSubject<Void, Never>()
        let tappedWithdrawalReasonCell = PassthroughSubject<WithdrawalReason, Never>()
    }
    
    struct Output {
        let handleWithdrawal = PassthroughSubject<Result<Void, Error>, Never>()
        let handleReason = PassthroughSubject<Result<Void, Error>, Never>()
    }
    
    let input: Input
    let output: Output
    var reasonState: WithdrawalReason = .jump
    
    private var cancellables = Set<AnyCancellable>()
    
    init(loginUseCase: LoginUseCase) {
        self.loginUseCase = loginUseCase
        self.input = Input()
        self.output = Output()
        super.init()
        settingBind()
    }
    
    let loginUseCase: LoginUseCase?
    
    @Published var textInput = ""
    
    private func settingBind() {
        input.tappedWithdrawal
            .sink { [weak self] _ in
                if KeyChain.read(key: .isAppleLogin) == "true" {
                    self?.handleAppleSignOut()
                } else {
                    self?.handleKakaoSignOut()
                }
            }
            .store(in: &cancellables)
        
        input.tappedWithdrawalReasonCell
            .sink { [weak self] reason in
                //API로 이유 전송
                self?.reasonState = reason
                self?.output.handleReason.send(.success({}()))
            }
            .store(in: &cancellables)
    }
    
    private func handleAppleSignOut() {
        let appleIDProvider = ASAuthorizationAppleIDProvider()
        let request = appleIDProvider.createRequest()
        request.requestedScopes = [.fullName, .email]
        
        let authorizationController = ASAuthorizationController(authorizationRequests: [request])
        authorizationController.delegate = self
        authorizationController.performRequests()
    }
    
    private func handleKakaoSignOut() {
        UserApi.shared.unlink { [self] error in
            if let error {
                print(error)
            } else {
                print("unlink() success")
                
                let bodyJSON: [String: Any?] = ["provider": LoginProvider.kakao.name,
                                                "code": nil,
                                                "reason": reasonState.rawValue,
                                                "content": textInput]
                //탈퇴 시켜줘
                Task {
                    do {
                        try await self.loginUseCase?.signOutWithAPI(body: bodyJSON)
                        KeyChain.delete(key: .accessToken)
                        KeyChain.delete(key: .refreshToken)
                        KeyChain.delete(key: .hasToken)
                        output.handleWithdrawal.send(.success({}()))
                    } catch(let error) {
                        output.handleWithdrawal.send(.failure(error))
                    }
                }
            }
        }
    }
}

extension WithdrawalViewModel: ASAuthorizationControllerDelegate {
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        guard let credential = authorization.credential as? ASAuthorizationAppleIDCredential else {
            return
        }
        //TODO: - 도메인에 넘겨줄 body Type 따로 정의해서 분리하기
        let bodyJSON: [String: Any] = ["provider": LoginProvider.apple.name,
                                       "code": String(data: credential.authorizationCode ?? Data(), encoding: .utf8) ?? "",
                                       "reason": reasonState.rawValue,
                                       "content": textInput]
        
        Task {
            do {
                try await loginUseCase?.signOutWithAPI(body: bodyJSON)
                //키체인에 유저 정보 삭제
                KeyChain.delete(key: .accessToken)
                KeyChain.delete(key: .refreshToken)
                KeyChain.delete(key: .hasToken)
                KeyChain.delete(key: .isAppleLogin)
                KeyChain.delete(key: .appleUserID)
                output.handleWithdrawal.send(.success({}()))
            } catch(let error) {
                output.handleWithdrawal.send(.failure(error))
            }
        }
    }
}
