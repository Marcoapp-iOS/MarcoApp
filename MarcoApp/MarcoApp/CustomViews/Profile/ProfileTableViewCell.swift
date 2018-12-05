//
//  ProfileTableViewCell.swift
//  MarcoApp
//
//  Created by Nabeel Hayat on 29/11/2017.
//  Copyright © 2017 GrayScaleLogic. All rights reserved.
//

import UIKit

class ProfileTableViewCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var titleTextView: UITextView!
    
    @IBOutlet weak var titleTextLabel: UILabel!
    
    @IBOutlet weak var separatorView: UIView!
    
    var indexPath: IndexPath!
    
    @IBOutlet weak var firstNameLabel: UILabel!
    @IBOutlet weak var firstNameTitleLabel: UILabel!
    @IBOutlet weak var firstNameTextField: UITextField!
    
    @IBOutlet weak var lastNameLabel: UILabel!
    @IBOutlet weak var lastNameTitleLabel: UILabel!
    @IBOutlet weak var lastNameTextField: UITextField!
    
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var emailTitleLabel: UILabel!
    @IBOutlet weak var emailTextField: UITextField!
    
    @IBOutlet weak var genderLabel: UILabel!
    @IBOutlet weak var genderTitleLabel: UILabel!
    @IBOutlet weak var genderTextField: UITextField!
    
    @IBOutlet weak var maritalStatusLabel: UILabel!
    @IBOutlet weak var maritalStatusTitleLabel: UILabel!
    @IBOutlet weak var maritalStatusTextField: UITextField!
    
    @IBOutlet weak var dobLabel: UILabel!
    @IBOutlet weak var dobTitleLabel: UILabel!
    @IBOutlet weak var dobTextField: UITextField!
    
    @IBOutlet weak var zodiacLabel: UILabel!
    @IBOutlet weak var zodiacTitleLabel: UILabel!
    @IBOutlet weak var zodiacTextField: UITextField!
    
    @IBOutlet weak var interestLabel: UILabel!
    @IBOutlet weak var interestTitleLabel: UILabel!
    @IBOutlet weak var interestTextField: UITextField!
    
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var locationTitleLabel: UILabel!
    @IBOutlet weak var locationTextField: UITextField!
    
    @IBOutlet weak var phoneLabel: UILabel!
    @IBOutlet weak var phoneTitleLabel: UILabel!
    @IBOutlet weak var phoneTextField: UITextField!
    
    @IBOutlet weak var aboutLabel: UILabel!
    @IBOutlet weak var aboutTitleLabel: UILabel!
    @IBOutlet weak var aboutTextView: UITextView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        self.selectionStyle = .none
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
