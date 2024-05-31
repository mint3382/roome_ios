//
//  PopUpViewController.swift
//  roome
//
//  Created by minsong kim on 5/31/24.
//

import UIKit
import Combine

class PopUpViewController: UIViewController {
    private let popUpView: PopUpView = {
        let view = PopUpView(frame: .zero)
        view.backgroundColor = .white
        view.layer.cornerRadius = 10
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    private let viewModel: PopUpViewModel
    private var cancellables = Set<AnyCancellable>()
    
    init(viewModel: PopUpViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = UIColor(white: 0, alpha: 0.6)
        self.view.isOpaque = false
        self.view.addSubview(popUpView)
        configurePopUpView()
    }
    
    func bind() {
        let new = popUpView.tappedNewButton()
        let still = popUpView.tappedStillButton()
        let output = viewModel.transforms(PopUpViewModel.Input(newButton: new, stillButton: still))
        
        output.handleNext
            .sink { [weak self] state in
                var nextPage: UIViewController
                switch state {
                case .roomCount:
                    nextPage = DIContainer.shared.resolve(RoomCountViewController.self)
                case .genres:
                    nextPage = DIContainer.shared.resolve(GenreViewController.self)
                case .mbti:
                    nextPage = DIContainer.shared.resolve(MBTIViewController.self)
                case .strengths:
                    nextPage = DIContainer.shared.resolve(StrengthViewController.self)
                case .themes:
                    nextPage = DIContainer.shared.resolve(ThemeSelectViewController.self)
                case .horrorPosition:
                    nextPage = DIContainer.shared.resolve(HorrorPositionViewController.self)
                case .hint:
                    nextPage = DIContainer.shared.resolve(HintViewController.self)
                case .device:
                    nextPage = DIContainer.shared.resolve(DeviceAndLockViewController.self)
                case .activity:
                    nextPage = DIContainer.shared.resolve(ActivityViewController.self)
                case .dislike:
                    nextPage = DIContainer.shared.resolve(DislikeViewController.self)
                case .color:
                    nextPage = DIContainer.shared.resolve(ColorSelectViewController.self)
                case .complete:
                    nextPage = DIContainer.shared.resolve(WaitingViewController.self)
                }
                self?.navigationController?.pushViewController(nextPage, animated: true)
            }.store(in: &cancellables)
    }
    
    func configurePopUpView() {
        NSLayoutConstraint.activate([
            popUpView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            popUpView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 24),
            popUpView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -24),
            popUpView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.24)
        ])
    }
}
