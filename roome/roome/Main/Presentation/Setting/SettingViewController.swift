//
//  SettingViewController.swift
//  roome
//
//  Created by minsong kim on 6/4/24.
//

import UIKit
import Combine

class SettingViewController: UIViewController, UICollectionViewDelegate {
    private let window = (UIApplication.shared.connectedScenes.first as? UIWindowScene)?.windows.first
    private let titleLabel = TitleLabel(text: "설정")
    private var collectionView: UICollectionView!
    private var dataSource: UICollectionViewDiffableDataSource<SettingSection, SettingItem>?
    private lazy var withdrawalPopUp = PopUpView(frame: window!.bounds, title: "정말로 탈퇴하시겠어요?", description: "지금까지 작성된 모든 정보가 삭제되고,\n복구할 수 없어요",whiteButtonTitle: "취소", colorButtonTitle: "탈퇴")
    private lazy var logoutPopUp = PopUpView(frame: window!.bounds, title: "로그아웃", description: "정말 로그아웃하시겠어요?",whiteButtonTitle: "취소", colorButtonTitle: "로그아웃")
    private lazy var errorPopUp = PopUpView(frame: window!.bounds, title: "에러 발생", description: "다시 시도해주세요", colorButtonTitle: "확인")
    
    private var viewModel: SettingViewModel
    private var cancellables = Set<AnyCancellable>()
    
    init(viewModel: SettingViewModel) {
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
        bindOutput()
        registerCollectionView()
        configureCollectionView()
        setDataSource()
        setSnapShot()
        collectionView.delegate = self
    }
    
