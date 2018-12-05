//
//  FeedsViewController.swift
//  MarcoApp
//
//  Created by Nabeel Hayat on 10/11/2017.
//  Copyright © 2017 GrayScaleLogic. All rights reserved.
//

import UIKit
import GoogleMaps
//import GooglePlaces
import CoreLocation
import SDWebImage

class FeedsViewController: BaseViewController {
    
    @IBOutlet weak var mainTabView: TabView!
    
    @IBOutlet weak var addFeedButton: UIButton!
    @IBOutlet weak var addFeedView: UIView!
    @IBOutlet weak var addFeedImageView: UIImageView!
    
    @IBOutlet weak var feedsCollectionView: UICollectionView!
    @IBOutlet weak var membersTableView: MembersTableView!
    @IBOutlet weak var addFeedCampaignButton: UIButton!
    @IBOutlet weak var inviteButton: UIButton!
    @IBOutlet weak var addFeedCampaignImageView: UIImageView!
    
    @IBOutlet weak var campaignCollectionView: UICollectionView!
    
    @IBOutlet weak var addFeedCampaignView: UIView!
    @IBOutlet weak var campaignContainerView: UIView!
    @IBOutlet weak var feedContainerView: UIView!
    @IBOutlet weak var membersContainerView: UIView!
    
    @IBOutlet weak var mapContainerView: UIView!
    
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var feedPlaceholderLabel: UILabel!
    @IBOutlet weak var feedCampaignPlaceholderLabel: UILabel!
    @IBOutlet weak var feedMembersPlaceholderLabel: UILabel!
    
    @IBOutlet weak var placeholderView: UIView!
    @IBOutlet weak var campaignPlaceholderView: UIView!
    @IBOutlet weak var membersPlaceholderView: UIView!
    
    @IBOutlet weak var mainTabViewHeightConstraint: NSLayoutConstraint!
    
    
    // MARK: - Variables
    
    private var userAnnotationList: [UserAnnotation] = []
    
    let regionRadius: CLLocationDistance = 1000
    
    @IBInspectable var isGroupFeeds: Bool = false
    
    var isDeeplinking: Bool = false
    
    var isOpenChat: Bool = true
    
    private var isBackground: Bool = false
    
    var userProfile: UserProfile!
    
    var userList: [UserProfile] = [UserProfile]() {
        didSet {
            
            if userList.count > 0 {
                
                self.membersPlaceholderView.isHidden = true
            }
            else {
                
                self.membersPlaceholderView.isHidden = false
            }
        }
    }
    
    var campaignList: [CampaignObject] = [CampaignObject]() {
        
        didSet {
            if campaignList.count > 0 {
                
                self.campaignPlaceholderView.isHidden = true
            }
            else {
                
                self.campaignPlaceholderView.isHidden = false
            }
        }
    }
    
    var postList: [PostObject] = [PostObject]() {
        
        didSet {
            
            if postList.count > 0 {
                
                if self.mainTabView.indexSelected == 0 {
                 
                    self.feedContainerView.isHidden = false
                    self.campaignContainerView.isHidden = true
                    self.mapContainerView.isHidden = true
                    self.membersContainerView.isHidden = true
                    self.placeholderView.isHidden = true
                }
            }
            else {
                
                self.placeholderView.isHidden = false
            }
        }
    }
    
    var postHeightList: [CGFloat] = [CGFloat]()
    
    var groupObject: GroupObject!
    
    fileprivate var isContributePayments: Bool = false
    
    fileprivate var selectedCampaignID: Int!
    fileprivate var campaignAmount: String!
    
//    var locationManager = CLLocationManager()
    var locationManager: CLLocationManager!
    var currentLocation: CLLocation?
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.isBackground = false
        
        self.hideNavigationMenuButtonItem = isGroupFeeds
        self.showBackButtonItem = isGroupFeeds
        // Do any additional setup after loading the view.

        self.setupViews()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.isOpenChat = true
        
        if self.isGroupFeeds {
         
            self.addFeedButton.isHidden = (self.groupObject.groupCreator.userId == loginUserProfile.userId) ? false : true
            self.addFeedImageView.isHidden = (self.groupObject.groupCreator.userId == loginUserProfile.userId) ? false : true
            self.addFeedCampaignButton.isHidden = (self.groupObject.groupCreator.userId == loginUserProfile.userId) ? false : true
            self.addFeedCampaignImageView.isHidden = (self.groupObject.groupCreator.userId == loginUserProfile.userId) ? false : true
            
            
            self.feedCampaignPlaceholderLabel.text = (self.groupObject.groupCreator.userId == loginUserProfile.userId) ? "Please create your first campaign by clicking the button below." : "No active campaigns."
            
            self.feedPlaceholderLabel.text = (self.groupObject.groupCreator.userId == loginUserProfile.userId) ? "You have not created a post yet!" : "No post created."
            self.feedMembersPlaceholderLabel.text = (self.userList.count > 0) ? "" : "Please invite your friends and contact by clicking the Invite Members button."
            
            if self.mainTabView.indexSelected == 0 {
                
                self.sendRequestForGroupPosts(self.isBackground)
                self.isBackground = true
            }
            else if self.mainTabView.indexSelected == 1 {
                
                self.sendRequestForGroupCampaign()
                
            }
            else if self.mainTabView.indexSelected == 2 {
                
                self.sendRequestForGroupMembers(true)
            }
            else if self.mainTabView.indexSelected == 3 {
                
                self.sendRequestForGroupMembers()
                
            }
            
            if self.locationManager == nil {
                
                self.locationManager = CLLocationManager()
                self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
                self.locationManager.requestWhenInUseAuthorization()
                self.locationManager.distanceFilter = 1000
                self.locationManager.startUpdatingLocation()
                self.locationManager.delegate = self
            }
        }
        else {
            
            self.sendRequestForUserFeeds(self.isBackground)
            self.isBackground = true
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        self.isOpenChat = true
    }
    
