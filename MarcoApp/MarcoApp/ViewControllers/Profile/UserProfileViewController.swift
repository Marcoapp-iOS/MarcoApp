//
//  UserProfileViewController.swift
//  MarcoApp
//
//  Created by Nabeel Hayat on 09/11/2017.
//  Copyright © 2017 GrayScaleLogic. All rights reserved.
//

import UIKit
import SDWebImage

class UserProfileViewController: BaseViewController {

    @IBOutlet weak var userAvatarImageView: RoundedImageView!
    
    @IBOutlet weak var userCoverImageView: UIImageView!
    @IBOutlet weak var userInfoView: UIView!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var userDetailLabel: UILabel!
    @IBOutlet weak var addButton: UIButton!
    
    @IBOutlet weak var mainTabView: TabView!
    @IBOutlet weak var subTabView: TabView!
    @IBOutlet weak var containerView: BaseView!
    
    @IBOutlet weak var aboutTableView: ProfileTableView!
    @IBOutlet weak var userGroupsCollectionView: UICollectionView!
    @IBOutlet weak var containerViewLeadingConstraint: NSLayoutConstraint!
    @IBOutlet weak var placeholderView: UIView!
    
    var userProfile: UserProfile!
    
    var adminGroupList: [GroupObject] = []
    var memberGroupList: [GroupObject] = []
    var allGroupList: [GroupObject] = [] {
        
        didSet {
            
            if allGroupList.count > 0 {
                
                self.placeholderView.isHidden = true
            }
            else {
                
                self.placeholderView.isHidden = false
            }
        }
    }
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.hideNavigationMenuButtonItem = true
        self.showBackButtonItem = true
        // Do any additional setup after loading the view.
       
