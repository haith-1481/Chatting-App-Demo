//
//  Extensions.swift
//  ChattingAppDemo
//
//  Created by Sean on 24/08/2023.
//

import Foundation
import UIKit
import RxCocoa
import RxSwift

extension UITableView {
	func registerWithNib<T: UITableViewCell>(_: T.Type) {
		register(UINib(nibName: T.nibName, bundle: .main), forCellReuseIdentifier: T.identifier)
	}
	
	func dequeueReusableCell<T: UITableViewCell>(for indexPath: IndexPath) -> T {
		guard let cell = dequeueReusableCell(withIdentifier: T.identifier, for: indexPath) as? T else {
			fatalError("Could not dequeue reusable cell with identifier: \(T.identifier)")
		}
		return cell
	}
}

extension UITableViewCell {
	class var nibName: String {
		return String(describing: self)
	}
	
	class var identifier: String {
		return String(describing: self)
	}
	
	func addSelectedBackgroundColor(_ color: UIColor, alpha: CGFloat = 1.0) {
		selectedBackgroundView = UIView(frame: bounds)
		selectedBackgroundView?.backgroundColor = color.withAlphaComponent(alpha)
	}
}

extension UIImage {
	func compressedData(_ quality: JPEGQuality) -> Data? {
		return jpegData(compressionQuality: quality.rawValue)
	}
}

extension UITextField {
	func makeUnderline(_ color: UIColor = UIColor.init(hexString: "#787878")) {
		let bottomLineName = "bottomLine"
		if let sublayers = self.layer.sublayers {
			for layer in sublayers.filter({$0.name == bottomLineName}) {
				//                layer.removeFromSuperlayer()
				return
			}
		}
		let bottomLine = CALayer()
		bottomLine.name = bottomLineName
		bottomLine.frame = CGRect(x: 0.0, y: self.frame.height - 2, width: self.frame.width, height: 1.0)
		bottomLine.backgroundColor = color.cgColor
		self.borderStyle = UITextField.BorderStyle.none
		self.layer.addSublayer(bottomLine)
	}
}

public extension UIColor {
	convenience init(hexString: String) {
		let hex = hexString.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
		var int = UInt64()
		Scanner(string: hex).scanHexInt64(&int)
		let alphaColr: UInt64
		let redColr: UInt64
		let greenColr: UInt64
		let blueColr: UInt64
		
		switch hex.count {
		case 3: // RGB (12-bit)
			(alphaColr, redColr, greenColr, blueColr) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
		case 6: // RGB (24-bit)
			(alphaColr, redColr, greenColr, blueColr) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
		case 8: // ARGB (32-bit)
			(alphaColr, redColr, greenColr, blueColr) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
		default:
			(alphaColr, redColr, greenColr, blueColr) = (255, 0, 0, 0)
		}
		self.init(red: CGFloat(redColr) / 255, green: CGFloat(greenColr) / 255, blue: CGFloat(blueColr) / 255, alpha: CGFloat(alphaColr) / 255)
	}
}

extension SharedSequenceConvertibleType {
	func mapToVoid() -> SharedSequence<SharingStrategy, Void> {
		return map { _ in Void() }
	}
}

extension ObservableType {
	func asDriverOnErrorJustComplete() -> Driver<Element> {
		return asDriver { _ in
			return Driver.empty()
		}
	}
	
	func mapToVoid() -> Observable<Void> {
		return map { _ in Void() }
	}
}

extension UINavigationController {
	func popToSpecificVC(of aClass: AnyClass, animated: Bool = true) {
		for controller in viewControllers as Array {
			if controller.isKind(of: aClass.self) {
				popToViewController(controller, animated: animated)
				break
			}
		}
	}
}

extension Date {
	func toDateString() -> String {
		let formatter = DateFormatter()
		formatter.dateFormat = "dd/MM/yyyy"
		return formatter.string(from: self)
	}
	
	func toString() -> String {
		let dateFormatter = DateFormatter()
		dateFormatter.locale = UtilityObject.shared.is12HourFormat() ? Locale(identifier: "en_US_POSIX") : nil
		dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
		return dateFormatter.string(from: self)
	}
}

extension Double {
	func greaterThanOrEqual(_ value: Double?, precise: Int) -> Bool {
		guard let value = value else {
			return false
		}
		
		let denominator: Double = pow(10.0, Double(precise))
		let maxDiff: Double = 1 / denominator
		let realDiff: Double = self - value
		
		if fabs(realDiff) >= maxDiff, realDiff >= 0 {
			return true
		} else if fabs(realDiff) <= maxDiff {
			return true
		} else {
			return false
		}
	}
}

extension URL {
	/// Returns a new URL by adding the query items, or nil if the URL doesn't support it.
	/// URL must conform to RFC 3986.
	func appending(_ queryItems: [URLQueryItem]) -> URL? {
		guard var urlComponents = URLComponents(url: self, resolvingAgainstBaseURL: true) else {
			// URL is not conforming to RFC 3986 (maybe it is only conforming to RFC 1808, RFC 1738, and RFC 2732)
			return nil
		}
		// append the query items to the existing ones
		urlComponents.queryItems = (urlComponents.queryItems ?? []) + queryItems
		
		// return the url from new url components
		return urlComponents.url
	}
}
