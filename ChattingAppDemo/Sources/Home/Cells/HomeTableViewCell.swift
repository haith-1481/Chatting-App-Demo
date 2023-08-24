//
//  HomeTableViewCell.swift
//  ChattingAppDemo
//
//  Created by Sean on 24/08/2023.
//

import UIKit
import SDWebImage

class HomeTableViewCell: UITableViewCell {

	@IBOutlet weak var avatarImageView: UIImageView!
	@IBOutlet weak var usernameLabel: UILabel!
	@IBOutlet weak var lastMessageLabel: UILabel!
	@IBOutlet weak var dateLabel: UILabel!
	
	override func awakeFromNib() {
        super.awakeFromNib()
    }

	func configureCell(_ model: HomeCellModel) {
		avatarImageView.layer.cornerRadius = avatarImageView.frame.width/2
		
		avatarImageView.sd_setImage(with: URL(string: model.avatarUrl), placeholderImage: Assets.icAvatarPlaceholder)
		usernameLabel.text = model.username
		lastMessageLabel.text = model.lastMessage
		dateLabel.text = "* " + model.date
	}
    
}
