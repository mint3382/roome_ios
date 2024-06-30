//
//  NicknameViewController.swift
//  roome
//
//  Created by minsong kim on 5/17/24.
//

import UIKit
import Combine

class NicknameViewController: UIViewController {
    private let stackView: UIStackView = {
        let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .vertical
        stack.distribution = .fillProportionally
        stack.spacing = 4
        
        return stack
    }()
    
    private let welcomeLabel: UILabel = {
        let label = UILabel()
        label.text = "반가워요!\n닉네임을 입력해주세요"
        label.numberOfLines = 2
        label.sizeToFit()
        label.textAlignment = .left
        label.font = .boldHeadline2
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    private let warningLabel: UILabel = {
        let label = UILabel()
        label.text = "가입 완료 후에도 수정할 수 있어요"
        label.sizeToFit()
        label.textAlignment = .left
        label.font = .regularBody2
        label.textColor = .systemGray
        label.setContentHuggingPriority(.defaultHigh, for: .vertical)
        
        return label
    }()
    
    private let nicknameLabel: UILabel = {
        let label = UILabel()
        label.text = "닉네임"
        label.font = .boldLabel
        
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
    private let backButton = BackButton()
    
    var viewModel: NicknameViewModel
    var cancellables = Set<AnyCancellable>()
    
    init(viewModel: NicknameViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        nicknameTextField.delegate = self
        nicknameTextField.becomeFirstResponder()
        configureUI()
        registerKeyboardListener()
        bind()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    func bind() {
        let text = nicknameTextField.publisher
        text.receive(on: RunLoop.main)
            .assign(to: &viewModel.$textInput)
        text.sink { [weak self] nickname in
            self?.viewModel.input.enteredNickname.send(nickname)
        }
        .store(in: &cancellables)
        
        nextButton.publisher(for: .touchUpInside)
            .sink { [weak self] in
                self?.viewModel.input.tappedNextButton.send()
            }
            .store(in: &cancellables)
        
        backButton.publisher(for: .touchUpInside)
            .throttle(for: 1, scheduler: RunLoop.main, latest: false)
            .sink { [weak self] in
                self?.navigationController?.popViewController(animated: true)
            }
            .store(in: &cancellables)
        
        viewModel.output.isButtonEnable
            .sink { [weak self] isButtonOn in
                if isButtonOn {
                    self?.nextButton.isEnabled = true
                } else {
                    self?.nextButton.isEnabled = false
                }
            }
            .store(in: &cancellables)
        
        viewModel.output.handleNextButton
            .throttle(for: 1, scheduler: RunLoop.main, latest: true)
            .sink { [weak self] result in
                switch result {
                case .success:
                    self?.handleNextPage()
                case .failure(let error):
                    if let error = error as? NetworkError {
                        var nicknameError: NicknameError
                        switch error {
                        case .failureCode(let errorDTO):
                            nicknameError = NicknameError.form(errorDTO)
                        default:
                            nicknameError = NicknameError.network
                        }
                        self?.handleError(nicknameError)
                    } else {
                        print("그 외의 문제: \(error)")
                    }
                }
            }
            .store(in: &cancellables)
    }
    
    func handleError(_ error: NicknameError) {
        switch error {
        case .form(let data):
            formLabel.text = data.message
            formLabel.textColor = .roomeMain
            nicknameLabel.textColor = .roomeMain
        case .network:
            let loginPage = DIContainer.shared.resolve(LoginViewController.self)
            (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?
                .changeRootViewController(loginPage, animated: true)
        }
    }
    
    func handleNextPage() {
        let nextPage = DIContainer.shared.resolve(WelcomeSignUPViewController.self)
        self.navigationController?.pushViewController(nextPage, animated: true)
    }
    
    private func configureUI() {
        configureWelcomeLabel()
        configureStackView()
        configureNextButton()
    }
    
    private func configureWelcomeLabel() {
        view.addSubview(backButton)
        view.addSubview(welcomeLabel)
        
        NSLayoutConstraint.activate([
            backButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 10),
            backButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 32),
            
            welcomeLabel.topAnchor.constraint(equalTo: backButton.bottomAnchor, constant: 12),
            welcomeLabel.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.9),
            welcomeLabel.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor)
        ])
        
    }
    
    private func configureStackView() {
        view.addSubview(stackView)
        
        stackView.addArrangedSubview(warningLabel)
        stackView.addArrangedSubview(nicknameLabel)
        stackView.addArrangedSubview(nicknameTextField)
        stackView.addArrangedSubview(formLabel)
        
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: welcomeLabel.bottomAnchor),
            stackView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.9),
            stackView.heightAnchor.constraint(equalTo: stackView.widthAnchor, multiplier: 0.5),
            stackView.centerXAnchor.constraint(equalTo: view.centerXAnchor)
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

extension NicknameViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let newText = (textField.text! as NSString).replacingCharacters(in: range, with: string)
        
        if viewModel.canFillTextField(newText) {
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

extension NicknameViewController {
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
