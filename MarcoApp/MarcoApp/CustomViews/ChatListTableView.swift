//
//  ChatListTableView.swift
//  MarcoApp
//
//  Created by Nabeel Hayat on 05/12/2017.
//  Copyright © 2017 GrayScaleLogic. All rights reserved.
//

import UIKit
import SDWebImage

protocol ChatListTableViewDelegate {
    
    func chatListTableView(_ chatListTableView: ChatListTableView, didCell cell: ChatListTableViewCell, forRowAt indexPath: IndexPath)
    
    func chatListTableView(_ chatListTableView: ChatListTableView, didSelectRowAt indexPath: IndexPath, completion: @escaping (_ success: Bool) -> Void)
}

class ChatListTableView: UITableView, UITableViewDelegate, UITableViewDataSource, ChatListTableViewCellDelegate {
    
    // MARK: - Variables
    
    var chatListDelegate: ChatListTableViewDelegate!
    
    var loginUserProfile: UserProfile!
    
    var userList: [UserProfile] = []  {
        
        didSet {
            
            self.reloadData()
        }
    }
    
    var parentViewController: UIViewController! {
        
        didSet {
            
            self.reloadData()
        }
    }
    
    var isRecentChat: Bool = false {
    
        didSet {
        
            self.reloadData()
        }
    }
    
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
        
        self.delegate = self
        self.dataSource = self
        
        self.register(UINib(nibName: "ChatListTableViewCell", bundle: nil), forCellReuseIdentifier: "ChatListTableViewCell")
    }
    
    // MARK: - ChatListTableViewCellDelegate
    
    
    
    // MARK: - UITableViewDataSource
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return self.userList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell: ChatListTableViewCell = tableView.dequeueReusableCell(withIdentifier: "ChatListTableViewCell", for: indexPath) as! ChatListTableViewCell
        
        cell.delegate = self
        cell.indexPath = indexPath
        
        let userProfile: UserProfile = self.userList[indexPath.row]
        
        cell.usernameLabel.text = userProfile.fullName
        cell.userDetailLabel.text = "" //"Last seen 5 min ago"
        cell.timeStampLabel.text = "" //"12:38 AM"
        cell.messageStateImageView.isHidden = true
        
        if userProfile.profilePicture != nil && userProfile.profilePicture != "" {
            
            let urlString: URL = URL(string: userProfile.profilePicture)!
            
            cell.userImageView.sd_setImage(with: urlString, placeholderImage: UIImage(named: "user_default")) { (image, error, imageCacheType, url) in
                
            }
        }
        else {
            
            cell.userImageView.image = UIImage(named: "user_default")
        }
        
        
        if self.delegate != nil {
            
            self.chatListDelegate.chatListTableView(self, didCell: cell, forRowAt: indexPath)
        }
        
//        if self.isRecentChat {
//        
//            cell.configureCellForRecents()
//        }
//        else {
//        
//            cell.configureCellForUsers()
//        }
        
        
        return cell
    }
    
    // MARK: - UITableViewDelegate
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 85.0;
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
     
        if self.chatListDelegate != nil {
            
            self.chatListDelegate.chatListTableView(self, didSelectRowAt: indexPath) { (success) in
         
            }
        }
    }
}
