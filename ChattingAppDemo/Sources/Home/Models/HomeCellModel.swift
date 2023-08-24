//
//  HomeCellModel.swift
//  ChattingAppDemo
//
//  Created by Sean on 24/08/2023.
//

import Foundation
import MessageKit

struct HomeCellModel: SenderType {
	let username: String
	let id: String
	let avatarUrl: String
	let lastMessage: String
	let date: String
	
	var senderId: String {
		id
	}
	
	var displayName: String {
		username
	}
}
