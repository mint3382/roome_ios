//
//  EditDeviceAndLockViewController.swift
//  roome
//
//  Created by minsong kim on 7/10/24.
//

import UIKit
import Combine

class EditDeviceAndLockViewController: UIViewController {
    private let window = (UIApplication.shared.connectedScenes.first as? UIWindowScene)?.windows.first
    private lazy var changePopUp = PopUpView(frame: window!.bounds,
                                             title: "변경사항이 있어요",
                                             description: "변경사항을 저장하지 않고 나가시겠어요?",
                                             whiteButtonTitle: "취소",
                                             colorButtonTitle: "나가기")
    private let closeButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "xmark")?.changeImageColor(.label).resize(newWidth: 16), for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        
        return button
    }()
    private let titleLabel = TitleLabel(text: "장치와 자물쇠 중\n어떤 것을 더 선호하시나요?")
    private lazy var collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
    private var nextButton = NextButton(title: "저장", backgroundColor: .roomeMain, tintColor: .white)
    var viewModel: DeviceAndLockViewModel
    var cancellables = Set<AnyCancellable>()
    
    init(viewModel: DeviceAndLockViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(ButtonCell.self, forCellWithReuseIdentifier: "cell")
        configureUI()
        bind()
    }
    
    func bind() {
        nextButton.publisher(for: .touchUpInside)
            .sink { [weak self] in
                self?.viewModel.input.tapSaveButton.send()
            }
            .store(in: &cancellables)
        
        closeButton.publisher(for: .touchUpInside)
            .sink { [weak self] in
                self?.viewModel.input.tapCloseButton.send()
            }
            .store(in: &cancellables)
        
        viewModel.output.handleCloseButton
            .throttle(for: 1, scheduler: RunLoop.main, latest: false)
            .sink { [weak self] didEdit in
                if let self, didEdit {
                    window?.addSubview(changePopUp)
                } else {
                    self?.dismiss(animated: false)
                }
            }
            .store(in: &cancellables)
        
        viewModel.output.handleNextButton
            .throttle(for: 1, scheduler: RunLoop.main, latest: false)
            .sink { [weak self] result in
                switch result {
                case .success:
                    self?.dismiss(animated: false)
                case .failure(let error):
                    print(error)
                    //TODO: error Toast 띄우기
                }
            }
            .store(in: &cancellables)
        
        changePopUp.publisherWhiteButton()
            .sink { [weak self] in
                self?.changePopUp.removeFromSuperview()
            }
            .store(in: &cancellables)
        
        changePopUp.publisherColorButton()
            .sink { [weak self] in
                self?.changePopUp.removeFromSuperview()
                self?.dismiss(animated: false)
            }
            .store(in: &cancellables)
    }
    
    func configureUI() {
        configureStackView()
        setUpCollectionView()
        configureNextButton()
    }
    
    func setUpCollectionView() {
        collectionView.alwaysBounceVertical = true
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(collectionView)
        
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 22),
            collectionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -50)
        ])
        
    }
    
    func configureStackView() {
        view.addSubview(closeButton)
        view.addSubview(titleLabel)
        
        NSLayoutConstraint.activate([
            closeButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -24),
            closeButton.widthAnchor.constraint(equalToConstant: 24),
            closeButton.heightAnchor.constraint(equalToConstant: 24),
            closeButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            
            titleLabel.topAnchor.constraint(equalTo: closeButton.bottomAnchor, constant: 12),
            titleLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor)
        ])
    }
    
    private func configureNextButton() {
        view.addSubview(nextButton)
        
        NSLayoutConstraint.activate([
            nextButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            nextButton.heightAnchor.constraint(equalToConstant: 50),
            nextButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            nextButton.widthAnchor.constraint(equalToConstant: view.frame.width * 0.9)
        ])
    }
}

extension EditDeviceAndLockViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        UserContainer.shared.defaultProfile?.data.deviceLockPreferences.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as? ButtonCell
        else {
            return UICollectionViewCell()
        }
        
        guard let device = UserContainer.shared.defaultProfile?.data.deviceLockPreferences[indexPath.row] else {
            return UICollectionViewCell()
        }
        
        if let userSelect = UserContainer.shared.profile?.data.deviceLockPreference?.id {
            if userSelect == device.id {
                cell.isSelected = true
                collectionView.selectItem(at: indexPath, animated: false, scrollPosition: .init())
                viewModel.input.selectCell.send((true, userSelect))
            }
        }
        
        cell.changeTitle(device.title)
        cell.addDescription(device.description)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let device = UserContainer.shared.defaultProfile?.data.deviceLockPreferences[indexPath.row] else {
            return
        }
        viewModel.input.selectCell.send((true,device.id))
    }
}

extension EditDeviceAndLockViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        10
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        guard let device = UserContainer.shared.defaultProfile?.data.deviceLockPreferences[indexPath.row] else {
            return .zero
        }
        
        var height: CGFloat = 50
        
        if device.description != "" {
            height = 80
        }
        
        let width = view.frame.width - 48
        
        return CGSize(width: width, height: height)
    }
}