    override func didBackButtonPressed(_ sender: UIBarButtonItem) {
        super.didBackButtonPressed(sender)
        
        if self.isDeeplinking {
            
            NotificationCenter.default.post(name: NSNotification.Name.DismissGroupControllerNotification, object: nil)
        }
    }
    
    override func didMenuButtonPressed(_ sender: UIBarButtonItem) {
        super.didMenuButtonPressed(sender)
        
    }
    
    override func didTapOnTitleView(_ titleView: NavigationTitleView) {
        super.didTapOnTitleView(titleView)
        
    }
    
    // MARK: - Helper Functions
    
    private func calculatePostsHeight() {
        
        let topViewHeight: CGFloat = 66
        let bottomViewHeight: CGFloat = 0
        
        let width = UIScreen.main.bounds.size.width
        
        let height = width/1.875
        
        let imageViewHeight: CGFloat = height
        let spaceHeight: CGFloat = 16
        
        self.postHeightList.removeAll()
        
        for postObject: PostObject in self.postList {
            
            if postObject.contents.count > 0 {
                
                if postObject.postText != "" {
                    // Text and Image Post
                    
                    var textHeight: CGFloat = postObject.postText.height(withConstrainedWidth: (UIScreen.main.bounds.width - 32), font: AppTheme.regularFont(withSize: 14)) + 16
                    
                    // Minimum height
                    if textHeight < 32 {
                     
                        textHeight = 32
                    }
                    
                    let totalHeight: CGFloat = topViewHeight + imageViewHeight + textHeight + spaceHeight + bottomViewHeight
                    
                    self.postHeightList.append(totalHeight)
                }
                else {
                    // Only Image Post
                 
                    let totalHeight: CGFloat = topViewHeight + imageViewHeight + bottomViewHeight
                    
                    self.postHeightList.append(totalHeight)
                }
            }
            else {
                // Only Text Post
                
                let textHeight: CGFloat = postObject.postText.height(withConstrainedWidth: (UIScreen.main.bounds.width - 32), font: AppTheme.regularFont(withSize: 14)) + 16
                
                let totalHeight: CGFloat = topViewHeight + textHeight + spaceHeight + bottomViewHeight + 17
                
                self.postHeightList.append(totalHeight)
            }
        }
    }
    
