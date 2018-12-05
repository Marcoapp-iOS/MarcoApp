//
//  MemberTableViewCell.swift
//  MarcoApp
//
//  Created by Nabeel Hayat on 02/11/2017.
//  Copyright © 2017 GrayScaleLogic. All rights reserved.
//

import UIKit

protocol MemberTableViewCellDelegate {
    
    func memberTableViewCell(_ cell: MemberTableViewCell, didMoreButtonPressed sender: UIButton, atIndexPath: IndexPath)
    
    func memberTableViewCell(_ cell: MemberTableViewCell, didChatButtonPressed sender: UIButton, atIndexPath: IndexPath)
}

class MemberTableViewCell: UITableViewCell {

    @IBOutlet weak var avatarImageView: RoundedImageView!
    @IBOutlet weak var onlineImageView: RoundedImageView!
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var detailLabel: UILabel!
    
    @IBOutlet weak var moreButton: UIButton!
    @IBOutlet weak var chatButton: UIButton!
    
    var delegate: MemberTableViewCellDelegate!
    var indexPath: IndexPath!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    
        self.avatarImageView.isBorder = false
        self.moreButton.setImage(UIImage.getImage(withName: "ic_dropdown", imageColor: AppTheme.grayColor), for: .normal)
        
        self.chatButton.setImage(UIImage.getImage(withName: "ic_nb_message", imageColor: AppTheme.grayColor), for: .normal)
        
        self.chatButton.isHidden = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
    @IBAction func didChatButtonPressed(_ sender: UIButton) {
        
        if let delegate = self.delegate {
            
            delegate.memberTableViewCell(self, didChatButtonPressed: sender, atIndexPath: self.indexPath)
        }
    }
    
    @IBAction func didMoreButtonPressed(_ sender: UIButton) {
        
        if let delegate = self.delegate {
            
            delegate.memberTableViewCell(self, didMoreButtonPressed: sender, atIndexPath: self.indexPath)
        }
    }
    
}
