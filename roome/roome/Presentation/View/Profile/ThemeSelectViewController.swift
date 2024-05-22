//
//  ThemeSelectViewController.swift
//  roome
//
//  Created by minsong kim on 5/23/24.
//

import UIKit

class ThemeSelectViewController: UIViewController {
    private lazy var stackView: UIStackView = {
        let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .vertical
        stack.alignment = .leading
        stack.distribution = .fillProportionally
        stack.spacing = 4
        
        return stack
    }()
    
    private let titleLabel = TitleLabel(text: "테마 선택 시,\n어떤 요소를 중요하게\n생각하시나요?")
    private let descriptionLabel = DescriptionLabel(text: "최대 2개까지 선택할 수 있어요")
    lazy var profileCount = ProfileStateLineView(pageNumber: 5, frame: CGRect(x: 20, y: 60, width: view.frame.width * 0.9 - 10, height: view.frame.height))
    private let backButton = BackButton()
    private let nextButton = NextButton()
    private lazy var flowLayout = self.createFlowLayout()
    private lazy var collectionView = UICollectionView(frame: .zero, collectionViewLayout: self.flowLayout)

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(ButtonCell.self, forCellWithReuseIdentifier: "cell")
        configureUI()
    }
    
    func configureUI() {
        configureStackView()
        setUpCollectionView()
        configureNextButton()
    }
    
    func setUpCollectionView() {
        collectionView.alwaysBounceVertical = true
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.allowsMultipleSelection = true
        view.addSubview(collectionView)
        
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: stackView.bottomAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -50)
        ])
        
    }
    
    
    func configureStackView() {
        view.addSubview(profileCount)
        view.addSubview(backButton)
        view.addSubview(stackView)
        stackView.addArrangedSubview(titleLabel)
        stackView.addArrangedSubview(descriptionLabel)
        
        NSLayoutConstraint.activate([
            backButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 10),
            backButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 32),
            
            stackView.topAnchor.constraint(equalTo: backButton.bottomAnchor),
            stackView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            stackView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.2)
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
        layout.itemSize = CGSize(width: view.frame.width * 0.9, height: 50)
        layout.sectionInset = UIEdgeInsets(top: 10, left: 24, bottom: 50, right: 24)
        
        return layout
    }

}

extension ThemeSelectViewController: UICollectionViewDataSource, UICollectionViewDelegate  {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        ProfileModel.themeSelect.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as? ButtonCell
        else {
            return UICollectionViewCell()
        }
        cell.changeTitle(ProfileModel.themeSelect[indexPath.item])
        
        return cell
    }
    
}

