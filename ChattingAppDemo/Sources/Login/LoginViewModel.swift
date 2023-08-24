//
//  LoginViewModel.swift
//  ChattingAppDemo
//
//  Created by Sean on 24/08/2023.
//

import Foundation
import RxCocoa
import RxSwift

class LoginViewModel: ViewModelType {
	struct Input {
		let loadTrigger: Driver<Void>
		let username: Driver<String>
		let password: Driver<String>
		let loginTrigger: Driver<Void>
	}
	
	struct Output {
//		let errorTrigger: Driver<Error>
		let isLoading: Driver<Bool>
		let toHomeTrigger: Driver<Void>
	}
	
	private let toHomeTrigger = PublishSubject<Void>()
	private let disposeBag = DisposeBag()
	
	func binding(input: Input) -> Output {
		
		let credentials = Driver.combineLatest([input.username,
												input.password]) { credentials -> (String, String) in
			return (credentials[0], credentials[1])
		}
		
		input.loginTrigger.withLatestFrom(credentials).map { [unowned self] userName, password in
			signIn(credentials: Credentials(userName: userName,
											password: password))
		}.mapToVoid().drive().disposed(by: disposeBag)
		
		return Output(
			isLoading: Driver.just(false), 
			toHomeTrigger: toHomeTrigger.asDriverOnErrorJustComplete())
	}
	
	private func signIn(credentials: Credentials) {
		toHomeTrigger.onNext(())
	}
}


