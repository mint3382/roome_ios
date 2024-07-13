//
//  EditMBTIViewController.swift
//  roome
//
//  Created by minsong kim on 7/9/24.
//

import UIKit
import Combine

class EditMBTIViewController: UIViewController {
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
    private let titleLabel = TitleLabel(text: "MBTI를 알려주세요")
    private let nextButton = NextButton(title: "저장", backgroundColor: .roomeMain, tintColor: .white)
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
    
    func bind() {
        closeButton.publisher(for: .touchUpInside)
            .sink { [weak self] in
                self?.viewModel.input.tappedCloseButton.send()
            }
            .store(in: &cancellables)
        
        nextButton.publisher(for: .touchUpInside)
            .sink { [weak self] in
                self?.viewModel.input.tappedNextButton.send()
            }
            .store(in: &cancellables)
        
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
        
        viewModel.output.handleCloseButton
            .sink { [weak self] isEdit in
                if let self, isEdit {
                    self.window?.addSubview(changePopUp)
                } else {
                    self?.dismiss(animated: false)
                }
            }
            .store(in: &cancellables)
        
        viewModel.output.handleNextButton
            .throttle(for: 1, scheduler: RunLoop.main, latest: false)
            .sink { result in
                switch result {
                case .success:
                    self.dismiss(animated: false)
                case .failure(let error):
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
        configureTitle()
        setUpCollectionView()
        configureNotAddButton()
        configureNextButton()
    }
    
    func configureTitle() {
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

extension EditMBTIViewController: UICollectionViewDataSource, UICollectionViewDelegate  {
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
