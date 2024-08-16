//
//  ColorSelectViewController.swift
//  roome
//
//  Created by minsong kim on 5/24/24.
//

import UIKit
import Combine
import FirebaseAnalytics

class ColorSelectViewController: UIViewController{
    private let titleLabel = TitleLabel(text: "프로필 배경으로 쓰일\n색상을 골라주세요")
    lazy var profileCount = ProfileStateLineView(pageNumber: 11, frame: CGRect(x: 0, y: 0, width: view.frame.width * 0.9 - 10, height: view.frame.height))
    private let backButton = BackButton()
    private lazy var flowLayout = self.createFlowLayout()
    private lazy var collectionView = UICollectionView(frame: .zero, collectionViewLayout: self.flowLayout)
    var viewModel: ColorSelectViewModel
    var cancellables = Set<AnyCancellable>()
    
    init(viewModel: ColorSelectViewModel) {
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
        collectionView.register(ColorPaletteCell.self, forCellWithReuseIdentifier: "cell")
        configureUI()
        bind()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        Analytics.logEvent(Tracking.Profile.colorView, parameters: nil)
    }
    
    func bind() {
        backButton.publisher(for: .touchUpInside)
            .debounce(for: 0.3, scheduler: RunLoop.main)
            .sink { [weak self] _ in
                self?.navigationController?.popViewController(animated: false)
            }
            .store(in: &cancellables)
        
        viewModel.output.handleNextButton
            .debounce(for: 0.3, scheduler: RunLoop.main)
            .sink { [weak self] result in
                switch result {
                case .success(_):
                    let nextViewController = ProfileCardViewController(viewModel: ProfileCardViewModel())
                    
                    self?.navigationController?.pushViewController(nextViewController, animated: false)
                    self?.collectionView.allowsSelection = true
                case .failure(let error):
                    print(error)
                    self?.collectionView.allowsSelection = true
                    //TODO: error Toast 띄우기
                }
            }
            .store(in: &cancellables)
        
        viewModel.output.handleLoading
            .debounce(for: 0.3, scheduler: RunLoop.main)
            .sink { isEdit in
                if isEdit == false {
                    let loadingView = DIContainer.shared.resolve(LoadingView.self)
                    let window = (UIApplication.shared.connectedScenes.first as? UIWindowScene)?.windows.first
                    
                    window?.addSubview(loadingView)
                }
            }
            .store(in: &cancellables)
    }
    
    func configureUI() {
        configureStackView()
        setUpCollectionView()
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
    
    func setUpCollectionView() {
        collectionView.alwaysBounceVertical = true
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(collectionView)
        
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 10),
            collectionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -50)
        ])
    }

    func createFlowLayout() -> UICollectionViewFlowLayout {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 20
        layout.minimumInteritemSpacing = 20
        layout.itemSize = CGSize(width: (view.frame.width - 88) / 3 , height: (view.frame.width - 88) / 3)
        layout.sectionInset = UIEdgeInsets(top: 10, left: 24, bottom: 50, right: 24)
        
        return layout
    }
}

extension ColorSelectViewController: UICollectionViewDataSource, UICollectionViewDelegate  {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        UserContainer.shared.defaultProfile?.data.colors.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as? ColorPaletteCell
        else {
            return UICollectionViewCell()
        }
        guard let colorDTO = UserContainer.shared.defaultProfile?.data.colors[indexPath.row] else {
            return UICollectionViewCell()
        }
        let color = BackgroundColor(
            mode: Mode(rawValue: colorDTO.mode) ?? .gradient,
            shape: Shape(rawValue: colorDTO.shape) ?? .linear,
            direction: Direction(rawValue: colorDTO.direction) ?? .tlBR,
            startColor: colorDTO.startColor,
            endColor: colorDTO.endColor)
        
        cell.changeColor(color)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let colorDTO = UserContainer.shared.defaultProfile?.data.colors[indexPath.row] else {
            return
        }
        collectionView.allowsSelection = false
        viewModel.input.selectCell.send((false,colorDTO.id))
    }
}
