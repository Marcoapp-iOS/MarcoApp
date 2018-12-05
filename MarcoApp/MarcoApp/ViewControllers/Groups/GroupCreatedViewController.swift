//
//  GroupCreatedViewController.swift
//  MarcoApp
//
//  Created by Nabeel Hayat on 10/11/2017.
//  Copyright © 2017 GrayScaleLogic. All rights reserved.
//

import UIKit
import SDWebImage

class GroupCreatedViewController: BaseViewController {

    @IBOutlet weak var greetLabel: UILabel!
    
    
    @IBOutlet weak var coverImageView: UIImageView!
    @IBOutlet weak var avatarImageView: RoundedImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var privacyLabel: UILabel!
    
    @IBOutlet weak var goGroupButton: UIButton!
    @IBOutlet weak var inviteMemberButton: UIButton!
    
    
    var createdGroup: GroupObject! = nil
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.showBackButtonItem = false
        self.hideNavigationMenuButtonItem = true
        
        // Do any additional setup after loading the view.
        
        self.setupViews()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        self.navigationItem.setHidesBackButton(true, animated:true);
    }
    
    override func didBackButtonPressed(_ sender: UIBarButtonItem) {
        super.didBackButtonPressed(sender)
        
    }
    
    override func didMenuButtonPressed(_ sender: UIBarButtonItem) {
        super.didMenuButtonPressed(sender)
        
    }
    
    // MARK: - Helper Functions
    
    func setupViews() {
     
        let attributedGreetText: NSMutableAttributedString = NSMutableAttributedString(string: "Thank You")
        
        self.greetLabel.attributedText = attributedGreetText.setFont(font: AppTheme.regularFont(withSize: 36), kerningValue: -40.0)
        
        if self.createdGroup != nil {
            
            self.nameLabel.text = self.createdGroup.groupTitle
            
            var privacyString = ""
            
            if self.createdGroup.isPrivateGroup {
                
                privacyString = "Private Group - 1 Member"
            }
            else {
                
                privacyString = "Public Group - 1 Member"
            }
            
            self.privacyLabel.text = privacyString
            
            if self.createdGroup.groupProfilePicture != nil && self.createdGroup.groupProfilePicture != "" {
                
                let url = URL(string: self.createdGroup.groupProfilePicture)
                
                self.avatarImageView.sd_setImage(with: url, placeholderImage: UIImage.getImage(withName: "group-default", imageColor: UIColor(hexString: "#cccccc"))) { (image, error, imageCacheType, url) in
                    
                }
            }
            else {
                
                self.avatarImageView.image = UIImage.getImage(withName: "group-default", imageColor: UIColor(hexString: "#cccccc"))
            }
            
            
            if self.createdGroup.groupCoverPicture != nil && self.createdGroup.groupCoverPicture != "" {
                
                let url = URL(string: self.createdGroup.groupCoverPicture)
                
                self.coverImageView.sd_setImage(with: url, placeholderImage: UIImage(named: "cover_default")) { (image, error, imageCacheType, url) in
                    
                }
            }
            else {
                
                self.coverImageView.image = UIImage(named: "cover_default")
            }
        }
    }
    
    // MARK: - Buttons Action

    @IBAction func didGoToGroupButtonPressed(_ sender: UIButton) {
     
        NotificationCenter.default.post(name: .GOTOFeedNotification, object: createdGroup)
    }
    
    @IBAction func didInviteMemberButtonPressed(_ sender: UIButton) {
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
