//
//  HintViewController.swift
//  roome
//
//  Created by minsong kim on 5/23/24.
//

import UIKit
import Combine
import FirebaseAnalytics

class HintViewController: UIViewController {
    private let titleLabel = TitleLabel(text: "힌트 사용에 대해,\n어떻게 생각하시나요?")
    lazy var profileCount = ProfileStateLineView(pageNumber: 7, frame: CGRect(x: 0, y: 0, width: view.frame.width * 0.9 - 10, height: view.frame.height))
    private let backButton = BackButton()
    private lazy var flowLayout = self.createFlowLayout()
    private lazy var collectionView = UICollectionView(frame: .zero, collectionViewLayout: self.flowLayout)
    var viewModel: HintViewModel
    var cancellables = Set<AnyCancellable>()
    
    init(viewModel: HintViewModel) {
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
        Analytics.logEvent(Tracking.Profile.hintView, parameters: nil)
    }
    
    func bind() {
        backButton.publisher(for: .touchUpInside)
            .throttle(for: 1, scheduler: RunLoop.main, latest: false)
            .sink { [weak self] _ in
                self?.navigationController?.popViewController(animated: false)
            }
            .store(in: &cancellables)
        
        viewModel.output.handleNextButton
            .throttle(for: 1, scheduler: RunLoop.main, latest: false)
            .sink { [weak self] result in
                switch result {
                case .success:
                    let nextViewController = DIContainer.shared.resolve(DeviceAndLockViewController.self)
                    self?.navigationController?.pushViewController(nextViewController, animated: false)
                case .failure(let error):
                    print(error)
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
            collectionView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 12),
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
    
    func createFlowLayout() -> UICollectionViewFlowLayout {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 10
        layout.itemSize = CGSize(width: view.frame.width - 48, height: 70)
        layout.sectionInset = UIEdgeInsets(top: 10, left: 24, bottom: 50, right: 24)
        
        return layout
    }

}

extension HintViewController: UICollectionViewDataSource, UICollectionViewDelegate  {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        UserContainer.shared.defaultProfile?.data.hintUsagePreferences.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as? ButtonCell
        else {
            return UICollectionViewCell()
        }
        guard let hint = UserContainer.shared.defaultProfile?.data.hintUsagePreferences[indexPath.row] else {
            return UICollectionViewCell()
        }
        
        if let userSelect = UserContainer.shared.profile?.data.hintUsagePreference?.id {
            if userSelect == hint.id {
                cell.isSelected = true
                collectionView.selectItem(at: indexPath, animated: false, scrollPosition: .init())
            }
        }
        
        cell.changeTitle(hint.title)
        cell.addDescription(hint.description)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let hint = UserContainer.shared.defaultProfile?.data.hintUsagePreferences[indexPath.row] else {
            return
        }
        viewModel.input.selectCell.send((false, hint.id))
    }
}
