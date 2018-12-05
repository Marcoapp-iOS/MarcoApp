//
//  MenuViewController.swift
//  MarcoApp
//
//  Created by Nabeel Hayat on 26/10/2017.
//  Copyright © 2017 GrayScaleLogic. All rights reserved.
//

import UIKit
import SDWebImage

class MenuViewController: UIViewController {

    @IBOutlet weak var profileContainerView: UIView!
    @IBOutlet weak var profileContainerHConstraint: NSLayoutConstraint!
    @IBOutlet weak var bottomView: UIView!
    @IBOutlet weak var userAvatarImageView: RoundedImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    
    @IBOutlet weak var detailLabel: UILabel!
    @IBOutlet weak var settingLabel: UILabel!
    
    @IBOutlet weak var settingButton: UIButton!
    @IBOutlet weak var inviteButton: UIButton!
    @IBOutlet weak var contactUsButton: UIButton!
    @IBOutlet weak var settingImageView: UIImageView!
    
    @IBOutlet weak var profileButton: UIButton!
    
    var userProfile: UserProfile! {
        
        didSet {
            
            self.setupUserProfile()
        }
    }
    
    var titlesList: [String] = []
    var imagesList: [String] = []
    
    
    lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        
        let xAxis: CGFloat = 0
        let yAxis: CGFloat = (self.view.frame.size.height - 54 * 6) / 2.0
        let width: CGFloat = self.view.frame.size.width
        let height: CGFloat = 54 * 6
        
        tableView.frame = CGRect(x: xAxis, y: yAxis, width: width, height: height)
        tableView.autoresizingMask = [.flexibleTopMargin, .flexibleBottomMargin, .flexibleWidth]
        
        tableView.register(UINib(nibName: "MenuTableViewCell", bundle: nil), forCellReuseIdentifier: "menuTableViewCell")
        
        tableView.isOpaque = false
        tableView.backgroundColor = UIColor.clear
        tableView.backgroundView = nil
        tableView.bounces = false
        return tableView
    }()
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
//        self.userProfile = UserProfile(index: 19)
        
        self.view.backgroundColor = UIColor.clear
        self.view.addSubview(self.tableView)
    
        self.userAvatarImageView.isBorder = false
        
//        self.userAvatarImageView.image = UIImage(named: self.userProfile.avatar)
        
        self.profileContainerView.backgroundColor = UIColor.clear
        self.profileContainerHConstraint.constant = self.tableView.frame.origin.y
        
        self.titlesList = ["My Groups", "Discover", "Feed", "Chats", "Favourites"]
        
        self.imagesList = ["ic_groups", "ic_discover", "ic_feed", "ic_chat", "ic_favourite"]
        
        self.settingImageView.image = UIImage.getImage(withName: "ic_settings", imageColor: UIColor.lightGray)
        
        self.contactUsButton.imageView?.image = UIImage.getImage(withName: "ic_help", imageColor: UIColor.lightGray)
        self.inviteButton.imageView?.image = UIImage.getImage(withName: "ic_addUsers", imageColor: UIColor.lightGray)
        
//        let attributedText: NSMutableAttributedString = NSMutableAttributedString(string: "Chiara Ferragni")
//        let attributedText: NSMutableAttributedString = NSMutableAttributedString(string: self.userProfile.name)
        
//        self.userNameLabel.attributedText = attributedText.setFont(font: AppTheme.regularFont(withSize: 18), kerningValue: -30.0)
        
//        let attributedDetailText: NSMutableAttributedString = NSMutableAttributedString(string: "Fashion Designer")

//        let attributedDetailText: NSMutableAttributedString = NSMutableAttributedString(string: self.userProfile.designation)
        
//        self.detailLabel.attributedText = attributedDetailText.setFont(font: AppTheme.regularFont(withSize: 14), kerningValue: -20.0)
        
        self.settingImageView.isHidden = false
        
