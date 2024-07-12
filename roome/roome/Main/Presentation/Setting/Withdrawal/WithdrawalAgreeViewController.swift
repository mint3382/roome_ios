//
//  WithdrawalAgreeViewController.swift
//  roome
//
//  Created by minsong kim on 7/12/24.
//

import UIKit

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
        label.font = .regularBody2
        label.textAlignment = .left
        label.textColor = .darkGray
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    private let agreeButton: UIButton = {
        var configuration = UIButton.Configuration.plain()
        configuration.baseForegroundColor = .label
        configuration.image = UIImage(systemName: "checkmark.circle.fill")?.changeImageColor(.disable).resize(newWidth: 24)
        configuration.titleLineBreakMode = .byCharWrapping
        configuration.imagePadding = 8
        configuration.contentInsets = NSDirectionalEdgeInsets(top: 12, leading: 0, bottom: 0, trailing: 0)
        configuration.title = "안내사항을 모두 확인하였으며, 이에 동의합니다."
        
        let button = UIButton(configuration: configuration)
        button.titleLabel?.font = .regularBody2
        button.translatesAutoresizingMaskIntoConstraints = false
        button.contentHorizontalAlignment = .leading
        
        return button
    }()
    
    private let nextButton = NextButton(title: "탈퇴하기", backgroundColor: .roomeMain, tintColor: .white)

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemBackground
        configureUI()
        nextButton.isEnabled = false
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
        
        NSLayoutConstraint.activate([
            dotView.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            dotView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 32),
            dotView.heightAnchor.constraint(equalToConstant: 24),
            dotView.widthAnchor.constraint(equalToConstant: 24),
            
            descriptionLabel.leadingAnchor.constraint(equalTo: dotView.trailingAnchor),
            descriptionLabel.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor),
            descriptionLabel.topAnchor.constraint(equalTo: dotView.topAnchor, constant: -4),
            descriptionLabel.heightAnchor.constraint(greaterThanOrEqualToConstant: 50)
        ])
    }
    
    private func configureAgreeButton() {
        view.addSubview(agreeButton)
        
        NSLayoutConstraint.activate([
            agreeButton.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor),
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

//#Preview {
//    let vc = WithdrawalAgreeViewController()
//    
//    return vc
//}
