//
//  ChatsViewController.swift
//  ChattingAppDemo
//
//  Created by Sean on 24/08/2023.
//

import UIKit
import MapKit
import MessageKit
import InputBarAccessoryView

class ChatsViewController: MessagesViewController {
	
	private var model: HomeCellModel
	private var messageList: [MessageModel] = Constants.shared.mockMessagesData
	private var currentSenderModel: HomeCellModel {
		Constants.shared.currentUser
	}
	lazy var audioController = BasicAudioController(messageCollectionView: messagesCollectionView)
	
	init(model: HomeCellModel) {
		self.model = model
		super.init(nibName: nil, bundle: nil)
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
    override func viewDidLoad() {
        super.viewDidLoad()
		navigationController?.navigationBar.isHidden = false
		title = model.username
		
		configureMessageCollectionView()
		configureMessageInputBar()
    }
	
	func configureMessageCollectionView() {
		messagesCollectionView.messagesDataSource = self
		messagesCollectionView.messageCellDelegate = self
		messagesCollectionView.messagesLayoutDelegate = self
		messagesCollectionView.messagesDisplayDelegate = self
		
		scrollsToLastItemOnKeyboardBeginsEditing = true
		maintainPositionOnKeyboardFrameChanged = true
		showMessageTimestampOnSwipeLeft = true
		
//		messagesCollectionView.refreshControl = refreshControl
	}
	
	func configureMessageInputBar() {
		messageInputBar.delegate = self
		messageInputBar.inputTextView.tintColor = .tintColor
		messageInputBar.sendButton.setTitleColor(.tintColor, for: .normal)
		messageInputBar.sendButton.setTitleColor(
			UIColor.tintColor.withAlphaComponent(0.3),
			for: .highlighted)
	}

	private let formatter: DateFormatter = {
		let formatter = DateFormatter()
		formatter.dateStyle = .medium
		return formatter
	}()
}

extension ChatsViewController: MessagesDataSource {
	func currentSender() -> MessageKit.SenderType {
		currentSenderModel
	}
	
	func messageForItem(at indexPath: IndexPath, in messagesCollectionView: MessageKit.MessagesCollectionView) -> MessageKit.MessageType {
		messageList[indexPath.section]
	}
	
	func numberOfSections(in messagesCollectionView: MessageKit.MessagesCollectionView) -> Int {
		messageList.count
	}
}

extension ChatsViewController: MessageCellDelegate {
	
	func cellTopLabelAttributedText(for message: MessageType, at indexPath: IndexPath) -> NSAttributedString? {
		if indexPath.section % 3 == 0 {
			return NSAttributedString(
				string: MessageKitDateFormatter.shared.string(from: message.sentDate),
				attributes: [
					NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 10),
					NSAttributedString.Key.foregroundColor: UIColor.darkGray,
				])
		}
		return nil
	}
	
//	func cellBottomLabelAttributedText(for _: MessageType, at _: IndexPath) -> NSAttributedString? {
//		NSAttributedString(
//			string: "Read",
//			attributes: [
//				NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 10),
//				NSAttributedString.Key.foregroundColor: UIColor.darkGray,
//			])
//	}
	
	func messageTopLabelAttributedText(for message: MessageType, at _: IndexPath) -> NSAttributedString? {
		let name = message.sender.displayName
		return NSAttributedString(
			string: name,
			attributes: [NSAttributedString.Key.font: UIFont.preferredFont(forTextStyle: .caption1)])
	}
	
	func messageBottomLabelAttributedText(for message: MessageType, at _: IndexPath) -> NSAttributedString? {
		let dateString = formatter.string(from: message.sentDate)
		return NSAttributedString(
			string: dateString,
			attributes: [NSAttributedString.Key.font: UIFont.preferredFont(forTextStyle: .caption2)])
	}
	
	func textCell(for _: MessageType, at _: IndexPath, in _: MessagesCollectionView) -> UICollectionViewCell? {
		nil
	}
	
	// MARK: Private
	
	// MARK: - Private properties
}

extension ChatsViewController: InputBarAccessoryViewDelegate {
		
