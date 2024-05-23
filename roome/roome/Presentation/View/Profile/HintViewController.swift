//
//  HintViewController.swift
//  roome
//
//  Created by minsong kim on 5/23/24.
//

import UIKit

class HintViewController: UIViewController {
    private let titleLabel = TitleLabel(text: "힌트 사용에 대해,\n어떻게 생각하시나요?")
    lazy var profileCount = ProfileStateLineView(pageNumber: 7, frame: CGRect(x: 20, y: 60, width: view.frame.width * 0.9 - 10, height: view.frame.height))
    private let backButton = BackButton()
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
        layout.itemSize = CGSize(width: view.frame.width * 0.9, height: 70)
        layout.sectionInset = UIEdgeInsets(top: 10, left: 24, bottom: 50, right: 24)
        
        return layout
    }

}

extension HintViewController: UICollectionViewDataSource, UICollectionViewDelegate  {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        ProfileModel.hintPrefer.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as? ButtonCell
        else {
            return UICollectionViewCell()
        }
        cell.changeTitle(ProfileModel.hintPrefer[indexPath.item].type)
        cell.addDescription(ProfileModel.hintPrefer[indexPath.item].description)
        
        return cell
    }
    
}

