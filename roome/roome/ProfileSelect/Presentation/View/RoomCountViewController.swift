//
//  RoomCountViewController.swift
//  roome
//
//  Created by minsong kim on 5/22/24.
//

import UIKit
import Combine

class RoomCountViewController: UIViewController {
    private let stackView = UIStackView(axis: .vertical)
    
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
        configuration.background.strokeColor = .systemGray4
        configuration.background.strokeWidth = 2
        
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
        textField.font = .boldSpecial
        textField.translatesAutoresizingMaskIntoConstraints = false
        
        return textField
    }()
    private let textFieldLabel: UILabel = {
        let label = UILabel()
        label.text = "번"
        label.textAlignment = .left
        label.font = .boldSpecial
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    lazy var profileCount = ProfileStateLineView(pageNumber: 1, frame: CGRect(x: 20, y: 50, width: view.frame.width * 0.9 - 10, height: view.frame.height))
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
        nextButton.backgroundColor = .gray
        numberTextField.delegate = self
        configureUI()
        configureSizeButtons()
        configureSelectButton()
        configureNextButton()
        bind()
        registerKeyboardListener()
        tableView.register(DropDownCell.self, forCellReuseIdentifier: "tableViewCell")
        tableView.dataSource = self
        tableView.delegate = self
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    func bind() {
        let next = nextButton.publisher(for: .touchUpInside).eraseToAnyPublisher()
        let count = numberTextField.publisher
        let range = rangeButton.publisher(for: .touchUpInside).eraseToAnyPublisher()
        let textFieldInput = textFieldButton.publisher(for: .touchUpInside).eraseToAnyPublisher()
        
        count.receive(on: RunLoop.main)
            .assign(to: &viewModel.$textInput)
        
        let output = viewModel.transform(RoomCountViewModel.Input(count: count, nextButton: next, rangeButton: range, textButton: textFieldInput))
        
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
        
        output.tapNext
            .sink {}
            .store(in: &cancellables)
        
        output.handleNextPage
            .throttle(for: 1, scheduler: RunLoop.main, latest: false)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished:
                    print("roomcount finish")
                case .failure(_):
                    self.navigationController?.popToRootViewController(animated: true)
                }
            }, receiveValue: { _ in
                let nextPage = DIContainer.shared.resolve(GenreViewController.self)
                self.navigationController?.pushViewController(nextPage, animated: true)
            })
            .store(in: &cancellables)
        
        output.handleRangeOrText
            .sink { [weak self] isRange in
                if isRange {
                    self?.textFieldBackgroundView.removeFromSuperview()
                    self?.numberLineStackView.removeFromSuperview()
                    
                    self?.configureSelectButton()
                    self?.rangeButton.isSelected.toggle()
                    self?.textFieldButton.isSelected.toggle()
                } else {
                    self?.selectButton.removeFromSuperview()
                    self?.tableView.removeFromSuperview()
                    
                    self?.configureNumberTextField()
                    self?.rangeButton.isSelected.toggle()
                    self?.textFieldButton.isSelected.toggle()
                    self?.selectButton.layoutIfNeeded()
                    self?.numberTextField.becomeFirstResponder()
                }
            }.store(in: &cancellables)
        
        selectButton.publisher(for: .touchUpInside)
            .throttle(for: 1, scheduler: RunLoop.main, latest: false)
            .sink { [weak self] _ in
                self?.configureTableView()
            }.store(in: &cancellables)
        
        backButton.publisher(for: .touchUpInside)
            .throttle(for: 0.05, scheduler: RunLoop.main, latest: true)
            .sink { [weak self]  in
                self?.navigationController?.popViewController(animated: true)
            }.store(in: &cancellables)
    }
    
    func configureUI() {
        view.addSubview(profileCount)
        view.addSubview(backButton)
        view.addSubview(stackView)
        stackView.addArrangedSubview(titleLabel)
        stackView.addArrangedSubview(descriptionLabel)
        
        NSLayoutConstraint.activate([
            backButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 10),
            backButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 32),
            
            stackView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            stackView.topAnchor.constraint(equalTo: backButton.bottomAnchor),
            stackView.heightAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.35)
        ])
    }
    
    private func configureSizeButtons() {
        view.addSubview(rangeButton)
        view.addSubview(textFieldButton)
        
        NSLayoutConstraint.activate([
            rangeButton.topAnchor.constraint(equalTo: stackView.bottomAnchor),
            rangeButton.heightAnchor.constraint(equalToConstant: 50),
            rangeButton.leadingAnchor.constraint(equalTo: stackView.leadingAnchor, constant: 24),
            rangeButton.widthAnchor.constraint(equalToConstant: view.frame.width * 0.42)
        ])
        
        NSLayoutConstraint.activate([
            textFieldButton.topAnchor.constraint(equalTo: stackView.bottomAnchor),
            textFieldButton.heightAnchor.constraint(equalToConstant: 50),
            textFieldButton.trailingAnchor.constraint(equalTo: stackView.trailingAnchor, constant: -24),
            textFieldButton.widthAnchor.constraint(equalToConstant: view.frame.width * 0.42)
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
        view.addSubview(tableView)
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: selectButton.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: selectButton.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: selectButton.trailingAnchor),
            tableView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.37)
        ])
    }
    
    private func configureNumberTextField() {
        view.addSubview(textFieldBackgroundView)
        view.addSubview(numberLineStackView)
        numberLineStackView.addArrangedSubview(numberTextField)
        numberLineStackView.addArrangedSubview(textFieldLabel)
        
        NSLayoutConstraint.activate([
            textFieldBackgroundView.topAnchor.constraint(equalTo: rangeButton.bottomAnchor, constant: 24),
            textFieldBackgroundView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.9),
            textFieldBackgroundView.heightAnchor.constraint(equalToConstant: 100),
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
        
        viewModel.canGoNext.send(true)
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
