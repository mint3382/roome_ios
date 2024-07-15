//
//  WithdrawalViewController.swift
//  roome
//
//  Created by minsong kim on 7/11/24.
//

import UIKit
import Combine
import FirebaseAnalytics

class WithdrawalViewController: UIViewController, UICollectionViewDelegate {
    private let backButton = BackButton()
    
    private let jumpButton: UIButton = {
        let button = UIButton()
        button.setTitle("넘어가기", for: .normal)
        button.titleLabel?.font = .boldTitle3
        button.setTitleColor(.label, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        
        return button
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "탈퇴하는 이유가 무엇인가요?"
        label.sizeToFit()
        label.textAlignment = .left
        label.font = .boldTitle2
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    private var collectionView: UICollectionView!
    private var dataSource: UICollectionViewDiffableDataSource<Int, WithdrawalItem>?
    private var cancellables = Set<AnyCancellable>()
    private var viewModel: WithdrawalViewModel
    
    init(viewModel: WithdrawalViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground

        configureNavigationBar()
        configureTitle()
        registerCollectionView()
        configureCollectionView()
        setDataSource()
        setSnapShot()
        collectionView.delegate = self
        bind()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        Analytics.logEvent(Tracking.Withdrawal.reasonView, parameters: nil)
    }
    
    private func bind() {
        backButton.publisher(for: .touchUpInside)
            .sink { [weak self] in
                self?.dismiss(animated: false)
            }
            .store(in: &cancellables)
        
        jumpButton.publisher(for: .touchUpInside)
            .sink { [weak self] in
                let next = DIContainer.shared.resolve(WithdrawalAgreeViewController.self)
                next.modalPresentationStyle = .fullScreen
                self?.present(next, animated: false)
            }
            .store(in: &cancellables)
        
        viewModel.output.handleReason
            .sink { [weak self] result in
                switch result {
                case .success:
                    let next = DIContainer.shared.resolve(WithdrawalAgreeViewController.self)
                    next.modalPresentationStyle = .fullScreen
                    self?.present(next, animated: false)
                case .failure(let error):
                    print(error)
                }
            }
            .store(in: &cancellables)
    }
    
    private func configureNavigationBar() {
        view.addSubview(backButton)
        view.addSubview(jumpButton)
        
        NSLayoutConstraint.activate([
            backButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 24),
            backButton.widthAnchor.constraint(equalToConstant: 24),
            backButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 12),
            
            jumpButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -24),
            jumpButton.centerYAnchor.constraint(equalTo: backButton.centerYAnchor)
        ])
    }
    
    private func configureTitle() {
        view.addSubview(titleLabel)
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: backButton.bottomAnchor, constant: 24),
            titleLabel.leadingAnchor.constraint(equalTo: backButton.leadingAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -12)
        ])
    }
    
    private func configureCollectionView() {
        view.addSubview(collectionView)
        collectionView.backgroundColor = .systemBackground
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
        collectionView.register(WithdrawalCollectionViewCell.self, forCellWithReuseIdentifier: WithdrawalCollectionViewCell.id)
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
        section.contentInsets = NSDirectionalEdgeInsets(top: 12, leading: 0, bottom: 16, trailing: 0)
        
        return section
    }
    
    private func setDataSource() {
        dataSource = UICollectionViewDiffableDataSource<Int, WithdrawalItem>(collectionView: collectionView, cellProvider: { collectionView, indexPath, itemIdentifier in
            guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: WithdrawalCollectionViewCell.id,
                for: indexPath) as? WithdrawalCollectionViewCell else {
                return UICollectionViewCell()
            }
    
            cell.configureCell(title: WithdrawalItem.allCases[indexPath.row].rawValue)
            
            return cell
        })
    }
    
    private func setSnapShot() {
        var snapshot = NSDiffableDataSourceSnapshot<Int, WithdrawalItem>()
        let withdrawalItems: [WithdrawalItem] = [.notEnoughFunction, .rarelyUseService, .tooManyError, .worriedPersonalInformation, .wantReSignIn, .etc]
        snapshot.appendSections([0])
        snapshot.appendItems(withdrawalItems, toSection: 0)
        
        dataSource?.apply(snapshot)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let withdrawalReason = WithdrawalItem.allCases[indexPath.row]
        
        switch withdrawalReason {
        case .etc:
            let next = DIContainer.shared.resolve(WithdrawalDetailViewController.self)
            next.modalPresentationStyle = .fullScreen
            self.present(next, animated: false)
        default:
            viewModel.input.tappedWithdrawalReasonCell.send(withdrawalReason)
        }
    }
}

enum WithdrawalItem: String, CaseIterable {
    case notEnoughFunction = "원하는 기능이 없어요"
    case rarelyUseService = "서비스를 자주 사용하지 않아요"
    case tooManyError = "서비스 오류가 많아요"
    case worriedPersonalInformation = "개인 정보 및 보안이 걱정돼요"
    case wantReSignIn = "탈퇴 후 재가입하고 싶어요"
    case etc = "기타"
}

//#Preview {
//    let vc = WithdrawalViewController()
//    
//    return vc
//}
