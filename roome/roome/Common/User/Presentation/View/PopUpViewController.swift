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
        view.isUserInteractionEnabled = true
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    private let viewModel: WelcomeViewModel
    private var cancellables = Set<AnyCancellable>()
    
    init(viewModel: WelcomeViewModel) {
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
        bind()
    }
    
    func bind() {
        let new = popUpView.tappedNewButton()
        let still = popUpView.tappedStillButton()
        let output = viewModel.popUpTransforms(WelcomeViewModel.PopUpInput(newButton: new, stillButton: still))
        
        output.handleNext
            .sink { [weak self] _ in
                self?.dismiss(animated: true)
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
