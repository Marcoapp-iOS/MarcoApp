//
//  FeedsCollectionViewCell.swift
//  MarcoApp
//
//  Created by Nabeel Hayat on 10/11/2017.
//  Copyright © 2017 GrayScaleLogic. All rights reserved.
//

import UIKit

class FeedsCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var topContainerView: UIView!
    @IBOutlet weak var imageContainerView: UIView!
    @IBOutlet weak var textContainerView: UIView!
    @IBOutlet weak var bottomView: UIView!
    
    @IBOutlet weak var likeContainerView: UIView!
    @IBOutlet weak var commentContainerView: UIView!
    @IBOutlet weak var shareContainerView: UIView!
    
    @IBOutlet weak var likeImageView: UIImageView!
    @IBOutlet weak var likeTitleLabel: UILabel!
    @IBOutlet weak var commentImageView: UIImageView!
    @IBOutlet weak var commentTitleLabel: UILabel!
    @IBOutlet weak var shareImageView: UIImageView!
    @IBOutlet weak var shareTitleLabel: UILabel!
    
    @IBOutlet weak var feedImageView: UIImageView!
    
    @IBOutlet weak var userAvatarImageView: RoundedImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var feedPostDetailLabel: UILabel!
    
    @IBOutlet weak var feedTimeLabel: UILabel!
    @IBOutlet weak var feedTitleLabel: UILabel!
    
    @IBOutlet weak var feedImageHeightConstaint: NSLayoutConstraint!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}
