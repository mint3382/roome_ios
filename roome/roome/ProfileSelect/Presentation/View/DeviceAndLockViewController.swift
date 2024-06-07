//
//  DeviceAndLockViewController.swift
//  roome
//
//  Created by minsong kim on 5/23/24.
//

import UIKit
import Combine

class DeviceAndLockViewController: UIViewController {
    private let titleLabel = TitleLabel(text: "장치와 자물쇠 중\n어떤 것을 더 선호하시나요?")
    lazy var profileCount = ProfileStateLineView(pageNumber: 8, frame: CGRect(x: 20, y: 60, width: view.frame.width * 0.9 - 10, height: view.frame.height))
    private let backButton = BackButton()
    private lazy var flowLayout = self.createFlowLayout()
    private lazy var collectionView = UICollectionView(frame: .zero, collectionViewLayout: self.flowLayout)
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
        let back = backButton.publisher(for: .touchUpInside).eraseToAnyPublisher()
        
        let output = viewModel.transform(DeviceAndLockViewModel.Input(tapBackButton: back))
        
        output.handleCellSelect
            .throttle(for: 1, scheduler: RunLoop.main, latest: false)
            .sink(receiveCompletion: { error in
                //실패 시
            }, receiveValue: { [weak self] _ in
                let nextViewController = DIContainer.shared.resolve(ActivityViewController.self)
                
                self?.navigationController?.pushViewController(nextViewController, animated: true)
            }).store(in: &cancellables)
        
        output.handleBackButton
            .throttle(for: 1, scheduler: RunLoop.main, latest: false)
            .sink { [weak self] _ in
                self?.navigationController?.popViewController(animated: true)
            }.store(in: &cancellables)
        
        output.tapNext
            .sink {}
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
            collectionView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -50)
        ])
        
    }
    
    func configureStackView() {
        view.addSubview(profileCount)
        view.addSubview(backButton)
        view.addSubview(titleLabel)
        
        NSLayoutConstraint.activate([
            backButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 10),
            backButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 32),
            
            titleLabel.topAnchor.constraint(equalTo: backButton.bottomAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor)
        ])
    }
    
    func createFlowLayout() -> UICollectionViewFlowLayout {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 10
        layout.minimumInteritemSpacing = 10
        layout.itemSize = CGSize(width: view.frame.width * 0.9, height: 50)
        layout.sectionInset = UIEdgeInsets(top: 10, left: 24, bottom: 50, right: 24)
        
        return layout
    }

}

extension DeviceAndLockViewController: UICollectionViewDataSource, UICollectionViewDelegate  {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        DeviceLockDTO.allCases.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as? ButtonCell
        else {
            return UICollectionViewCell()
        }
        cell.changeTitle(DeviceLockDTO(rawValue: indexPath.row + 1)!.title)
//        cell.addDescription(DeviceLockDTO(rawValue: indexPath.row + 1)!.description)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        viewModel.selectCell.send(indexPath)
    }
}


