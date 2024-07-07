//
//  SharingCardViewController.swift
//  roome
//
//  Created by minsong kim on 6/26/24.
//

import UIKit
import Combine

class SharingCardViewController: UIViewController {
    private let sharingContainer: SharingContainer
    private let backButton = BackButton()
    private let navigationLabel: UILabel = {
        let label = UILabel()
        label.text = "프로필 이미지"
        label.font = .boldTitle3
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    //Profile View
    private let profileBackView: UIView = {
        let view = UIView()
        view.backgroundColor = .disable
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
    lazy var squareProfileView = SharingCardView(frame: .zero, sharingContainer: sharingContainer)
    lazy var rectangleProfileView = SharingCardView(frame: .zero, sharingContainer: sharingContainer)
    
    //Profile Image
    var squareImage: UIImage?
    var rectangleImage: UIImage?
    
    //Button
    private let squareButton = SizeButton(title: SizeDTO.square.title, isSelected: true)
    private let rectangleButton = SizeButton(title: SizeDTO.rectangle.title, isSelected: false)
    private let saveButton = NextButton(title: "이미지로 저장하기", backgroundColor: .roomeMain, tintColor: .white)
    
    //Window
    private let window = (UIApplication.shared.connectedScenes.first as? UIWindowScene)?.windows.first
    
    //PopUpView
    private lazy var saveSuccessPopUp = PopUpView(frame: window!.frame,
                                                  title: "저장 완료",
                                                  description: "내 사진에 저장되었어요",
                                                  colorButtonTitle: "확인")
    
    private lazy var saveFailPopUp = PopUpView(frame: window!.frame,
                                               title: "저장 실패",
                                               description: "설정을 확인해주세요",
                                               colorButtonTitle: "확인")
    
    //ViewModel
    private var viewModel: ProfileCardViewModel
    private var cancellable = Set<AnyCancellable>()
    
    init(viewModel: ProfileCardViewModel, sharingContainer: SharingContainer) {
        self.viewModel = viewModel
        self.sharingContainer = sharingContainer
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
        bindOutput()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        if squareImage == nil {
            loadCardImages()
        }
    }
    
    private func loadCardImages() {
        squareImage = squareProfileView.asImage()
        rectangleImage = rectangleProfileView.asImage()
        squareProfileView.removeFromSuperview()
        rectangleProfileView.removeFromSuperview()
        profileImageView.image = squareImage
        
        ImageManager.saveImageToDirectory(identifier: .squareCard, image: squareImage)
        ImageManager.saveImageToDirectory(identifier: .rectangleCard, image: rectangleImage)
    }
    
    private func bind() {
        backButton.publisher(for: .touchUpInside)
            .sink { [weak self] in
                self?.dismiss(animated: true)
            }
            .store(in: &cancellable)
        
        squareButton.publisher(for: .touchUpInside)
            .sink { [weak self] in
                self?.viewModel.input.tapSquareButton.send()
            }
            .store(in: &cancellable)
        
        rectangleButton.publisher(for: .touchUpInside)
            .sink { [weak self] in
                self?.viewModel.input.tapRectangleButton.send()
            }
            .store(in: &cancellable)
        
        saveButton.publisher(for: .touchUpInside)
            .sink { [weak self] _ in
                self?.viewModel.input.tapSaveButton.send()
            }
            .store(in: &cancellable)
        
        saveSuccessPopUp.publisherColorButton()
            .sink { [weak self] _ in
                self?.saveSuccessPopUp.removeFromSuperview()
            }
            .store(in: &cancellable)
        
        saveFailPopUp.publisherColorButton()
            .sink { [weak self] _ in
                self?.saveFailPopUp.removeFromSuperview()
            }
            .store(in: &cancellable)
    }
    
    private func bindOutput() {
        viewModel.output.handleSaveButton
            .sink { [weak self] image in
                self?.saveImage(image)
            }
            .store(in: &cancellable)
        
        viewModel.output.handleSquareButton
            .sink { [weak self] isSquareSize in
                if isSquareSize {
                    self?.squareButton.isSelected = true
                    self?.rectangleButton.isSelected = false

                    self?.profileImageView.image = self?.squareImage
                    self?.profileImageView.layoutIfNeeded()
                } else {
                    self?.squareButton.isSelected = false
                    self?.rectangleButton.isSelected = true
                    
                    self?.profileImageView.image = self?.rectangleImage
                    self?.profileImageView.layoutIfNeeded()
                }
            }
            .store(in: &cancellable)
    }
    
    private func configureUI() {
        configureNavigation()
        configureProfileView()
        configureSaveButton()
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
        backButton.updateButton(image: UIImage(systemName: "xmark")?.changeImageColor(.label).resize(newWidth: 16))
        
        view.addSubview(backButton)
        view.addSubview(navigationLabel)
        
        NSLayoutConstraint.activate([
            navigationLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 24),
            navigationLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            navigationLabel.heightAnchor.constraint(equalToConstant: 60),
            
            backButton.centerYAnchor.constraint(equalTo: navigationLabel.centerYAnchor),
            backButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -10),
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
    
    private func configureSaveButton() {
        view.addSubview(saveButton)
        
        NSLayoutConstraint.activate([
            saveButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16),
            saveButton.heightAnchor.constraint(equalToConstant: 50),
            saveButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            saveButton.widthAnchor.constraint(equalToConstant: view.frame.width * 0.9)
        ])
    }
}

extension SharingCardViewController {
    func saveImage(_ image: UIImage?) {
        guard let image else {
            return
        }
        
        UIImageWriteToSavedPhotosAlbum(image, self, #selector(savedImage(image:  didFinishSavingWithError: contextInfo: )), nil)
    }
    
    @objc func savedImage(image: UIImage, didFinishSavingWithError error: Error?, contextInfo: UnsafeRawPointer) {
        if let error {
            print("‼️\(error)")
            self.window?.addSubview(saveFailPopUp)
        } else {
            self.window?.addSubview(saveSuccessPopUp)
        }
    }
}

