//
//  EditProfileViewController.swift
//  roome
//
//  Created by minsong kim on 6/25/24.
//

import UIKit

class EditProfileViewController: UIViewController {
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "프로필 수정"
        label.font = .boldTitle3
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    private let closeButton: UIButton = {
        var configuration = UIButton.Configuration.plain()
        configuration.image = UIImage(systemName: "xmark")?.changeImageColor(.label).resize(newWidth: 16)
        
        let button = UIButton(configuration: configuration)
        button.translatesAutoresizingMaskIntoConstraints = false
        
        return button
    }()
    
    let profileImageButton: UIButton = {
        var configuration = UIButton.Configuration.plain()
        configuration.image = UIImage(resource: .userProfile).resize(newWidth: 80)
        configuration.cornerStyle = .capsule
        
        let button = UIButton(configuration: configuration)
        button.translatesAutoresizingMaskIntoConstraints = false
        
        return button
    }()
    
    let cameraButton: UIButton = {
        var configuration = UIButton.Configuration.plain()
        configuration.image = UIImage(resource: .camera).resize(newWidth: 16)
        configuration.cornerStyle = .capsule
        configuration.contentInsets = NSDirectionalEdgeInsets(top: 1, leading: 1, bottom: 1, trailing: 1)
        
        let button = UIButton(configuration: configuration)
        button.backgroundColor = .white
        button.layer.cornerRadius = 15
        button.layer.shadowColor = UIColor.label.cgColor
        button.layer.shadowOffset = CGSize(width: 0, height: 4)
        button.layer.shadowRadius = 10
        button.layer.shadowOpacity = 0.1
        button.translatesAutoresizingMaskIntoConstraints = false
        
        return button
    }()
    
    let cameraImageView: UIImageView = {
        let view = UIImageView(image: UIImage(resource: .camera).resize(newWidth: 16))
        view.backgroundColor = .white
        view.contentMode = .center
        view.layer.cornerRadius = 15
        view.layer.masksToBounds = true
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    private let nicknameLabel: UILabel = {
        let label = UILabel()
        label.text = "닉네임"
        label.font = .boldLabel
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    private let nicknameTextField: UITextField = {
        let textField = UITextField()
        textField.layer.cornerRadius = 8
        textField.clipsToBounds = true
        textField.clearButtonMode = .whileEditing
        textField.borderStyle = .none
        textField.text = UserContainer.shared.user?.data.nickname
        textField.backgroundColor = .systemGray6
        textField.addLeftPadding()
        textField.translatesAutoresizingMaskIntoConstraints = false
        
        return textField
    }()
    
    private let formLabel: UILabel = {
        let label = UILabel()
        label.text = "2-8자리 한글, 영문, 숫자"
        label.font = .mediumCaption
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    private let nextButton = NextButton()
    private var nextButtonWidthConstraint: NSLayoutConstraint?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        configureTitleLabel()
        configureCloseButton()
        configureImageView()
        configureNickName()
        configureNextButton()
        registerKeyboardListener()
    }
    
    private func configureTitleLabel() {
        view.addSubview(titleLabel)
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 24),
            titleLabel.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -24),
            titleLabel.heightAnchor.constraint(equalToConstant: 60)
        ])
    }
    
    private func configureCloseButton() {
        view.addSubview(closeButton)
        
        NSLayoutConstraint.activate([
            closeButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -24),
            closeButton.widthAnchor.constraint(equalToConstant: 24),
            closeButton.heightAnchor.constraint(equalToConstant: 24),
            closeButton.centerYAnchor.constraint(equalTo: titleLabel.centerYAnchor)
        ])
    }
    
    private func configureImageView() {
        view.addSubview(profileImageButton)
        view.addSubview(cameraButton)
        
        NSLayoutConstraint.activate([
            profileImageButton.topAnchor.constraint(equalTo: titleLabel.bottomAnchor),
            profileImageButton.heightAnchor.constraint(equalToConstant: 80),
            profileImageButton.widthAnchor.constraint(equalToConstant: 80),
            profileImageButton.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor)
        ])
        
        NSLayoutConstraint.activate([
            cameraButton.centerXAnchor.constraint(equalTo: profileImageButton.trailingAnchor, constant: -10),
            cameraButton.bottomAnchor.constraint(equalTo: profileImageButton.bottomAnchor, constant: 4),
            cameraButton.widthAnchor.constraint(equalToConstant: 30),
            cameraButton.heightAnchor.constraint(equalToConstant: 30)
        ])
    }
    
    private func configureNickName() {
        view.addSubview(nicknameLabel)
        view.addSubview(nicknameTextField)
        view.addSubview(formLabel)
        
        NSLayoutConstraint.activate([
            nicknameLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            nicknameLabel.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor),
            nicknameLabel.topAnchor.constraint(equalTo: profileImageButton.bottomAnchor, constant: 24),
            
            
            nicknameTextField.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            nicknameTextField.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor),
            nicknameTextField.topAnchor.constraint(equalTo: nicknameLabel.bottomAnchor, constant: 8),
            nicknameTextField.heightAnchor.constraint(equalToConstant: 50),
            
            formLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            formLabel.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor),
            formLabel.topAnchor.constraint(equalTo: nicknameTextField.bottomAnchor, constant: 8),
        ])
    }
    
    private func configureNextButton() {
        view.addSubview(nextButton)
        
        nextButtonWidthConstraint = nextButton.widthAnchor.constraint(equalToConstant: view.frame.width * 0.9)
        nextButtonWidthConstraint?.isActive = true
        
        NSLayoutConstraint.activate([
            nextButton.bottomAnchor.constraint(equalTo: view.keyboardLayoutGuide.topAnchor),
            nextButton.heightAnchor.constraint(equalToConstant: 50),
            nextButton.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }
}

extension EditProfileViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

extension EditProfileViewController {
    private func registerKeyboardListener() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillShow(_:)),
            name: UIResponder.keyboardWillShowNotification,
            object: nil
        )
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillHide(_:)),
            name: UIResponder.keyboardWillHideNotification,
            object: nil
        )
    }
    
    @objc private func keyboardWillShow(_ notification: Notification) {
        nextButton.layer.cornerRadius = 0
        
        nextButtonWidthConstraint?.isActive = false
        nextButtonWidthConstraint = nextButton.widthAnchor.constraint(equalToConstant: view.frame.width)
        nextButtonWidthConstraint?.isActive = true
    }
    
    @objc private func keyboardWillHide(_ notification: Notification) {
        nextButton.layer.cornerRadius = 10
        
        nextButtonWidthConstraint?.isActive = false
        nextButtonWidthConstraint = nextButton.widthAnchor.constraint(equalToConstant: view.frame.width * 0.9)
        nextButtonWidthConstraint?.isActive = true
    }
}

#Preview {
    let vc = EditProfileViewController()
    
    return vc
}
