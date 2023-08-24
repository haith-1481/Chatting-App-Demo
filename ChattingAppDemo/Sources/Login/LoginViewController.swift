//
//  LoginViewController.swift
//  ChattingAppDemo
//
//  Created by Sean on 24/08/2023.
//

import UIKit
import RxCocoa
import RxSwift

class LoginViewController: BaseViewController {
	@IBOutlet weak var usernameContainerView: UIView!
	@IBOutlet weak var passwordContainerView: UIView!
	
	@IBOutlet weak var usernameTF: UITextField!
	@IBOutlet weak var passwordTF: UITextField!
	
	@IBOutlet weak var clearUsernameView: UIView!
	@IBOutlet weak var showHidePasswordView: UIView!
	
	@IBOutlet weak var clearUsernameBtn: UIButton!
	@IBOutlet weak var showHidePasswordBtn: UIButton!
	
	@IBOutlet weak var eyeImageView: UIImageView!
	
	@IBOutlet weak var loginBtn: UIButton!
	
	private let viewModel = LoginViewModel()
	private let disposeBag = DisposeBag()
	
	override func viewDidLoad() {
		super.viewDidLoad()
		setupUI()
		setupAction()
		bindViewmodel()
	}
	
	private func setupUI() {
		passwordTF.isSecureTextEntry = true
		let cornerRadius = 8.0
		
		usernameContainerView.layer.cornerRadius = cornerRadius
		passwordContainerView.layer.cornerRadius = cornerRadius
		loginBtn.layer.cornerRadius = cornerRadius
	}

	private func setupAction() {
		clearUsernameBtn.rx.tap.subscribe(onNext: { [unowned self] in
			usernameTF.text = ""
		}).disposed(by: disposeBag)
		
		showHidePasswordBtn.rx.tap.subscribe(onNext: { [unowned self] in
			passwordTF.isSecureTextEntry.toggle()
			
			let secureImage = passwordTF.isSecureTextEntry 
			? Assets.icEyeClose.withTintColor(Assets.gray828282.color, renderingMode: .alwaysTemplate) 
			: Assets.icEyeOpen.withTintColor(Assets.gray828282.color, renderingMode: .alwaysTemplate)
			eyeImageView.image = secureImage
		}).disposed(by: disposeBag)
		
		usernameTF.rx.text.orEmpty.asDriver().drive(onNext: { [unowned self] text in
			clearUsernameView.isHidden = text == ""
		}).disposed(by: disposeBag)
		
		passwordTF.rx.text.orEmpty.asDriver().drive(onNext: { [unowned self] text in
			showHidePasswordView.isHidden = text == ""
		}).disposed(by: disposeBag)
		
		Driver.combineLatest([usernameTF.rx.text.asDriver(), passwordTF.rx.text.asDriver()]).drive(onNext: { [unowned self] credentials in
			let cre = Credentials(userName: credentials[0] ?? "", password: credentials[1] ?? "")
			updateLoginBtnState(cre)
		}).disposed(by: disposeBag)
	}
	
	private func updateLoginBtnState(_ input: Credentials) {
		let disable = input.userName == "" || input.password == ""
		loginBtn.isEnabled = !disable
		loginBtn.backgroundColor = disable ? Assets.blue212B71.color.withAlphaComponent(0.5) : Assets.blue212B71.color
	}
}

// MARK: --Binding
extension LoginViewController {
	private func bindViewmodel() {
		let output = viewModel.binding(input: LoginViewModel.Input(
			loadTrigger: Driver.just(()), 
			username: usernameTF.rx.text.orEmpty.asDriver().distinctUntilChanged(), 
			password: passwordTF.rx.text.orEmpty.asDriver().distinctUntilChanged(), 
			loginTrigger: loginBtn.rx.tap.asDriverOnErrorJustComplete())
		)
		
		output.toHomeTrigger.drive(onNext: { [unowned self] in
			toHome()
		}).disposed(by: disposeBag)
	}
}

// MARK: --Navigations
extension LoginViewController {
	private func toHome() {
//		let vc = HomeViewController()
		let vc = DashboardTabBarController()
		navigationController?.pushViewController(vc, animated: true)
	}
}
