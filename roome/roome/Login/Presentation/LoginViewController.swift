//
//  ViewController.swift
//  roome
//
//  Created by minsong kim on 4/17/24.
//

import UIKit
import Combine

class LoginViewController: UIViewController {
    private let window = (UIApplication.shared.connectedScenes.first as? UIWindowScene)?.windows.first
    private lazy var errorPopUp = PopUpView(frame: window!.bounds, title: "카카오톡 미설치", description: "카카오톡의 설치 여부를 확인해주세요!", colorButtonTitle: "확인")
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "나만의 방탈출 라이프"
        label.textAlignment = .center
        label.textColor = .roomeMain
        label.font = .boldHeadline3
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    private lazy var logoImageView: UIImageView = {
        let view = UIImageView(image: UIImage(resource: .colorLogo).resize(newWidth: view.frame.width * 0.6))
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    //로그인 버튼
    lazy var kakaoLoginButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(resource: .kakaoLoginButton).resize(newWidth: view.frame.width * 0.9), for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        
        return button
    }()
    
    lazy var appleLoginButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(resource: .appleLoginButton).resize(newWidth: view.frame.width * 0.9), for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        
        return button
    }()
    
    private var viewModel: LoginViewModel
    private var cancellables = Set<AnyCancellable>()
    
    init(viewModel: LoginViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .disable
        configureUI()
        bind()
    }
    
    private func configureUI() {
        view.addSubview(titleLabel)
        view.addSubview(logoImageView)
        view.addSubview(kakaoLoginButton)
        view.addSubview(appleLoginButton)
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 200),
            titleLabel.widthAnchor.constraint(equalToConstant: titleLabel.intrinsicContentSize.width),
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            logoImageView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 16),
            logoImageView.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            logoImageView.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor),
            logoImageView.heightAnchor.constraint(equalTo: logoImageView.widthAnchor, multiplier: 0.18),
            
            appleLoginButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -100),
            appleLoginButton.widthAnchor.constraint(equalTo: logoImageView.widthAnchor, multiplier: 1.58),
            appleLoginButton.heightAnchor.constraint(equalTo: appleLoginButton.widthAnchor, multiplier: 0.16),
            appleLoginButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            kakaoLoginButton.bottomAnchor.constraint(equalTo: appleLoginButton.topAnchor, constant: -8),
            kakaoLoginButton.widthAnchor.constraint(equalTo: logoImageView.widthAnchor, multiplier: 1.58),
            kakaoLoginButton.heightAnchor.constraint(equalTo: kakaoLoginButton.widthAnchor, multiplier: 0.16),
            kakaoLoginButton.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }
    
    private func bind() {
        let apple = appleLoginButton.publisher(for: .touchUpInside)
            .eraseToAnyPublisher()
        let kakao = kakaoLoginButton.publisher(for: .touchUpInside)
            .eraseToAnyPublisher()
        
        let output = viewModel.transform(LoginViewModel.LoginInput(apple: apple, kakao: kakao))
        
        output.state
            .throttle(for: 1, scheduler: RunLoop.main, latest: false)
            .sink { completion in
                switch completion {
                case .finished:
                    print("finished")
                case .failure(let error):
                    if let error = error as? NetworkError {
                        switch error {
                        case .noKakaoTalk:
                            self.window?.addSubview(self.errorPopUp)
                        default:
                            self.errorPopUp.updatePopUpView(title: "에러 발생", description: "다시 시도해주세요.", colorButtonTitle: "확인")
                            self.window?.addSubview(self.errorPopUp)
                        }
                    } else {
                        self.errorPopUp.updatePopUpView(title: "에러 발생", description: "다시 시도해주세요.", colorButtonTitle: "확인")
                        self.window?.addSubview(self.errorPopUp)
                    }
                }
            } receiveValue: { state in
                self.goToNextPage(state)
            }.store(in: &cancellables)
        
        errorPopUp.publisherColorButton()
            .throttle(for: 1, scheduler: RunLoop.main, latest: false)
            .sink { [weak self] _ in
                DIContainer.shared.removeAll()
                DIManager.shared.registerAll()
                let next = DIContainer.shared.resolve(LoginViewController.self)
                self?.window?.rootViewController?.dismiss(animated: false)
                (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.changeRootViewController(next, animated: true)
            }
            .store(in: &cancellables)

    }
    
    private func goToNextPage(_ state: UserState) {
            var nextPage = UIViewController()
            switch state {
            case .registrationCompleted:
                print("registrationCompleted")
                if UserContainer.shared.profile?.data.state == StateDTO.complete.rawValue {
                    nextPage = DIContainer.shared.resolve(TabBarController.self)
                } else {
                    nextPage = DIContainer.shared.resolve(WelcomeSignUPViewController.self)
                }
            case .termsAgreement:
                nextPage = DIContainer.shared.resolve(TermsAgreeViewController.self)
                print("termsAgreement")
            case .nickname:
                nextPage = DIContainer.shared.resolve(NicknameViewController.self)
                print("nickname")
            }
            navigationController?.pushViewController(nextPage, animated: true)
    }
}
