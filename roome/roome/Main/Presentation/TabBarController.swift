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
        let setting = DIContainer.shared.resolve(SettingViewController.self)
        let attributes = [NSAttributedString.Key.font: UIFont.mediumCaption]
        
        myProfile.tabBarItem.image = UIImage(systemName: "person.fill")
        myProfile.tabBarItem.title = "프로필"
        myProfile.tabBarItem.setTitleTextAttributes(attributes, for: .normal)
        
        setting.tabBarItem.image = UIImage(systemName: "gearshape.fill")
        setting.tabBarItem.title = "설정"
        setting.tabBarItem.setTitleTextAttributes(attributes, for: .normal)
        
        viewControllers = [myProfile, setting]
    }
}