    func setupViews() {
        
//        if self.group == nil {
//
//            self.group = UserGroup(index: 20)
//        }
        
//        self.userList = TempDataModel.getList(with: 7)
        
        self.feedContainerView.isHidden = false
        self.mapContainerView.isHidden = true
        self.membersContainerView.isHidden = true
        
        self.addFeedView.isHidden = !self.isGroupFeeds;
        self.addFeedButton.isHidden = !self.isGroupFeeds;
        self.addFeedImageView.isHidden = !self.isGroupFeeds;
        
        if isGroupFeeds {
            
             let rightNavigationItem = UIBarButtonItem(image: UIImage(named: "ic_nb_setting"), style: .done, target: self, action: #selector(didSettingsButtonPressed(_:)))
            
//            let negativeSpace:UIBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.fixedSpace, target: nil, action: nil)
//            negativeSpace.width = -10.0
            self.navigationItem.rightBarButtonItems = [rightNavigationItem]
            
            self.membersTableView.isDiscoverView = true
            self.membersTableView.isChatButtonHidden = true
            self.membersTableView.parentViewController = self
            self.membersTableView.userList = self.userList

            self.mainTabViewHeightConstraint.constant = 68.0
            
            self.mainTabView.setupTabButtons(tabs: ["ic_feed", "icons-campaign", "ic_discover", "ic_groups"], isImages: true)
            
//            var privateGroupString: String = ""
//            
//            if self.groupObject.isPrivateGroup {
//                
//                privateGroupString = "Private Group"
//            }
//            else {
//                
//                privateGroupString = "Public Group"
//            }
//            
//            var groupMembersString: String = ""
//            
//            if self.groupObject.totalMembers.intValue > 1 {
//                
//                groupMembersString = "\(self.groupObject.totalMembers.intValue) Members"
//            }
//            else {
//                
//                groupMembersString = "1 Member"
//            }
//            
//            let text: String = privateGroupString + " - " + groupMembersString
            
//            self.setTitleView(title: self.groupObject.groupTitle, detailTitle: "", avatarImageURL: URL(string: self.groupObject.groupProfilePicture), placehoderImage: UIImage.getImage(withName: "group-default", imageColor: UIColor(hexString: "#cccccc")))
            
            self.setTitleView(title: self.groupObject.groupTitle, detailTitle: "")
        }
        else {
            
//            let rightNavigationItem = UIBarButtonItem(image: UIImage(named: "ic_dropdown"), style: .done, target: self, action: #selector(didMoreOptionButtonPressed(_:)))
            
//            let negativeSpace:UIBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.fixedSpace, target: nil, action: nil)
////            negativeSpace.width = -10.0
//            self.navigationItem.rightBarButtonItems = [rightNavigationItem]
        
//            self.mainTabView.setupTabButtons(tabs: ["RECENT", "NEARBY"])
            self.mainTabViewHeightConstraint.constant = 0.0
        }
        
        self.mainTabView.delegate = self
        
        self.feedsCollectionView.register(UINib(nibName: "FeedsCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "FeedsCollectionViewCell")
        
        self.feedsCollectionView.delegate = self
        self.feedsCollectionView.dataSource = self
        
        self.feedsCollectionView.backgroundColor = AppTheme.tableViewGroupColor
        
        let edgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 150, right: 0)
        self.feedsCollectionView.contentInset = edgeInsets
        self.automaticallyAdjustsScrollViewInsets = false
        
        self.campaignCollectionView.register(UINib(nibName: "CampaignCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "CampaignCollectionViewCell")

        self.campaignCollectionView.delegate = self
        self.campaignCollectionView.dataSource = self
        
        self.campaignCollectionView.backgroundColor = AppTheme.tableViewGroupColor
        
        let edgeInsetsCampaign = UIEdgeInsets(top: 0, left: 0, bottom: 150, right: 0)
        self.campaignCollectionView.contentInset = edgeInsetsCampaign
        
    }
    
    private func loadInitialData() {
        
        var index: Int = 0
        
        for userProfile: UserProfile in self.userList {
            
            let userAnnotation: UserAnnotation = UserAnnotation(userProfile: userProfile, at: index)
            
            self.userAnnotationList.append(userAnnotation)
            
            index = index + 1
        }
    }
    
    func centerMapOnLocation(location: CLLocation) {
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(location.coordinate,
                                                                  self.regionRadius, self.regionRadius)
        self.mapView.setRegion(coordinateRegion, animated: true)
    }
    
    
    fileprivate func setupMapsLayout() {
        
        if self.userAnnotationList.count > 0 {
        
            self.mapView.removeAnnotations(self.userAnnotationList)
        }
        
        self.mapView.delegate = self
        //    mapView.register(ArtworkMarkerView.self, forAnnotationViewWithReuseIdentifier: MKMapViewDefaultAnnotationViewReuseIdentifier)
        if #available(iOS 11.0, *) {
            self.mapView.register(UserAnnotationView.self, forAnnotationViewWithReuseIdentifier: MKMapViewDefaultAnnotationViewReuseIdentifier)
        } else {
            // Fallback on earlier versions
        }
        self.loadInitialData()
        self.mapView.addAnnotations(self.userAnnotationList)
    }
    
    // MARK: - Web Services
    
    fileprivate func sendRequestForUserFeeds(_ isBackground: Bool = false) {
        
        if !isBackground {
            
            self.showPKHUD(WithMessage: "Getting feeds...")
        }
        
        ApiServices.shared.requestForGetUserFeeds(onTarget: self, successfull: { (success, feedsList) in
            
            self.hidePKHUD()
            
            self.postList = feedsList
            
            self.calculatePostsHeight()
            
            self.feedsCollectionView.reloadData()
            
        }) { (failure) in
            
            self.hidePKHUD()
        }
    }
    
    fileprivate func sendRequestForGroupMembers(_ isBackground: Bool = false) {
        
        if !isBackground {
            
            self.showPKHUD(WithMessage: "Getting members...")
        }
        
        ApiServices.shared.requestForGetGroupUsers(onTarget: self, String(self.groupObject.groupId), successfull: { (success, userProfileList) in
            
            self.hidePKHUD()
            
            self.userList = userProfileList
            
            self.membersTableView.userList = self.userList
            
            self.setupMapsLayout()
            
        }) { (failure) in
            
            self.hidePKHUD()
            
        }
    }
    
    fileprivate func sendRequestForGroupPosts(_ isBackground: Bool = false) {
        
        if !isBackground {
            
            self.showPKHUD(WithMessage: "Getting posts...")
        }
        
        let parameters: [String : Any] = ["GroupId":String(self.groupObject.groupId)]
        
        ApiServices.shared.requestForGetGroupPosts(onTarget: self, parameters, successfull: { (successful, postsList) in
            
            self.hidePKHUD()
            
            self.postList = postsList
            
            self.calculatePostsHeight()
            
            if self.mainTabView.indexSelected == 0 {
             
                self.feedsCollectionView.reloadData()
            }
            
        }) { (failure) in
            
            self.hidePKHUD()
        }
    }
    
    fileprivate func sendRequestForGroupCampaign(_ isBackground: Bool = false) {
        
        if !isBackground {
            
            self.showPKHUD(WithMessage: "Getting campaigns...")
        }
        
        let groupId: String = String(self.groupObject.groupId!)
        
        ApiServices.shared.requestForGetGroupCampaigns(onTarget: self, groupId, successfull: { (success, campaignList) in
            
            self.hidePKHUD()
            
            self.campaignList = campaignList
            
            if self.mainTabView.indexSelected == 1 {
                
                self.campaignCollectionView.reloadData()
            }
            
        }) { (failure) in
            
            self.hidePKHUD()
        }
    }
    
    fileprivate func sendRequestForContributePayments(_ token: String) {
        
        if !self.isContributePayments {
            
            self.isContributePayments = true
            
            if let campaignId = self.selectedCampaignID {
                
                if let amount = self.campaignAmount {
                    
                    let parameters: [String : Any] = ["Amount" : amount as Any, "CampaignId" : campaignId as Any, "Token" : token]
                    
                    ApiServices.shared.requestForMakeCampaignPayment(onTarget: self, parameters, successfull: { (success) in
                        
                        self.campaignAmount = nil
                        self.selectedCampaignID = nil
                        
                        self.navigationController?.popViewController(animated: true)
                        self.dismiss(animated: true, completion: nil)
                        
                    }) { (failure) in
                        
                        
                    }
                }
            }
        }
    }
    
    
    // MARK: - Buttons Action
    
    @objc func didSettingsButtonPressed(_ sender: UIButton) {
        
        if self.isGroupFeeds {
            
            let groupSettingViewController: GroupSettingViewController = self.storyboard?.instantiateViewController(withIdentifier: "GroupSettingViewController") as! GroupSettingViewController
            
            groupSettingViewController.groupObject = self.groupObject
            
            self.navigationController?.pushViewController(groupSettingViewController, animated: true)
        }
        else {
            
        }
    }
    
    @objc func didMoreOptionButtonPressed(_ sender: UIButton) {
        
        
    }
    
    @IBAction func myLocationButtonPressed(_ sender: UIButton) {
        
        
    }
    

    @IBAction func didInviteButtonPressed(_ sender: UIButton) {
        
        self.showPKHUD(WithMessage: "Generating link...")
        
        guard let groupId:Int = self.groupObject.groupId else {
           
            self.hidePKHUD()
            return
        }
        
        let groupCoverPicture: String = (self.groupObject.groupCoverPicture == nil) ? "" : self.groupObject.groupCoverPicture
        let groupTitle: String = (self.groupObject.groupTitle == nil) ? "" : self.groupObject.groupTitle
        let groupDescription: String = (self.groupObject.groupDescription == nil) ? "" : self.groupObject.groupDescription
        
        _ = self.getFirebaseDeeplinkWithPreview(itemId: groupId.stringValue, imageUrlString: groupCoverPicture, titleText: groupTitle, descriptionText: groupDescription, lastComponent: "api/Groups", extraParam: "") { (shortURL, warnings, error) in
            
            self.showAppsActivityController(shortURL!)
        }
        
    }
    
    fileprivate func showAppsActivityController(_ shortURL: URL) {
        
        DispatchQueue.global(qos: .userInitiated).async {
            DispatchQueue.main.async {
                
                self.hidePKHUD()
                
                print(shortURL.absoluteString)
                
                let activityViewControntroller: UIActivityViewController = UIActivityViewController(activityItems: [shortURL.absoluteString], applicationActivities: nil)
                
                if #available(iOS 11.0, *) {
                    activityViewControntroller.excludedActivityTypes = [UIActivityType.airDrop, UIActivityType.print, UIActivityType.addToReadingList, UIActivityType.saveToCameraRoll, UIActivityType.markupAsPDF, UIActivityType.openInIBooks]
                } else {
                    // Fallback on earlier versions
                    activityViewControntroller.excludedActivityTypes = [UIActivityType.airDrop, UIActivityType.print, UIActivityType.addToReadingList, UIActivityType.saveToCameraRoll, UIActivityType.openInIBooks]
                }
                
                if UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiom.pad {
                    
                    activityViewControntroller.popoverPresentationController?.sourceView = self.view
                    activityViewControntroller.popoverPresentationController?.sourceRect = CGRect(x: self.view.bounds.size.width/2, y: self.view.bounds.size.height/4, width: 0, height: 0)
                }
                
                self.present(activityViewControntroller, animated: true, completion: nil)
            }
        }
    }
    
    @IBAction func didAddFeedButtonPressed(_ sender: UIButton) {
        
        let createPostViewController: CreatePostViewController = self.storyboard?.instantiateViewController(withIdentifier: "CreatePostViewController") as! CreatePostViewController
        createPostViewController.groupId = String(self.groupObject.groupId)
        self.navigationController?.pushViewController(createPostViewController, animated: true)
    }
    
    @IBAction func didCreateCampaignButtonPressed(_ sender: UIButton) {
        
        let createPostViewController: CreateCampaignViewController = self.storyboard?.instantiateViewController(withIdentifier: "CreateCampaignViewController") as! CreateCampaignViewController
        //        let createPostViewController: CreatePostViewController = self.storyboard?.instantiateViewController(withIdentifier: "CreatePostViewController") as! CreatePostViewController
        createPostViewController.groupId = String(self.groupObject.groupId)
        self.navigationController?.pushViewController(createPostViewController, animated: true)
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

extension FeedsViewController: TabViewDelegate {

    func tabView(_ tabView: TabView, selectionChanged: Int) {
        
        if self.isGroupFeeds {
        
            if selectionChanged == 0 {
                
                self.sendRequestForGroupPosts(true)
                
                if postList.count > 0 {
                    
                    self.placeholderView.isHidden = true
                }
                else {
                    
                    self.placeholderView.isHidden = false
                }
                
                self.feedContainerView.isHidden = false
                self.campaignContainerView.isHidden = true
                self.mapContainerView.isHidden = true
                self.membersContainerView.isHidden = true
            }
            else if selectionChanged == 1 {
                
                self.sendRequestForGroupCampaign(true)
                
                self.placeholderView.isHidden = true
                self.feedContainerView.isHidden = true
                self.campaignContainerView.isHidden = false
                self.mapContainerView.isHidden = true
                self.membersContainerView.isHidden = true
            }
            else if selectionChanged == 2 {
                
                self.sendRequestForGroupMembers(true)
             
                self.placeholderView.isHidden = true
                self.feedContainerView.isHidden = true
                self.campaignContainerView.isHidden = true
                self.mapContainerView.isHidden = false
                self.membersContainerView.isHidden = true
            }
            else if selectionChanged == 3 {
                
                self.sendRequestForGroupMembers(true)
                
                self.placeholderView.isHidden = true
                self.feedContainerView.isHidden = true
                self.campaignContainerView.isHidden = true
                self.mapContainerView.isHidden = true
                self.membersContainerView.isHidden = false
            }
            
        }
        else {
            
            self.placeholderView.isHidden = (self.postList.count > 0) ? true : false
        
            if selectionChanged == 0 {
                
            }
            else if selectionChanged == 1 {
                
            }
        }
    }
}

extension FeedsViewController: CampaignCollectionViewCellDelegate {
    
    func campaignCollectionViewCell(_ Cell: CampaignCollectionViewCell, didContributePressed: UIButton, at indexPath: IndexPath) {
        
        let campaignObject: CampaignObject = self.campaignList[indexPath.row]
        
        //1. Create the alert controller.
        let alert: UIAlertController = UIAlertController(title: "Contribution", message: "", preferredStyle: .alert)
        
        let image = UIImage(named: "")
        
        let config: TextField.Config = { textField in
            textField.becomeFirstResponder()
            textField.textColor = .black
            textField.placeholder = "Amount in USD"
            textField.left(image: image, color: .black)
            textField.leftViewPadding = 12
            textField.borderWidth = 1
            textField.cornerRadius = 8
            textField.borderColor = UIColor.lightGray.withAlphaComponent(0.5)
            textField.backgroundColor = nil
            textField.keyboardAppearance = .default
            textField.keyboardType = .decimalPad
            textField.isSecureTextEntry = false
            textField.returnKeyType = .done
            textField.action { textField in
                
                let payAction: UIAlertAction = alert.actions[0]
                payAction.isEnabled = (textField.text != "") ? true : false
            }
        }
        
        //2. Add the text field. You can configure it however you need.
        alert.addOneTextField(configuration: config)
        
        // 4. Do nothing and dismiss alert
        alert.addAction(UIAlertAction(title: "CANCEL", style: .default, handler: nil))
        
        // 3. Grab the value from the text field, and print it when the user clicks Pay.
        alert.addAction(UIAlertAction(title: "PAY", style: .cancel, handler: { [weak alert] (_) in
           // Content View controller is custom controller with custome text field.
            let oneTextFieldViewController: OneTextFieldViewController = alert?.value(forKey: "contentViewController") as! OneTextFieldViewController
            
            print("Text field: \(oneTextFieldViewController.text)")
            
            self.campaignAmount = oneTextFieldViewController.text
            
            self.campaignAmount = (self.campaignAmount as NSString).replacingOccurrences(of: "$", with: "")
            
            if self.campaignAmount != "" && self.campaignAmount != nil {
                
                self.isContributePayments = false
                
                self.selectedCampaignID = campaignObject.campaignId
                
                let configuration: STPPaymentConfiguration = STPPaymentConfiguration.shared()
                
                let addCardViewController = STPAddCardViewController(configuration: configuration, theme: AppTheme.cardTheme)
                addCardViewController.delegate = self
                
                self.navigationController?.pushViewController(addCardViewController, animated: true)
            }
            else  {
                
                let alertViewController: UIAlertController = UIAlertController(title: "Warning", message: "Please enter amount for contribution.", preferredStyle: .alert)
                
                let action: UIAlertAction = UIAlertAction(title: "OK", style: .default) { (alertAction) in
                    
                    
                }
                
                alertViewController.addAction(action)
                
                self.present(alertViewController, animated: true, completion: nil)
            }
        }))
        
        
        
        // 5. Present the alert.
        self.present(alert, animated: true, completion: nil)
        
//        let campaignObject: CampaignObject = self.campaignList[indexPath.row]
//
//        let addCardViewController: PaymentViewController = self.storyboard?.instantiateViewController(withIdentifier: "PaymentViewController") as! PaymentViewController
//
//        addCardViewController.campaignObject = campaignObject
//        self.navigationController?.pushViewController(addCardViewController, animated: true)
    }
}
extension FeedsViewController: UIScrollViewDelegate {
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        
        UIView.animate(withDuration: 0.5) {
            
            self.addFeedCampaignView.alpha = 0
            self.addFeedView.alpha = 0
        }
    }
    
    func scrollViewWillBeginDecelerating(_ scrollView: UIScrollView) {
        
        UIView.animate(withDuration: 0.5) {
            
            self.addFeedCampaignView.alpha = 0
            self.addFeedView.alpha = 0
        }
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        
        UIView.animate(withDuration: 0.5) {
            
            self.addFeedCampaignView.alpha = 1
            self.addFeedView.alpha = 1
        }
    }
    
    func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
     
        UIView.animate(withDuration: 0.5) {
            
            self.addFeedCampaignView.alpha = 1
            self.addFeedView.alpha = 1
        }
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        
        UIView.animate(withDuration: 0.5) {
            
            self.addFeedCampaignView.alpha = 1
            self.addFeedView.alpha = 1
        }
    }
}


extension FeedsViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    // MARK: - DiscoverCollectionDelegate
    
//    func discoverCollectionViewCell(_ cell: DiscoverCollectionViewCell, didJoinGroupPressed sender: UIButton, at indexPath: IndexPath) {
//        
//        let groupDetailViewController: GroupDetailViewController = self.storyboard?.instantiateViewController(withIdentifier: "GroupDetailViewController") as! GroupDetailViewController
//        
//        self.navigationController?.pushViewController(groupDetailViewController, animated: true)
//    }
//    
//    func discoverCollectionViewCell(_ cell: DiscoverCollectionViewCell, didMoreOptionPressed sender: UIButton, at indexPath: IndexPath) {
//        
//    }
    
    // MARK: UICollectionViewDataSource
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        
        return 1
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {

        return (self.mainTabView.indexSelected == 0) ? self.postList.count : self.campaignList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if self.mainTabView.indexSelected == 0 {
         
            let cell: FeedsCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: "FeedsCollectionViewCell", for: indexPath) as! FeedsCollectionViewCell
            
            let postObject: PostObject = self.postList[indexPath.row]
            
            //        let imageName = self.group.feedList[indexPath.row]
            //
            //        cell.feedImageView.image = UIImage(named: imageName)
            cell.userNameLabel.text = postObject.createdByUser.fullName
            
            if postObject.createdByUser.profilePicture != nil && postObject.createdByUser.profilePicture != "" {
                
                let urlString: URL = URL(string: postObject.createdByUser.profilePicture)!
                
                cell.userAvatarImageView.sd_setImage(with: urlString, placeholderImage: UIImage(named: "user_default")) { (image, error, imageCacheType, url) in
                    
                }
            }
            else {
                
                cell.userAvatarImageView.image = UIImage(named: "user_default")
            }
            
            //        cell.likeImageView.image = UIImage.getImage(withName: "ic_heart_filled", imageColor: AppTheme.likeHeartColor)
            //
            //        //cell.likeImageView.image = UIImage.getImage(withName: "ic_heart_outline", imageColor: AppTheme.grayColor)
            //        cell.commentImageView.image = UIImage.getImage(withName: "ic_comment", imageColor: AppTheme.grayColor)
            //        cell.shareImageView.image = UIImage.getImage(withName: "ic_link", imageColor: AppTheme.grayColor)
            
            //2018-04-18T15:17:00.373
            
            let createdDate: String = postObject.postCreatedDate
            let localDate = AppFunctions.getDateFromServerString(createdDate).prettyDate()
            
            let attributedText: NSMutableAttributedString = NSMutableAttributedString(string: localDate)
            
            cell.feedPostDetailLabel.attributedText = attributedText.setFont(font: AppTheme.regularFont(withSize: 14), kerningValue: -60.0)
            
            if postObject.postText != "" {
                
                let attributedTitleText: NSMutableAttributedString = NSMutableAttributedString(string: postObject.postText)
                
                cell.feedTitleLabel.attributedText = attributedTitleText.setFont(font: AppTheme.regularFont(withSize: 14), kerningValue: 20.0)
            }
            
            //        let attributedTimeText: NSMutableAttributedString = NSMutableAttributedString(string: "18 min ago")
            //
            //        cell.feedTimeLabel.attributedText = attributedTimeText.setFont(font: AppTheme.regularFont(withSize: 10), kerningValue: 30.0)
            
            cell.feedTimeLabel.isHidden = true
            
            if postObject.contents.count > 0 {
                
                cell.feedImageHeightConstaint.constant = 200
                
                let postContent: PostContent = postObject.contents[0]
                
                if postContent.contentURL != "" {
                    
                    let urlString: URL = URL(string: postContent.contentURL)!
                    
                    cell.feedImageView.sd_setImage(with: urlString, placeholderImage: nil) { (image, error, imageCacheType, url) in
                        
                    }
                    
                }
                else {
                    
                    cell.feedImageView.image = nil
                }
            }
            else {
                
                cell.feedImageHeightConstaint.constant = 0
            }
            
            return cell
        }
        else /*if self.mainTabView.indexSelected == 1*/ {
            
            let cellCampaign: CampaignCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: "CampaignCollectionViewCell", for: indexPath) as! CampaignCollectionViewCell
            
            cellCampaign.delegate = self
            cellCampaign.indexPath = indexPath
            
            let campaignObject: CampaignObject = self.campaignList[indexPath.row]
            
            cellCampaign.titleLabel.text = campaignObject.titleCampaign
            cellCampaign.descriptionLabel.text = campaignObject.descriptionCampaign
            
            cellCampaign.percentageLabel.text = "90%"
        
        
            if campaignObject.terminateCampaign == "Time                " || campaignObject.terminateCampaign == "Time" {
                
                self.collectionView(collectionView, timedCampaign: cellCampaign, at: indexPath)
            }
            else {
                
                self.collectionView(collectionView, collectionCampaign: cellCampaign, at: indexPath)
            }
            
            if let contribution: CGFloat = campaignObject.contributionCampaign {
                
                if contribution > 0.0 {
                
                    cellCampaign.contributeButton.isHidden = true
                    cellCampaign.contributeImageView.isHidden = true
                    cellCampaign.contributedLabel.isHidden = false
                    
                    cellCampaign.contributedLabel.text = "You Contributed - $\(contribution)"
                }
                else {
                    
                    cellCampaign.contributeButton.isHidden = false
                    cellCampaign.contributeImageView.isHidden = false
                    cellCampaign.contributedLabel.isHidden = true
                }
                
            }
            else  {
                
                cellCampaign.contributeButton.isHidden = false
                cellCampaign.contributeImageView.isHidden = false
                cellCampaign.contributedLabel.isHidden = true
            }
            
            if let contributor: Int = campaignObject.contributorCampaign {
                
                cellCampaign.contributorLabel.text = (contributor > 0) ? "\(contributor)" : "--"
            }
            else {
                
                cellCampaign.contributorLabel.text = "--"
            }
            
            if let userProfile: UserProfile = campaignObject.createdByUser {
                
                if userProfile.profilePicture != nil && userProfile.profilePicture != "" {
                    
                    let urlString: URL = URL(string: userProfile.profilePicture)!
                    
                    cellCampaign.userImageView.sd_setImage(with: urlString, placeholderImage: UIImage(named: "user_default")) { (image, error, imageCacheType, url) in
                        
                    }
                }
                else {
                    
                    cellCampaign.userImageView.image = UIImage(named: "user_default")
                }
            }
            else {
                
                cellCampaign.userImageView.image = UIImage(named: "user_default")
            }
            
            return cellCampaign
        }
    }
    
    fileprivate func collectionView(_ collectionView: UICollectionView, timedCampaign cell: CampaignCollectionViewCell, at indexPath: IndexPath) {
        
        let campaignObject: CampaignObject = self.campaignList[indexPath.row]
        
        cell.remainingDaysView.isHidden = false
        cell.remainingAmountView.isHidden = true
        
        cell.targetAmountLabel.text = "--"
        
        
        cell.targetLeadingConstraint.constant = -(cell.frame.size.width / 2);
        
        cell.collectedAmountLabel.textColor = AppTheme.blackColor
        
        if let endDateString  = campaignObject.endDateCampaign {
        
            cell.remainingLabel.text = self.getRemainingDaysWithEndDate(endDateString)
        }
        else  {
            
            cell.remainingLabel.text = "--"
        }
        
        
        if let collectedAmount: CGFloat = campaignObject.collectedCampaign {
            
            cell.collectedAmountLabel.text = (collectedAmount == 0.0) ? "--" : "\(collectedAmount)"
        }
        else {
            
            cell.collectedAmountLabel.text = "--"
        }
        
    }
    
    fileprivate func getRemainingDaysWithEndDate(_ endDateString: String!) -> String {
        
//        2018-09-29T18:00:00
//        2018-05-04T15:24:16.743
        
        let endDate: Date = AppFunctions.getDateFromServerString2(endDateString)
        
//        let dateFormater: DateFormatter = DateFormatter()
//
//        dateFormater.dateFormat = "yyy-MM-dd"
//
//        if let endDate: Date = dateFormater.date(from: endDateString!) {
//
            return endDate.daysRemaining()
//        }
        
        return "0"
    }
    
    fileprivate func collectionView(_ collectionView: UICollectionView, collectionCampaign cell: CampaignCollectionViewCell, at indexPath: IndexPath) {
        
        let campaignObject: CampaignObject = self.campaignList[indexPath.row]
        
        cell.remainingDaysView.isHidden = true
        cell.remainingAmountView.isHidden = false
        
        cell.targetLeadingConstraint.constant = 0;
        
        if let targetAmount: CGFloat = campaignObject.amountCampaign {
            
            cell.targetAmountLabel.text = (targetAmount == 0.0) ? "--" : "\(targetAmount)"
            
            if let collectedAmount: CGFloat = campaignObject.collectedCampaign {
                
                if targetAmount > collectedAmount {
                    
                    cell.collectedAmountLabel.textColor = UIColor.red
                    
                    cell.amountRemainingLabel.text = "$\(targetAmount - collectedAmount) remaining"
                }
                else if targetAmount == collectedAmount {
                    
                    cell.collectedAmountLabel.textColor = UIColor.green
                    
                    cell.amountRemainingLabel.text = "You have achived your target."
                }
                else if targetAmount < collectedAmount {
                    
                    cell.collectedAmountLabel.textColor = UIColor.green
                    
                    let extraAmount = collectedAmount - targetAmount
                    cell.amountRemainingLabel.text = "You have achived your target."
                }
                
                cell.collectedAmountLabel.text = (collectedAmount == 0.0) ? "--" : "\(collectedAmount)"
            }
            else {
                
                cell.collectedAmountLabel.textColor = UIColor.red
                
                cell.collectedAmountLabel.text = "--"
                cell.amountRemainingLabel.text = "--"
            }
        }
        else {
            
            cell.targetAmountLabel.text = "--"
            cell.amountRemainingLabel.text = "--"
        }
    }
    
    // MARK: UICollectionViewDelegateFlowLayout
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        if self.mainTabView.indexSelected == 0 {
            
            let cellHeight: CGFloat = self.postHeightList[indexPath.row]
            
            return CGSize(width: self.view.frame.size.width, height: cellHeight)
        }
        else {
            
            return CGSize(width: self.view.frame.size.width, height: 290)
        }
    }
    
    // MARK: UICollectionViewDelegate
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if self.mainTabView.indexSelected == 0 {
        
            let postObject: PostObject = self.postList[indexPath.row]

            let feedDetailViewController: FeedDetailViewController = AppUI.mainStoryboard.instantiateViewController(withIdentifier: "FeedDetailViewController") as! FeedDetailViewController
            
            feedDetailViewController.postObject = postObject
            
            self.navigationController?.pushViewController(feedDetailViewController, animated: true)
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

extension FeedsViewController: STPAddCardViewControllerDelegate {
    
    func addCardViewControllerDidCancel(_ addCardViewController: STPAddCardViewController) {
        navigationController?.popViewController(animated: true)
    }
    
    func addCardViewController(_ addCardViewController: STPAddCardViewController,
                               didCreateToken token: STPToken,
                               completion: @escaping STPErrorBlock) {
        
        
        self.sendRequestForContributePayments(token.tokenId)
        
    }
}

extension FeedsViewController: CLLocationManagerDelegate {
    
    // MARK: - CLLocationManager
    
    func checkLocationAuthorizationStatus() {
        if CLLocationManager.authorizationStatus() == .authorizedAlways {
            mapView.showsUserLocation = true
        } else {
            locationManager.requestAlwaysAuthorization()
        }
    }
    
    // MARK: - CLLocationManagerDelegate
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        if let location = locations.first {
            
            let initialLocation = CLLocation(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
            self.centerMapOnLocation(location: initialLocation)
            
        }
    }
    
    // Handle authorization for the location manager.
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .restricted:
            print("Location access was restricted.")
        case .denied:
            print("User denied access to location.")
            // Display the map using the default location.
            mapView.isHidden = false
            locationManager.requestAlwaysAuthorization()
        case .notDetermined:
            print("Location status not determined.")
        case .authorizedAlways: fallthrough
        case .authorizedWhenInUse:
            print("Location status is OK.")
            
            mapView.showsUserLocation = true
        }
    }
    
    // Handle location manager errors.
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        locationManager.stopUpdatingLocation()
        print("Error: \(error)")
    }
}

