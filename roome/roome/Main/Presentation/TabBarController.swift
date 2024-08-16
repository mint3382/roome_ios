//
//  TabBarController.swift
//  roome
//
//  Created by minsong kim on 6/19/24.
//

import UIKit

class TabBarController: UITabBarController {
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tabBar.tintColor = .roomeMain
        self.tabBar.unselectedItemTintColor = .disable
        UITabBar.appearance().backgroundColor = .systemBackground
        setUpViewController()
    }
    
    private func setUpViewController() {
        let myProfile = DIContainer.shared.resolve(MyProfileViewController.self)
        let record = DIContainer.shared.resolve(RecordViewController.self)
        let list = DIContainer.shared.resolve(RecordListViewController.self)
        let setting = DIContainer.shared.resolve(SettingViewController.self)
        
        myProfile.tabBarItem.image = UIImage(systemName: "person.fill")
        record.tabBarItem.image = UIImage(systemName: "plus.app")
        list.tabBarItem.image = UIImage(systemName: "list.bullet")
        setting.tabBarItem.image = UIImage(systemName: "gearshape.fill")
        
        viewControllers = [myProfile, record, list, setting]
    }
}
