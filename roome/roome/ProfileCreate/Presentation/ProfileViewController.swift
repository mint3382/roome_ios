//
//  ProfileViewController.swift
//  roome
//
//  Created by minsong kim on 6/3/24.
//

import UIKit

class ProfileViewController: UIViewController {
    private let backButton = BackButton()
    private let navigationLabel: UILabel = {
        let label = UILabel()
        label.text = "프로필 이미지"
        label.font = UIFont().pretendardBold(size: .title2)
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    lazy var profileView = ProfileView(frame: view.frame)
    private lazy var flowLayout = self.createFlowLayout()
    private lazy var collectionView = UICollectionView(frame: .zero, collectionViewLayout: self.flowLayout)
    private let saveButton = NextButton(title: "저장하기", backgroundColor: .roomeMain, tintColor: .white)
    private let pageButton = NextButton(title: "프로필 페이지로 이동", backgroundColor: .clear, tintColor: .lightGray)

    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(ButtonCell.self, forCellWithReuseIdentifier: "cell")
        configureUI()
    }
    
    func configureUI() {
        configureNavigation()
        configureProfileView()
        setUpCollectionView()
        configureNextButton()
    }
    
    func configureNavigation() {
        view.addSubview(backButton)
        view.addSubview(navigationLabel)
        
        NSLayoutConstraint.activate([
            backButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 10),
            backButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 0),
            
            navigationLabel.centerYAnchor.constraint(equalTo: backButton.centerYAnchor),
            navigationLabel.leadingAnchor.constraint(equalTo: backButton.trailingAnchor, constant: 8),
        ])
    }
    
    func configureProfileView() {
        view.addSubview(profileView)
        profileView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            profileView.topAnchor.constraint(equalTo: backButton.bottomAnchor, constant: 8),
            profileView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            profileView.widthAnchor.constraint(equalTo: view.widthAnchor),
            profileView.heightAnchor.constraint(equalTo: profileView.widthAnchor)
        ])
    }
    
    func setUpCollectionView() {
        collectionView.alwaysBounceVertical = true
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.allowsMultipleSelection = true
        view.addSubview(collectionView)
        
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: profileView.bottomAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
    }
    
    private func configureNextButton() {
        view.addSubview(saveButton)
        view.addSubview(pageButton)
        
        NSLayoutConstraint.activate([
            saveButton.bottomAnchor.constraint(equalTo: pageButton.topAnchor),
            saveButton.heightAnchor.constraint(equalToConstant: 50),
            saveButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            saveButton.widthAnchor.constraint(equalToConstant: view.frame.width * 0.9)
        ])
        
        NSLayoutConstraint.activate([
            pageButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16),
            pageButton.heightAnchor.constraint(equalToConstant: 50),
            pageButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            pageButton.widthAnchor.constraint(equalToConstant: view.frame.width * 0.9)
        ])
    }

    func createFlowLayout() -> UICollectionViewFlowLayout {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 10
        layout.minimumInteritemSpacing = 10
        layout.itemSize = CGSize(width: view.frame.width * 0.42, height: 50)
        layout.sectionInset = UIEdgeInsets(top: 10, left: 24, bottom: 50, right: 24)
        
        return layout
    }
}

extension ProfileViewController: UICollectionViewDataSource, UICollectionViewDelegate  {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        SizeDTO.allCases.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as? ButtonCell
        else {
            return UICollectionViewCell()
        }
        cell.changeTitle(SizeDTO(rawValue: indexPath.row)!.title)
        
        return cell
    }
    
//    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        viewModel.selectCell.send(indexPath)
//    }
//    
//    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
//        viewModel.deselectItem(indexPath)
//    }
}
