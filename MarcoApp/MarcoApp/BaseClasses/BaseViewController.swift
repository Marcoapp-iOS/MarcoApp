//
//  BaseViewController.swift
//  MarcoApp
//
//  Created by Nabeel Hayat on 28/10/2017.
//  Copyright © 2017 GrayScaleLogic. All rights reserved.
//

import UIKit
import CoreData
import MagicalRecord
import FacebookCore
import FacebookLogin
import Firebase


typealias ConfirmBlock = (_ alertAction: UIAlertAction) -> Void
typealias CancelBlock = (_ alertAction: UIAlertAction) -> Void

class BaseViewController: UIViewController, NavigationTitleViewDelegate {

    private var leftNavigationItem: UIBarButtonItem!
    
    lazy var loginUserProfile: UserProfile = {
        
        let loginUser: LoginUser = AppFunctions.getLoginUser()
        
        let userProfile: UserProfile = AppFunctions.getUserProfile(from: loginUser.userId)
        
        return userProfile
    }()
    
    lazy var loginManager: LoginManager = {
        return appDelegate.loginManager
    }()
    
    var hideNavigationMenuButtonItem: Bool = false {
    
        didSet {
        
            switch hideNavigationMenuButtonItem {
            case true:
                
                self.hideMenuItemButton()
                
                break
            case false:
                
                self.showMenuItemButton()
                
                break
            }
        }
    }
    
