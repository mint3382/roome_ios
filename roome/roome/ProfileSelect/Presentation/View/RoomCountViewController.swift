//
//  RoomCountViewController.swift
//  roome
//
//  Created by minsong kim on 5/22/24.
//

import UIKit
import Combine
import FirebaseAnalytics

class RoomCountViewController: UIViewController {
    private let titleLabel = TitleLabel(text: "현재까지 경험한 방 수를\n알려주세요")
    private let descriptionLabel = DescriptionLabel(text: "프로필 생성 후 마이페이지에서 수정할 수 있어요")
    
    private let rangeButton = SizeButton(title: "범위 선택", isSelected: true)
    private let textFieldButton = SizeButton(title: "직접 입력", isSelected: false)
    
    //범위 선택 UI들
    private lazy var selectButton: UIButton = {
        var configuration = UIButton.Configuration.plain()
        configuration.baseForegroundColor = .label
        configuration.title = "선택"
        configuration.cornerStyle = .large
        configuration.background.strokeColor = .disableTint
        configuration.background.strokeWidth = 1
        
        let button = UIButton(configuration: configuration)
        button.titleLabel?.font = .boldLabel
        button.translatesAutoresizingMaskIntoConstraints = false
        button.contentHorizontalAlignment = .leading
        
        return button
    }()
    let dropdownImage: UIImageView = {
        let image = UIImage(systemName: "arrowtriangle.down.fill")?.changeImageColor(.lightGray).resize(newWidth: 10)
        let view = UIImageView(image: image)
        view.contentMode = .scaleAspectFit
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    let tableView: UITableView = {
        let view = UITableView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.clipsToBounds = true
        view.layer.cornerRadius = 10
        view.layer.shadowColor = UIColor.gray.cgColor
        view.layer.shadowOffset = CGSize(width: 0, height: 5)
        view.layer.shadowRadius = 10
        view.layer.shadowOpacity = 0.5
        view.layer.masksToBounds = false
        view.separatorStyle = .none
        
        return view
    }()
    
    //직접 입력 UI들
    private let textFieldBackgroundView: UIView = {
        let view = UIView()
        view.backgroundColor = .systemGray5
        view.clipsToBounds = true
        view.layer.cornerRadius = 10
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    private let numberLineStackView: UIStackView = {
        let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .horizontal
        stack.alignment = .center
        stack.distribution = .fill
        stack.backgroundColor = .clear
        stack.spacing = 0
        
        return stack
    }()
    private let numberTextField: UITextField = {
        let textField = UITextField()
        textField.borderStyle = .none
        textField.backgroundColor = .clear
        textField.textAlignment = .right
        textField.text = "0"
        textField.keyboardType = .numberPad
        textField.font = .boldHeadline1
        textField.translatesAutoresizingMaskIntoConstraints = false
        
        return textField
    }()
    private let textFieldLabel: UILabel = {
        let label = UILabel()
        label.text = "번"
        label.textAlignment = .left
        label.font = .boldHeadline1
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    lazy var profileCount = ProfileStateLineView(pageNumber: 1, frame: CGRect(x: 0, y: 0, width: view.frame.width * 0.9 - 10, height: 10))
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
        nextButton.isEnabled = false
        configureUI()
        configureSizeButtons()
        configureSelectButton()
        configureNextButton()
        bind()
        registerKeyboardListener()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        Analytics.logEvent(Tracking.Profile.numberView, parameters: nil)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    func bind() {
        nextButton.publisher(for: .touchUpInside)
            .map {
                Analytics.logEvent(Tracking.Profile.numberNextButton, parameters: nil)
            }
            .sink { [weak self] in
                self?.viewModel.input.tapNextButton.send()
            }
            .store(in: &cancellables)
        
        numberTextField.publisher
            .receive(on: RunLoop.main)
            .assign(to: &viewModel.$textInput)
        
        rangeButton.publisher(for: .touchUpInside)
            .sink { [weak self] in
                self?.viewModel.input.tapRangeButton.send()
            }
            .store(in: &cancellables)
        
        textFieldButton.publisher(for: .touchUpInside)
            .sink { [weak self] in
                self?.viewModel.input.tapTextButton.send()
            }
            .store(in: &cancellables)
        
        viewModel.output.handleCanGoNext
            .sink { [weak self] isNextButtonOn in
                if isNextButtonOn {
                    self?.nextButton.isEnabled = true
                } else {
                    self?.nextButton.isEnabled = false
                }
            }
            .store(in: &cancellables)
        
        viewModel.output.handleNextButton
            .throttle(for: 1, scheduler: RunLoop.main, latest: false)
            .sink { [weak self] result in
                switch result {
                case .success:
                    let nextPage = DIContainer.shared.resolve(GenreViewController.self)
                    self?.navigationController?.pushViewController(nextPage, animated: false)
                case .failure(let error):
                    print(error)
                }
            }
            .store(in: &cancellables)
        
        viewModel.output.handleRangeOrText
            .sink { [weak self] isRange in
                if isRange {
                    self?.textFieldBackgroundView.removeFromSuperview()
                    self?.numberLineStackView.removeFromSuperview()
                    
                    self?.configureSelectButton()
                    self?.rangeButton.isSelected = true
                    self?.textFieldButton.isSelected = false
                } else {
                    self?.selectButton.removeFromSuperview()
                    self?.tableView.removeFromSuperview()
                    
                    self?.configureNumberTextField()
                    self?.rangeButton.isSelected = false
                    self?.textFieldButton.isSelected = true
                    self?.selectButton.layoutIfNeeded()
                    self?.numberTextField.becomeFirstResponder()
                }
            }.store(in: &cancellables)
        
        selectButton.publisher(for: .touchUpInside)
            .throttle(for: 1, scheduler: RunLoop.main, latest: false)
            .sink { [weak self] _ in
                guard let self else {
                    return
                }
                if view.subviews.filter({ $0 == self.tableView }).isEmpty {
                    configureTableView()
                } else {
                    tableView.removeFromSuperview()
                }
            }.store(in: &cancellables)
        
        backButton.publisher(for: .touchUpInside)
            .throttle(for: 0.05, scheduler: RunLoop.main, latest: true)
            .sink { [weak self]  in
                self?.navigationController?.popViewController(animated: false)
            }.store(in: &cancellables)
    }
    
    func configureUI() {
        profileCount.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(profileCount)
        view.addSubview(backButton)
        view.addSubview(titleLabel)
        view.addSubview(descriptionLabel)
        
        NSLayoutConstraint.activate([
            profileCount.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
            profileCount.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            profileCount.heightAnchor.constraint(equalToConstant: 15),
            profileCount.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.9),
            
            backButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 10),
            backButton.topAnchor.constraint(equalTo: profileCount.bottomAnchor, constant: 12),
            
            titleLabel.topAnchor.constraint(equalTo: backButton.bottomAnchor, constant: 12),
            titleLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            
            descriptionLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 12),
            descriptionLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor)
        ])
    }
    
    private func configureSizeButtons() {
        view.addSubview(rangeButton)
        view.addSubview(textFieldButton)
        
        NSLayoutConstraint.activate([
            rangeButton.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 16),
            rangeButton.heightAnchor.constraint(equalToConstant: 50),
            rangeButton.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor, constant: 24),
            rangeButton.trailingAnchor.constraint(equalTo: view.centerXAnchor, constant: -5)
        ])
        
        NSLayoutConstraint.activate([
            textFieldButton.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 16),
            textFieldButton.heightAnchor.constraint(equalToConstant: 50),
            textFieldButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -24),
            textFieldButton.leadingAnchor.constraint(equalTo: view.centerXAnchor, constant: 5)
        ])
    }
    
    private func configureSelectButton() {
        view.addSubview(selectButton)
        view.addSubview(dropdownImage)
        
        NSLayoutConstraint.activate([
            selectButton.topAnchor.constraint(equalTo: rangeButton.bottomAnchor, constant: 16),
            selectButton.leadingAnchor.constraint(equalTo: rangeButton.leadingAnchor),
            selectButton.trailingAnchor.constraint(equalTo: textFieldButton.trailingAnchor),
            selectButton.heightAnchor.constraint(equalTo: rangeButton.heightAnchor),
            
            dropdownImage.trailingAnchor.constraint(equalTo: selectButton.trailingAnchor, constant: -16),
            dropdownImage.topAnchor.constraint(equalTo: selectButton.topAnchor),
            dropdownImage.bottomAnchor.constraint(equalTo: selectButton.bottomAnchor)
        ])
    }
    
    private func configureTableView() {
        tableView.register(DropDownCell.self, forCellReuseIdentifier: "tableViewCell")
        tableView.dataSource = self
        tableView.delegate = self
        view.addSubview(tableView)
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: selectButton.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: selectButton.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: selectButton.trailingAnchor),
            tableView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.37)
        ])
    }
    
    private func configureNumberTextField() {
        numberTextField.delegate = self
        view.addSubview(textFieldBackgroundView)
        view.addSubview(numberLineStackView)
        numberLineStackView.addArrangedSubview(numberTextField)
        numberLineStackView.addArrangedSubview(textFieldLabel)
        
        NSLayoutConstraint.activate([
            textFieldBackgroundView.topAnchor.constraint(equalTo: rangeButton.bottomAnchor, constant: 24),
            textFieldBackgroundView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.9),
            textFieldBackgroundView.heightAnchor.constraint(equalToConstant: 90),
            textFieldBackgroundView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            numberLineStackView.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            numberLineStackView.centerYAnchor.constraint(equalTo: textFieldBackgroundView.centerYAnchor)
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
        
        // 현재 텍스트 필드의 텍스트
        let currentText = textField.text ?? ""
        
        if currentText == "0" {
            textField.text = string
            self.viewModel.textInput = string
            return false
        }
        
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

extension RoomCountViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        UserContainer.shared.defaultProfile?.data.roomCountRanges.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "tableViewCell", for: indexPath) as? DropDownCell else {
            return UITableViewCell()
        }
        
        guard let count = UserContainer.shared.defaultProfile?.data.roomCountRanges[indexPath.row] else {
            return UITableViewCell()
        }
        
        cell.changeTitle(text: count.title)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let range = UserContainer.shared.defaultProfile?.data.roomCountRanges[indexPath.row] else {
            return
        }
        
        viewModel.output.handleCanGoNext.send(true)
        viewModel.isSelected = (range.minCount, range.maxCount)
        selectButton.setTitle(range.title, for: .normal)
        self.tableView.removeFromSuperview()
    }
}

//#Preview {
//    let vc = RoomCountViewController(viewModel: RoomCountViewModel(usecase: RoomCountUseCase(repository: RoomCountRepository())))
//    
//    return vc
//}
