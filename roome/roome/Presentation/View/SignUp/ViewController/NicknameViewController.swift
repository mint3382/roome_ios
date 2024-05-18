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
        label.font = UIFont().pretendardBold(size: .headline2)
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    private let warningLabel: UILabel = {
        let label = UILabel()
        label.text = """
                        가입 완료 후에는 수정할 수 없으니
                        신중하게 입력해주세요
                        """
        label.numberOfLines = 2
        label.sizeToFit()
        label.textAlignment = .left
        label.font = UIFont().pretendardRegular(size: .label)
        label.textColor = .systemGray
        label.setContentHuggingPriority(.defaultHigh, for: .vertical)
        
        return label
    }()
    
    private let nicknameLabel: UILabel = {
        let label = UILabel()
        label.text = "닉네임"
        label.font = UIFont().pretendardBold(size: .label)
        
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
        label.font = UIFont().pretendardMedium(size: .caption)
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    private let nextButton: UIButton = {
        let button = UIButton(type: .system)
        button.isEnabled = false
        button.tintColor = .white
        button.layer.cornerRadius = 10
        button.backgroundColor = .gray
        button.setTitle("다음", for: .normal)
        button.titleLabel?.font = UIFont().pretendardBold(size: .label)
        button.translatesAutoresizingMaskIntoConstraints = false
        
        return button
    }()
    
    private var nextButtonWidthConstraint: NSLayoutConstraint?
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
        let input = NicknameViewModel.NicknameViewModelInput(nickname: text)
        let output = viewModel.transform(input)
        
        output.isButtonEnable.sink { [weak self] buttonOn in
            if buttonOn {
                self?.nextButton.isEnabled = true
                self?.nextButton.backgroundColor = .roomeMain
            }
        }.store(in: &cancellables)
    }
    
    private func configureUI() {
        configureWelcomeLabel()
        configureStackView()
        configureNextButton()
    }
    
    private func configureWelcomeLabel() {
        view.addSubview(welcomeLabel)
        
        NSLayoutConstraint.activate([
            welcomeLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 4),
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
            nextButton.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.05),
            nextButton.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }

}

extension NicknameViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let newText = (textField.text! as NSString).replacingCharacters(in: range, with: string)
        
        if viewModel.canFillTextField(newText) {
            formLabel.textColor = .label
            return true
        } else {
            formLabel.textColor = .roomeMain
            return false
        }
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
