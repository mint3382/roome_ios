//
//  SignOutViewModel.swift
//  roome
//
//  Created by minsong kim on 6/4/24.
//

import Combine
import KakaoSDKUser
import UIKit

class SettingViewModel: NSObject {
    struct Input {
        let selectCell = PassthroughSubject<SettingItem?, Never>()
        let tappedLogout = PassthroughSubject<Void, Never>()
    }
    
    struct Output {
        let handleTermsDetail = PassthroughSubject<Void, Never>()
        let handleLogoutButton = PassthroughSubject<Void, Never>()
        let handleWithdrawalButton = PassthroughSubject<Void, Never>()
        let handleLogout = PassthroughSubject<Void, Error>()
        let handleSelectError = PassthroughSubject<Void, Never>()
        let handleUpdate = PassthroughSubject<Void, Error>()
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
    var termsState: TermsDetailStates?
    
    private func settingBind() {
        input.selectCell
            .sink { [weak self] state in
                switch state {
                case .service:
                    self?.termsState = .service
                    self?.output.handleTermsDetail.send()
                case .personal:
                    self?.termsState = .personal
                    self?.output.handleTermsDetail.send()
                case .version:
                    self?.updateVersion()
                case .logout:
                    self?.output.handleLogoutButton.send()
                case .withdrawal:
                    self?.output.handleWithdrawalButton.send()
                case .none:
                    self?.output.handleSelectError.send()
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
    }
    
    private func updateVersion() {
        guard let url = URL(string: "itms-apps://itunes.apple.com/app/apple-store/6503616766") else {
            print("invalid app store url")
            output.handleUpdate.send(completion: .failure(UpdateError.invalidURL))
            return
        }
        
        if UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
            output.handleUpdate.send()
        } else {
            print("fail open app store")
            output.handleUpdate.send(completion: .failure(UpdateError.failedOpenAppStore))
        }
        
    }
    
    private func handleAppleLogout() {
        Task {
            do {
                try await self.loginUseCase?.logoutWithAPI()
                KeyChain.delete(key: .accessToken)
                KeyChain.delete(key: .refreshToken)
                KeyChain.delete(key: .isAppleLogin)
                KeyChain.delete(key: .appleUserID)
                KeyChain.delete(key: .hasToken)
                self.output.handleLogout.send()
            } catch(let error) {
                self.output.handleLogout.send(completion: .failure(error))
            }
        }
    }
    
    private func handleKakaoLogout() {
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
}
