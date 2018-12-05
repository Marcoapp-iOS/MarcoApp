//
//  ChatListTableViewCell.swift
//  MarcoApp
//
//  Created by Nabeel Hayat on 06/12/2017.
//  Copyright © 2017 GrayScaleLogic. All rights reserved.
//

import UIKit

protocol ChatListTableViewCellDelegate {
    
}

class ChatListTableViewCell: UITableViewCell {

    @IBOutlet weak var userImageView: RoundedImageView!
    @IBOutlet weak var userOnlineImageView: RoundedImageView!
    
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var userDetailLabel: UILabel!
    @IBOutlet weak var timeStampLabel: UILabel!
    @IBOutlet weak var messageStateImageView: UIImageView!
    
    var delegate: ChatListTableViewCellDelegate!
    var indexPath: IndexPath!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        self.userImageView.isBorder = false
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    // MARK: - Helper Functions
    
    func configureCellForRecents() {
    
        self.userOnlineImageView.isHidden = false
        self.messageStateImageView.isHidden = false
    }
    
    func configureCellForUsers() {
        
        self.userOnlineImageView.isHidden = true
        self.messageStateImageView.isHidden = true
    }
    
}
