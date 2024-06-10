//
//  ProfileViewController.swift
//  roome
//
//  Created by minsong kim on 6/3/24.
//

import UIKit
import Combine

class ProfileViewController: UIViewController {
    private let backButton = BackButton()
    private let navigationLabel: UILabel = {
        let label = UILabel()
        label.text = "프로필 이미지"
        label.font = .boldTitle2
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    //Profile View
    private let profileBackView: UIView = {
        let view = UIView()
        view.backgroundColor = .lightGray
        view.translatesAutoresizingMaskIntoConstraints = false

        return view
    }()
    private lazy var profileImageView: UIImageView = {
        let view = UIImageView(frame: .zero)
        view.image = squareImage
        view.contentMode = .scaleAspectFit
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    lazy var squareProfileView = ProfileView(frame: .zero)
    lazy var rectangleProfileView = ProfileView(frame: .zero)
    
    //Profile Image
    var squareImage = UIImage(resource: .sample)
    var rectangleImage = UIImage(resource: .sample)
    
    //Button
    private let squareButton = SizeButton(title: SizeDTO.square.title, isSelected: true)
    private let rectangleButton = SizeButton(title: SizeDTO.rectangle.title, isSelected: false)
    private let saveButton = NextButton(title: "저장하기", backgroundColor: .roomeMain, tintColor: .white)
    private let pageButton = NextButton(title: "프로필 페이지로 이동", backgroundColor: .clear, tintColor: .lightGray)
    
    //Window
    private let window = (UIApplication.shared.connectedScenes.first as? UIWindowScene)?.windows.first
    
    //PopUpView
    private lazy var popUpView = PopUpView(frame: window!.frame,
                                           title: "저장 완료",
                                           description: "내 사진에 저장되었어요",
                                           colorButtonTitle: "확인",
                                           isWhiteButton: false)
    
    //ViewModel
    private var viewModel: ProfileViewModel
    private var cancellable = Set<AnyCancellable>()
    
    init(viewModel: ProfileViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        configureUI()
        configureSquareView()
        configureRectangleView()
        bind()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        squareImage = squareProfileView.asImage()
        rectangleImage = rectangleProfileView.asImage()
        DIContainer.shared.resolve(LoadingView.self).removeFromSuperview()
        squareProfileView.removeFromSuperview()
        rectangleProfileView.removeFromSuperview()
        
        if viewModel.isSquareSize {
            profileImageView.image = squareImage
        } else {
            profileImageView.image = rectangleImage
        }
    }
    
    func bind() {
        let back = backButton.publisher(for: .touchUpInside)
            .eraseToAnyPublisher()
        let square = squareButton.publisher(for: .touchUpInside)
            .eraseToAnyPublisher()
        let rectangle = rectangleButton.publisher(for: .touchUpInside)
            .eraseToAnyPublisher()
        let save = saveButton.publisher(for: .touchUpInside)
            .eraseToAnyPublisher()
        let next = pageButton.publisher(for: .touchUpInside)
            .eraseToAnyPublisher()
        let okay = popUpView.colorButton.publisher(for: .touchUpInside)
            .eraseToAnyPublisher()
        let input = ProfileViewModel.Input(tapBackButton: back,
                                           tapSquareButton: square,
                                           tapRectangleButton: rectangle,
                                           tapSaveButton: save,
                                           tapNextButton: next,
                                           tapOkayButton: okay)
        let output = viewModel.transform(input)
        
        output.handleSaveButton
            .sink { [weak self] isSquareSize in
                guard let self = self else {
                    return
                }
                var image: UIImage
                if isSquareSize {
                    image = squareImage
                } else {
                    image = rectangleImage
                }
                UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil)
                self.window?.addSubview(self.popUpView)
            }.store(in: &cancellable)
        
        output.handleRectangleButton
            .sink { [weak self] _ in
                guard let self = self else {
                    return
                }
                
                self.squareButton.isSelected = false
                self.rectangleButton.isSelected = true
                
                self.profileImageView.image = self.rectangleImage
            }.store(in: &cancellable)
        
        output.handleSquareButton
            .sink { [weak self] _ in
                guard let self = self else {
                    return
                }
                self.squareButton.isSelected = true
                self.rectangleButton.isSelected = false

                profileImageView.image = squareImage
            }.store(in: &cancellable)
        
        output.handleOkayButton
            .sink { [weak self] _ in
                self?.popUpView.removeFromSuperview()
            }.store(in: &cancellable)
        
        output.handleBackButton
            .sink { [weak self] _ in
                self?.navigationController?.popViewController(animated: true)
            }.store(in: &cancellable)
        
        output.handleNextButton
            .sink { [weak self] _ in
                let nextViewController = DIContainer.shared.resolve(SignOutViewController.self)
                
                self?.navigationController?.pushViewController(nextViewController, animated: true)
            }.store(in: &cancellable)
    }
    
    private func configureUI() {
        configureNavigation()
        configureProfileView()
        configureNextButton()
        configureSizeButtons()
    }
    
    private func configureSquareView() {
        view.insertSubview(squareProfileView, at: 0)
        
        NSLayoutConstraint.activate([
            squareProfileView.topAnchor.constraint(equalTo: profileBackView.topAnchor),
            squareProfileView.bottomAnchor.constraint(equalTo: profileBackView.bottomAnchor),
            squareProfileView.leadingAnchor.constraint(equalTo: profileBackView.leadingAnchor),
            squareProfileView.trailingAnchor.constraint(equalTo: profileBackView.trailingAnchor)
        ])
    }
    
    private func configureRectangleView() {
        view.insertSubview(rectangleProfileView, at: 0)
        
        NSLayoutConstraint.activate([
            rectangleProfileView.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            rectangleProfileView.widthAnchor.constraint(equalTo: profileBackView.widthAnchor),
            rectangleProfileView.heightAnchor.constraint(equalTo: view.widthAnchor, multiplier: 1.25),
            rectangleProfileView.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor)
        ])
    }
    
