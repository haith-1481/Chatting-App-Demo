//
//  ChatsViewController.swift
//  ChattingAppDemo
//
//  Created by Sean on 24/08/2023.
//

import UIKit
import MessageKit

class ChatsViewController: BaseViewController {
	
	var model: HomeCellModel
	
	init(model: HomeCellModel) {
		self.model = model
		super.init()
	}

    override func viewDidLoad() {
        super.viewDidLoad()
		navigationController?.navigationBar.isHidden = false
		title = model.username
    }

}
