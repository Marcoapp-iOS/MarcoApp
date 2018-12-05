//
//  ProfileViewController.swift
//  MarcoApp
//
//  Created by Nabeel Hayat on 29/11/2017.
//  Copyright © 2017 GrayScaleLogic. All rights reserved.
//

import UIKit
import SDWebImage

class ProfileViewController: BaseViewController {

    
    @IBOutlet weak var profileTableView: ProfileTableView!
    
    @IBOutlet weak var coverImageView: UIImageView!
    @IBOutlet weak var avatarImageView: RoundedImageView!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var detailTextLabel: UILabel!
    
    @IBOutlet weak var editButton: UIButton!
    
    var userProfile: UserProfile!
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.hideNavigationMenuButtonItem = true
        self.showBackButtonItem = true
        // Do any additional setup after loading the view.
        
//        self.setupViews()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.setupViews()
    }
    
    override func didBackButtonPressed(_ sender: UIBarButtonItem) {
//        super.didBackButtonPressed(sender)
        
        DispatchQueue.main.async {
            
            self.showPKHUD(WithMessage: "Updating...")
            
            self.dismiss(animated: true, completion: {
                
                self.hidePKHUD()
            })
        }
    }
    
    override func didMenuButtonPressed(_ sender: UIBarButtonItem) {
        super.didMenuButtonPressed(sender)
        
    }
    
    // MARK: - Helper Functions
    
    func setupViews() {
        
        self.profileTableView.setupTableView(WithParentViewController: self, isEditMode: false, userProfile: self.userProfile)
        
        self.usernameLabel.text = self.userProfile.fullName
        self.detailTextLabel.text = self.userProfile.designation
        
        if userProfile.profilePicture != nil && userProfile.profilePicture != "" {
            
            let url = URL(string: userProfile.profilePicture)
            
            self.avatarImageView.sd_setImage(with: url, placeholderImage: UIImage(named: "user_default")) { (image, error, imageCacheType, url) in
                
            }
        }
        else {
        
            self.avatarImageView.image = UIImage(named: "user_default")
        }
        
        if userProfile.coverPicture != nil && userProfile.coverPicture != "" {
            
            let url = URL(string: userProfile.coverPicture)
            
            self.coverImageView.sd_setImage(with: url, placeholderImage: UIImage(named: "cover_default")) { (image, error, imageCacheType, url) in
                
            }
        }
        else {
            
            self.coverImageView.image = UIImage(named: "cover_default")
        }
        
        let moreBarButtonItem: UIBarButtonItem = UIBarButtonItem(image: UIImage(named: "ic_dropdown"), style: UIBarButtonItemStyle.done, target: self, action: #selector(didMoreButtonPressed(_:)))
        
        let chatBarButtonItem: UIBarButtonItem = UIBarButtonItem(image: UIImage(named: "ic_nb_setting"), style: UIBarButtonItemStyle.done, target: self, action: #selector(didSettingButtonPressed(_:)))
        
        let chatImageInset = UIEdgeInsets(top: 0, left: 30, bottom: 0, right: 0);
        
        chatBarButtonItem.imageInsets = chatImageInset;
//        
//        let negativeSpace:UIBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.fixedSpace, target: nil, action: nil)
////        negativeSpace.width = -10.0
        self.navigationItem.rightBarButtonItems = [moreBarButtonItem, chatBarButtonItem]
        
    }
    
    // MARK: - Buttons Action
    
    @objc func didMoreButtonPressed(_ sender: UIBarButtonItem) {
        
    }
    
    @objc func didSettingButtonPressed(_ sender: UIBarButtonItem) {
        
    }
    
    @IBAction func didEditButtonPressed(_ sender: UIButton) {
    
        let editProfileViewController: EditProfileViewController = self.storyboard?.instantiateViewController(withIdentifier: "EditProfileViewController") as! EditProfileViewController
        editProfileViewController.showBackButton = true
        editProfileViewController.userProfile = self.userProfile
        self.navigationController?.pushViewController(editProfileViewController, animated: true)
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