    private func configureNavigation() {
        view.addSubview(backButton)
        view.addSubview(navigationLabel)
        
        NSLayoutConstraint.activate([
            backButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 10),
            backButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 0),
            
            navigationLabel.centerYAnchor.constraint(equalTo: backButton.centerYAnchor),
            navigationLabel.leadingAnchor.constraint(equalTo: backButton.trailingAnchor, constant: 8),
        ])
    }
    
    private func configureProfileView() {
        view.addSubview(profileBackView)
        profileBackView.addSubview(profileImageView)
        
        NSLayoutConstraint.activate([
            profileBackView.topAnchor.constraint(equalTo: backButton.bottomAnchor, constant: 8),
            profileBackView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            profileBackView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            profileBackView.heightAnchor.constraint(equalToConstant: view.frame.width),
            
            profileImageView.topAnchor.constraint(equalTo: profileBackView.topAnchor),
            profileImageView.bottomAnchor.constraint(equalTo: profileBackView.bottomAnchor),
            profileImageView.leadingAnchor.constraint(equalTo: profileBackView.leadingAnchor),
            profileImageView.trailingAnchor.constraint(equalTo: profileBackView.trailingAnchor)
            
        ])
    }
    
    private func configureSizeButtons() {
        view.addSubview(squareButton)
        view.addSubview(rectangleButton)
        
        NSLayoutConstraint.activate([
            squareButton.topAnchor.constraint(equalTo: profileBackView.bottomAnchor, constant: 24),
            squareButton.heightAnchor.constraint(equalToConstant: 50),
            squareButton.leadingAnchor.constraint(equalTo: saveButton.leadingAnchor),
            squareButton.widthAnchor.constraint(equalToConstant: view.frame.width * 0.44)
        ])
        
        NSLayoutConstraint.activate([
            rectangleButton.topAnchor.constraint(equalTo: profileBackView.bottomAnchor, constant: 24),
            rectangleButton.heightAnchor.constraint(equalToConstant: 50),
            rectangleButton.trailingAnchor.constraint(equalTo: saveButton.trailingAnchor),
            rectangleButton.widthAnchor.constraint(equalToConstant: view.frame.width * 0.44)
        ])
    }
    
    private func configureNextButton() {
        view.addSubview(saveButton)
        view.addSubview(pageButton)
        
        NSLayoutConstraint.activate([
            saveButton.bottomAnchor.constraint(equalTo: pageButton.topAnchor),
            saveButton.heightAnchor.constraint(equalToConstant: 50),
            saveButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            saveButton.widthAnchor.constraint(equalToConstant: view.frame.width * 0.9)
        ])
        
        NSLayoutConstraint.activate([
            pageButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16),
            pageButton.heightAnchor.constraint(equalToConstant: 50),
            pageButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            pageButton.widthAnchor.constraint(equalToConstant: view.frame.width * 0.9)
        ])
    }
}