		@objc
		func inputBar(_: InputBarAccessoryView, didPressSendButtonWith _: String) {
			processInputBar(messageInputBar)
		}
		
		func processInputBar(_ inputBar: InputBarAccessoryView) {
			// Here we can parse for which substrings were autocompleted
			let attributedText = inputBar.inputTextView.attributedText!
			let range = NSRange(location: 0, length: attributedText.length)
			attributedText.enumerateAttribute(.autocompleted, in: range, options: []) { _, range, _ in
				
				let substring = attributedText.attributedSubstring(from: range)
				let context = substring.attribute(.autocompletedContext, at: 0, effectiveRange: nil)
				print("Autocompleted: `", substring, "` with context: ", context ?? [])
			}
			
			let components = inputBar.inputTextView.components
			inputBar.inputTextView.text = String()
			inputBar.invalidatePlugins()
			// Send button activity animation
			inputBar.sendButton.startAnimating()
			inputBar.inputTextView.placeholder = "Sending..."
			// Resign first responder for iPad split view
			inputBar.inputTextView.resignFirstResponder()
			DispatchQueue.global(qos: .default).async {
				// fake send request task
				sleep(1)
				DispatchQueue.main.async { [weak self] in
					inputBar.sendButton.stopAnimating()
					inputBar.inputTextView.placeholder = "Aa"
					self?.insertMessages(components)
					self?.messagesCollectionView.scrollToLastItem(animated: true)
				}
			}
		}
				
		private func insertMessages(_ data: [Any]) {
			for component in data {
				let user = currentSenderModel
				if let str = component as? String {
					let message = MessageModel(sender: user, messageId: "\(Int.random(in: 0...100000))", sentDate: Date() , kind: .text(str))
					insertMessage(message)
				} else if let img = component as? UIImage {
					let message = MessageModel(sender: user, messageId: "\(Int.random(in: 0...100000))", sentDate: Date() , kind: .photo(ImageMediaItem(image: img)))
					insertMessage(message)
				}
			}
		}
	
	func insertMessage(_ message: MessageModel) {
		messageList.append(message)
		// Reload last section to update header/footer labels and insert a new one
		messagesCollectionView.performBatchUpdates({
			messagesCollectionView.insertSections([messageList.count - 1])
			if messageList.count >= 2 {
				messagesCollectionView.reloadSections([messageList.count - 2])
			}
		}, completion: { [weak self] _ in
			if self?.isLastSectionVisible() == true {
				self?.messagesCollectionView.scrollToLastItem(animated: true)
			}
		})
	}
	
	func isLastSectionVisible() -> Bool {
		guard !messageList.isEmpty else { return false }
		
		let lastIndexPath = IndexPath(item: 0, section: messageList.count - 1)
		
		return messagesCollectionView.indexPathsForVisibleItems.contains(lastIndexPath)
	}

}

// MARK: MessagesDisplayDelegate

extension ChatsViewController: MessagesDisplayDelegate {
	// MARK: - Text Messages
	
	func textColor(for message: MessageType, at _: IndexPath, in _: MessagesCollectionView) -> UIColor {
		isFromCurrentSender(message: message) ? .white : .darkText
	}
	
	func detectorAttributes(for detector: DetectorType, and _: MessageType, at _: IndexPath) -> [NSAttributedString.Key: Any] {
		switch detector {
		case .hashtag, .mention: return [.foregroundColor: UIColor.blue]
		default: return MessageLabel.defaultAttributes
		}
	}
	
	func enabledDetectors(for _: MessageType, at _: IndexPath, in _: MessagesCollectionView) -> [DetectorType] {
		[.url, .address, .phoneNumber, .date, .transitInformation, .mention, .hashtag]
	}
	
	// MARK: - All Messages
	
	func backgroundColor(for message: MessageType, at _: IndexPath, in _: MessagesCollectionView) -> UIColor {
		isFromCurrentSender(message: message) ? .tintColor : UIColor(red: 230 / 255, green: 230 / 255, blue: 230 / 255, alpha: 1)
	}
	
