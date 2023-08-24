//
//  MessageModel.swift
//  ChattingAppDemo
//
//  Created by Sean on 24/08/2023.
//

import Foundation
import MessageKit

struct MessageModel: MessageType {
	
	var sender: MessageKit.SenderType
	var messageId: String
	var sentDate: Date
	var kind: MessageKit.MessageKind
}
