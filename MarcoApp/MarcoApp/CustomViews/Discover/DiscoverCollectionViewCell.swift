//
//  DiscoverCollectionViewCell.swift
//  MarcoApp
//
//  Created by Nabeel Hayat on 31/10/2017.
//  Copyright © 2017 GrayScaleLogic. All rights reserved.
//

import UIKit

protocol DiscoverCollectionDelegate {
    
    func discoverCollectionViewCell(_ cell: DiscoverCollectionViewCell, didJoinGroupPressed sender: UIButton, at indexPath: IndexPath)
    func discoverCollectionViewCell(_ cell: DiscoverCollectionViewCell, didMoreOptionPressed sender: UIButton, at indexPath: IndexPath)
}

class DiscoverCollectionViewCell: UICollectionViewCell {

    var delegate: DiscoverCollectionDelegate!
    var indexPath: IndexPath!
    
    @IBOutlet weak var coverPhotoImageView: UIImageView!
    @IBOutlet weak var profileImageView: RoundedImageView!
    @IBOutlet weak var ContainerView: BaseView!
    
    @IBOutlet weak var groupName: UILabel!
    @IBOutlet weak var groupDetail: UILabel!
    @IBOutlet weak var moreOptionButton: UIButton!
    @IBOutlet weak var joinButton: UIButton!
    @IBOutlet weak var joinedLabel: UILabel!
    
    @IBOutlet weak var commentView: UIView!
    @IBOutlet weak var commentImageView: UIImageView!
    
    @IBOutlet weak var commentLabel: UILabel!
    
    @IBOutlet weak var membersView: UIView!
    @IBOutlet weak var membersImageView: UIImageView!
    @IBOutlet weak var membersLabel: UILabel!
    
    @IBOutlet weak var dimsView: UIView!
    @IBOutlet weak var dimsCoverView: UIView!
    @IBOutlet weak var profileProgressView: UICircularProgressRingView!
    @IBOutlet weak var coverProgressView: LinearProgressBar!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.profileProgressView.startAngle = 270.0
        self.profileProgressView.outerRingWidth = 0.0
        self.profileProgressView.maxValue = 100.0
        self.profileProgressView.innerRingColor = AppTheme.blueColor
        
        self.coverProgressView.trackPadding = 0.0
        self.coverProgressView.progressValue = 50.0
        self.coverProgressView.trackColor = UIColor(hexString: "#EFF0F2")
        self.coverProgressView.barColor = AppTheme.blueColor
        
    }

    @IBAction func didMoreOptionPressed(_ sender: UIButton) {
        
        if let delegate = self.delegate {
            
            delegate.discoverCollectionViewCell(self, didMoreOptionPressed: sender, at: self.indexPath)
        }
    }
    
    @IBAction func didJoinGroupPressed(_ sender: UIButton) {
    
        if let delegate = self.delegate {
            
            delegate.discoverCollectionViewCell(self, didJoinGroupPressed: sender, at: self.indexPath)
        }
    }
    
}
