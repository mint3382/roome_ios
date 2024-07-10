//
//  EditHintViewController.swift
//  roome
//
//  Created by minsong kim on 7/10/24.
//

import UIKit
import Combine

class EditHintViewController: UIViewController {
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
    private let titleLabel = TitleLabel(text: "힌트 사용에 대해,\n어떻게 생각하시나요?")
    private lazy var flowLayout = self.createFlowLayout()
    private lazy var collectionView = UICollectionView(frame: .zero, collectionViewLayout: self.flowLayout)
    private var nextButton = NextButton(title: "저장", backgroundColor: .roomeMain, tintColor: .white)
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
            collectionView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 12),
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
    
    func createFlowLayout() -> UICollectionViewFlowLayout {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 10
        layout.itemSize = CGSize(width: view.frame.width - 48, height: 70)
        layout.sectionInset = UIEdgeInsets(top: 10, left: 24, bottom: 50, right: 24)
        
        return layout
    }
}

extension EditHintViewController: UICollectionViewDataSource, UICollectionViewDelegate  {
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
                viewModel.input.selectCell.send((true, userSelect))
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
        viewModel.input.selectCell.send((true, hint.id))
    }
}
