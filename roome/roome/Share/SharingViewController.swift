//
//  SharingViewController.swift
//  roome
//
//  Created by minsong kim on 6/26/24.
//

import UIKit
import Combine

class SharingViewController: UIViewController {
    private let sharingContainer: SharingContainer
    private let titleLabel = TitleLabel(text: "프로필")
    private lazy var collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
    private let nextButton: UIButton = {
        if UserContainer.shared.profile?.data.state == "complete" {
            return NextButton(title: "내 프로필로 이동", backgroundColor: .roomeMain, tintColor: .white)
        } else {
            return NextButton(title: "나만의 프로필 만들기", backgroundColor: .roomeMain, tintColor: .white)
        }
    }()
    
    private var cancellables = Set<AnyCancellable>()
    
    init(sharingContainer: SharingContainer) {
        self.sharingContainer = sharingContainer
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        configureTitleLabel()
        configureNextButton()
        setUpCollectionView()
        bind()
    }
    
    private func bind() {
        nextButton.publisher(for: .touchUpInside)
            .debounce(for: 0.3, scheduler: RunLoop.main)
            .sink { _ in
                //TODO: - 계정 유무에 따라 다르게 이동
                var next = UIViewController()
                if UserContainer.shared.profile?.data.state == "complete" {
                    next = DIContainer.shared.resolve(TabBarController.self)
                } else {
                    next = DIContainer.shared.resolve(LoginViewController.self)
                }
                (UIApplication.shared.connectedScenes.first as? UIWindowScene)?.windows.first?.rootViewController?.dismiss(animated: false)
                (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?
                    .changeRootViewController(next, animated: true)
            }
            .store(in: &cancellables)
    }
    
    private func configureTitleLabel() {
        view.addSubview(titleLabel)
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor)
        ])
    }
    
    private func setUpCollectionView() {
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(SharingUserCell.self, forCellWithReuseIdentifier: "SharingUserCell")
        collectionView.register(MyProfileCell.self, forCellWithReuseIdentifier: "MyProfileCell")
        collectionView.alwaysBounceVertical = true
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(collectionView)
        
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 20),
            collectionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: nextButton.topAnchor)
        ])
    }
    
    func configureNextButton() {
        view.addSubview(nextButton)
        
        NSLayoutConstraint.activate([
            nextButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            nextButton.heightAnchor.constraint(equalToConstant: 50),
            nextButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            nextButton.widthAnchor.constraint(equalToConstant: view.frame.width * 0.9)
        ])
    }
}

extension SharingViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        section == 0 ? 1 : MyProfileDTO.category.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let sharingUserCell = collectionView.dequeueReusableCell(withReuseIdentifier: "SharingUserCell", for: indexPath) as? SharingUserCell,
              let myProfileCell = collectionView.dequeueReusableCell(withReuseIdentifier: "MyProfileCell", for: indexPath) as? MyProfileCell,
              let profile = sharingContainer.profile,
              let colorDTO = profile.data.color else {
            return UICollectionViewCell()
        }
        
        if indexPath.section == 0 {
            sharingUserCell.updateNickname(sharingContainer.nickname)
            
            sharingUserCell.cardButtonPublisher()
                .sink { [weak self] _ in
                    print("card Button Tapped")
                    let popUpView = DIContainer.shared.resolve(MyProfileCardViewController.self)
                    popUpView.modalPresentationStyle = .fullScreen
                    
                    self?.present(popUpView, animated: true)
                }
                .store(in: &cancellables)
            
            return sharingUserCell
        } else {
            myProfileCell.updateOption(text: MyProfileDTO.category[indexPath.row])
            
            if indexPath.row == 0 || indexPath.row == 1 {
                myProfileCell.updateSelects(profile.bundle[indexPath.row], isBig: true)
            } else if indexPath.row == 10 {
                let color = BackgroundColor(
                    mode: Mode(rawValue: colorDTO.mode) ?? .gradient,
                    shape: Shape(rawValue: colorDTO.shape) ?? .linear,
                    direction: Direction(rawValue: colorDTO.direction) ?? .tlBR,
                    startColor: colorDTO.startColor,
                    endColor: colorDTO.endColor)
                myProfileCell.updateColorSet(color)
            } else {
                myProfileCell.updateSelects(profile.bundle[indexPath.row], isBig: false)
            }
            
            return myProfileCell
        }
    }
}
    
extension SharingViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        10
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        10
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        if section == 1 {
            return UIEdgeInsets(top: 10, left: 20, bottom: 10, right: 20)
        } else {
            return UIEdgeInsets(top: 10, left: 0, bottom: 0, right: 0)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        var height = view.frame.width * 0.25
        var width = view.frame.width * 0.43
        
        if indexPath.section == 0 {
            height = view.frame.width * 0.3
            width = view.frame.width * 0.9
        } else if indexPath.row == 0 || indexPath.row == 1 {
            height = view.frame.width * 0.2
        }
        
        return CGSize(width: width, height: height)
    }
}

//#Preview {
//    let vc = SharingViewController(sharingContainer: SharingContainer(nickname: ""))
//    
//    return vc
//}
