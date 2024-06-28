//
//  MBTIViewController.swift
//  roome
//
//  Created by minsong kim on 5/23/24.
//

import UIKit
import Combine

class MBTIViewController: UIViewController {
    private let titleLabel = TitleLabel(text: "MBTI를 알려주세요")
    lazy var profileCount = ProfileStateLineView(pageNumber: 3, frame: CGRect(x: 20, y: 60, width: view.frame.width * 0.9 - 10, height: view.frame.height))
    private let backButton = BackButton()
    private let nextButton = NextButton()
    private lazy var flowLayout = self.createFlowLayout()
    private lazy var collectionView = UICollectionView(frame: .zero, collectionViewLayout: self.flowLayout)
    
    private let willNotAddButton: UIButton = {
        var configuration = UIButton.Configuration.plain()
        configuration.baseForegroundColor = .label
        configuration.image = UIImage(systemName: "checkmark.circle.fill")?.changeImageColor(.gray).resize(newWidth: 24)
        configuration.imagePadding = 8
        configuration.contentInsets = NSDirectionalEdgeInsets(top: 15, leading: 24, bottom: 10, trailing: 20)
        configuration.title = "프로필에 추가하지 않을래요"
        
        let button = UIButton(configuration: configuration)
        button.titleLabel?.font = .regularBody2
        button.translatesAutoresizingMaskIntoConstraints = false
        button.contentHorizontalAlignment = .leading
        
        return button
    }()
    
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
    
    func bind() {
        let next = nextButton.publisher(for: .touchUpInside).eraseToAnyPublisher()
        let back = backButton.publisher(for: .touchUpInside).eraseToAnyPublisher()
        let notAdd = willNotAddButton.publisher(for: .touchUpInside).eraseToAnyPublisher()
        
        let output = viewModel.transform(MBTIViewModel.Input(tapNextButton: next, tapBackButton: back, tapWillNotAddButton: notAdd))
        
        output.handleCellSelect
            .sink { [weak self] (result, item) in
                if result == false {
                    self?.collectionView.deselectItem(at: item, animated: false)
                }
            }.store(in: &cancellables)
        
        output.canGoNext
            .sink { [weak self] result in
                if result {
                    self?.nextButton.isEnabled = true
                } else {
                    self?.nextButton.isEnabled = false
                }
            }.store(in: &cancellables)
        
        output.handleBackButton
            .throttle(for: 1, scheduler: RunLoop.main, latest: false)
            .sink { [weak self] _ in
                self?.navigationController?.popViewController(animated: false)
            }.store(in: &cancellables)
        
        output.handleNextButton
            .throttle(for: 1, scheduler: RunLoop.main, latest: false)
            .sink(receiveCompletion: { error in
                //연결 실패 시
            }, receiveValue: { [weak self] _ in
                let nextViewController = DIContainer.shared.resolve(StrengthViewController.self)
                
                self?.navigationController?.pushViewController(nextViewController, animated: false)
            })
            .store(in: &cancellables)
        
        output.handleWillNotAddButton
            .sink { [weak self] result in
                if result {
                    self?.willNotAddButton.configuration?.image = UIImage(systemName: "checkmark.circle.fill")?.changeImageColor(.roomeMain).resize(newWidth: 24)
                    _ = self?.collectionView.visibleCells.map { $0.isSelected = false }
                    _ = self?.collectionView.visibleCells
                        .compactMap { $0 as? ButtonCell }
                        .map { $0.isChecked = true }
                    self?.collectionView.reloadData()
                } else {
                    self?.willNotAddButton.configuration?.image = UIImage(systemName: "checkmark.circle.fill")?.changeImageColor(.gray).resize(newWidth: 24)
                    _ = self?.collectionView.visibleCells
                        .compactMap { $0 as? ButtonCell }
                        .map { $0.isChecked = false }
                }
            }.store(in: &cancellables)
        
        output.tapNext
            .sink {}
            .store(in: &cancellables)
    }
    
    func configureUI() {
        configureTitle()
        setUpCollectionView()
        configureNotAddButton()
        configureNextButton()
    }
    
    func configureTitle() {
        view.addSubview(profileCount)
        view.addSubview(backButton)
        view.addSubview(titleLabel)
        
        NSLayoutConstraint.activate([
            backButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 10),
            backButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 32),
            
            titleLabel.topAnchor.constraint(equalTo: backButton.bottomAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            titleLabel.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.1)
        ])
    }
    
    func setUpCollectionView() {
        collectionView.alwaysBounceVertical = true
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.allowsMultipleSelection = true
        view.addSubview(collectionView)
        
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            collectionView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.45)
        ])
        
    }
    
    private func configureNotAddButton() {
        view.addSubview(willNotAddButton)
        
        NSLayoutConstraint.activate([
            willNotAddButton.topAnchor.constraint(equalTo: collectionView.bottomAnchor),
            willNotAddButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            willNotAddButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
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
        layout.itemSize = CGSize(width: view.frame.width * 0.42, height: 80)
        layout.sectionInset = UIEdgeInsets(top: 10, left: 24, bottom: 50, right: 24)
        
        return layout
    }

}

extension MBTIViewController: UICollectionViewDataSource, UICollectionViewDelegate  {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        MBTIDTO.allCases.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as? ButtonCell
        else {
            return UICollectionViewCell()
        }
        cell.changeTitle(MBTIDTO(rawValue: indexPath.row)!.title)
        cell.addDescription(MBTIDTO(rawValue: indexPath.row)!.description)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        viewModel.selectCell.send(indexPath)
        _ = collectionView.visibleCells
            .compactMap { $0 as? ButtonCell }
            .map { $0.isChecked = false }
        self.willNotAddButton.configuration?.image = UIImage(systemName: "checkmark.circle.fill")?.changeImageColor(.gray).resize(newWidth: 24)
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        viewModel.deselectItem(indexPath)
    }
}