//        let attributedSettingsText: NSMutableAttributedString = NSMutableAttributedString(string: "Settings")
        let attributedSettingsText: NSMutableAttributedString = NSMutableAttributedString(string: "Logout")
        
        self.settingLabel.attributedText = attributedSettingsText.setFont(font: AppTheme.regularFont(withSize: 16), kerningValue: -20.0)
        
        NotificationCenter.default.addObserver(self, selector: #selector(MenuViewController.getProfileFromServer), name: Notification.Name.OnUpdateUserProfile, object: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if AppDefaults.getLoggedUserId() == "" {
            
            self.getProfileFromServer()
        }
        else {
        
            self.userProfile = AppFunctions.getUserProfile(from: AppDefaults.getLoggedUserId())
        }
    }
    
    override var prefersStatusBarHidden: Bool {
        
        return true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @objc private func getProfileFromServer() {
        
        ApiServices.shared.requestForMyProfile(onTarget: self, successfull: { (success, isProfileFound) in
        
            self.userProfile = AppFunctions.getUserProfile(from: AppDefaults.getLoggedUserId())
            
        }) { (failure) in
            
        }
    }
    
    private func setupUserProfile() {
        
        NotificationCenter.default.post(name: Notification.Name.OnUpdateCoverPicture, object: nil)
        
        self.userNameLabel.text = self.userProfile.fullName
        self.detailLabel.text = self.userProfile.designation
        
        if self.userProfile.profilePicture != nil && self.userProfile.profilePicture != "" {
            
            let url = URL(string: self.userProfile.profilePicture)
            
            
            self.userAvatarImageView.sd_setImage(with: url, placeholderImage: UIImage(named: "user_default")) { (image, error, imageCacheType, url) in
                
            }
        }
        else {
            
            self.userAvatarImageView.image = UIImage(named: "user_default")
        }
        
    }
    
    
    // MARK: - Buttons Action
    
    @IBAction func didSettingButtonPressed(_ sender: UIButton) {
        
//        let baseNavigationController: BaseNavigationController = AppUI.mainStoryboard.instantiateViewController(withIdentifier: AppConstants.kSettingsSegues) as! BaseNavigationController
//
//        let settingViewController: SettingsViewController = baseNavigationController.childViewControllers[0] as! SettingsViewController
//
//        self.sideMenuViewController.contentViewController.present(baseNavigationController, animated: true, completion: nil)
//
//        //        self.sideMenuViewController.contentViewController = baseNavigationController
//
//        self.sideMenuViewController.hideViewController()
        
        appDelegate.loginManager.logOut()
        AppDefaults.setAppLoggedIn(false)
        
        self.appDelegate.clientPubNub.unsubscribeFromAll()
        
        self.appDelegate.pubNubRemoveAllPushNotifications { (status) in
        
            self.appDelegate.window?.rootViewController = AppUI.getRootViewController()
        }
        
        
    }
    
    
    @IBAction func didProfileButtonPressed(_ sender: UIButton) {
        
        let baseNavigationController: BaseNavigationController = AppUI.mainStoryboard.instantiateViewController(withIdentifier: AppConstants.kMyProfileSegues) as! BaseNavigationController
        
        let profileViewController: ProfileViewController = baseNavigationController.childViewControllers[0] as! ProfileViewController
        
        profileViewController.userProfile = self.userProfile
        
        self.sideMenuViewController.contentViewController.present(baseNavigationController, animated: true, completion: nil)
        
//        self.sideMenuViewController.contentViewController = baseNavigationController
        
//        self.sideMenuViewController.hideViewController()
    
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

// MARK : TableViewDataSource & Delegate Methods

extension MenuViewController : UITableViewDelegate, UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.titlesList.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 54
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let menuCell: MenuTableViewCell = tableView.dequeueReusableCell(withIdentifier: "menuTableViewCell", for: indexPath) as! MenuTableViewCell
        
        
        menuCell.backgroundColor = UIColor.clear
        
        menuCell.menuIconImageView.image = UIImage(named: self.imagesList[indexPath.row])
        menuCell.selectionStyle = .none
        
        let attributedText: NSMutableAttributedString = NSMutableAttributedString(string: self.titlesList[indexPath.row])
        
        menuCell.menuTitleLabel.attributedText = attributedText.setFont(font: AppTheme.regularFont(withSize: 16), kerningValue: -20.0)
        menuCell.menuBadgeLabel.text = ((self.titlesList[indexPath.row] == "Feed")||(self.titlesList[indexPath.row] == "Chats")) ? "" : ""
        
//        cell.backgroundColor = UIColor.clear
//        cell.textLabel?.font = UIFont(name: "HelveticaNeue", size: 21)
//        cell.textLabel?.textColor = UIColor.white
//        cell.textLabel?.text  = titles[indexPath.row]
//        cell.selectionStyle = .none
//        cell.imageView?.image = UIImage(named: images[indexPath.row])
        
        
        return menuCell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
        
        switch indexPath.row {
        case 0:
            self.willChangeMenuTab(with: 0)
            break
        case 1:
            self.willChangeMenuTab(with: 1)
            break
        case 2:
            self.willChangeMenuTab(with: 2)
            break
        case 3:
            self.willChangeMenuTab(with: 3)
            break
        case 4:
            self.willChangeMenuTab(with: 4)
            break
        default:
            break
        }
    }
    
    func willChangeMenuTab(with selectedIndex: Int) {
        
        if self.sideMenuViewController.contentViewController != nil {
            
            if self.sideMenuViewController.contentViewController.isKind(of: MainTabBarViewController.self) {
                
                let mainTabBarViewController: MainTabBarViewController = self.sideMenuViewController.contentViewController as! MainTabBarViewController
                
                mainTabBarViewController.selectedIndex = selectedIndex
            }
            else {
                
                self.sideMenuViewController.contentViewController = AppUI.mainStoryboard.instantiateViewController(withIdentifier: AppConstants.kDiscoverSegues)
            }
        }
        
        //self.sideMenuViewController.contentViewController = AppUI.mainStoryboard.instantiateViewController(withIdentifier: AppConstants.kDiscoverSegues)
        
        self.sideMenuViewController.hideViewController()
    }
}
