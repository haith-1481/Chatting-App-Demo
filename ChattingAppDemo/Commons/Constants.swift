//
//  Constants.swift
//  ChattingAppDemo
//
//  Created by Sean on 24/08/2023.
//

import Foundation
import MessageKit

struct Constants {
	public static let shared = Constants()
	let mockData: [HomeCellModel] = [
		.init(username: "User 1",
			  id: "1",
			  avatarUrl: "https://unsplash.com/photos/2pPw5Glro5I", 
			  lastMessage: "Last message", 
			  date: "Aug 24"),
		.init(username: "User 2", 
			  id: "2",
			  avatarUrl: "https://pixabay.com/photos/landscape-mountain-peak-summit-5585247/", 
			  lastMessage: "Last message, Last message", 
			  date: "Aug 24"),
		.init(username: "User 3",
			  id: "3",
			  avatarUrl: "https://pixabay.com/photos/landscape-mountain-peak-summit-5585247/", 
			  lastMessage: "Last message, Last message, Last message", 
			  date: "Aug 24"),
		.init(username: "User 4",
			  id: "4",
			  avatarUrl: "https://pixabay.com/photos/landscape-mountain-peak-summit-5585247/", 
			  lastMessage: "Last message, Last message, Last message, Last message", 
			  date: "Aug 24"),
		.init(username: "User 5",
			  id: "5",
			  avatarUrl: "https://pixabay.com/photos/landscape-mountain-peak-summit-5585247/", 
			  lastMessage: "Last message, Last message, Last message, Last message", 
			  date: "Aug 24"),
		.init(username: "User 6",
			  id: "6",
			  avatarUrl: "https://pixabay.com/photos/landscape-mountain-peak-summit-5585247/", 
			  lastMessage: "Last message, Last message, Last message, Last message", 
			  date: "Aug 24"),
		.init(username: "User 7",
			  id: "7",
			  avatarUrl: "https://pixabay.com/photos/landscape-mountain-peak-summit-5585247/", 
			  lastMessage: "Last message, Last message, Last message, Last message", 
			  date: "Aug 24"),
		.init(username: "User 8",
			  id: "8",
			  avatarUrl: "https://pixabay.com/photos/landscape-mountain-peak-summit-5585247/", 
			  lastMessage: "Last message", 
			  date: "Aug 24"),
		.init(username: "User 9",
			  id: "9",
			  avatarUrl: "https://pixabay.com/photos/landscape-mountain-peak-summit-5585247/", 
			  lastMessage: "I don't know", 
			  date: "Aug 24"),
		.init(username: "User 10",
			  id: "10",
			  avatarUrl: "https://pixabay.com/photos/landscape-mountain-peak-summit-5585247/", 
			  lastMessage: "I don't know", 
			  date: "Aug 24")
	]
	
	var mockMessagesData: [MessageModel] { [
		.init(sender: mockData[0], messageId: "0", sentDate: Date(), kind: .text("qwertyuiop")),
		.init(sender: mockData[1], messageId: "1", sentDate: Date(), kind: .text("asdfghjkl")),
		.init(sender: mockData[2], messageId: "2", sentDate: Date(), kind: .text("zxcvbnm,./")),
		.init(sender: mockData[3], messageId: "3", sentDate: Date(), kind: .text("1234567890")),
		.init(sender: mockData[4], messageId: "4", sentDate: Date(), kind: .text("poiuyrewq")),
		.init(sender: mockData[5], messageId: "5", sentDate: Date(), kind: .text("lkjhfdsa")),
		.init(sender: mockData[6], messageId: "6", sentDate: Date(), kind: .text("mnbcxz/.,")),
		.init(sender: mockData[7], messageId: "7", sentDate: Date(), kind: .text("qazwsxedc")),
		.init(sender: mockData[8], messageId: "8", sentDate: Date(), kind: .text("rfvtgbyhn")),
		.init(sender: mockData[9], messageId: "9", sentDate: Date(), kind: .text("mjuik,.lo"))
	] }
	
	var currentUser: HomeCellModel {
		HomeCellModel(username: "user No.0", id: "0", avatarUrl: "", lastMessage: "", date: "")
	}
}
