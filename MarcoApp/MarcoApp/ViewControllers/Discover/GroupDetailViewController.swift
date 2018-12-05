//
//  GroupDetailViewController.swift
//  MarcoApp
//
//  Created by Nabeel Hayat on 09/11/2017.
//  Copyright © 2017 GrayScaleLogic. All rights reserved.
//

import UIKit
import SDWebImage
import Stripe

class GroupDetailViewController: BaseViewController {

    @IBOutlet weak var groupCoverImageView: UIImageView!
    @IBOutlet weak var groupPhotoImageView: RoundedImageView!
    
    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBOutlet weak var containerView: BaseView!
    @IBOutlet weak var groupTitleLabel: UILabel!
    @IBOutlet weak var groupDetailLabel: UILabel!
    
    @IBOutlet weak var groupAdminView: UIView!
    @IBOutlet weak var groupAdminAvatarImageView: RoundedImageView!
    @IBOutlet weak var groupAdminTitleLabel: UILabel!
    @IBOutlet weak var groupAdminNameLabel: UILabel!
    
    @IBOutlet weak var aboutView: UIView!
    @IBOutlet weak var groupAboutLabel: UILabel!
    
    @IBOutlet weak var groupMembersList: GroupMembersListView!
    
    @IBOutlet weak var subscriptionView: UIView!
    
    @IBOutlet weak var subscriptionTitleLabel: UILabel!
    @IBOutlet weak var subscriptionButton: UIButton!
    @IBOutlet weak var gotoGroupDetailButton: UIButton!
    
    @IBOutlet weak var subscriptionHConstaint: NSLayoutConstraint!
    @IBOutlet weak var aboutHConstraint: NSLayoutConstraint!
    @IBOutlet weak var memberHConstraint: NSLayoutConstraint!
    
    var groupCreatedProfile: UserProfile!
    var group: GroupObject!
    
    var isDeeplinking: Bool = false
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.hideNavigationMenuButtonItem = true
        self.showBackButtonItem = true
        // Do any additional setup after loading the view.
        
        NotificationCenter.default.addObserver(self, selector: #selector(dismissViewController), name: .DismissGroupControllerNotification, object: nil)
        
//        self.sendRequestForUserProfile()
        self.sendRequestForGroupDetail()
        
        if !isDeeplinking {
            
            self.setupViews()
        }
        
    }
    
    override func didBackButtonPressed(_ sender: UIBarButtonItem) {
        super.didBackButtonPressed(sender)
        
        self.dismissViewController()
    }
    