// MARK: - MKMapViewDelegate

extension FeedsViewController: MKMapViewDelegate {
    
    //   1
      func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        guard let annotation = annotation as? UserAnnotation else { return nil }
        // 2
        let identifier = "marker"
        if #available(iOS 11.0, *) {
            var view: UserAnnotationView
            
            if let dequeuedView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier)
                as? UserAnnotationView { // 3
                dequeuedView.annotation = annotation
                view = dequeuedView
            } else {
                // 4
                view = UserAnnotationView(annotation: annotation, reuseIdentifier: identifier)
            }
            return view
        } else {
            // Fallback on earlier versions
            
            return nil
        }
        
      }
    
    func mapView(_ mapView: MKMapView,
                 didSelect view: MKAnnotationView)
    {
        // 1
        if view.annotation is MKUserLocation
        {
            // Don't proceed with custom callout
            return
        }
        // 2
        let annotation = view.annotation as! UserAnnotation

        let detailAnnotationView: UserDetailAnnotationView = UserDetailAnnotationView(frame: CGRect(x: 0, y: 0, width: 320, height: 74))
        
        let url = (annotation.discipline == "") ? nil : URL(string: annotation.discipline)!
        
        detailAnnotationView.set(Title: annotation.title!, imageUrl: url) { (sender) in
        
            if self.isOpenChat {
                
                self.isOpenChat = false
                
                if annotation.userProfile.channel != "" {
                    
                    self.appDelegate.pubNubAddPushNotifications([annotation.userProfile.channel]) { (status) in
                        
                        print(status.description)
                    }
                    
                    self.subscribeToChannel(annotation.userProfile.channel)
                    
                    let chatViewController: ChatViewController = self.storyboard?.instantiateViewController(withIdentifier: "ChatViewController") as! ChatViewController
                    
                    chatViewController.userProfile = annotation.userProfile
                    chatViewController.loginUserProfile = self.loginUserProfile
                    self.navigationController?.pushViewController(chatViewController, animated: true)
                }
            }
            
        }
        
        detailAnnotationView.center = CGPoint(x: view.bounds.size.width / 2, y: -detailAnnotationView.bounds.size.height*0.52)
        
        view.addSubview(detailAnnotationView)
        
        mapView.setCenter((view.annotation?.coordinate)!, animated: true)
        
//        let calloutView = views?[0] as! CustomCalloutView
//        calloutView.starbucksName.text = starbucksAnnotation.name
//        calloutView.starbucksAddress.text = starbucksAnnotation.address
//        calloutView.starbucksPhone.text = starbucksAnnotation.phone
//        calloutView.starbucksImage.image = starbucksAnnotation.image
//        let button = UIButton(frame: calloutView.starbucksPhone.frame)
//        button.addTarget(self, action: #selector(ViewController.callPhoneNumber(sender:)), for: .touchUpInside)
//        calloutView.addSubview(button)
//        // 3
//        calloutView.center = CGPoint(x: view.bounds.size.width / 2, y: -calloutView.bounds.size.height*0.52)
//        view.addSubview(calloutView)
//        mapView.setCenter((view.annotation?.coordinate)!, animated: true)
    }
    
    func mapView(_ mapView: MKMapView, didDeselect view: MKAnnotationView) {
        if #available(iOS 11.0, *) {
            if view.isKind(of: UserAnnotationView.self)
            {
                for subview in view.subviews
                {
                    subview.removeFromSuperview()
                }
            }
        } else {
            // Fallback on earlier versions
        }
    }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView,
                 calloutAccessoryControlTapped control: UIControl) {
//        let location = view.annotation as! UserAnnotation
//        let launchOptions = [MKLaunchOptionsDirectionsModeKey:
//            MKLaunchOptionsDirectionsModeDriving]
//        location.mapItem().openInMaps(launchOptions: launchOptions)
    }
}

