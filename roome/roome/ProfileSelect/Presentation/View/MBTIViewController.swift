//
//  MBTIViewController.swift
//  roome
//
//  Created by minsong kim on 5/23/24.
//

import UIKit
import Combine
import FirebaseAnalytics

class MBTIViewController: UIViewController {
    private let titleLabel = TitleLabel(text: "MBTI를 알려주세요")
    lazy var profileCount = ProfileStateLineView(pageNumber: 3, frame: CGRect(x: 0, y: 0, width: view.frame.width * 0.9 - 10, height: view.frame.height))
    private let backButton = BackButton()
    private let nextButton = NextButton()
    private lazy var flowLayout = self.createFlowLayout()
    private lazy var collectionView = UICollectionView(frame: .zero, collectionViewLayout: self.flowLayout)
    
    private let willNotAddButton = AgreeButton(title: "프로필에 추가하지 않을래요")
    
    var viewModel: MBTIViewModel
    var cancellables = Set<AnyCancellable>()
    
    init(viewModel: MBTIViewModel) {
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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if UserContainer.shared.profile?.data.mbti == "NONE" {
            viewModel.input.tappedNotAddButton.send()
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        Analytics.logEvent(Tracking.Profile.mbtiView, parameters: nil)
    }
    
    func bind() {
        nextButton.publisher(for: .touchUpInside)
            .map {
                Analytics.logEvent(Tracking.Profile.mbtiNextButton, parameters: nil)
            }
            .sink { [weak self] in
                self?.nextButton.loadingButton()
                self?.viewModel.input.tappedNextButton.send()
            }
            .store(in: &cancellables)
        
        backButton.publisher(for: .touchUpInside)
            .debounce(for: 0.3, scheduler: RunLoop.main)
            .sink { [weak self] _ in
                self?.navigationController?.popViewController(animated: false)
            }.store(in: &cancellables)
        
        willNotAddButton.publisher(for: .touchUpInside)
            .sink { [weak self] in
                self?.viewModel.input.tappedNotAddButton.send()
            }
            .store(in: &cancellables)
        
        viewModel.output.deselectCell
            .sink { [weak self] indexPath in
                self?.collectionView.deselectItem(at: indexPath, animated: false)
            }
            .store(in: &cancellables)
        
        viewModel.output.canGoNext
            .sink { [weak self] isEnable in
                self?.nextButton.isEnabled = isEnable
            }
            .store(in: &cancellables)
        
        viewModel.output.handleNextButton
            .debounce(for: 0.3, scheduler: RunLoop.main)
            .sink { [weak self] result in
                switch result {
                case .success:
                    let nextViewController = DIContainer.shared.resolve(StrengthViewController.self)
                    
                    self?.navigationController?.pushViewController(nextViewController, animated: false)
                    self?.nextButton.stopLoading()
                case .failure(let error):
                    self?.nextButton.stopLoading()
                    print(error)
                }
            }
            .store(in: &cancellables)
        
        viewModel.output.handleNotAddButton
            .sink { [weak self] willNotAdd in
                self?.willNotAddButton.isSelected = willNotAdd
                if willNotAdd {
                    _ = self?.collectionView.visibleCells.map { $0.isSelected = false }
                    self?.collectionView.reloadData()
                } else {
                    _ = self?.collectionView.visibleCells
                        .compactMap { $0 as? ButtonCell }
                        .map { $0.isChecked = false }
                }
            }
            .store(in: &cancellables)
    }
    
    func configureUI() {
        configureTitle()
        setUpCollectionView()
        configureNotAddButton()
        configureNextButton()
    }
    
    func configureTitle() {
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
    
    func setUpCollectionView() {
        collectionView.alwaysBounceVertical = true
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.allowsMultipleSelection = true
        view.addSubview(collectionView)
        
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 12),
            collectionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            collectionView.heightAnchor.constraint(equalToConstant: 360)
        ])
        
    }
    
    private func configureNotAddButton() {
        view.addSubview(willNotAddButton)
        
        NSLayoutConstraint.activate([
            willNotAddButton.topAnchor.constraint(equalTo: collectionView.bottomAnchor, constant: 12),
            willNotAddButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 24),
            willNotAddButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -24),
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
    
    func createFlowLayout() -> UICollectionViewFlowLayout {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 10
        layout.minimumInteritemSpacing = 10
        layout.itemSize = CGSize(width: (view.frame.width / 2) - 29, height: 80)
        layout.sectionInset = UIEdgeInsets(top: 5, left: 24, bottom: 5, right: 24)
        
        return layout
    }
}

extension MBTIViewController: UICollectionViewDataSource, UICollectionViewDelegate  {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        4
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        2
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as? ButtonCell
        else {
            return UICollectionViewCell()
        }
        
        if let userSelect = UserContainer.shared.profile?.data.mbti.map({String($0)}), viewModel.withoutButtonState == false {
            if userSelect[0] == MBTIDTO.EI(rawValue: indexPath.row)?.title ||
                userSelect[1] == MBTIDTO.NS(rawValue: indexPath.row)?.title ||
                userSelect[2] == MBTIDTO.TF(rawValue: indexPath.row)?.title ||
                userSelect[3] == MBTIDTO.JP(rawValue: indexPath.row)?.title {
                cell.isSelected = true
                collectionView.selectItem(at: indexPath, animated: false, scrollPosition: .init())
                viewModel.input.cellSelect.send(indexPath)
            }
        }
        
        if viewModel.withoutButtonState == true {
            cell.isChecked = true
        }
        
        switch indexPath.section {
        case 0:
            cell.changeTitle(MBTIDTO.EI(rawValue: indexPath.row)?.title)
            cell.addDescription(MBTIDTO.EI(rawValue: indexPath.row)?.description)
        case 1:
            cell.changeTitle(MBTIDTO.NS(rawValue: indexPath.row)?.title)
            cell.addDescription(MBTIDTO.NS(rawValue: indexPath.row)?.description)
        case 2:
            cell.changeTitle(MBTIDTO.TF(rawValue: indexPath.row)?.title)
            cell.addDescription(MBTIDTO.TF(rawValue: indexPath.row)?.description)
        default:
            cell.changeTitle(MBTIDTO.JP(rawValue: indexPath.row)?.title)
            cell.addDescription(MBTIDTO.JP(rawValue: indexPath.row)?.description)
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        viewModel.input.cellSelect.send(indexPath)
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        viewModel.deselectItem(indexPath)
    }
}
