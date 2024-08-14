//
//  MyProfileViewController.swift
//  roome
//
//  Created by minsong kim on 6/18/24.
//

import UIKit
import Combine
import FirebaseAnalytics

class MyProfileViewController: UIViewController {
    private let window = (UIApplication.shared.connectedScenes.first as? UIWindowScene)?.windows.first
    private lazy var errorPopUp = PopUpView(frame: window!.bounds, title: "카카오톡 미설치", description: "카카오톡 설치 여부를 확인해주세요.", colorButtonTitle: "확인")
    private let titleLabel = TitleLabel(text: "프로필")
    private lazy var collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
    var viewModel: MyProfileViewModel
    private var cancellables = Set<AnyCancellable>()
    
    init(viewModel: MyProfileViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        configureTitleLabel()
        setUpCollectionView()
        bind()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print("viewWillAppear")
        //TODO: - 닉네임과 유저 사진이 바뀌었다면 업데이트.
        (collectionView.cellForItem(at: IndexPath(item: 0, section: 0)) as? UserCell)?.updateUserProfile()
        collectionView.reloadSections(IndexSet.init(arrayLiteral: 1))
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        Analytics.logEvent(Tracking.MyProfile.myProfileView, parameters: nil)
    }
    
    private func bind() {
        viewModel.output.handleKakaoShare
            .sink { [weak self] isSuccess in
                guard let self else {
                    return
                }
                
                if isSuccess == false {
                    window?.addSubview(errorPopUp)
                }
            }
            .store(in: &cancellables)
        
        errorPopUp.publisherColorButton()
            .sink { [weak self] in
                self?.errorPopUp.removeFromSuperview()
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
        collectionView.register(UserCell.self, forCellWithReuseIdentifier: "UserCell")
        collectionView.register(MyProfileCell.self, forCellWithReuseIdentifier: "MyProfileCell")
        collectionView.alwaysBounceVertical = true
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(collectionView)
        
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 20),
            collectionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
}

extension MyProfileViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        section == 0 ? 1 : MyProfileDTO.category.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let userCell = collectionView.dequeueReusableCell(withReuseIdentifier: "UserCell", for: indexPath) as? UserCell,
              let myProfileCell = collectionView.dequeueReusableCell(withReuseIdentifier: "MyProfileCell", for: indexPath) as? MyProfileCell,
              let profile = UserContainer.shared.profile,
              let colorDTO = profile.data.color else {
            return UICollectionViewCell()
        }
        
        if indexPath.section == 0 {
            userCell.userButtonPublisher()
                .sink { [weak self] in
                    let view = EditProfileViewController(viewModel: EditProfileViewModel(usecase: DIContainer.shared.resolve(UserProfileUseCase.self)))
                    view.modalPresentationStyle = .fullScreen
                    
                    self?.present(view, animated: true)
                }
                .store(in: &cancellables)
            
            userCell.cardButtonPublisher()
                .map {
                    Analytics.logEvent(Tracking.MyProfile.myProfileCardButton, parameters: nil)
                }
                .sink { [weak self] _ in
                    print("card Button Tapped")
                    let popUpView = DIContainer.shared.resolve(MyProfileCardViewController.self)
                    let cardViewModel = ProfileCardViewModel()
                    let view = MyProfileCardViewController(viewModel: cardViewModel)
                    view.modalPresentationStyle = .fullScreen
                    
                    self?.present(view, animated: true)
                }
                .store(in: &cancellables)
            
            userCell.shareButtonPublisher()
                .map {
                    Analytics.logEvent(Tracking.MyProfile.shareKakaoButton, parameters: nil)
                }
                .sink { [weak self] _ in
                    self?.viewModel.input.tappedShareButton.send()
                }
                .store(in: &cancellables)
            
            return userCell
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
    
extension MyProfileViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        10
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        10
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        if section == 1 {
            return UIEdgeInsets(top: 10, left: 24, bottom: 10, right: 24)
        } else {
            return UIEdgeInsets(top: 10, left: 24, bottom: 0, right: 24)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        var height = 90.0
        var width = (view.frame.width / 2) - 29
        
        if indexPath.section == 0 {
            height = 140.0
            width = view.frame.width - 48
        } else if indexPath.row == 0 || indexPath.row == 1 {
            height = 70.0
        }
        
        return CGSize(width: width, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        var next = UIViewController()
        if indexPath.section == 1 {
            switch indexPath.row {
            case 0:
                next = DIContainer.shared.resolve(EditRoomCountViewController.self)
            case 1:
                next = DIContainer.shared.resolve(EditMBTIViewController.self)
            case 2:
                next = DIContainer.shared.resolve(EditGenreViewController.self)
            case 3:
                next = DIContainer.shared.resolve(EditStrengthViewController.self)
            case 4:
                next = DIContainer.shared.resolve(EditImportantFactorViewController.self)
            case 5:
                next = DIContainer.shared.resolve(EditHorrorPositionViewController.self)
            case 6:
                next = DIContainer.shared.resolve(EditHintViewController.self)
            case 7:
                next = DIContainer.shared.resolve(EditDeviceAndLockViewController.self)
            case 8:
                next = DIContainer.shared.resolve(EditActivityViewController.self)
            case 9:
                next = DIContainer.shared.resolve(EditDislikeViewController.self)
            case 10:
                next = DIContainer.shared.resolve(EditColorViewController.self)
            default:
                print("default")
            }
            next.modalPresentationStyle = .fullScreen
            self.present(next, animated: false)
        }
    }
}
