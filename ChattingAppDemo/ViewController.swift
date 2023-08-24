//
//  ViewController.swift
//  ChattingAppDemo
//
//  Created by Sean on 24/08/2023.
//

import UIKit

class ViewController: UIViewController {

	override func viewDidLoad() {
		super.viewDidLoad()
		// Do any additional setup after loading the view.
		let vc = LoginViewController()
		let nav = UINavigationController(rootViewController: vc)
		UIApplication.shared.windows.first?.rootViewController = nav
		UIApplication.shared.windows.first?.makeKeyAndVisible()
	}


}

