//
//  WithdrawalAgreeViewController.swift
//  roome
//
//  Created by minsong kim on 7/12/24.
//

import UIKit
import Combine
import FirebaseAnalytics

class WithdrawalAgreeViewController: UIViewController {
    private let window = (UIApplication.shared.connectedScenes.first as? UIWindowScene)?.windows.first
    
    private lazy var withdrawalPopUp = PopUpView(frame: window!.bounds,
                                                 title: "정말로 탈퇴하시겠어요?",
                                                 description: "지금까지 작성된 모든 정보가 삭제되고,\n복구할 수 없어요",
                                                 whiteButtonTitle: "취소",
                                                 colorButtonTitle: "탈퇴")
    
    private lazy var successWithdrawalPopUp = PopUpView(frame: window!.bounds,
                                                        title: "탈퇴 완료",
                                                        description: "탈퇴 처리가 성공적으로 완료되었습니다.",
                                                        colorButtonTitle: "확인")
    
    private let backButton = BackButton()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "탈퇴하기 전에 확인해 주세요"
        label.sizeToFit()
        label.textAlignment = .left
        label.font = .boldTitle2
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    private let dotView: UIImageView = {
        let view = UIImageView(image: UIImage(systemName: "circlebadge.fill")?.changeImageColor(.label).resize(newWidth: 4))
        view.contentMode = .center
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.text = "작성하신 계정, 프로필 정보, 후기와 같은 모든 정보가 삭제되고 재가입하더라도 복구할 수 없어요."
        label.numberOfLines = 0
        label.font = .regularBody1
        label.textAlignment = .left
        label.textColor = .darkGray
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    private let agreeButton = AgreeButton(title: "안내사항을 모두 확인하였으며, 이에 동의합니다.")
    
    private let nextButton = NextButton(title: "탈퇴하기", backgroundColor: .roomeMain, tintColor: .white)
    
    private var viewModel: WithdrawalViewModel
    private var cancellables = Set<AnyCancellable>()
    
    init(viewModel: WithdrawalViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemBackground
        nextButton.isEnabled = false
        configureUI()
        bind()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        Analytics.logEvent(Tracking.Withdrawal.withdrawalAgreeView, parameters: nil)
    }
    
    private func bind() {
        backButton.publisher(for: .touchUpInside)
            .sink { [weak self] in
                self?.dismiss(animated: false)
            }
            .store(in: &cancellables)
        
        agreeButton.publisher(for: .touchUpInside)
            .sink { [weak self] in
                self?.agreeButton.isSelected.toggle()
                if let self, agreeButton.isSelected {
                    nextButton.isEnabled = true
                } else {
                    self?.nextButton.isEnabled = false
                }
            }
            .store(in: &cancellables)
        
        nextButton.publisher(for: .touchUpInside)
            .map {
                Analytics.logEvent(Tracking.Withdrawal.withdrawalAgreeButton, parameters: nil)
            }
            .sink { [weak self] in
                guard let self else {
                    return
                }
                window?.addSubview(withdrawalPopUp)
            }
            .store(in: &cancellables)
        
        viewModel.output.handleWithdrawal
            .throttle(for: 1, scheduler: RunLoop.main, latest: false)
            .sink { [weak self] result in
                switch result {
                case .success:
                    guard let self else {
                        return
                    }
                    print("✨withdrawal Success")
                    UserContainer.shared.resetUser()
                    DIContainer.shared.removeAll()
                    DIManager.shared.registerAll()
                    let next = DIContainer.shared.resolve(LoginViewController.self)
                    window?.rootViewController?.dismiss(animated: false)
                    (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.changeRootViewController(next, animated: true)
                    successWithdrawalPopUp.dismissViewWithColorButton()
                    window?.addSubview(successWithdrawalPopUp)
                case .failure(let error):
                    print("withdrawal fail: \(error)") //ToastView로 띄우기
                    self?.dismiss(animated: false)
                }
            }
            .store(in: &cancellables)
        
        withdrawalPopUp.publisherWhiteButton()
            .sink { [weak self] _ in
                self?.withdrawalPopUp.removeFromSuperview()
            }
            .store(in: &cancellables)
        
        withdrawalPopUp.publisherColorButton()
            .map {
                Analytics.logEvent(Tracking.Withdrawal.withdrawalFinalButton, parameters: nil)
            }
            .sink { [weak self] _ in
                self?.viewModel.input.tappedWithdrawal.send()
                self?.withdrawalPopUp.removeFromSuperview()
            }
            .store(in: &cancellables)
    }
    
    private func configureUI() {
        configureNavigationBar()
        configureTitle()
        configureDescription()
        configureAgreeButton()
        configureNextButton()
    }
    
    private func configureNavigationBar() {
        view.addSubview(backButton)
        
        NSLayoutConstraint.activate([
            backButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 24),
            backButton.widthAnchor.constraint(equalToConstant: 24),
            backButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 12),
        ])
    }

    private func configureTitle() {
        view.addSubview(titleLabel)
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: backButton.bottomAnchor, constant: 24),
            titleLabel.leadingAnchor.constraint(equalTo: backButton.leadingAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -24)
        ])
    }
    
    private func configureDescription() {
        view.addSubview(dotView)
        view.addSubview(descriptionLabel)
        let descriptionSize = descriptionLabel.sizeThatFits(CGSize(width: 0, height: CGFloat.greatestFiniteMagnitude))
        
        NSLayoutConstraint.activate([
            dotView.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            dotView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 32),
            dotView.heightAnchor.constraint(equalToConstant: 16),
            dotView.widthAnchor.constraint(equalToConstant: 16),
            
            descriptionLabel.leadingAnchor.constraint(equalTo: dotView.trailingAnchor),
            descriptionLabel.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor),
            descriptionLabel.topAnchor.constraint(equalTo: dotView.topAnchor),
            descriptionLabel.heightAnchor.constraint(greaterThanOrEqualToConstant: descriptionSize.height)
        ])
    }
    
    private func configureAgreeButton() {
        view.addSubview(agreeButton)
        
        NSLayoutConstraint.activate([
            agreeButton.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 12),
            agreeButton.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            agreeButton.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor)
        ])
    }
    
    private func configureNextButton() {
        view.addSubview(nextButton)
        
        NSLayoutConstraint.activate([
            nextButton.bottomAnchor.constraint(equalTo: view.keyboardLayoutGuide.topAnchor),
            nextButton.heightAnchor.constraint(equalToConstant: 50),
            nextButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            nextButton.widthAnchor.constraint(equalToConstant: view.frame.width * 0.9)
        ])
    }
}
