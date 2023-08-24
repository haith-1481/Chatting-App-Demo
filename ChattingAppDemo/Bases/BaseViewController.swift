//
//  BaseViewController.swift
//

import Foundation
import UIKit
import RxCocoa
import RxSwift
import ProgressHUD

open class BaseViewController: UIViewController {
    let loadDataTrigger = PublishSubject<Void>()
    private var isLoadData = false
    public init() {
        super.init(nibName: String(describing: type(of: self)), bundle: Bundle(for: type(of: self)))
    }

    @available(iOS, unavailable)
    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    open override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupLogoutNoti()
        loadData()
    }

    open override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }

    open override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }

    open func setupView() {
        // Override in subclass
    }

    open func loadData() {
        loadDataTrigger.onNext(())
    }
    
    func setupLogoutNoti() {
        
    }
    
    @objc func logout() {
        
    }

    public func showActivityIndicator() {
        ProgressHUD.show()
    }

    public func hideActivityIndicator() {
        ProgressHUD.dismiss()
    }

    @objc
    public func popToRoot() {
        navigationController?.popToRootViewController(animated: true)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }

    func showAlert(_ message: String, title: String = "", handler: ((UIAlertAction) -> Void)? = nil) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: handler))
        self.present(alert, animated: true, completion: nil)
    }
    
    func showConfirmAlert(_ title: String, message: String, completion: (() -> Void)?) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default) { _ in
            completion?()
        })
        self.present(alert, animated: true, completion: nil)
    }

    func getAPIError(error: Error) -> String {
        if let error = error as? APIErrorResponse, let errorMessage = error.errorMessage {
            return errorMessage
        } else {
            return error.localizedDescription
        }
    }
	
	func showToast(message : String, font: UIFont = UIFont.systemFont(ofSize: 16)) {

		let toastLabel = UILabel(frame: CGRect(x: 27, y: self.view.frame.size.height-200, width: (self.view.frame.width - 54), height: 35))
		toastLabel.numberOfLines = 0
		toastLabel.backgroundColor = UIColor.black.withAlphaComponent(0.6)
		toastLabel.textColor = UIColor.white
		toastLabel.font = font
		toastLabel.textAlignment = .center;
		toastLabel.text = message
		toastLabel.alpha = 1.0
		toastLabel.layer.cornerRadius = 10;
		toastLabel.clipsToBounds  =  true
		self.view.addSubview(toastLabel)
		UIView.animate(withDuration: 4.0, delay: 0.1, options: .curveEaseOut, animations: {
			 toastLabel.alpha = 0.0
		}, completion: {(isCompleted) in
			toastLabel.removeFromSuperview()
		})
	}
}
