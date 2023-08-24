//
//  Credential.swift
//  ChattingAppDemo
//
//  Created by Sean on 24/08/2023.
//

import Foundation

class Credentials: NSObject, NSCoding, NSSecureCoding {
	static var supportsSecureCoding: Bool = true
	
	let userName: String
	let password: String
	
	init(userName: String, password: String) {
		self.userName = userName
		self.password = password
	}
	
	required convenience init(coder aDecoder: NSCoder) {
		let userName = aDecoder.decodeObject(forKey: "userName") as! String
		let password = aDecoder.decodeObject(forKey: "password") as! String
		self.init(userName: userName, password: password)
	}
	
	func encode(with aCoder: NSCoder) {
		aCoder.encode(userName, forKey: "userName")
		aCoder.encode(password, forKey: "password")
	}
}
