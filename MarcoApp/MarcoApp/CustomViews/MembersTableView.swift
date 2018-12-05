//
//  MembersTableView.swift
//  MarcoApp
//
//  Created by Nabeel Hayat on 01/12/2017.
//  Copyright © 2017 GrayScaleLogic. All rights reserved.
//

import UIKit
import SDWebImage

protocol MembersTableViewDelegate {
    
    func membersTableView(_ tableView: MembersTableView, didChatButtonPressed sender: UIButton, atIndexPath: IndexPath);
    func membersTableView(_ tableView: MembersTableView, didMoreButtonPressed sender: UIButton, atIndexPath: IndexPath);
    func membersTableView(_ tableView: MembersTableView,  didSelectRowAt indexPath: IndexPath);
    
    func membersTableView(_ tableView: MembersTableView,  didDeleteRowAt indexPath: IndexPath);
}

class MembersTableView: UITableView, UITableViewDelegate, UITableViewDataSource, MemberTableViewCellDelegate {
    
    // MARK: - Variables
    
    var membersDelegate: MembersTableViewDelegate!
    
    var parentViewController: UIViewController! {
    
        didSet {
        
            self.reloadData()
        }
    }
    
    var userListTemp: [UserProfile] = [UserProfile]()
    
    var userList: [UserProfile] = [UserProfile]() {
        
        didSet {
            
            self.reloadData()
        }
    }
    
    var isDiscoverView: Bool!
    var isFavoritesView: Bool!
    
    var isChatButtonHidden: Bool!
    
    // MARK: - Lifecycle
    
    override init(frame: CGRect, style: UITableViewStyle) {
        super.init(frame: frame, style: style)
        
        self.initialize()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        self.initialize()
    }
    
    func initialize() {
        
        self.isFavoritesView = false
        self.isDiscoverView = false
        self.isChatButtonHidden = false
        
        self.delegate = self
        self.dataSource = self
        
        self.register(UINib(nibName: "MemberTableViewCell", bundle: nil), forCellReuseIdentifier: "MemberTableViewCell")
    }
    
    // MARK: - Helper Functions
    
    public func searchUsers(by searchText: String) {
        
        let usersList = self.userList.filter({$0.fullName.contains(searchText)})
        
        self.userListTemp = self.userList
        
        self.userList = usersList
        
        self.reloadData()
    }
    
    public func didEndSearch() {
        
        self.userList = self.userListTemp
        
        self.reloadData()
    }
    
    // MARK: - MemberTableViewCellDelegate
    
    func memberTableViewCell(_ cell: MemberTableViewCell, didChatButtonPressed sender: UIButton, atIndexPath: IndexPath) {
        
        if self.membersDelegate != nil {
            
            self.membersDelegate.membersTableView(self, didChatButtonPressed: sender, atIndexPath: atIndexPath)
        }
        
    }
    
    func memberTableViewCell(_ cell: MemberTableViewCell, didMoreButtonPressed sender: UIButton, atIndexPath: IndexPath) {
        
        if self.membersDelegate != nil {
            
            self.membersDelegate.membersTableView(self, didMoreButtonPressed: sender, atIndexPath: atIndexPath)
        }
        
//        let userProfileViewController: UserProfileViewController = self.parentViewController.storyboard?.instantiateViewController(withIdentifier: "UserProfileViewController") as! UserProfileViewController
//        let userProfile: UserProfile = self.userList[atIndexPath.row]
//        userProfileViewController.userProfile = userProfile
//
//        self.parentViewController.navigationController?.pushViewController(userProfileViewController, animated: true)
    }
    
    // MARK: - UITableViewDataSource
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return self.userList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell: MemberTableViewCell = tableView.dequeueReusableCell(withIdentifier: "MemberTableViewCell", for: indexPath) as! MemberTableViewCell
        
        cell.delegate = self
        cell.indexPath = indexPath
        
        let userProfile: UserProfile = self.userList[indexPath.row]
        
        let titleText = NSMutableAttributedString(string: userProfile.fullName)
        
        cell.titleLabel.attributedText = titleText.setFont(font: AppTheme.semiBoldFont(withSize: 16), kerningValue: -10)
        
        let detailText = NSMutableAttributedString(string: "")
        
        cell.detailLabel.attributedText = detailText.setFont(font: AppTheme.semiBoldFont(withSize: 12), kerningValue: 10)
        
        cell.onlineImageView.isHidden = true
        
        
        cell.moreButton.isHidden = (self.isFavoritesView) ? true : false
        
        if userProfile.profilePicture != nil {
            
            if userProfile.profilePicture != "" {
                
                let urlString: URL = URL(string: userProfile.profilePicture)!
                
                cell.avatarImageView.sd_setImage(with: urlString, placeholderImage: UIImage(named: "user_default")) { (image, error, imageCacheType, url) in
                    
                }
            }
            else {
                
                cell.avatarImageView.image = UIImage(named: "user_default")
            }
        }
        else {
            
            cell.avatarImageView.image = UIImage(named: "user_default")
        }
        
        cell.chatButton.isHidden = self.isChatButtonHidden
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        
        
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        
        return true
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        
        let doneAction = UITableViewRowAction(style: .default, title: "Delete") { (action:UITableViewRowAction!, indexPath:IndexPath!) in
        
            if self.membersDelegate != nil {
                
                self.membersDelegate.membersTableView(self, didDeleteRowAt: indexPath)
            }
            
        }
        
        return [doneAction]
        
        //        return nil
    }
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCellEditingStyle {
        
        return .delete
    }
    
    // MARK: - UITableViewDelegate
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 85.0;
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        if self.membersDelegate != nil {
            
            self.membersDelegate.membersTableView(self, didSelectRowAt: indexPath)
        }
        
        let userProfileViewController: UserProfileViewController = self.parentViewController.storyboard?.instantiateViewController(withIdentifier: "UserProfileViewController") as! UserProfileViewController
        let userProfile: UserProfile = self.userList[indexPath.row]
        userProfileViewController.userProfile = userProfile
        
        self.parentViewController.navigationController?.pushViewController(userProfileViewController, animated: true)
    }
}
