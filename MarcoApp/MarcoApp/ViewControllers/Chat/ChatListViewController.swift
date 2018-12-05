//
//  ChatListViewController.swift
//  MarcoApp
//
//  Created by Nabeel Hayat on 05/12/2017.
//  Copyright © 2017 GrayScaleLogic. All rights reserved.
//

import UIKit
import PubNub

class ChatListViewController: BaseViewController {

    @IBOutlet weak var recentChatTableView: ChatListTableView!
    @IBOutlet weak var userChatTableView: ChatListTableView!
    
    @IBOutlet weak var chatTabView: TabView!
    
    @IBOutlet weak var mainContainerView: UIView!
    @IBOutlet weak var placeholderView: UIView!
    
    @IBOutlet weak var mainContainerLeadingConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var tabViewHeightConstraint: NSLayoutConstraint!
    
    var userMsgsCountList: [Int] = []
    
    var userChannelList: [String] = []
    
    var recentChatList: [UserProfile] = []
    var userChatList: [UserProfile] = [] {
        
        didSet {
            
            if self.userChatList.count > 0 {
                
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
        
        self.hideNavigationMenuButtonItem = false
        self.showBackButtonItem = false
        // Do any additional setup after loading the view.
        
        self.setupViews()
     
        NotificationCenter.default.addObserver(self, selector: #selector(didReceiveMessageNotification(_:)), name: .DidReceiveMessageNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(didSubscribeUserNotification(_:)), name: .DidSubscribeUserNotification, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(didOpenChatNotification(_:)), name: .DidOpenChatNotification, object: nil)
        
        self.mainContainerLeadingConstraint.constant = -self.view.frame.size.width;
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.getAllMarcoUsers()
        
        
        if AppDefaults.getOpenChatPublisher() != "" {
            
            self.showPKHUD(WithMessage: "Fetching...")
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        self.appDelegate.registerNotification()
        
        self.appDelegate.pubNubGetAllPushNotifications { (result, status) in
            
            print(result?.data.channels)
        }
    }
    
    override func didBackButtonPressed(_ sender: UIBarButtonItem) {
        super.didBackButtonPressed(sender)
        
    }
    
    override func didMenuButtonPressed(_ sender: UIBarButtonItem) {
        super.didMenuButtonPressed(sender)
        
    }
    
    // MARK: - Helper Functions
    
    func setupViews() {
        
//        self.recentChatList = self.getChatList(count: 5)
//        self.userChatList = self.getChatList(count: 16)
        
//        self.chatTabView.setupTabButtons(tabs: ["ic-chat-clock","ic-chat-user"], isImages: true)
//        self.chatTabView.delegate = self
    
//        self.recentChatTableView.parentViewController = self
//        self.recentChatTableView.loginUserProfile = self.loginUserProfile
//        self.recentChatTableView.userList = self.recentChatList
//        self.recentChatTableView.isRecentChat = true
//        self.recentChatTableView.chatListDelegate = self
        
        self.userChatTableView.parentViewController = self
        self.userChatTableView.loginUserProfile = self.loginUserProfile
        self.userChatTableView.userList = self.userChatList
        self.userChatTableView.chatListDelegate = self
    }
    
//    func getChatList(count: Int) -> [UserProfile] {
//
//        var chat: [UserProfile] = []
//
//        for _ in 0...count {
//
////            let userChat:UserProfile = UserProfile(index: AppFunctions.randomNumber(MIN: 0, MAX: 19))
//
//            chat.append(userChat)
//
//        }
//
//        return chat
//    }
    
    fileprivate func setupUserIdsList() {
        
        if self.userChatList.count > 0 {
            
            for userProfile: UserProfile in self.userChatList {
                
                self.userChannelList.append(userProfile.channel)
            }
            
            if self.userChannelList.count > 0 {
                
//                self.subscribeToUserChannels()
            }
        }
    }
    
    fileprivate func subscribeToUserChannels() {
        
//        self.appDelegate.clientPubNub.subscribeToChannels(self.userChannelList, withPresence: true)
    }
    
    fileprivate func unSubscribeWithUserChannels() {
        
        self.appDelegate.clientPubNub.unsubscribeFromChannels(self.userChannelList, withPresence: true)
    }
    
    fileprivate func getIndexPathFromUserId(_ userId: String) -> IndexPath {
        
        var index: Int = 0
        
        for userProfile: UserProfile in self.userChatList {
            
            if userProfile.userId == userId {
        
                break
            }
            
            index = index + 1
        }
        
        return IndexPath(row: index, section: 0)
    }
    
    func didOpenChat(_ publisher: String) {
        
        
        self.hidePKHUD()
        
        AppDefaults.setOpenChatPublisher("")
        
        var found: Bool = false
        
        var foundUserProfile: UserProfile!
        
        for userProfile: UserProfile in self.userChatList {
            
            if publisher == userProfile.userId {
                
                foundUserProfile = userProfile
                found = true
                break
            }
        }
        
        
        if found && foundUserProfile != nil {
            
            self.appDelegate.pubNubAddPushNotifications([foundUserProfile.channel]) { (status) in
                
                print(status.description)
            }
            
            self.subscribeToChannel(foundUserProfile.channel)
            
            let chatViewController: ChatViewController = self.storyboard?.instantiateViewController(withIdentifier: "ChatViewController") as! ChatViewController
            
            chatViewController.userProfile = foundUserProfile
            chatViewController.loginUserProfile = self.loginUserProfile
            self.navigationController?.pushViewController(chatViewController, animated: true)
        }
    }
    
    // MARK: - Notification
    
    @objc func didReceiveMessageNotification(_ notification: Notification) {
        
        let notifiObject: Any = notification.object!
        
        if let messageDictionary: [String: String] = notifiObject as? [String: String]  {
            
//            let message: String = messageDictionary["text"]!
//            let publisher: String = messageDictionary["publisher"]!
            //                let date: String = messageDictionary["date"]!
            
            
        }
    }
    
    @objc func didSubscribeUserNotification(_ notification: Notification) {
        
        
    }
    
    @objc func didOpenChatNotification(_ notification: Notification) {
        
        let notifiObject: Any = notification.object!
        
        if let publisher: String = notifiObject as? String  {
            
            self.didOpenChat(publisher)
            
        }
    }
    
    // MARK: - Web Services
    
    private func getAllMarcoUsers() {
        
        ApiServices.shared.requestForMarcoUsers(onTarget: self, successfull: { (success, userProfileList) in
            
            self.userChatList = userProfileList
            
            self.setupUserIdsList()
            
            for userProfile: UserProfile in self.userChatList {
                
                if userProfile.userId == self.loginUserProfile.userId {
                    
                    self.userChatList.removeAll(userProfile)
                }
            }
        
//            self.recentChatTableView.userList = self.userChatList
//            self.recentChatTableView.isRecentChat = true
            self.userChatTableView.userList = self.userChatList
            
            self.hidePKHUD()
            
            if self.userChatTableView.userList.count > 0 {
                
                let publisher: String = AppDefaults.getOpenChatPublisher()
                
                if publisher != "" {
                
                    self.didOpenChat(publisher)
                }
            }
            
        }) { (failure) in
         
            self.hidePKHUD()
        }
    }
    
    // MARK: - Buttons Action
    
    @IBAction func didCreateChatButtonPressed(_ sender: UIButton) {
        
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

extension ChatListViewController: ChatListTableViewDelegate {
    
    func chatListTableView(_ chatListTableView: ChatListTableView, didCell cell: ChatListTableViewCell, forRowAt indexPath: IndexPath) {
        
        cell.userOnlineImageView.isHidden = true
        
        if self.recentChatTableView == chatListTableView {
            
            let channel: String = self.userChannelList[indexPath.row]
            
//            self.appDelegate.clientPubNub.hereNowForChannel(channel) { (result, status) in
//
//                print(result?.data)
//                print(result?.data.uuids)
//
//                // Check whether request successfully completed or not.
//                if status != nil {
//
//                    /**
//                     Handle downloaded presence information using:
//                     result.data.uuids - list of uuids.
//                     result.data.occupancy - total number of active subscribers.
//                     */
//
//
//
//                    if let uuidsList: [String] = result?.data.uuids as? [String] {
//
//
//                        if uuidsList.count > 0 {
//
//                            cell.userOnlineImageView.isHidden = false
//                            cell.userOnlineImageView.image = UIImage(named: "ic_online")
//                        }
//                        else {
//
//                            cell.userOnlineImageView.isHidden = true
//                            cell.userOnlineImageView.image = nil
//                        }
//                    }
//                }
//                else {
//
//                    cell.userOnlineImageView.isHidden = true
//
//                    /**
//                     Handle presence audit error. Check 'category' property to find
//                     out possible reason because of which request did fail.
//                     Review 'errorData' property (which has PNErrorData data type) of status
//                     object to get additional information about issue.
//
//                     Request can be resent using: [status retry];
//                     */
//                }
//
//            }
        }
        else {
            
            cell.userOnlineImageView.isHidden = true
        }
    }
    
    func chatListTableView(_ chatListTableView: ChatListTableView, didSelectRowAt indexPath: IndexPath, completion: @escaping (Bool) -> Void) {
    
        let userProfile: UserProfile = self.userChatList[indexPath.row]
        
        self.appDelegate.pubNubAddPushNotifications([userProfile.channel]) { (status) in
            
            print(status.description)
        }
        
        self.subscribeToChannel(userProfile.channel)
        
        
        self.appDelegate.clientPubNub.hereNowForChannel(userProfile.channel) { (result, status) in
            
            
            var foundOtherUser: Bool = false
            
            if let uuidsList: [[String : String]] = result?.data.uuids as? [[String : String]] {
                
                for uuidDict: [String : String] in uuidsList {
                    
                    let uuid: String = uuidDict["uuid"]!
                    
                    if uuid == userProfile.userId {
                        
                        foundOtherUser = true
                    }
                }
                
                if !foundOtherUser {
                    
                    self.appDelegate.clientPubNub.publish(["text": "subscribe", "channel": userProfile.channel], toChannel: userProfile.userId, withCompletion: { (status) in
                        
                        print(status.data.information)
                        print(status.description)
                    })
                }
            }
            
            
        }
        
        
        
        let chatViewController: ChatViewController = self.storyboard?.instantiateViewController(withIdentifier: "ChatViewController") as! ChatViewController

        chatViewController.userProfile = userProfile
        chatViewController.loginUserProfile = self.loginUserProfile
        self.navigationController?.pushViewController(chatViewController, animated: true)
    }
}

extension ChatListViewController: TabViewDelegate {

    func tabView(_ tabView: TabView, selectionChanged: Int) {
        
        if selectionChanged == 0 {
            
            self.mainContainerLeadingConstraint.constant = 0.0;
        }
        else {
        
            self.mainContainerLeadingConstraint.constant = -self.view.frame.size.width;
        }
        
        UIView.animate(withDuration: 0.3) { 
            
            self.view.layoutIfNeeded()
        }
    }
}
