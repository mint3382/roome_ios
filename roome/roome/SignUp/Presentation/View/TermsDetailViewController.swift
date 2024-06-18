//
//  TermsDetailViewController.swift
//  roome
//
//  Created by minsong kim on 6/17/24.
//

import UIKit
import WebKit
import Combine

class TermsDetailViewController: UIViewController {
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = .boldTitle3
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    private let closeButton: UIButton = {
        var configuration = UIButton.Configuration.plain()
        configuration.image = UIImage(systemName: "xmark")?.changeImageColor(.label).resize(newWidth: 16)
        
        let button = UIButton(configuration: configuration)
        button.translatesAutoresizingMaskIntoConstraints = false
        
        return button
    }()
    
    private let webView: WKWebView = {
        let configuration = WKWebViewConfiguration()
        let view = WKWebView(frame: .zero, configuration: configuration)
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    let agreeButton = NextButton(title: "동의", backgroundColor: .roomeMain, tintColor: .white)
    let viewModel: TermsAgreeViewModel
    var cancellable = Set<AnyCancellable>()
    
    init(viewModel: TermsAgreeViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        configureTitleLabel()
        configureCloseButton()
        configureNextButton()
        configureWebView()
        bind()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        titleLabel.text = viewModel.detailState?.title
        loadWebView()
    }
    
    func bind() {
        closeButton.publisher(for: .touchUpInside).eraseToAnyPublisher()
            .sink { [weak self] _ in
                self?.dismiss(animated: true)
            }
            .store(in: &cancellable)
        
        agreeButton.publisher(for: .touchUpInside)
            .eraseToAnyPublisher()
            .sink { [weak self] _ in
                self?.viewModel.handleDetail.send()
                self?.dismiss(animated: true)
            }
            .store(in: &cancellable)
    }
    
    func agreeButtonPublisher() -> AnyPublisher<Void, Never> {
        agreeButton.publisher(for: .touchUpInside).eraseToAnyPublisher()
    }
    
    private func configureTitleLabel() {
        view.addSubview(titleLabel)
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 24),
            titleLabel.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -24),
            titleLabel.heightAnchor.constraint(equalToConstant: 60)
        ])
    }
    
    private func configureCloseButton() {
        view.addSubview(closeButton)
        
        NSLayoutConstraint.activate([
            closeButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -24),
            closeButton.widthAnchor.constraint(equalToConstant: 24),
            closeButton.heightAnchor.constraint(equalToConstant: 24),
            closeButton.centerYAnchor.constraint(equalTo: titleLabel.centerYAnchor)
        ])
    }
    
    private func configureNextButton() {
        view.addSubview(agreeButton)
        
        NSLayoutConstraint.activate([
            agreeButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            agreeButton.heightAnchor.constraint(equalToConstant: 50),
            agreeButton.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.9),
            agreeButton.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }
    
    private func configureWebView() {
        view.addSubview(webView)
        
        NSLayoutConstraint.activate([
            webView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor),
            webView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            webView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            webView.bottomAnchor.constraint(equalTo: agreeButton.topAnchor, constant: -8)
        ])
    }
    
    private func loadWebView() {
        //웹 링크 띄우기
        guard let link = viewModel.detailState?.link,
              let url = URL(string: link) else {
            return
        }
        let request = URLRequest(url: url)
        
        webView.load(request)
    }
}

//#Preview {
//    let vc = TermsDetailViewController(terms: .service)
//    
//    return vc
//}