    override func didMenuButtonPressed(_ sender: UIBarButtonItem) {
        super.didMenuButtonPressed(sender)
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        self.hideNavigationMenuButtonItem = false
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Helper Functions
    
    @objc func dismissViewController() {
       
        if self.isDeeplinking {
            
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    func setupViews() {
        
//        self.groupPhotoImageView.image = UIImage(named: self.group.userProfile.avatar)
//        self.groupAdminAvatarImageView.image = UIImage(named: self.group.userProfile.avatar)
//        self.groupCoverImageView.image = UIImage(named: self.group.groupCoverPhoto)
//        self.groupAdminNameLabel.text = self.group.userProfile.name
        
        
        let attributedText: NSMutableAttributedString = NSMutableAttributedString(string: self.group.groupTitle)
        
        self.groupTitleLabel.attributedText = attributedText.setFont(font: AppTheme.regularFont(withSize: 20), kerningValue: -60.0)
        
        var privateGroupString: String = ""
        
        if group.isPrivateGroup {
            
            privateGroupString = "Private Group"
        }
        else {
            
            privateGroupString = "Public Group"
        }
        
        var groupMembersString: String = ""
        
        if group.totalMembers.intValue > 1 {
            
            groupMembersString = "\(group.totalMembers.intValue) Members"
        }
        else {
            
            groupMembersString = "1 Member"
        }
        
        let attributedDetailText: NSMutableAttributedString = NSMutableAttributedString(string: privateGroupString + " - " + groupMembersString)
        
        self.groupDetailLabel.attributedText = attributedDetailText.setFont(font: AppTheme.regularFont(withSize: 14), kerningValue: -30.0)
        
        self.groupAboutLabel.text = self.group.groupDescription
        
        self.groupAdminAvatarImageView.isBorder = false
        self.groupPhotoImageView.isBorder = false
        
        if group.groupProfilePicture != nil && group.groupProfilePicture != "" {
            
            let urlString: URL = URL(string: group.groupProfilePicture)!
            
            
            self.groupPhotoImageView.sd_setImage(with: urlString, placeholderImage: UIImage.getImage(withName: "group-default", imageColor: UIColor(hexString: "#cccccc"))) { (image, error, imageCacheType, url) in
                
            }
            
        }
        else {
            
            self.groupPhotoImageView.image = UIImage.getImage(withName: "group-default", imageColor: UIColor(hexString: "#cccccc"))
        }
        
        if group.groupCoverPicture != nil && group.groupCoverPicture != "" {
            
            let urlString: URL = URL(string: group.groupCoverPicture)!
            
            self.groupCoverImageView.sd_setImage(with: urlString, placeholderImage: UIImage(named: "cover_default")) { (image, error, imageCacheType, url) in
                
            }
        }
        else {
            
            self.groupCoverImageView.image = UIImage(named: "cover_default")
        }
        
        self.updateDetailViewConstraints()
        
        self.subscriptionButton.isEnabled = false
        self.subscriptionButton.isHidden = true
        self.subscriptionTitleLabel.isHidden = true
        self.gotoGroupDetailButton.isHidden = true
    }
    
    private func updateDetailViewConstraints() {
        
        if let description = self.group.groupDescription {
        
            let aboutHeight: CGFloat = description.height(withConstrainedWidth: self.groupAboutLabel.frame.size.width, font: self.groupAboutLabel.font)
            
            self.aboutHConstraint.constant = aboutHeight
        }
        else  {
            
            self.aboutHConstraint.constant = 0.0
        }
        
        if self.group.groupMembers.count > 1 {
            
            self.memberHConstraint.constant = 90.0;
            
            self.groupMembersList.groupMembersList = self.group.groupMembers
        }
        else {
            
            self.memberHConstraint.constant = 0.0;
        }
        
        
        if self.group.isPaidGroup {
            
            self.subscriptionTitleLabel.isHidden = false
            self.subscriptionHConstaint.constant = 97
        }
        else {

            self.subscriptionTitleLabel.isHidden = true
            self.subscriptionHConstaint.constant = 70
        }
    }
    
    private func updateViewDetail() {
        
        if self.group.groupCreator.profilePicture != nil {
        
            if self.group.groupCreator.profilePicture != "" {
                
                let urlString: URL = URL(string: self.group.groupCreator.profilePicture)!
                
                self.groupAdminAvatarImageView.sd_setImage(with: urlString, placeholderImage: UIImage(named: "user_default")) { (image, error, imageCacheType, url) in
                    
                }
                
            }
            else {
                
                self.groupAdminAvatarImageView.image = UIImage(named: "user_default")
            }
        }
        else {
            
            self.groupAdminAvatarImageView.image = UIImage(named: "user_default")
        }
        
        self.groupAdminNameLabel.text = group.groupCreator.fullName
        
        
        self.gotoGroupDetailButton.setImage(UIImage.getImage(withName: "btn-goto-group", imageColor: AppTheme.blueColor), for: .normal)
        
        if self.group.isPaidGroup {
            
            if self.group.isUserCanJoin {
                
                let attributes: [NSAttributedStringKey : Any] = [NSAttributedStringKey.font : AppTheme.regularFont(withSize: 14), NSAttributedStringKey.foregroundColor : AppTheme.grayColor]
                
                let attrString: NSMutableAttributedString = NSMutableAttributedString(string: "Subscription Price ", attributes: attributes)
                
                let attributesPrice: [NSAttributedStringKey : Any] = [NSAttributedStringKey.font : AppTheme.regularFont(withSize: 14), NSAttributedStringKey.foregroundColor : AppTheme.blackColor]
                
                let priceString: String = "$" + String(self.group.groupPrice) + "/Year."
                
                let attrPriceString: NSAttributedString = NSAttributedString(string: priceString, attributes: attributesPrice)
                
                attrString.append(attrPriceString)
                
                self.subscriptionTitleLabel.attributedText = attrString
                self.subscriptionTitleLabel.textAlignment = .center
            }
            else {
                
                self.subscriptionTitleLabel.attributedText = NSAttributedString(string: "")
            }
        }
        else {
            
            self.subscriptionTitleLabel.attributedText = NSAttributedString(string: "")
        }
    }
    
    fileprivate func prepareStripeController() {
     
        let configuration: STPPaymentConfiguration = STPPaymentConfiguration.shared()
        
        let addCardViewController = STPAddCardViewController(configuration: configuration, theme: AppTheme.cardTheme)
        addCardViewController.delegate = self
        
        self.navigationController?.pushViewController(addCardViewController, animated: true)
    }
    
    // MARK:- Web Services
    
    private func sendRequestForUserProfile() {
        
        ApiServices.shared.requestForUserProfile(onTarget: self, self.group.groupCreator.userId, successfull: { (success, userProfile) in
            
            self.groupCreatedProfile = userProfile
            
            self.updateViewDetail()
            
        }) { (failure, errorMessage) in
            
        }
    }
    
    fileprivate func sendRequestForJoinGroup(_ parameters: [String: Any] = [:]) {
        
        if self.group.isUserCanJoin {
            
            self.showPKHUD(WithMessage: "Joining...")
            
            ApiServices.shared.requestForJoinGroup(onTarget: self, String(self.group.groupId), parameters: parameters, successfull: { (success, serverMessage) in
                
                self.hidePKHUD()
                
                if serverMessage != "" {
                    
                    let message: String = serverMessage
                    
                    let alertController: UIAlertController = UIAlertController(title: "Payment", message: message, preferredStyle: .alert)
                    
                    let action: UIAlertAction = UIAlertAction(title: "OK", style: .destructive) { (yesAction) in
                        
                        self.navigationController?.popViewController(animated: true)
                        
                    }
                    
                    alertController.addAction(action)
                    
                    self.present(alertController, animated: true, completion: nil)
                }
                else {
                    
                    self.sendRequestForGroupDetail()
                }
                
            }) { (failure) in
                
                self.hidePKHUD()
            }
        }
    }
    
    private func sendRequestForGroupDetail() {
        
        let parameters: [String:Any] = ["GroupId": self.group.groupId.stringValue]
        
        ApiServices.shared.requestForGroupDetail(onTarget: self, parameters, successfull: { (success, groupObject) in
            
            self.group = groupObject
            
            // If user come from deeplink.
            if self.isDeeplinking {
                
                // If user already member of this group.
                if !self.group.isUserCanJoin {
                    
                    self.openFeedsViewController()
                }
                else {
                
                    self.setupViews()
                }
            }
            
            if self.group.isUserCanJoin {
                
                self.subscriptionButton.isEnabled = true
                self.subscriptionButton.isHidden = false
                self.subscriptionTitleLabel.isHidden = false
                self.gotoGroupDetailButton.isHidden = true
            }
            else {
                
                self.subscriptionButton.isEnabled = false
                self.subscriptionButton.isHidden = true
                self.subscriptionTitleLabel.isHidden = true
                self.gotoGroupDetailButton.isHidden = false
            }
            
            self.updateViewDetail()
            
        }) { (failure) in
            
            
        }
    }
    
    // MARK: - Buttons Action
    
    
    fileprivate func openFeedsViewController() {
        
        let feedViewController: FeedsViewController = AppUI.mainStoryboard.instantiateViewController(withIdentifier: "FeedsViewController") as! FeedsViewController
        feedViewController.isGroupFeeds = true
        feedViewController.groupObject = self.group
        feedViewController.isDeeplinking = self.isDeeplinking
        
        self.navController?.pushViewController(feedViewController, animated: true)
    }
    
    @IBAction func didGotoGroupDetailButtonPressed(_ sender: UIButton) {
        
        self.openFeedsViewController()
    }
    
    @IBAction func didSubscriptionButtonPressed(_ sender: UIButton) {
    
        if self.group.isPaidGroup {
            
            if AppDefaults.isStripeUser() {
                
                if let price = self.group.groupPrice {
                    
                    let message: String = self.group.groupTitle + " is a paid group the joining cost is $\(price). \nAmount will be automatically deducted from your Visa/Credit card.\nAre You sure you want to join?"
                    
                    let alertController: UIAlertController = UIAlertController(title: "Payment", message: message, preferredStyle: .alert)
                    
                    let action: UIAlertAction = UIAlertAction(title: "YES", style: .destructive) { (yesAction) in
                        
                        self.sendRequestForJoinGroup()
                    }
                    
                    let cancelAction: UIAlertAction = UIAlertAction(title: "NO", style: .cancel) { (cancelAction) in
                        
                        self.navigationController?.popViewController(animated: true)
                    }
                    
                    alertController.addAction(action)
                    alertController.addAction(cancelAction)
                    
                    self.present(alertController, animated: true, completion: nil)
                    
                }
            }
            else  {
                
                self.prepareStripeController()
            }
        }
        else {
            
            self.sendRequestForJoinGroup()
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

extension GroupDetailViewController: STPAddCardViewControllerDelegate {
    
    func addCardViewControllerDidCancel(_ addCardViewController: STPAddCardViewController) {
        navigationController?.popViewController(animated: true)
    }
    
    func addCardViewController(_ addCardViewController: STPAddCardViewController,
                               didCreateToken token: STPToken,
                               completion: @escaping STPErrorBlock) {
        print(token)
        navigationController?.popViewController(animated: true)
        self.sendRequestForJoinGroup(["SourceToken":token.tokenId])
        
    }
}