        self.setupViews()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.sendRequestForUsersGroups()
        self.sendRequestForUserProfile()
    }
    
    override func didBackButtonPressed(_ sender: UIBarButtonItem) {
        super.didBackButtonPressed(sender)
        
    }
    
    override func didMenuButtonPressed(_ sender: UIBarButtonItem) {
        super.didMenuButtonPressed(sender)
        
    }
    
    // MARK: - Helper Functions
    
    func setupViews() {
        

        if self.userProfile.channel == "" {
            
            
        }
        
        self.addButton.isHidden = (self.userProfile.userId == self.loginUserProfile.userId) ? false : true
        
        self.mainTabView.setupTabButtons(tabs: ["GROUPS", "ABOUT"])
        self.mainTabView.delegate = self
        
        self.subTabView.setupTabButtons(tabs: ["ALL GROUPS", "MEMBERS", "ADMIN"], selectedColor: AppTheme.blueColor, unSelectedColor: AppTheme.blackColor, indicatorColor: AppTheme.whiteColor)
        self.subTabView.backgroundColor = AppTheme.whiteColor
        
        self.subTabView.delegate = self
        
        self.userAvatarImageView.isBorder = false
        
        self.userGroupsCollectionView.register(UINib(nibName: "DiscoverCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "DiscoverCollectionViewCell")
        
        self.userGroupsCollectionView.delegate = self
        self.userGroupsCollectionView.dataSource = self
        
        let moreBarButtonItem: UIBarButtonItem = UIBarButtonItem(image: UIImage(named: "ic_dropdown"), style: UIBarButtonItemStyle.done, target: self, action: #selector(didMoreButtonPressed(_:)))
        
        let chatBarButtonItem: UIBarButtonItem = UIBarButtonItem(image: UIImage(named: "ic_nb_message"), style: UIBarButtonItemStyle.done, target: self, action: #selector(didChatButtonPressed(_:)))
        
        let chatImageInset = UIEdgeInsets(top: 0, left: 30, bottom: 0, right: 0);
        
        chatBarButtonItem.imageInsets = chatImageInset;
        
//        let negativeSpace:UIBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.fixedSpace, target: nil, action: nil)
//        negativeSpace.width = -10.0
        self.navigationItem.rightBarButtonItems = [moreBarButtonItem, chatBarButtonItem]
        
        
        self.userAvatarImageView.image = nil
        self.userCoverImageView.image = nil
    }
    
    private func setGroupLists() {
        
        if self.allGroupList.count > 0 {
            
            for currentGroup: GroupObject in self.allGroupList {
                
                if currentGroup.groupCreator.userId == self.userProfile.userId {
                    
                    self.adminGroupList.append(currentGroup)
                }
                else {
                    
                    self.memberGroupList.append(currentGroup)
                }
            }
        }
    }
    
    // MARK: - Web Services
    
    private func sendRequestForUsersGroups() {
        
        let parameters: [String : Any] = ["UserId": self.userProfile.userId]
        
        ApiServices.shared.requestForUserGroups(onTarget: self, self.userProfile.userId, successfull: { (success, groupList) in
            
            self.allGroupList = groupList
            
            self.setGroupLists()
            
            self.userGroupsCollectionView.reloadData()
            
        }) { (failure) in
            
            
        }
    }
    
    private func sendRequestForUserProfile() {
        
        ApiServices.shared.requestForUserProfile(onTarget: self, self.userProfile.userId, successfull: { (success, userProfile) in
            
            self.userProfile = userProfile
            
            self.userNameLabel.text = self.userProfile.fullName
            self.userDetailLabel.text = self.userProfile.designation
            
            if self.userProfile.profilePicture != nil && self.userProfile.profilePicture != "" {
                
                let urlString: URL = URL(string: self.userProfile.profilePicture)!
                
                self.userAvatarImageView.sd_setImage(with: urlString, placeholderImage: UIImage(named: "user_default")) { (image, error, imageCacheType, url) in
                    
                }
            }
            else {
                
                self.userAvatarImageView.image = UIImage(named: "user_default")
            }
            
            self.aboutTableView.setupTableView(WithParentViewController: self, isEditMode: false, userProfile: self.userProfile)
            
        }) { (failure, errorMessage) in
            
            
        }
    }

    // MARK: - Buttons Action
    
    @objc func didMoreButtonPressed(_ sender: UIBarButtonItem) {
    
    }
    
    @objc func didChatButtonPressed(_ sender: UIBarButtonItem) {
        
        if self.userProfile.channel != "" {
         
            self.subscribeToChannel(userProfile.channel)
            
            let chatViewController: ChatViewController = self.storyboard?.instantiateViewController(withIdentifier: "ChatViewController") as! ChatViewController
            
            chatViewController.userProfile = userProfile
            chatViewController.loginUserProfile = self.loginUserProfile
            self.navigationController?.pushViewController(chatViewController, animated: true)
        }
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

extension UserProfileViewController: TabViewDelegate {

    func tabView(_ tabView: TabView, selectionChanged: Int) {
        
        if self.mainTabView == tabView {
            
            if selectionChanged == 0 {
                
                if self.allGroupList.count > 0 {
                    
                    self.placeholderView.isHidden = true
                }
                else {
                
                    self.placeholderView.isHidden = false
                }
                
                self.containerViewLeadingConstraint.constant = 0.0
            }
            else if selectionChanged == 1 {
             
//                self.placeholderView.isHidden = true
                self.containerViewLeadingConstraint.constant = -self.view.frame.size.width
            }
            
            UIView.animate(withDuration: 0.3, animations: {
                self.view.layoutIfNeeded()
            }, completion: { (successfull) in
                
                if selectionChanged == 0 {
                    
                    if self.allGroupList.count > 0 {
                        
                        self.placeholderView.isHidden = true
                    }
                    else {
                        
                        self.placeholderView.isHidden = false
                    }
                }
                else if selectionChanged == 1 {
                    
                    self.placeholderView.isHidden = true
                }
            })
            
        }
        else if self.subTabView == tabView {
         
            self.userGroupsCollectionView.reloadData()
            
            if selectionChanged == 0 {
                
            }
            else if selectionChanged == 1 {
                
            }
            else if selectionChanged == 2 {
                
            }
        }
    }
}

extension UserProfileViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, DiscoverCollectionDelegate {
    
    // MARK: - DiscoverCollectionDelegate
    
    func discoverCollectionViewCell(_ cell: DiscoverCollectionViewCell, didJoinGroupPressed sender: UIButton, at indexPath: IndexPath) {
        
        let groupDetailViewController: GroupDetailViewController = self.storyboard?.instantiateViewController(withIdentifier: "GroupDetailViewController") as! GroupDetailViewController
        
        var group: GroupObject = GroupObject()
        
        if self.mainTabView.indexSelected == 0 {
            
            group = self.allGroupList[indexPath.row]
        }
        else if self.mainTabView.indexSelected == 1 {
            
            group = self.memberGroupList[indexPath.row]
        }
        else /*if self.mainTabView.indexSelected == 2*/ {
            
            group = self.adminGroupList[indexPath.row]
        }
        
        groupDetailViewController.group = group
        
        self.navigationController?.pushViewController(groupDetailViewController, animated: true)
    }
    
    func discoverCollectionViewCell(_ cell: DiscoverCollectionViewCell, didMoreOptionPressed sender: UIButton, at indexPath: IndexPath) {
        
    }
    
    // MARK: UICollectionViewDataSource
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if self.subTabView.indexSelected == 0 {
            
            return self.allGroupList.count
        }
        else if self.subTabView.indexSelected == 1 {
            
            return self.memberGroupList.count
        }
        else /*if self.mainTabView.indexSelected == 2*/ {
            
            return self.adminGroupList.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: DiscoverCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: "DiscoverCollectionViewCell", for: indexPath) as! DiscoverCollectionViewCell
        
        cell.delegate = self
        cell.indexPath = indexPath
        
        cell.coverPhotoImageView.layer.cornerRadius = 8;
        cell.ContainerView.layer.cornerRadius = 8;
        
        var group: GroupObject = GroupObject()
        
        if self.subTabView.indexSelected == 0 {
            
            group = self.allGroupList[indexPath.row]
        }
        else if self.subTabView.indexSelected == 1 {
            
            group = self.memberGroupList[indexPath.row]
        }
        else /*if self.subTabView.indexSelected == 2*/ {
            
            group = self.adminGroupList[indexPath.row]
        }
        
//        let group: UserGroup = self.groupList[indexPath.row]
        
//        cell.coverPhotoImageView.image = UIImage(named: group.groupCoverPhoto)
//        cell.profileImageView.image = UIImage(named: group.userProfile.avatar)
        // Configure the cell
        cell.profileImageView.imageBorderWidth = 4
        
        cell.dimsView.isHidden = true
        
        if self.userProfile.userId == group.groupCreator.userId {
            
            var privateGroupString: String = ""
            
            if group.isPrivateGroup {
                
                privateGroupString = "Private"
            }
            else {
                
                privateGroupString = "Public"
            }
            
            let text = NSMutableAttributedString(string: privateGroupString)
            
            cell.groupDetail.attributedText = text.setFont(font: AppTheme.semiBoldFont(withSize: 15), kerningValue: -20)
        }
        else {
            
            let privateGroupString: String = group.groupCreator.fullName
            
            let text = NSMutableAttributedString(string: privateGroupString)
            
            cell.groupDetail.attributedText = text.setFont(font: AppTheme.semiBoldFont(withSize: 15), kerningValue: -20)
        }
        
        cell.membersLabel.text = "\(group.totalMembers.intValue)"
        
        if group.totalPosts.intValue == 0 {
            
            cell.commentView.isHidden = true
            cell.commentImageView.isHidden = true
            cell.commentLabel.isHidden = true
        }
        else {
            
            cell.commentView.isHidden = false
            cell.commentImageView.isHidden = false
            cell.commentLabel.isHidden = false
        
            cell.commentLabel.text = "\(group.totalPosts.intValue)"
        }
        
        
        
        cell.groupName.text = group.groupTitle
        
        if group.groupProfilePicture != nil && group.groupProfilePicture != "" {
            
            let urlString: URL = URL(string: group.groupProfilePicture)!
            
            cell.profileImageView.sd_setImage(with: urlString, placeholderImage: UIImage(named: "user_default")) { (image, error, imageCacheType, url) in
                
            }
        }
        else {
            
            cell.profileImageView.image = UIImage(named: "user_default")
        }
        
        if group.groupCoverPicture != nil && group.groupCoverPicture != "" {
            
            let urlString: URL = URL(string: group.groupCoverPicture)!
            
            cell.coverPhotoImageView.sd_setImage(with: urlString, placeholderImage: UIImage(named: "cover_default")) { (image, error, imageCacheType, url) in
                
            }
        }
        else {
            
            cell.coverPhotoImageView.image = UIImage(named: "cover_default")
        }
        
        
        cell.joinButton.isHidden = !group.isUserCanJoin
        cell.joinedLabel.isHidden = group.isUserCanJoin
        cell.commentView.isHidden = false
        
        return cell
    }
    
    // MARK: UICollectionViewDelegateFlowLayout
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: self.view.frame.size.width, height: 230);
    }
    
    // MARK: UICollectionViewDelegate
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        var group: GroupObject = GroupObject()
        
        if self.subTabView.indexSelected == 0 {
            
            group = self.allGroupList[indexPath.row]
        }
        else if self.subTabView.indexSelected == 1 {
            
            group = self.memberGroupList[indexPath.row]
        }
        else /*if self.subTabView.indexSelected == 2*/ {
            
            group = self.adminGroupList[indexPath.row]
        }
        
        if !group.isUserCanJoin {
            
            let feedViewController: FeedsViewController = AppUI.mainStoryboard.instantiateViewController(withIdentifier: "FeedsViewController") as! FeedsViewController
            feedViewController.isGroupFeeds = true
            feedViewController.groupObject = group
            
            self.navController?.pushViewController(feedViewController, animated: true)
        }
    }
    
    /*
     // Uncomment this method to specify if the specified item should be highlighted during tracking
     func collectionView(_ collectionView: UICollectionView, shouldHighlightItemAt indexPath: IndexPath) -> Bool {
     return true
     }
     */
    
    /*
     // Uncomment this method to specify if the specified item should be selected
     func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
     return true
     }
     */
    
    /*
     // Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
     func collectionView(_ collectionView: UICollectionView, shouldShowMenuForItemAt indexPath: IndexPath) -> Bool {
     return false
     }
     
     func collectionView(_ collectionView: UICollectionView, canPerformAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) -> Bool {
     return false
     }
     
     func collectionView(_ collectionView: UICollectionView, performAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) {
     
     }
     */
}
