//
//  HomeViewModel.swift
//  ChattingAppDemo
//
//  Created by Sean on 24/08/2023.
//

import Foundation
import RxSwift
import RxCocoa

class HomeViewModel: ViewModelType {
	struct Input {
		let loadTrigger: Driver<Void>
		let itemSelected: Driver<IndexPath>
	}
	
	struct Output {
		let tableViewModels: Driver<[HomeCellModel]>
		let modelSelected: Driver<HomeCellModel>
	}
	
	
	
	func binding(input: Input) -> Output {
		let models = input.loadTrigger.map { [unowned self] in
			Constants.shared.mockData
		}
		
		let modelSelected = input.itemSelected.map { indexPath in
			Constants.shared.mockData[indexPath.row]
		}
		
		return Output(tableViewModels: models, 
					  modelSelected: modelSelected)
	}
}