	func messageStyle(for message: MessageType, at _: IndexPath, in _: MessagesCollectionView) -> MessageStyle {
		let tail: MessageStyle.TailCorner = isFromCurrentSender(message: message) ? .bottomRight : .bottomLeft
		return .bubbleTail(tail, .curved)
	}
	
	func configureAvatarView(_ avatarView: AvatarView, for message: MessageType, at _: IndexPath, in _: MessagesCollectionView) {
		// TODO: --replace with real data
		let avatar = Avatar(image: Assets.icAvatarPlaceholder)
		avatarView.set(avatar: avatar)
	}
	
	func configureMediaMessageImageView(
		_ imageView: UIImageView,
		for message: MessageType,
		at _: IndexPath,
		in _: MessagesCollectionView)
	{
		if case MessageKind.photo(let media) = message.kind, let imageURL = media.url {
			imageView.sd_setImage(with: imageURL)
		} else {
			imageView.sd_cancelCurrentImageLoad()
		}
	}
	
	// MARK: - Location Messages
	
	func annotationViewForLocation(message _: MessageType, at _: IndexPath, in _: MessagesCollectionView) -> MKAnnotationView? {
		let annotationView = MKAnnotationView(annotation: nil, reuseIdentifier: nil)
		let pinImage = #imageLiteral(resourceName: "ic_map_marker")
		annotationView.image = pinImage
		annotationView.centerOffset = CGPoint(x: 0, y: -pinImage.size.height / 2)
		return annotationView
	}
	
	func animationBlockForLocation(
		message _: MessageType,
		at _: IndexPath,
		in _: MessagesCollectionView) -> ((UIImageView) -> Void)?
	{
		{ view in
			view.layer.transform = CATransform3DMakeScale(2, 2, 2)
			UIView.animate(
				withDuration: 0.6,
				delay: 0,
				usingSpringWithDamping: 0.9,
				initialSpringVelocity: 0,
				options: [],
				animations: {
					view.layer.transform = CATransform3DIdentity
				},
				completion: nil)
		}
	}
	
	func snapshotOptionsForLocation(
		message _: MessageType,
		at _: IndexPath,
		in _: MessagesCollectionView)
	-> LocationMessageSnapshotOptions
	{
		LocationMessageSnapshotOptions(
			showsBuildings: true,
			showsPointsOfInterest: true,
			span: MKCoordinateSpan(latitudeDelta: 10, longitudeDelta: 10))
	}
	
	// MARK: - Audio Messages
	
	func audioTintColor(for message: MessageType, at _: IndexPath, in _: MessagesCollectionView) -> UIColor {
		isFromCurrentSender(message: message) ? .white : UIColor(red: 15 / 255, green: 135 / 255, blue: 255 / 255, alpha: 1.0)
	}
	
	func configureAudioCell(_ cell: AudioMessageCell, message: MessageType) {
		audioController
			.configureAudioCell(
				cell,
				message: message) // this is needed especially when the cell is reconfigure while is playing sound
	}
}

// MARK: MessagesLayoutDelegate

extension ChatsViewController: MessagesLayoutDelegate {
	func cellTopLabelHeight(for _: MessageType, at _: IndexPath, in _: MessagesCollectionView) -> CGFloat {
		18
	}
	
	func cellBottomLabelHeight(for _: MessageType, at _: IndexPath, in _: MessagesCollectionView) -> CGFloat {
		17
	}
	
	func messageTopLabelHeight(for _: MessageType, at _: IndexPath, in _: MessagesCollectionView) -> CGFloat {
		20
	}
	
	func messageBottomLabelHeight(for _: MessageType, at _: IndexPath, in _: MessagesCollectionView) -> CGFloat {
		16
	}
}


struct ImageMediaItem: MediaItem {
	var url: URL?
	var image: UIImage?
	var placeholderImage: UIImage
	var size: CGSize
	
	init(image: UIImage) {
		self.image = image
		size = CGSize(width: 240, height: 240)
		placeholderImage = UIImage()
	}
	
	init(imageURL: URL) {
		url = imageURL
		size = CGSize(width: 240, height: 240)
		placeholderImage = Assets.icAvatarPlaceholder
	}
}