    private func bindOutput() {
        viewModel.output.handleTermsDetail
            .sink { [weak self] in
                let view = DIContainer.shared.resolve(SettingWebViewController.self)
                view.modalPresentationStyle = .fullScreen
                
                self?.present(view, animated: true)
            }
            .store(in: &cancellables)
        
        viewModel.output.handleWithdrawalButton
            .sink { [weak self] _ in
                guard let self else {
                    return
                }
                self.window?.addSubview(self.withdrawalPopUp)
            }
            .store(in: &cancellables)
        
        viewModel.output.handleLogoutButton
            .sink { [weak self] _ in
                guard let self else {
                    return
                }
                self.window?.addSubview(self.logoutPopUp)
            }
            .store(in: &cancellables)
        
        logoutPopUp.publisherWhiteButton()
            .sink { [weak self] _ in
                self?.logoutPopUp.removeFromSuperview()
            }
            .store(in: &cancellables)
        
        withdrawalPopUp.publisherWhiteButton()
            .sink { [weak self] _ in
                self?.withdrawalPopUp.removeFromSuperview()
            }
            .store(in: &cancellables)
        
        logoutPopUp.publisherColorButton()
            .sink { [weak self] _ in
                self?.viewModel.input.tappedLogout.send()
            }
            .store(in: &cancellables)
        
        withdrawalPopUp.publisherColorButton()
            .sink { [weak self] _ in
                self?.viewModel.input.tappedWithdrawal.send()
                self?.withdrawalPopUp.removeFromSuperview()
            }
            .store(in: &cancellables)
        
        viewModel.output.handleLogout
            .throttle(for: 1, scheduler: RunLoop.main, latest: false)
            .sink { [weak self] completion in
                switch completion {
                case .finished:
                    print("logout finish")
                case .failure(let error):
                    print("logout fail: \(error)")
                    DIContainer.shared.removeAll()
                    DIManager.shared.registerAll()
                    let next = DIContainer.shared.resolve(LoginViewController.self)
                    self?.window?.rootViewController?.dismiss(animated: false)
                    (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.changeRootViewController(next, animated: true)
                }
            } receiveValue: { [weak self] _ in
                print("logout Success✨")
                DIContainer.shared.removeAll()
                DIManager.shared.registerAll()
                let next = DIContainer.shared.resolve(LoginViewController.self)
                self?.window?.rootViewController?.dismiss(animated: false)
                (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.changeRootViewController(next, animated: true)
            }
            .store(in: &cancellables)
        
        viewModel.output.handleWithdrawal
            .throttle(for: 1, scheduler: RunLoop.main, latest: false)
            .sink { [weak self] completion in
                switch completion {
                case .finished:
                    print("withdrawal finish")
                case .failure(let error):
                    print("withdrawal fail: \(error)")
                    DIContainer.shared.removeAll()
                    DIManager.shared.registerAll()
                    let next = DIContainer.shared.resolve(LoginViewController.self)
                    self?.window?.rootViewController?.dismiss(animated: false)
                    (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.changeRootViewController(next, animated: true)
                }
            } receiveValue: { [weak self] _ in
                print("✨withdrawal Success")
                DIContainer.shared.removeAll()
                DIManager.shared.registerAll()
                let next = DIContainer.shared.resolve(LoginViewController.self)
                self?.window?.rootViewController?.dismiss(animated: false)
                (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.changeRootViewController(next, animated: true)
            }
            .store(in: &cancellables)
        
        viewModel.output.handleUpdate
            .sink { completion in
                switch completion {
                case .finished:
                    print("app update finished")
                case .failure(_):
                    self.window?.addSubview(self.errorPopUp)
                }
            } receiveValue: { _ in
                print("업데이트 성공!")
            }
            .store(in: &cancellables)

        errorPopUp.publisherColorButton()
            .sink { [weak self] in
                self?.errorPopUp.removeFromSuperview()
            }
            .store(in: &cancellables)
    }
    
    private func configureTitleLabel() {
        titleLabel.backgroundColor = .systemBackground
        view.addSubview(titleLabel)
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor)
        ])
    }
    
    private func configureCollectionView() {
        view.addSubview(collectionView)
        collectionView.backgroundColor = .collectionViewBackground
        collectionView?.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
    private func registerCollectionView() {
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: createLayout())
        collectionView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        collectionView.register(SettingCollectionViewCell.self, forCellWithReuseIdentifier: SettingCollectionViewCell.id)
        collectionView.register(FooterView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: FooterView.id)
    }
    
    private func createLayout() -> UICollectionViewLayout {
        UICollectionViewCompositionalLayout(sectionProvider: { [weak self] sectionIndex, _ in
            return self?.createSection()
        })
    }
    
    private func createSection() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(60))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(100))
        let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitems: [item])
        
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 16, trailing: 0)
        let sectionFooter = NSCollectionLayoutBoundarySupplementaryItem(
            layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                              heightDimension: .estimated(40)),
            elementKind: UICollectionView.elementKindSectionFooter,
            alignment: .bottom)
        section.boundarySupplementaryItems = [sectionFooter]
        
        return section
    }
    
    private func setDataSource() {
        dataSource = UICollectionViewDiffableDataSource<SettingSection, SettingItem>(collectionView: collectionView, cellProvider: { collectionView, indexPath, itemIdentifier in
            guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: SettingCollectionViewCell.id,
                for: indexPath) as? SettingCollectionViewCell else {
                return UICollectionViewCell()
            }
    
            cell.configureCell(viewModel: self.viewModel, title: itemIdentifier.title, state: itemIdentifier.self)
            
            return cell
        })
        
        let footerRegistration = UICollectionView.SupplementaryRegistration<FooterView>(elementKind: UICollectionView.elementKindSectionFooter) {
            supplementaryView, elementKind, indexPath in
            let section = SettingSection(rawValue: indexPath.section)
            if section == .signOut {
                guard let version = self.viewModel.version else {
                    return
                }
                supplementaryView.configureLabel(text: "앱 버전 \(version)")
            }
        }
        
        dataSource?.supplementaryViewProvider = { (view, kind, index) in
            self.collectionView.dequeueConfiguredReusableSupplementary(using: footerRegistration, for: index)
        }
    }
    
    private func setSnapShot() {
        var snapshot = NSDiffableDataSourceSnapshot<SettingSection, SettingItem>()
        let sections: [SettingSection] = [.terms, .version, .signOut]
        let termsItems: [SettingItem] = [.service, .personal]
        let versionItem: [SettingItem] = [.version]
        let signItems: [SettingItem] = [.logout, .withdrawal]
        snapshot.appendSections(sections)
        snapshot.appendItems(termsItems, toSection: .terms)
        snapshot.appendItems(versionItem, toSection: .version)
        snapshot.appendItems(signItems, toSection: .signOut)
        
        dataSource?.apply(snapshot)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath) as? SettingCollectionViewCell
        
        let section = SettingSection(rawValue: indexPath.section)
        
        if section == .version {
            if cell?.compareVersion() != true {
                viewModel.input.selectCell.send(cell?.state)
            }
        } else {
            viewModel.input.selectCell.send(cell?.state)
        }
    }
}

//#Preview {
//    let vc = SettingViewController(viewModel: SettingViewModel(loginUseCase: LoginUseCase(loginRepository: LoginRepository())))
//    
//    return vc
//}
