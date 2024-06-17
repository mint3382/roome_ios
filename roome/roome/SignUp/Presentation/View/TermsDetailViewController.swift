//
//  TermsDetailViewController.swift
//  roome
//
//  Created by minsong kim on 6/17/24.
//

import UIKit
import WebKit

class TermsDetailViewController: UIViewController {
    private let titleLabel: UILabel = {
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
    
    let nextButton = NextButton(title: "동의", backgroundColor: .roomeMain, tintColor: .white)
    
    init(text: String) {
        titleLabel.text = text
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureTitleLabel()
        configureCloseButton()
        configureNextButton()
        configureWebView()
        loadWebView()
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
        view.addSubview(nextButton)
        
        NSLayoutConstraint.activate([
            nextButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            nextButton.heightAnchor.constraint(equalToConstant: 50),
            nextButton.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.9),
            nextButton.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }
    
    private func configureWebView() {
        view.addSubview(webView)
        
        NSLayoutConstraint.activate([
            webView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor),
            webView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            webView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            webView.bottomAnchor.constraint(equalTo: nextButton.topAnchor, constant: -8)
        ])
    }
    
    private func loadWebView() {
        //웹 링크 띄우기
        guard let url = URL(string: "https://www.notion.so/ROOME-ef60fcf881da4745b4858357fa48b6be") else {
            return
        }
        let request = URLRequest(url: url)
        
        webView.load(request)
        
        //html 띄우기
//        let myURL = Bundle.main.url(forResource: "index", withExtension: "html", subdirectory: "website")!
//        webView.loadFileURL(myURL, allowingReadAccessTo: myURL)
    }
}

#Preview {
    let vc = TermsDetailViewController(text: "개인 정보 처리 방침")
    
    return vc
}
