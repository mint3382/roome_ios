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
    lazy var profileView = ProfileView(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.width))
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
            .sink { [weak self] _ in
                let image = self?.profileView.asImage() ?? UIImage(resource: .sample)
                UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil)
                self?.window?.addSubview(self!.popUpView)
            }.store(in: &cancellable)
        
        output.handleOkayButton
            .sink { [weak self] _ in
                self?.popUpView.removeFromSuperview()
            }.store(in: &cancellable)
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
        view.addSubview(profileView)
        profileView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            profileView.topAnchor.constraint(equalTo: backButton.bottomAnchor, constant: 8),
            profileView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            profileView.widthAnchor.constraint(equalTo: view.widthAnchor),
            profileView.heightAnchor.constraint(equalTo: profileView.widthAnchor)
        ])
    }
    
    func configureSizeButtons() {
        view.addSubview(squareButton)
        view.addSubview(rectangleButton)
        
        NSLayoutConstraint.activate([
            squareButton.topAnchor.constraint(equalTo: profileView.bottomAnchor, constant: 24),
            squareButton.heightAnchor.constraint(equalToConstant: 50),
            squareButton.leadingAnchor.constraint(equalTo: saveButton.leadingAnchor),
            squareButton.widthAnchor.constraint(equalToConstant: view.frame.width * 0.44)
        ])
        
        NSLayoutConstraint.activate([
            rectangleButton.topAnchor.constraint(equalTo: profileView.bottomAnchor, constant: 24),
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