    var showBackButtonItem: Bool = false {
    
        didSet {
            
            switch showBackButtonItem {
            case true:
                self.hideNavigationMenuButtonItem = true
                self.showBackItemButton()
                break
            case false:
                self.hideNavigationMenuButtonItem = false
                self.hideBackItemButton()
                break
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.hideNavigationMenuButtonItem = false
        self.showBackButtonItem = false
        // Do any additional setup after loading the view.
        
        self.navigationController?.navigationBar.sizeToFit()
        
        
        
//        guard  let statusBar = UIApplication.shared.value(forKeyPath: "statusBarWindow.statusBar") as? UIView else {
//            return
//        }
//
//        statusBar.backgroundColor = UIColor(red: 2, green: 200.0, blue: 200, alpha: 0)
//
//        statusBar.alpha = 0;
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
     
        if AppDefaults.getLoggedUserId() != "" && AppDefaults.isAppLoggedIn(){
        
            self.appDelegate.checkLocationChanges()
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if #available(iOS 11.0, *) {
            self.additionalSafeAreaInsets.top = 22
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    }
    
    override var prefersStatusBarHidden: Bool {
        get {
            return true
        }
    }
    
    open override var shouldAutorotate: Bool {
        get {
            return false
        }
    }
    
    override open var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .portrait
    }
    
    override open var preferredInterfaceOrientationForPresentation: UIInterfaceOrientation {
        return .portrait
    }

    // MARK: - Helper Varibales
    
    var navigationBar: BaseNavigationBar? {
        
        if let navigationController = self.navController {
            
            return navigationController.navigationBar as? BaseNavigationBar
        }
        else {
            
            return nil
        }
    }

    var navController: BaseNavigationController? {
        
        if let navigationController: BaseNavigationController = self.navigationController as? BaseNavigationController {
            
            return navigationController
        }
        else {
        
            return nil
        }
    }
    
    // MARK: - NavigationTitleViewDelegate
    
    func didTapOnTitleView(_ titleView: NavigationTitleView) {
        
        
    }
    
    // MARK: - Helper Functions
    
    func setTitleView(title: String, detailTitle: String, avatarImageURL: URL? = nil, placehoderImage: UIImage? = nil) {
    
        let titleView: NavigationTitleView = NavigationTitleView(frame: CGRect(x: 0, y: 0, width: 320, height: 44), title: title, detailTitle: detailTitle, avatarImageURL:
            avatarImageURL, placehoderImage: placehoderImage)
        
        titleView.delegate = self
        
//    titleView.backgroundColor = UIColor.red
        self.navigationItem.titleView  = titleView;
        
//        self.navigationItem.titleView?.frame = CGRect(x: 0, y: 0, width: 380, height: 64)
    }
    
    func showBackItemButton() {
    
        if self.leftNavigationItem == nil {
            
            self.leftNavigationItem = UIBarButtonItem(image: UIImage(named: "ic_nb_back"), style: .done, target: self, action: #selector(didBackButtonPressed(_:)))
            
            self.navigationItem.leftBarButtonItem = self.leftNavigationItem
        
//            let leftEdgeInsets: UIEdgeInsets = UIEdgeInsets(top: 0, left: -10, bottom: 0, right: 0)
            
//            self.navigationItem.leftBarButtonItem?.imageInsets = leftEdgeInsets
            
        }
    }
    
    func hideBackItemButton() {
        
        if self.leftNavigationItem != nil {
            
            self.leftNavigationItem = nil
        }
        
        self.navigationItem.backBarButtonItem = nil;
    }
    
    func showMenuItemButton() {
    
        if self.leftNavigationItem == nil {
        
            self.leftNavigationItem = UIBarButtonItem(image: UIImage(named: "ic_nb_menu"), style: .done, target: self, action: #selector(didMenuButtonPressed(_:)))
            
            self.navigationItem.leftBarButtonItem = self.leftNavigationItem
            
//            let leftEdgeInsets: UIEdgeInsets = UIEdgeInsets(top: 0, left: -10, bottom: 0, right: 0)
//            
//            self.navigationItem.leftBarButtonItem?.imageInsets = leftEdgeInsets
        }
    }
    
    func hideMenuItemButton() {
    
        if self.leftNavigationItem != nil {
            
            self.leftNavigationItem = nil
        }
        
        self.navigationItem.leftBarButtonItem = nil;
    }
    
    func showAlert(_ title: String, _ message: String, _ preferredStyle: UIAlertControllerStyle,  tintColor: UIColor = AppTheme.blueColor, _ confirmTitle: String, _ confirmAction: @escaping ConfirmBlock) {
        
        //        let alert: UIAlertController = UIAlertController(title: title, message: message, preferredStyle: preferredStyle)
        
        let alert: UIAlertController = UIAlertController(style: preferredStyle, source: nil, title: title, message: message, tintColor: tintColor)
        
        let okayAction: UIAlertAction = UIAlertAction(title: confirmTitle, style: .default) { (alertAction) in
            
            confirmAction(alertAction)
        }
        
        alert.addAction(okayAction)
        
        self.present(alert, animated: true, completion: nil)
    }
    
    func showAlert(_ title: String, _ message: String, _ preferredStyle: UIAlertControllerStyle,  tintColor: UIColor = AppTheme.blueColor, _ confirmTitle: String, _ confirmAction: @escaping ConfirmBlock, _ cancelTitle: String, _ cancelAction: @escaping CancelBlock) {
        
//        let alert: UIAlertController = UIAlertController(title: title, message: message, preferredStyle: preferredStyle)

        let alert: UIAlertController = UIAlertController(style: preferredStyle, source: nil, title: title, message: message, tintColor: tintColor)
        
        let okayAction: UIAlertAction = UIAlertAction(title: confirmTitle, style: .default) { (alertAction) in
            
            confirmAction(alertAction)
        }
        
        let cancelAction: UIAlertAction = UIAlertAction(title: cancelTitle, style: .cancel) { (alertAction) in
            
            cancelAction(alertAction)
        }
        
        alert.addAction(okayAction)
        alert.addAction(cancelAction)
        
        self.present(alert, animated: true, completion: nil)
    }
    
    func showHUD() {
    
    }
    
    // MARK: - Dynamic links
    
    func getSocialMetaTagParameters(imageUrlString: String, titleText: String, descriptionText: String) -> DynamicLinkSocialMetaTagParameters {
        
        let imageUrl: URL = URL(string: imageUrlString)!
        let socialMetaTag: DynamicLinkSocialMetaTagParameters = DynamicLinkSocialMetaTagParameters()
        
        socialMetaTag.imageURL = imageUrl
        socialMetaTag.title = titleText
        socialMetaTag.descriptionText = descriptionText
        
        return socialMetaTag
    }
    
    func getAndroidParameters() -> DynamicLinkAndroidParameters {
        
        let androidParameters: DynamicLinkAndroidParameters = DynamicLinkAndroidParameters(packageName: AppConstants.kDynamicLink_AndroidPackageID)
        
        androidParameters.minimumVersion = AppConstants.kDynamicLink_AndroidMiniVersion
        
        return androidParameters
    }
    
    func getIOSParameters() -> DynamicLinkIOSParameters {
        
        let bundleIdentifier: String = Bundle.main.bundleIdentifier!
        let bundleVersion: String = Bundle.main.infoDictionary!["CFBundleShortVersionString"] as! String
        
        let iOSParameters: DynamicLinkIOSParameters = DynamicLinkIOSParameters(bundleID: bundleIdentifier)
        iOSParameters.minimumAppVersion = bundleVersion
        iOSParameters.appStoreID = AppConstants.kDynamicLink_AppStoreID
        iOSParameters.customScheme = AppConstants.kDynamicLink_CustomScheme
        
        return iOSParameters
    }
    
    func getFireBaseDeeplink(itemId: String, lastComponent: String, completionHandler: @escaping DynamicLinkShortenerCompletion) -> String {
        
        return self.getFireBaseDeeplink(itemId: itemId, lastComponent: lastComponent, extraParam: "", completionHandler: completionHandler)
    }
    
    func getFireBaseDeeplink(itemId: String, lastComponent: String, extraParam: String, completionHandler: @escaping DynamicLinkShortenerCompletion) -> String {
        
        return self.getFirebaseDeeplinkWithPreview(itemId: itemId, imageUrlString: "", titleText: "", descriptionText: "", lastComponent: lastComponent, extraParam: extraParam, completionHandler: completionHandler)
    }
    
    func getFirebaseDeeplinkWithPreview(itemId: String, imageUrlString: String, titleText: String, descriptionText: String, lastComponent: String, extraParam: String, completionHandler: @escaping DynamicLinkShortenerCompletion) -> String {
        
        var urlString: String = String(format: "%@%@/%@", AppConstants.kDynamicLink_URL, lastComponent, itemId)
        
        if extraParam != "" {
            
            let extraParameters: String = extraParam.replacingOccurrences(of: " ", with: "_")
            urlString = urlString.appending(String(format: "/%@", extraParameters))
        }
        
        if let urlLink: URL = URL(string: urlString) {
            
            let options: DynamicLinkComponentsOptions = DynamicLinkComponentsOptions()
            options.pathLength = ShortDynamicLinkPathLength.short
            
            let components: DynamicLinkComponents = DynamicLinkComponents(link: urlLink, domain: AppConstants.kDynamicLink_Domain)
            
            components.iOSParameters = self.getIOSParameters()
            components.androidParameters = self.getAndroidParameters()
            
            if imageUrlString != "" || titleText != "" || descriptionText != "" {
                
                components.socialMetaTagParameters = self.getSocialMetaTagParameters(imageUrlString: imageUrlString, titleText: titleText, descriptionText: descriptionText)
            }
            
            components.options = options
            
            components.shorten { (shortURL, warnings, error) in
                
                completionHandler(shortURL, warnings, error)
            }
            
            return (components.url?.absoluteString)!
        }
        else {
            
            return ""
        }
    }
    
    // MARK: - Buttons Action 
    
    @objc func didBackButtonPressed(_ sender: UIBarButtonItem) {
    
        if let navigationController = self.navigationController {
            navigationController.popViewController(animated: true)
        }
    }
    
    @objc func didMenuButtonPressed(_ sender: UIBarButtonItem) {
    
        if self.sideMenuViewController != nil {
            
            self.sideMenuViewController.presentLeftMenuViewController()
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
