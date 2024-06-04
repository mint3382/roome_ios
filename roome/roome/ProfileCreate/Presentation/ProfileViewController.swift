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
        label.font = UIFont().pretendardBold(size: .title2)
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    private let profileBackView: UIView = {
        let view = UIView()
        view.backgroundColor = .lightGray
        view.translatesAutoresizingMaskIntoConstraints = false

        return view
    }()
    lazy var profileView = ProfileView(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.width), isRectangle: false)
    lazy var rectangleProfileView = ProfileView(frame: CGRect(x: 0, y: 0, width: view.frame.width * 0.75, height: view.frame.width), isRectangle: true)
    private let squareButton = SizeButton(title: SizeDTO.square.title, isSelected: true)
    private let rectangleButton = SizeButton(title: SizeDTO.rectangle.title, isSelected: false)
    private let saveButton = NextButton(title: "저장하기", backgroundColor: .roomeMain, tintColor: .white)
    private let pageButton = NextButton(title: "프로필 페이지로 이동", backgroundColor: .clear, tintColor: .lightGray)
    private let window = (UIApplication.shared.connectedScenes.first as? UIWindowScene)?.windows.first
    private lazy var popUpView = PopUpView(frame: window!.frame,
                                           title: "저장 완료",
                                           description: "내 사진에 저장되었어요",
                                           colorButtonTitle: "확인",
                                           isWhiteButton: false)
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
        bind()
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
                var image = UIImage()
                
                if isSquareSize {
                    image = self.profileView.asImage() ?? UIImage(resource: .sample)
                } else {
                    image = self.rectangleProfileView.asImage() ?? UIImage(resource: .sample)
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
                self.profileView.removeFromSuperview()
                self.profileBackView.addSubview(self.rectangleProfileView)
                
                NSLayoutConstraint.activate([
                    self.rectangleProfileView.topAnchor.constraint(equalTo: (self.profileBackView.topAnchor)),
                    self.rectangleProfileView.bottomAnchor.constraint(equalTo: self.profileBackView.bottomAnchor),
                    self.rectangleProfileView.centerXAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.centerXAnchor),
                    self.rectangleProfileView.widthAnchor.constraint(equalTo: self.profileBackView.widthAnchor, multiplier: 0.75)
                ])
            }.store(in: &cancellable)
        
        output.handleSquareButton
            .sink { [weak self] _ in
                guard let self = self else {
                    return
                }
                self.squareButton.isSelected = true
                self.rectangleButton.isSelected = false
                self.rectangleProfileView.removeFromSuperview()
                self.profileBackView.addSubview(self.profileView)
                
                NSLayoutConstraint.activate([
                    self.profileView.topAnchor.constraint(equalTo: (self.profileBackView.topAnchor)),
                    self.profileView.bottomAnchor.constraint(equalTo: self.profileBackView.bottomAnchor),
                    self.profileView.centerXAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.centerXAnchor),
                    self.profileView.widthAnchor.constraint(equalTo: self.profileBackView.widthAnchor)
                ])
            }.store(in: &cancellable)
        
        output.handleOkayButton
            .sink { [weak self] _ in
                self?.popUpView.removeFromSuperview()
            }.store(in: &cancellable)
        
        output.handleBackButton
            .sink { [weak self] _ in
                self?.navigationController?.popViewController(animated: true)
            }.store(in: &cancellable)
        
//        output.handleNextButton
//            .sink { [weak self] _ in
//                let nextViewController = SignOutViewController()
//                
//                self?.navigationController?.pushViewController(nextViewController, animated: true)
//            }.store(in: &cancellable)
    }
    
    func configureUI() {
        configureNavigation()
        configureProfileView()
        configureNextButton()
        configureSizeButtons()
    }
    
    func configureNavigation() {
        view.addSubview(backButton)
        view.addSubview(navigationLabel)
        
        NSLayoutConstraint.activate([
            backButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 10),
            backButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 0),
            
            navigationLabel.centerYAnchor.constraint(equalTo: backButton.centerYAnchor),
            navigationLabel.leadingAnchor.constraint(equalTo: backButton.trailingAnchor, constant: 8),
        ])
    }
    
    func configureProfileView() {
        view.addSubview(profileBackView)
        profileBackView.addSubview(profileView)
        
        NSLayoutConstraint.activate([
            profileBackView.topAnchor.constraint(equalTo: backButton.bottomAnchor, constant: 8),
            profileBackView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            profileBackView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            profileBackView.heightAnchor.constraint(equalToConstant: view.frame.width),
            
            profileView.topAnchor.constraint(equalTo: profileBackView.topAnchor),
            profileView.bottomAnchor.constraint(equalTo: profileBackView.bottomAnchor),
            profileView.leadingAnchor.constraint(equalTo: profileBackView.leadingAnchor),
            profileView.trailingAnchor.constraint(equalTo: profileBackView.trailingAnchor)
        ])
    }
    
    func configureSizeButtons() {
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
