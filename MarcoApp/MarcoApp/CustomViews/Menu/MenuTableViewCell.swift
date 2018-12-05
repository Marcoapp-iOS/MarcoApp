//
//  MenuTableViewCell.swift
//  MarcoApp
//
//  Created by Nabeel Hayat on 31/10/2017.
//  Copyright © 2017 GrayScaleLogic. All rights reserved.
//

import UIKit

class MenuTableViewCell: UITableViewCell {
    
    @IBOutlet weak var menuTitleLabel: UILabel!
    
    @IBOutlet weak var menuIconImageView: UIImageView!
    @IBOutlet weak var menuBadgeLabel: BadgeLabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
