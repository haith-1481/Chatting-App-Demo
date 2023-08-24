//
//  Tabbar.swift
//  ChattingAppDemo
//
//  Created by Sean on 24/08/2023.
//

import Foundation
import UIKit

class DashboardTabBarController: UITabBarController, UITabBarControllerDelegate {
	override func viewDidLoad() {
		super.viewDidLoad()
		delegate = self
		view.backgroundColor = Assets.grayCED4DA.color
		
	}
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		let home = HomeViewController()
		let homeIcon = UITabBarItem(title: "", image: Assets.icChatWhiteSmall.withRenderingMode(.alwaysOriginal), selectedImage: Assets.icChatBlackSmall.withRenderingMode(.alwaysOriginal))
		home.tabBarItem = homeIcon
		let profile = ProfileViewController()
		let profileIcon = UITabBarItem(title: "", image: Assets.icUserWhiteSmall.withRenderingMode(.alwaysOriginal), selectedImage: Assets.icUserBlackSmal.withRenderingMode(.alwaysOriginal))
		
		profile.tabBarItem = profileIcon
		let controllers = [home, profile]  //array of the root view controllers displayed by the tab bar interface
		self.viewControllers = controllers

	}
	
	//Delegate methods
	func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
		print("Should select viewController: \(viewController.title ?? "") ?")
		return true;
	}
}
