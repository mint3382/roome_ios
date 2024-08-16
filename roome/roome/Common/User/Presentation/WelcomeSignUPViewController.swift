//
//  CelebrateSignUPViewController.swift
//  roome
//
//  Created by minsong kim on 5/21/24.
//

import UIKit
import Combine
import FirebaseAnalytics

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
                                   colorButtonTitle: "이어서 하기")
    
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
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        Analytics.logEvent(Tracking.Profile.createView, parameters: nil)
    }
    
    func updateNickName() {
        welcomeLabel.text = """
                            \(UserContainer.shared.user?.data.nickname ?? "{Error2}")님,
                            가입을 축하드려요!
                            """
    }
    
    func bind() {
        makeProfileButton.publisher(for: .touchUpInside)
            .debounce(for: 0.3, scheduler: RunLoop.main)
            .map {
                Analytics.logEvent(Tracking.Profile.createNextButton, parameters: nil)
            }
            .sink { [weak self] in
                self?.viewModel.input.nextButton.send()
            }
            .store(in: &cancellables)
        
        popUpView.publisherWhiteButton()
            .debounce(for: 0.3, scheduler: RunLoop.main)
            .sink { [weak self] in
                self?.viewModel.input.newButton.send()
                self?.popUpView.removeFromSuperview()
            }
            .store(in: &cancellables)
        
        popUpView.publisherColorButton()
            .debounce(for: 0.3, scheduler: RunLoop.main)
            .sink { [weak self] in
                self?.viewModel.input.stillButton.send()
                self?.popUpView.removeFromSuperview()
            }
            .store(in: &cancellables)
        
        viewModel.output.willBeContinue
            .debounce(for: 0.3, scheduler: RunLoop.main)
            .sink { error in
                //fail
            } receiveValue: { [weak self] state in
                if state {
                    self?.window?.addSubview(self!.popUpView)
                } else {
                    let nextPage = DIContainer.shared.resolve(RoomCountViewController.self)
                    self?.navigationController?.pushViewController(nextPage, animated: true)
                }
            }
            .store(in: &cancellables)
        
        viewModel.output.handleNext
            .debounce(for: 0.3, scheduler: RunLoop.main)
            .sink { [weak self] state in
                self?.navigationController?.viewControllers.append(DIContainer.shared.resolve(RoomCountViewController.self))
                self?.navigationController?.viewControllers.append(DIContainer.shared.resolve(GenreViewController.self))
                self?.navigationController?.viewControllers.append(DIContainer.shared.resolve(MBTIViewController.self))
                self?.navigationController?.viewControllers.append(DIContainer.shared.resolve(StrengthViewController.self))
                self?.navigationController?.viewControllers.append(DIContainer.shared.resolve(ImportantFactorViewController.self))
                self?.navigationController?.viewControllers.append(DIContainer.shared.resolve(HorrorPositionViewController.self))
                self?.navigationController?.viewControllers.append(DIContainer.shared.resolve(HintViewController.self))
                self?.navigationController?.viewControllers.append(DIContainer.shared.resolve(DeviceAndLockViewController.self))
                self?.navigationController?.viewControllers.append(DIContainer.shared.resolve(ActivityViewController.self))
                self?.navigationController?.viewControllers.append(DIContainer.shared.resolve(DislikeViewController.self))
                self?.navigationController?.viewControllers.append(DIContainer.shared.resolve(ColorSelectViewController.self))
                
                switch state {
                case .roomCountRanges:
                    self?.navigationController?.popToViewController(DIContainer.shared.resolve(RoomCountViewController.self), animated: false)
                case .genres:
                    self?.navigationController?.popToViewController(DIContainer.shared.resolve(GenreViewController.self), animated: false)
                case .mbti:
                    self?.navigationController?.popToViewController(DIContainer.shared.resolve(MBTIViewController.self), animated: false)
                case .strengths:
                    self?.navigationController?.popToViewController(DIContainer.shared.resolve(StrengthViewController.self), animated: false)
                case .themes:
                    self?.navigationController?.popToViewController(DIContainer.shared.resolve(ImportantFactorViewController.self), animated: false)
                case .horrorPosition:
                    self?.navigationController?.popToViewController(DIContainer.shared.resolve(HorrorPositionViewController.self), animated: false)
                case .hint:
                    self?.navigationController?.popToViewController(DIContainer.shared.resolve(HintViewController.self), animated: false)
                case .device:
                    self?.navigationController?.popToViewController(DIContainer.shared.resolve(DeviceAndLockViewController.self), animated: false)
                case .activity:
                    self?.navigationController?.popToViewController(DIContainer.shared.resolve(ActivityViewController.self), animated: false)
                case .dislike:
                    self?.navigationController?.popToViewController(DIContainer.shared.resolve(DislikeViewController.self), animated: false)
                case .color:
                    self?.navigationController?.popToViewController(DIContainer.shared.resolve(ColorSelectViewController.self), animated: false)
                case .complete:
                    self?.navigationController?.pushViewController(DIContainer.shared.resolve(ProfileCardViewController.self), animated: true)
                }
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
