//
//  DeviceAndLockViewController.swift
//  roome
//
//  Created by minsong kim on 5/23/24.
//

import UIKit
import Combine
import FirebaseAnalytics

class DeviceAndLockViewController: UIViewController {
    private let titleLabel = TitleLabel(text: "장치와 자물쇠 중\n어떤 것을 더 선호하시나요?")
    lazy var profileCount = ProfileStateLineView(pageNumber: 8, frame: CGRect(x: 0, y: 0, width: view.frame.width * 0.9 - 10, height: view.frame.height))
    private let backButton = BackButton()
    private lazy var collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
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
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        Analytics.logEvent(Tracking.Profile.deviceAndLockView, parameters: nil)
    }
    
    func bind() {
        backButton.publisher(for: .touchUpInside)
            .debounce(for: 0.3, scheduler: RunLoop.main)
            .sink { [weak self] _ in
                self?.navigationController?.popViewController(animated: false)
            }
            .store(in: &cancellables)
        
        viewModel.output.handleNextButton
            .debounce(for: 0.3, scheduler: RunLoop.main)
            .sink { [weak self] result in
                switch result {
                case .success:
                    let nextViewController = DIContainer.shared.resolve(ActivityViewController.self)
                    self?.navigationController?.pushViewController(nextViewController, animated: false)
                    self?.collectionView.allowsSelection = true
                case .failure(let error):
                    print(error)
                    self?.collectionView.allowsSelection = true
                    //TODO: error Toast 띄우기
                }
            }
            .store(in: &cancellables)
    }
    
    func configureUI() {
        configureStackView()
        setUpCollectionView()
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
        profileCount.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(profileCount)
        view.addSubview(backButton)
        view.addSubview(titleLabel)
        
        NSLayoutConstraint.activate([
            profileCount.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
            profileCount.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            profileCount.heightAnchor.constraint(equalToConstant: 15),
            profileCount.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.9),
            
            backButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 10),
            backButton.topAnchor.constraint(equalTo: profileCount.bottomAnchor, constant: 12),
            
            titleLabel.topAnchor.constraint(equalTo: backButton.bottomAnchor, constant: 12),
            titleLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor)
        ])
    }
}

extension DeviceAndLockViewController: UICollectionViewDataSource {
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
        collectionView.allowsSelection = false
        viewModel.input.selectCell.send((false,device.id))
    }
}

extension DeviceAndLockViewController: UICollectionViewDelegateFlowLayout {
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
