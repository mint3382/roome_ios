//
//  CelebrateSignUPViewController.swift
//  roome
//
//  Created by minsong kim on 5/21/24.
//

import UIKit
import Combine

class WelcomeSignUPViewController: UIViewController {
    private let stackView = UIStackView(axis: .vertical, alignment: .center, spacing: 20)
    
    private lazy var welcomeLabel: UILabel = {
        let label = PaddingLabel(padding: UIEdgeInsets(top: 20, left: 4, bottom: 0, right: 4))
        label.text = """
                    {Error}님
                    가입을 축하드려요!
                    """
        label.numberOfLines = 2
        label.textAlignment = .center
        label.font = .boldHeadline3
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
        label.font = .regularBody1
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    private lazy var sampleImage: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(resource: .sample).resize(newWidth: self.view.frame.width * 0.9)
        
        return imageView
    }()
    
    private let makeProfileButton = NextButton(title: "프로필 만들기", backgroundColor: .roomeMain, tintColor: .white)
    
    let window = (UIApplication.shared.connectedScenes.first as? UIWindowScene)?.windows.first
    lazy var popUpView = PopUpView(frame: window!.frame,
                                   title: "제작 중인 프로필이 있어요",
                                   description: "이어서 만드시겠어요?",
                                   whiteButtonTitle: "처음부터 하기",
                                   colorButtonTitle: "이어서 하기",
                                   isWhiteButton: true)
    
    private let viewModel: WelcomeViewModel
    private var cancellables = Set<AnyCancellable>()
    
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
        let next = makeProfileButton.publisher(for: .touchUpInside).eraseToAnyPublisher()
        let start = popUpView.whiteButton.publisher(for: .touchUpInside).eraseToAnyPublisher()
        let still = popUpView.colorButton.publisher(for: .touchUpInside).eraseToAnyPublisher()
        
        let output = viewModel.transforms(WelcomeViewModel.Input(nextButton: next))
        let popUpOutput = viewModel.popUpTransforms(WelcomeViewModel.PopUpInput(newButton: start, stillButton: still))
        
        output.handleNext
            .throttle(for: 1, scheduler: RunLoop.main, latest: false)
            .sink(receiveCompletion: { error in
                //실패 시
            }, receiveValue: { [weak self] state in
                if state {
                    self?.window?.addSubview(self!.popUpView)
                } else {
                    let nextPage = DIContainer.shared.resolve(RoomCountViewController.self)
                    self?.navigationController?.pushViewController(nextPage, animated: true)
                }
            }).store(in: &cancellables)
        
        output.nextState
            .throttle(for: 1, scheduler: RunLoop.main, latest: false)
            .sink { [weak self] state in
                var nextPage: UIViewController
                switch state {
                case .roomCountRanges:
                    nextPage = DIContainer.shared.resolve(RoomCountViewController.self)
                case .genres:
                    nextPage = DIContainer.shared.resolve(GenreViewController.self)
                case .mbti:
                    nextPage = DIContainer.shared.resolve(MBTIViewController.self)
                case .strengths:
                    nextPage = DIContainer.shared.resolve(StrengthViewController.self)
                case .themes:
                    nextPage = DIContainer.shared.resolve(ImportantFactorViewController.self)
                case .horrorPosition:
                    nextPage = DIContainer.shared.resolve(HorrorPositionViewController.self)
                case .hint:
                    nextPage = DIContainer.shared.resolve(HintViewController.self)
                case .device:
                    nextPage = DIContainer.shared.resolve(DeviceAndLockViewController.self)
                case .activity:
                    nextPage = DIContainer.shared.resolve(ActivityViewController.self)
                case .dislike:
                    nextPage = DIContainer.shared.resolve(DislikeViewController.self)
                case .color:
                    nextPage = DIContainer.shared.resolve(ColorSelectViewController.self)
                case .complete:
                    nextPage = DIContainer.shared.resolve(ProfileCardViewController.self)
                }
                self?.navigationController?.pushViewController(nextPage, animated: true)
            }.store(in: &cancellables)
        
        popUpOutput.handleNext
            .sink { [weak self] _ in
                self?.popUpView.removeFromSuperview()
            }.store(in: &cancellables)
        
        output.tapNext
            .sink { }
            .store(in: &cancellables)
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
