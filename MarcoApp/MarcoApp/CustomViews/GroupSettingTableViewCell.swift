//
//  GroupSettingTableViewCell.swift
//  MarcoApp
//
//  Created by Nabeel Hayat on 25/11/2017.
//  Copyright © 2017 GrayScaleLogic. All rights reserved.
//

import UIKit

protocol GroupSettingTableViewCellDelegate {
    
    func didValueChanged(_ sender: UISwitch, at indexPath: IndexPath)
}

class GroupSettingTableViewCell: UITableViewCell {
    
    
    @IBOutlet weak var settingImageView: UIImageView!
    @IBOutlet weak var settingTitle: UILabel!
    @IBOutlet weak var settingSwitch: UISwitch!
    
    var indexPath: IndexPath!
    var delegate: GroupSettingTableViewCellDelegate!
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    @IBAction func didSwitchValueChanged(_ sender: UISwitch) {
        
        if self.delegate != nil {
            
            self.delegate.didValueChanged(sender, at: self.indexPath)
        }
    }
}
