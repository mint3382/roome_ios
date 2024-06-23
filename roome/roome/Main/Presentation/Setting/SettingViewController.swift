//
//  SettingViewController.swift
//  roome
//
//  Created by minsong kim on 6/4/24.
//

import UIKit
import Combine

class SettingViewController: UIViewController {
    private let titleLabel = TitleLabel(text: "설정")
    private lazy var tableView = UITableView(frame: .zero, style: .grouped)
//    private let signOutButton = NextButton(title: "탈퇴하기", backgroundColor: .roomeMain, tintColor: .white)
    
    private var viewModel: SettingViewModel
    private var cancellables = Set<AnyCancellable>()
    
    init(viewModel: SettingViewModel) {
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
        setTableView()
        bindOutput()
    }
    
    private func bindOutput() {
        viewModel.output.handleTermsDetail
            .sink { [weak self] _ in
                let view = DIContainer.shared.resolve(SettingWebViewController.self)
                view.modalPresentationStyle = .fullScreen
                
//                self?.present(view, animated: true)
                self?.view.window?.rootViewController?.present(view, animated: true)
            }
            .store(in: &cancellables)
    }
    
    private func configureTitleLabel() {
        titleLabel.backgroundColor = .systemBackground
        view.addSubview(titleLabel)
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor)
        ])
    }
    
    private func setTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        tableView.register(SettingCell.self, forCellReuseIdentifier: "cell")
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.contentInset = UIEdgeInsets(top: -35, left: 0, bottom: 0, right: 0)
        tableView.sectionHeaderHeight = 0
        
        view.insertSubview(tableView, at: 3)
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
//    func bind() {
//        let signOut = signOutButton.publisher(for: .touchUpInside)
//            .eraseToAnyPublisher()
//        let output = viewModel.transform(SettingViewModel.Input(tapSignOutButton: signOut))
//        
//        output.next
//            .throttle(for: 1, scheduler: RunLoop.main, latest: false)
//            .sink { error in
//                print("탈퇴 실패!")
//                let next = DIContainer.shared.resolve(LoginViewController.self)
//                    (UIApplication.shared.connectedScenes.first as? UIWindowScene)?.windows.first?.rootViewController?.dismiss(animated: false)
//                    (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?
//                        .changeRootViewController(next, animated: true)
//            } receiveValue: { _ in
//                    DIContainer.shared.resolveAll()
//                    DIManager.shared.registerAll()
//                    let next = DIContainer.shared.resolve(LoginViewController.self)
//                    (UIApplication.shared.connectedScenes.first as? UIWindowScene)?.windows.first?.rootViewController?.dismiss(animated: false)
//                    (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?
//                        .changeRootViewController(next, animated: true)
//            }
//            .store(in: &cancellables)
//        
//        output.handleSignOut
//            .sink {}
//            .store(in: &cancellables)
//    }
    
    
//    private func configureSignOutButton() {
//        view.addSubview(signOutButton)
//        
//        NSLayoutConstraint.activate([
//            signOutButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
//            signOutButton.centerYAnchor.constraint(equalTo: view.centerYAnchor)
//        ])
//    }

}

extension SettingViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        3
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {
        if section == 2 {
            return SettingDTO.footer[0]
        }
        
        return nil
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return SettingDTO.Terms.allCases.count
        } else if section == 1 {
            return SettingDTO.Version.allCases.count
        } else {
            return SettingDTO.SignOut.allCases.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? SettingCell else {
            return UITableViewCell()
        }
        
        cell.setViewModel(viewModel: viewModel)
        
        if indexPath.section == 0 {
            cell.changeTitle(text: SettingDTO.Terms(rawValue: indexPath.row)?.title)
            cell.changeState(SettingDTO.Terms(rawValue: indexPath.row))
            cell.accessoryType = .disclosureIndicator
        } else if indexPath.section == 1 {
            cell.changeTitle(text: SettingDTO.Version(rawValue: indexPath.row)?.title)
            cell.changeState(SettingDTO.Version(rawValue: indexPath.row))
        } else {
            cell.changeTitle(text: SettingDTO.SignOut(rawValue: indexPath.row)?.title)
            cell.changeState(SettingDTO.SignOut(rawValue: indexPath.row))
            cell.accessoryType = .disclosureIndicator
        }
        
        return cell
    }
    
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? SettingCell else {
//            return
//        }
//        viewModel.input.selectCell.send(cell.state)
//    }
}

//#Preview {
//    let vc = SettingViewController(viewModel: SettingViewModel(loginUseCase: LoginUseCase(loginRepository: LoginRepository())))
//    
//    return vc
//}
