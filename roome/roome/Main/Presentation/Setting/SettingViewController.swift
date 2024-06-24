//
//  SettingViewController.swift
//  roome
//
//  Created by minsong kim on 6/4/24.
//

import UIKit
import Combine

class SettingViewController: UIViewController {
    private let window = (UIApplication.shared.connectedScenes.first as? UIWindowScene)?.windows.first
    private let titleLabel = TitleLabel(text: "설정")
    private lazy var tableView = UITableView(frame: .zero, style: .grouped)
    private lazy var withdrawalPopUp = PopUpView(frame: window!.bounds, title: "정말로 탈퇴하시겠어요?", description: "지금까지 작성된 모든 정보가 삭제되고,\n복구할 수 없어요",whiteButtonTitle: "취소", colorButtonTitle: "탈퇴")
    private lazy var logoutPopUp = PopUpView(frame: window!.bounds, title: "로그아웃", description: "정말 로그아웃하시겠어요?",whiteButtonTitle: "취소", colorButtonTitle: "로그아웃")
    
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
                
                self?.present(view, animated: true)
            }
            .store(in: &cancellables)
        
        viewModel.output.handleWithdrawalButton
            .sink { [weak self] _ in
                guard let self else {
                    return
                }
                self.window?.addSubview(self.withdrawalPopUp)
            }
            .store(in: &cancellables)
        
        viewModel.output.handleLogoutButton
            .sink { [weak self] _ in
                guard let self else {
                    return
                }
                self.window?.addSubview(self.logoutPopUp)
            }
            .store(in: &cancellables)
        
        logoutPopUp.publisherWhiteButton()
            .sink { [weak self] _ in
                self?.logoutPopUp.removeFromSuperview()
            }
            .store(in: &cancellables)
        
        withdrawalPopUp.publisherWhiteButton()
            .sink { [weak self] _ in
                self?.withdrawalPopUp.removeFromSuperview()
            }
            .store(in: &cancellables)
        
        logoutPopUp.publisherColorButton()
            .sink { [weak self] _ in
                self?.viewModel.input.tappedLogout.send()
            }
            .store(in: &cancellables)
        
        withdrawalPopUp.publisherColorButton()
            .sink { [weak self] _ in
                self?.viewModel.input.tappedWithdrawal.send()
                self?.withdrawalPopUp.removeFromSuperview()
            }
            .store(in: &cancellables)
        
        viewModel.output.handleLogout
            .throttle(for: 1, scheduler: RunLoop.main, latest: false)
            .sink { [weak self] completion in
                switch completion {
                case .finished:
                    print("logout finish")
                case .failure(let error):
                    print("logout fail: \(error)")
                    DIContainer.shared.removeAll()
                    DIManager.shared.registerAll()
                    let next = DIContainer.shared.resolve(LoginViewController.self)
                    self?.window?.rootViewController?.dismiss(animated: false)
                    (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.changeRootViewController(next, animated: true)
                }
            } receiveValue: { [weak self] _ in
                print("logout Success✨")
                DIContainer.shared.removeAll()
                DIManager.shared.registerAll()
                let next = DIContainer.shared.resolve(LoginViewController.self)
                self?.window?.rootViewController?.dismiss(animated: false)
                (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.changeRootViewController(next, animated: true)
            }
            .store(in: &cancellables)
        
        viewModel.output.handleWithdrawal
            .throttle(for: 1, scheduler: RunLoop.main, latest: false)
            .sink { [weak self] completion in
                switch completion {
                case .finished:
                    print("withdrawal finish")
                case .failure(let error):
                    print("withdrawal fail: \(error)")
                    DIContainer.shared.removeAll()
                    DIManager.shared.registerAll()
                    let next = DIContainer.shared.resolve(LoginViewController.self)
                    self?.window?.rootViewController?.dismiss(animated: false)
                    (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.changeRootViewController(next, animated: true)
                }
            } receiveValue: { [weak self] _ in
                print("✨withdrawal Success")
                DIContainer.shared.removeAll()
                DIManager.shared.registerAll()
                let next = DIContainer.shared.resolve(LoginViewController.self)
                self?.window?.rootViewController?.dismiss(animated: false)
                (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.changeRootViewController(next, animated: true)
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
}

extension SettingViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
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
}

//#Preview {
//    let vc = SettingViewController(viewModel: SettingViewModel(loginUseCase: LoginUseCase(loginRepository: LoginRepository())))
//    
//    return vc
//}
