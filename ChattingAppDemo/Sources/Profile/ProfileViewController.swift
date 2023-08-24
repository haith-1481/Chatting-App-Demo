//
//  ProfileViewController.swift
//  ChattingAppDemo
//
//  Created by Sean on 24/08/2023.
//

import UIKit
import RxCocoa
import RxSwift

class ProfileViewController: UIViewController {
	
	@IBOutlet weak var logoutBtn: UIButton!
	
	private let disposeBag = DisposeBag()
	
    override func viewDidLoad() {
        super.viewDidLoad()

		logoutBtn.rx.tap.subscribe(onNext: { [unowned self] in
			navigationController?.popToSpecificVC(of: LoginViewController.self)
		}).disposed(by: disposeBag)
    }

}
