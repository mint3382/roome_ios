//
//  CelebrateSignUPViewController.swift
//  roome
//
//  Created by minsong kim on 5/21/24.
//

import UIKit
import Combine

class WelcomeSignUPViewController: UIViewController {
    private let stackView: UIStackView = {
        let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .vertical
        stack.distribution = .fillProportionally
        stack.spacing = 20
        
        return stack
    }()
    
    private lazy var welcomeLabel: UILabel = {
        let label = PaddingLabel(padding: UIEdgeInsets(top: 20, left: 4, bottom: 0, right: 4))
        label.text = """
                    {Error}님
                    가입을 축하드려요!
                    """
        label.numberOfLines = 2
        label.textAlignment = .center
        label.font = UIFont().pretendardBold(size: .headline3)
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    private let descriptionLabel: UILabel = {
        let label = PaddingLabel(padding: UIEdgeInsets(top: 0, left: 4, bottom: 20, right: 4))
        label.text = """
                    방탈출 취향을 가득 담은
                    특별한 프로필을 만들어 볼까요?
                    """
        label.numberOfLines = 2
        label.textAlignment = .center
        label.font = UIFont().pretendardRegular(size: .body1)
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    private lazy var sampleImage: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(resource: .sample).resize(newWidth: self.view.frame.width * 0.9)
        
        return imageView
    }()
    
    private let makeProfileButton: UIButton = {
        let button = UIButton(type: .system)
        button.tintColor = .white
        button.layer.cornerRadius = 10
        button.backgroundColor = .roomeMain
        button.setTitle("프로필 만들기", for: .normal)
        button.titleLabel?.font = UIFont().pretendardBold(size: .label)
        button.translatesAutoresizingMaskIntoConstraints = false
        
        return button
    }()
    
    private let viewModel: WelcomeViewModel
    private var cancellables = Set<AnyCancellable>()
//    private let nickname: String? = UserContainer.shared.user?.data.nickname
    
    init(viewModel: WelcomeViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        configureStackView()
        configureButton()
        updateNickName()
        bind()
    }
    
    func updateNickName() {
        welcomeLabel.text = """
                            \(UserContainer.shared.user?.data.nickname ?? "{Error2}")님,
                            가입을 축하드려요!
                            """
    }
    
    func bind() {
        let input = makeProfileButton.publisher(for: .touchUpInside).eraseToAnyPublisher()
        
        let output = viewModel.transforms(WelcomeViewModel.Input(nextButton: input))
        
        output.handleNext
            .sink { [weak self] _ in
                let nextPage = DIContainer.shared.resolve(RoomCountViewController.self)
                self?.navigationController?.pushViewController(nextPage, animated: true)
            }.store(in: &cancellables)
    }
    
    func configureStackView() {
        view.addSubview(stackView)
        
        stackView.addArrangedSubview(welcomeLabel)
        stackView.addArrangedSubview(descriptionLabel)
        stackView.addArrangedSubview(sampleImage)
        
        NSLayoutConstraint.activate([
            stackView.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            stackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 50)
        ])
    }
    
    func configureButton() {
        view.addSubview(makeProfileButton)
        
        NSLayoutConstraint.activate([
            makeProfileButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16),
            makeProfileButton.heightAnchor.constraint(equalToConstant: 50),
            makeProfileButton.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.9),
            makeProfileButton.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }

}
