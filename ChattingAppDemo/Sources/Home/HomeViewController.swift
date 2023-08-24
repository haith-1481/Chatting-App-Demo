//
//  HomeViewController.swift
//  ChattingAppDemo
//
//  Created by Sean on 24/08/2023.
//

import UIKit
import RxSwift
import RxCocoa

class HomeViewController: BaseViewController {

	@IBOutlet weak var tableView: UITableView!
	
	private let viewModel = HomeViewModel()
	private let disposeBag = DisposeBag()
	
	override func viewDidLoad() {
        super.viewDidLoad()
		navigationController?.navigationBar.isHidden = true
		setupTableView()
		bindViewModel()
    }
	
	private func setupTableView() {
		tableView.registerWithNib(HomeTableViewCell.self)
		tableView.delegate = self
	}
	
	private func bindViewModel() {
		let input = HomeViewModel.Input(loadTrigger: Driver.just(()), 
										itemSelected: tableView.rx.itemSelected.asDriver())
		let output = viewModel.binding(input: input)
		
		output.tableViewModels.drive(tableView.rx.items) { [weak self] tableView, index, element in
			let indexPath = IndexPath(item: index, section: 0)
			guard let cell = self?.getCell(indexPath: indexPath) as? HomeTableViewCell else {
				return UITableViewCell()
			}
			cell.configureCell(element)
			return cell
		}.disposed(by: disposeBag)
		
		output.modelSelected.drive(onNext: { [unowned self] model in
			let vc = ChatsViewController(model: model)
			navigationController?.pushViewController(vc, animated: true)
		}).disposed(by: disposeBag)
		
		tableView.rx.itemSelected.asDriver().drive(onNext: { [weak self] indexPath in
			self?.tableView.deselectRow(at: indexPath, animated: false)
		}).disposed(by: disposeBag)
	}
}

extension HomeViewController: UITableViewDelegate {
	private func getCell(indexPath: IndexPath) -> UITableViewCell {
		guard let cell: HomeTableViewCell = tableView
			.dequeueReusableCell(withIdentifier: HomeTableViewCell.identifier, for: indexPath) as? HomeTableViewCell else { return UITableViewCell() }
		return cell
	}
	
	func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
		return 80
	}
}
