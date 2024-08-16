//
//  NoRecordListViewController.swift
//  roome
//
//  Created by minsong kim on 8/16/24.
//

import UIKit

class NoRecordListViewController: UIViewController {
    private let titleLabel = TitleLabel(text: "후기")
    private let imageView: UIImageView = {
        let view = UIImageView(image: UIImage(systemName: "exclamationmark.circle")?.changeImageColor(.disableTint))
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    private let guideLabel: UILabel = {
        let label = UILabel()
        label.text = """
                     아직 작성된 후기가 없어요.
                     다양한 나만의 기록을 남겨보세요!
                     """
        label.textAlignment = .center
        label.numberOfLines = 0
        label.font = .regularBody1
        label.translatesAutoresizingMaskIntoConstraints = false
        
        
        return label
    }()
    private let recordCreateButton = NextButton(title: "후기 작성하기", backgroundColor: .roomeMain, tintColor: .white)

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground

        configureUI()
    }
    
    private func configureUI() {
        configureTitleLabel()
        configureGuideLabel()
        configureImageView()
        configureRecordCreateButton()
    }
    
    private func configureTitleLabel() {
        view.addSubview(titleLabel)
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor)
        ])
    }
    
    private func configureImageView() {
        view.addSubview(imageView)
        
        NSLayoutConstraint.activate([
            imageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            imageView.bottomAnchor.constraint(equalTo: guideLabel.topAnchor, constant: -8),
            imageView.widthAnchor.constraint(equalToConstant: 48),
            imageView.heightAnchor.constraint(equalToConstant: 48)
        ])
    }
    
    private func configureGuideLabel() {
        view.addSubview(guideLabel)
        
        NSLayoutConstraint.activate([
            guideLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            guideLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
    
    private func configureRecordCreateButton() {
        view.addSubview(recordCreateButton)
        
        NSLayoutConstraint.activate([
            recordCreateButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            recordCreateButton.topAnchor.constraint(equalTo: guideLabel.bottomAnchor, constant: 24),
            recordCreateButton.widthAnchor.constraint(equalToConstant: 210),
            recordCreateButton.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
}

//#Preview {
//    let vc = MainRecordViewController()
//    
//    return vc
//}
