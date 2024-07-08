//
//  EditProfileViewController.swift
//  roome
//
//  Created by minsong kim on 6/25/24.
//

import UIKit
import Combine

class EditProfileViewController: UIViewController {
    private let window = (UIApplication.shared.connectedScenes.first as? UIWindowScene)?.windows.first
    private lazy var photoPopUp = DownPopUpView(frame: window!.bounds)
    private lazy var changePopUp = PopUpView(frame: window!.bounds,
                                             title: "변경사항이 있어요",
                                             description: "변경사항을 저장하지 않고 나가시겠어요?",
                                             whiteButtonTitle: "취소",
                                             colorButtonTitle: "나가기")
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
        configuration.image = UserContainer.shared.userImage
        
        let button = UIButton(configuration: configuration)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.cornerRadius = 40
        button.clipsToBounds = true
        
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
    
    private let saveButton = NextButton(title: "저장하기", backgroundColor: .roomeMain, tintColor: .white)
    private var nextButtonWidthConstraint: NSLayoutConstraint?
    
    private let imagePicker = UIImagePickerController()
    
    private let viewModel: EditProfileViewModel
    private var cancellables = Set<AnyCancellable>()
    
    init(viewModel: EditProfileViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        
        configureTitleLabel()
        configureCloseButton()
        configureImageView()
        configureNickName()
        configureSaveButton()
        registerKeyboardListener()
        bind()
        imagePicker.delegate = self
    }
    
    override func viewWillLayoutSubviews() {
        photoPopUp.layoutSubviews()
        profileImageButton.configuration?.cornerStyle = .capsule
    }
    
    private func bind() {
        nicknameTextField.publisher
            .receive(on: RunLoop.main)
            .assign(to: &viewModel.$textInput)
        
        closeButton.publisher(for: .touchUpInside)
            .sink { [weak self] in
                self?.viewModel.input.tappedCloseButton.send()
            }
            .store(in: &cancellables)
        
        saveButton.publisher(for: .touchUpInside)
            .sink { [weak self] in
                self?.viewModel.input.tappedSaveButton.send()
            }
            .store(in: &cancellables)
        
        Publishers.Merge(profileImageButton.publisher(for: .touchUpInside), cameraButton.publisher(for: .touchUpInside))
            .sink { [weak self] in
                guard let self else {
                    return
                }
                self.window?.addSubview(self.photoPopUp)
            }
            .store(in: &cancellables)
        
        photoPopUp.takePhotoButtonPublisher()
            .sink { [weak self] in
                self?.openCamera()
            }
            .store(in: &cancellables)
        
        photoPopUp.albumButtonPublisher()
            .sink { [weak self] in
                self?.openAlbum()
            }
            .store(in: &cancellables)
        
        photoPopUp.baseImageButtonPublisher()
            .throttle(for: 1, scheduler: RunLoop.main, latest: false)
            .sink { [weak self] in
                self?.viewModel.input.tappedBaseImage.send()
                self?.profileImageButton.setImage(UIImage(resource: .userProfile).resize(newWidth: 80), for: .normal)
            }
            .store(in: &cancellables)
        
        photoPopUp.cancelButtonPublisher()
            .sink { [weak self] in
                self?.photoPopUp.removeFromSuperview()
            }
            .store(in: &cancellables)
        
        viewModel.output.handleSaveButton
            .throttle(for: 1, scheduler: RunLoop.main, latest: false)
            .sink { completion in
                switch completion {
                case .failure(let error):
                    self.handleError(error)
                case .finished:
                    print("finished")
                }
            } receiveValue: { [weak self] in
                self?.dismiss(animated: true)
            }
            .store(in: &cancellables)

        viewModel.output.handleCloseButton
            .sink { [weak self] isChanged in
                guard let self else {
                    return
                }
                
                if isChanged {
                    self.window?.addSubview(changePopUp)
                } else {
                    self.dismiss(animated: true)
                }
            }
            .store(in: &cancellables)
        
        changePopUp.publisherWhiteButton()
            .sink { [weak self] in
                self?.changePopUp.removeFromSuperview()
            }
            .store(in: &cancellables)
        
        changePopUp.publisherColorButton()
            .sink { [weak self] in
                self?.changePopUp.removeFromSuperview()
                self?.dismiss(animated: true)
            }
            .store(in: &cancellables)
    }
    
    private func handleError(_ error: NicknameError) {
        switch error {
        case .form(let data):
            formLabel.text = data.message
            formLabel.textColor = .roomeMain
            nicknameLabel.textColor = .roomeMain
        case .network:
            print("네트워크 에러")
        }
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
        nicknameTextField.delegate = self
        nicknameTextField.text = UserContainer.shared.user?.data.nickname
        
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
    
    private func configureSaveButton() {
        view.addSubview(saveButton)
        
        nextButtonWidthConstraint = saveButton.widthAnchor.constraint(equalToConstant: view.frame.width * 0.9)
        nextButtonWidthConstraint?.isActive = true
        
        NSLayoutConstraint.activate([
            saveButton.bottomAnchor.constraint(equalTo: view.keyboardLayoutGuide.topAnchor),
            saveButton.heightAnchor.constraint(equalToConstant: 50),
            saveButton.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }
}

extension EditProfileViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func openCamera() {
        guard UIImagePickerController.isSourceTypeAvailable(.camera) else {
            //에러 전달
            return
        }
        
        imagePicker.sourceType = .camera
        present(imagePicker, animated: false, completion: nil)
    }
    
    func openAlbum() {
        imagePicker.sourceType = .photoLibrary
        present(imagePicker, animated: false, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            //이미지 UserCell로 전송??
            profileImageButton.setImage(image.resize(newWidth: 80), for: .normal)
            viewModel.input.changePhoto.send(image)
            viewModel.isImageChanged = true
        }
        dismiss(animated: true, completion: nil)
        photoPopUp.removeFromSuperview()
    }
}

extension EditProfileViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if viewModel.canFillTextField() {
            formLabel.textColor = .label
            nicknameLabel.textColor = .label
            formLabel.text = "2-8자리 한글, 영문, 숫자"
            return true
        } else {
            formLabel.textColor = .roomeMain
            nicknameLabel.textColor = .roomeMain
            return false
        }
    }
    
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
        saveButton.layer.cornerRadius = 0
        
        nextButtonWidthConstraint?.isActive = false
        nextButtonWidthConstraint = saveButton.widthAnchor.constraint(equalToConstant: view.frame.width)
        nextButtonWidthConstraint?.isActive = true
    }
    
    @objc private func keyboardWillHide(_ notification: Notification) {
        saveButton.layer.cornerRadius = 10
        
        nextButtonWidthConstraint?.isActive = false
        nextButtonWidthConstraint = saveButton.widthAnchor.constraint(equalToConstant: view.frame.width * 0.9)
        nextButtonWidthConstraint?.isActive = true
    }
}
