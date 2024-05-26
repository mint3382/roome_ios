//
//  RoomCountViewController.swift
//  roome
//
//  Created by minsong kim on 5/22/24.
//

import UIKit
import Combine

class RoomCountViewController: UIViewController {
    private let stackView: UIStackView = {
        let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .vertical
        stack.alignment = .leading
        stack.distribution = .fillProportionally
        stack.spacing = 4
        
        return stack
    }()
    
    private let titleLabel = TitleLabel(text: "현재까지 경험한 방 수를\n알려주세요")
    
    private let descriptionLabel = DescriptionLabel(text: "프로필 생성 후 마이페이지에서 수정할 수 있어요")
    
    private let numberLineStackView: UIStackView = {
        let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .horizontal
        stack.distribution = .fill
        stack.spacing = 0
        
        return stack
    }()
    
    private let numberTextField: UITextField = {
        let textField = UITextField()
        textField.borderStyle = .none
        textField.backgroundColor = .systemBackground
        textField.textAlignment = .right
        textField.text = "0"
        textField.keyboardType = .numberPad
        textField.font = UIFont().pretendardBold(size: .custom(50))
        
        return textField
    }()
    
    private let textFieldLabel: UILabel = {
        let label = UILabel()
        label.text = "번"
        label.textAlignment = .left
        label.font = UIFont().pretendardBold(size: .custom(50))
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    lazy var profileCount = ProfileStateLineView(pageNumber: 1, frame: CGRect(x: 20, y: 60, width: view.frame.width * 0.9 - 10, height: view.frame.height))
    private let backButton = BackButton()
    private let nextButton = NextButton()
    private var nextButtonWidthConstraint: NSLayoutConstraint?
    private var viewModel: RoomCountViewModel
    private var cancellables = Set<AnyCancellable>()
    
    init(viewModel: RoomCountViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        nextButton.isEnabled = true
        nextButton.backgroundColor = .roomeMain
        numberTextField.delegate = self
        numberTextField.becomeFirstResponder()
        configureUI()
        configureNextButton()
        bind()
        registerKeyboardListener()
        //        additionalSafeAreaInsets.top = 50
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    func bind() {
        let next = nextButton.publisher(for: .touchUpInside).eraseToAnyPublisher()
        let count = numberTextField.publisher
        let back = backButton.publisher(for: .touchUpInside).eraseToAnyPublisher()
        
        count.receive(on: RunLoop.main)
            .assign(to: &viewModel.$textInput)
        
        let output = viewModel.transform(RoomCountViewModel.Input(count: count, nextButton: next, backButton: back))
        
        output.handleNextButton
            .sink(receiveValue: { [weak self] isNextButtonOn in
                if isNextButtonOn {
                    self?.nextButton.isEnabled = true
                    self?.nextButton.backgroundColor = .roomeMain
                } else {
                    self?.nextButton.isEnabled = false
                    self?.nextButton.backgroundColor = .gray
                }
            }).store(in: &cancellables)
        
        output.handleNextPage
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished:
                    print("roomcount finish")
                case .failure(_):
                    Task { @MainActor in
                        self.navigationController?.popToRootViewController(animated: true)
                    }
                }
            }, receiveValue: { _ in
                let nextPage = DIContainer.shared.resolve(GenreViewController.self)
                Task { @MainActor in
                    self.navigationController?.pushViewController(nextPage, animated: true)
                }
            })
            .store(in: &cancellables)
        
        output.handleBackButton
            .sink { [weak self] _ in
                self?.navigationController?.popViewController(animated: true)
            }.store(in: &cancellables)
    }
    
    func configureUI() {
        view.addSubview(profileCount)
        view.addSubview(backButton)
        view.addSubview(stackView)
        stackView.addArrangedSubview(titleLabel)
        stackView.addArrangedSubview(descriptionLabel)
        
        view.addSubview(numberLineStackView)
        numberLineStackView.addArrangedSubview(numberTextField)
        numberLineStackView.addArrangedSubview(textFieldLabel)
        
        NSLayoutConstraint.activate([
            backButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 10),
            backButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 32),
            
            stackView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            stackView.topAnchor.constraint(equalTo: backButton.bottomAnchor),
            
            numberLineStackView.topAnchor.constraint(equalTo: stackView.bottomAnchor, constant: 50),
            numberLineStackView.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor)
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

extension RoomCountViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let newText = (textField.text! as NSString).replacingCharacters(in: range, with: string)
        
        if newText.count == 0 {
            nextButton.isEnabled = false
            nextButton.backgroundColor = .gray
        } else {
            nextButton.isEnabled = true
            nextButton.backgroundColor = .roomeMain
        }
        
        if newText.count < 6 {
            return true
        } else {
            return false
        }
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

extension RoomCountViewController {
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
