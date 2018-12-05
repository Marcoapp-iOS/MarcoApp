//
//  CampaignCollectionViewCell.swift
//  MarcoApp
//
//  Created by Nabeel Hayat on 05/09/2018.
//  Copyright © 2018 GrayScaleLogic. All rights reserved.
//

import UIKit

protocol CampaignCollectionViewCellDelegate {
    
    func campaignCollectionViewCell(_ Cell: CampaignCollectionViewCell, didContributePressed: UIButton, at indexPath: IndexPath)
}

class CampaignCollectionViewCell: UICollectionViewCell {

    
    var delegate: CampaignCollectionViewCellDelegate!
    var indexPath: IndexPath!
    
    @IBOutlet weak var userImageView: RoundedImageView!
    
    @IBOutlet weak var remainingAmountHConstraint: NSLayoutConstraint!
    @IBOutlet weak var remainingDaysHConstraint: NSLayoutConstraint!
    @IBOutlet weak var targetLeadingConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var collectedView: UIView!
    @IBOutlet weak var contributorView: UIView!
    @IBOutlet weak var targetView: UIView!
    
    @IBOutlet weak var contributedLabel: UILabel!
    
    @IBOutlet weak var remainingAmountView: UIView!
    @IBOutlet weak var remainingDaysView: UIView!
    @IBOutlet weak var remainingIconImageView: UIImageView!
    @IBOutlet weak var remainingDaysIconImageView: UIImageView!
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var percentageLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    @IBOutlet weak var remainingLabel: UILabel!
    @IBOutlet weak var amountRemainingLabel: UILabel!
    
    @IBOutlet weak var collectedAmountLabel: UILabel!
    @IBOutlet weak var targetAmountLabel: UILabel!
    @IBOutlet weak var contributorLabel: UILabel!
    
    @IBOutlet weak var contributeButton: UIButton!
    @IBOutlet weak var contributeImageView: UIImageView!
    
    @IBAction func didContributeButtonPressed(_ sender: UIButton) {
        
        if self.delegate != nil {
            
            self.delegate.campaignCollectionViewCell(self, didContributePressed: sender, at: self.indexPath)
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    

}
