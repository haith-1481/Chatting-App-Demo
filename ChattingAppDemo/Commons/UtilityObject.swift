//
//  UtilityObject.swift
//  ChattingAppDemo
//
//  Created by Sean on 24/08/2023.
//

import Foundation

class UtilityObject {
	public static let shared = UtilityObject()
	
	func is12HourFormat() -> Bool {
		let locale = Locale.current
		
		let dateFormat = DateFormatter.dateFormat(fromTemplate: "j", options: 0, locale: locale)
		
		return dateFormat?.range(of: "a") != nil
	}
}
