//
//  LandingViewController.swift
//  MarcoApp
//
//  Created by Nabeel Hayat on 09/01/2018.
//  Copyright © 2018 GrayScaleLogic. All rights reserved.
//

import UIKit
import ObjectMapper
import FacebookLogin
import FacebookCore


class LandingViewController: BaseViewController {

    @IBOutlet weak var containerLeadingConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var signupButton: UIButton!
    @IBOutlet weak var signinButton: UIButton!
    @IBOutlet weak var startedButton: UIButton!
    
    @IBOutlet weak var landingPageControl: MarcoPageControl!
    
    @IBOutlet weak var containerView: UIView!
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.hideNavigationMenuButtonItem = true
        self.showBackButtonItem = false
        // Do any additional setup after loading the view.
        
        self.setupViews()
    }
    
    override func didBackButtonPressed(_ sender: UIBarButtonItem) {
        super.didBackButtonPressed(sender)
        
    }
    
    override func didMenuButtonPressed(_ sender: UIBarButtonItem) {
        super.didMenuButtonPressed(sender)
        
    }
    
    // MARK: - Helper Functions
    
    func setupViews() {
        
        let leftSwipeGesture: UISwipeGestureRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipeGesture(_:)))
        
        leftSwipeGesture.direction = .left
        
        let rightSwipeGesture: UISwipeGestureRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipeGesture(_:)))
        
        rightSwipeGesture.direction = .right
        
        leftSwipeGesture.require(toFail: rightSwipeGesture)
        
        self.view.addGestureRecognizer(leftSwipeGesture)
        self.view.addGestureRecognizer(rightSwipeGesture)
        
        self.requestForMaritalStatusList()
    }
    
    private func requestForMaritalStatusList() {
        
        ApiServices.shared.requestForMaritalStatusList(onTarget: self, successfull: { (success) in
            
        }) { (failure) in
            
            
        }
    }
    
    @objc func handleSwipeGesture(_ swipeGesture: UISwipeGestureRecognizer) {
     
        if swipeGesture.state == .ended {
            
            if swipeGesture.direction == .left {
                
                self.animateLandingPages(true)
            }
            else if swipeGesture.direction == .right {
                
                self.animateLandingPages(false)
            }
        }
    }
    
    func animateLandingPages(_ isLeftSwipe: Bool) {
        
        let screenWidth: CGFloat = UIScreen.main.bounds.size.width;
        
        if isLeftSwipe {
            // -
            
            if self.landingPageControl.currentPage < (self.landingPageControl.numberOfPages - 1) {
             
                self.containerLeadingConstraint.constant = self.containerLeadingConstraint.constant - screenWidth
                
                self.landingPageControl.currentPage = self.landingPageControl.currentPage + 1;
                
                if self.landingPageControl.currentPage < 0 {
                    
                    self.landingPageControl.currentPage = 0;
                }
            }
        }
        else {
            // +
            
            if self.landingPageControl.currentPage > 0 {
            
                self.containerLeadingConstraint.constant = self.containerLeadingConstraint.constant + screenWidth
                
                self.landingPageControl.currentPage = self.landingPageControl.currentPage - 1;
                
                print(self.landingPageControl.numberOfPages)
                print(self.landingPageControl.currentPage)
                
                if self.landingPageControl.currentPage >= self.landingPageControl.numberOfPages {
                    
                    self.landingPageControl.currentPage = self.landingPageControl.numberOfPages;
                }
            }
        }
        
        if self.landingPageControl.currentPage == 0 {

            self.signinButton.isHidden = true
            self.signupButton.isHidden = false
        }
        else {

            self.signinButton.isHidden = false
            self.signupButton.isHidden = true
        }
        
        UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseOut, animations: {
            
            self.view.layoutIfNeeded()
            
        }) { (finished) in
            
        }
    }
    
    func requestForRegisterUser() {

        let fbToken: String = (AccessToken.current?.authenticationToken)!

        if (AccessToken.current != nil) && fbToken.count > 0 {
         
            let parameters: [String : Any] = ["Token":fbToken, "Provider":"Facebook"];
            
            
            print(parameters)
            
            ApiServices.shared.requestForRegisterSocial(onTarget: self, parameters, isBackground: false, successfull: { (finished, hasRegisterUser) in
                
                if hasRegisterUser {
                
                    self.getUserInfoFromServer()
                    
                    if AppDefaults.getLoggedUserId() != "" {
                     
                        self.appDelegate.initPubNubClient()
                    }
                }
                
            }, failure: { (failed) in
                
                self.hidePKHUD()
            })
        }
        else {
            
            
        }
        
//        NSString *fbToken = [[FBSDKAccessToken currentAccessToken] tokenString];
//
//        if ([FBSDKAccessToken currentAccessToken] && fbToken.length > 0) {
    }
    
    func getUserInfoFromServer() {
        
        self.showPKHUD(WithMessage: "Getting profile...")
        
        ApiServices.shared.requestForMyProfile(onTarget: self, successfull: { (success, isProfileFound) in
            
            self.hidePKHUD()
            
            if isProfileFound {
            
                AppDefaults.setNewRegisterUser(false)
                AppDefaults.setAppOpenFirstTime(false)
                AppDefaults.setAppLoggedIn(true)
                
                self.appDelegate.window?.rootViewController = AppUI.getRootViewController()
            }
            else {
                
                self.getUserInfoFromFB()
            }
            
            
        }) { (failure) in
            
            self.hidePKHUD()
        }
    }
    
    func getUserInfoFromFB() {
        
        AppDefaults.setNewRegisterUser(true)
        
        let parameters: [String: Any] = ["fields":"id, first_name, last_name, name, email, gender, birthday, relationship_status, picture.type(large), address, locale, timezone, location, about, friendlists"]
        
        let request: GraphRequest = GraphRequest(graphPath: "/\(AccessToken.current?.userId ?? "")", parameters: parameters)
        
        request.start { (response, requestResult) in
            
            switch requestResult {
            case .failed(let error):
                self.hidePKHUD()
                print("error in graph request:", error)
                break
            case .success(let graphResponse):
                if let responseDictionary = graphResponse.dictionaryValue {
                    
                    DispatchQueue.main.async(execute: {
                    

                        self.hidePKHUD()
                        print(responseDictionary)
                        
                        let userProfile: UserProfile = UserProfile(WithFBResponse: responseDictionary)
                        
                        let baseNavigationController:BaseNavigationController = AppUI.mainStoryboard.instantiateViewController(withIdentifier: "embedEditProfileCenterController") as! BaseNavigationController
                        
                        let editProfileViewController: EditProfileViewController = baseNavigationController.childViewControllers[0] as! EditProfileViewController
                        editProfileViewController.userProfile = userProfile
                        
                        self.appDelegate.window?.rootViewController = baseNavigationController
                    })
                
                }
                else {
                    
                    self.hidePKHUD()
                }
                
            }
        }
        
        
    }

    // MARK: - Button Actions
    
    @IBAction func didSigninButtonPressed(_ sender: UIButton) {
        
        self.showPKHUD(WithMessage: "Signing in...")
        
//        self.loginManager.logOut()
        
        if (AccessToken.current != nil && AppDefaults.isAppLoggedIn()) {
         
            let tokenString: String = (AccessToken.current?.authenticationToken)!
            
            print(tokenString)
            
//            self.getUserInfoFromFB()
            self.getUserInfoFromServer()
            
        }
        else {
            
            self.hidePKHUD()

            self.loginUser()
        }
    }
    
    @IBAction func didSignupButtonPressed(_ sender: UIButton) {
        
        self.showPKHUD(WithMessage: "Signing up...")
        
        self.loginManager.logOut()
        
        self.hidePKHUD()
        
        self.loginUser()
    }
    
    private func loginUser() {
        
        self.loginManager.logIn(readPermissions: [.publicProfile, .email, .userFriends, .userBirthday, .userLocation, .userHometown], viewController: self) { (loginResult) in
            
            switch loginResult {
            case .failed(let error):
                print(error)
            case .cancelled:
                print("User cancelled Signup.")
            case .success(_, _, let accessToken):
                
                self.showPKHUD(WithMessage: "Signing in...")
                
                print("Logged in!: \(accessToken.authenticationToken)")
                
                self.requestForRegisterUser()
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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


/*
 SAVE:
 "ProfilePicture": "\"https://aplome.blob.core.windows.net/sme/5af8b204-651c-40fc-9ea6-99c2126f8a09.jpg\"", "Interests": ["cricket, Hockey, football "], "Gender": Female, "LastName": Jahanzaib, "MeritalStatusId": 1, "Title": , "About": Hi, I’m software engineer,, "Longitude": 0, "CoverPicture": "\"https://aplome.blob.core.windows.net/sme/889ddba6-4f78-4354-b5ca-5ab33cb87ef7.jpg\"", "FirstName": Humna, "Phone": 03155245810, "DOB": 12-May-1986, "Locale": en_US, "Location": Islamabad, Pakistan, "Latitude": 0]
 
 GET: {"FirstName":"Humna","LastName":"Jahanzaib","Phone":"03155245810","Location":null,"DOB":"1986-05-12T00:00:00","Gender":"Female","Title":"","MeritalStatusId":1,"About":"Hi, I’m software engineer,","ProfilePicture":"\"https://aplome.blob.core.windows.net/sme/5af8b204-651c-40fc-9ea6-99c2126f8a09.jpg\"","CoverPicture":"\"https://aplome.blob.core.windows.net/sme/889ddba6-4f78-4354-b5ca-5ab33cb87ef7.jpg\"","Latitude":0.000000,"Longitude":0.000000,"Locale":"en_US","Interests":null}
 
>>>>>>> FixesBranch
 
 EAAHorMm8UHABADKfbEPtQ0GeZCukC05MEzBZCi7YEKpNef5E4B2K3W0XywUndfLq1V4TkCpp8LpPHW6AZArxqkA5oufI9XFL8P3GD8eNKLdhQynhK12PYGbHWpTz5R57yhWM1ugf1J6JongpufTGHNHHuDGPjjRtd0N6aQDeV4H1kUR1fMdB40zbJVAQ49gueunIRyNlwZDZD
 ["Provider": "Facebook", "Token": "EAAHorMm8UHABADKfbEPtQ0GeZCukC05MEzBZCi7YEKpNef5E4B2K3W0XywUndfLq1V4TkCpp8LpPHW6AZArxqkA5oufI9XFL8P3GD8eNKLdhQynhK12PYGbHWpTz5R57yhWM1ugf1J6JongpufTGHNHHuDGPjjRtd0N6aQDeV4H1kUR1fMdB40zbJVAQ49gueunIRyNlwZDZD"]
 Network Status Changed: reachable(Alamofire.NetworkReachabilityManager.ConnectionType.ethernetOrWiFi)
 {
 "userName":"humnajahanzaib@gmail.com",
 "userId":"d17a6f92-3794-4a83-932e-8da445d11414",
 "access_token":"FjK5rygV8WuEiAr0P_zJsvsAHmiXe8WzxYAdtSlMVT9Q2-OF4aNHIGfrRxDodX8WVxPzxm7ueGuOCeJ0LoSmgT9GRuOZo3WV5Dx1E9AAKiMuWh3PhTVMKHmw9KHZS4DaLozBHT_ZT0jcvrd76eIrg7pzgN34ZW_RjhU032ShbRkIAgAdobJFNFiByrvsJFM7tQt2aREa1YDUeL-FXPMydcml4fXp0JZv44N1j1bT07vgqSA66_jyB0dvqjU4DtDwKLWYynJu4PXomD5PE34v6dx6WCZol2lf9nulKKgc0SHzQZEMBs_3GvIhPJJ3RLQo-F5AjrDDRXWIEiJ_drEnR0VU2L7YZVU4ZdOyoKybq3hVsbarzNboRCGi80S7_s17v0x1A0uh8O5N0ZX4b8hQZ-5N3jHfV3Vym30cRahaZf37D0jAHc_Bl497DvLr01QJkdexLHjI_u82_WzBQP4oVuRTndPKOjgJMvnG73ta65SCz0hrGxZ1ei7CnoNWodeLnxVsVcp-VVwOJgnMWa7-Y0_IUoB63mcMXYiDGo5d7UEgtTtDHdytx21TPoNGhuABzI9yRiisLsQCV4Ct2ZMYB-YQGvwBHK9D7tNQTKbHHPWb-JKRLWdzdBT3CwTO62sS",
 "token_type":"bearer",
 "expires_in":"1209600",
 "issued":"Fri, 16 Feb 2018 15:36:20 GMT",
 "expires":"Fri, 02 Mar 2018 15:36:20 GMT",
 "hasRegistered":false
 
 
 *******************************************************************************************
 {
 accessToken = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ0eXBlIjoiYWNjZXNzVG9rZW4iLCJ1c2VySWQiOiJkOTJlYjFhOC0xZjYxLTRiODgtYWZiNS1hOWI0NWE5ZTQ4MzMiLCJ0b2tlbklkIjoiYjc2MTliNzAtOTFhOS00NTFiLThmNDUtYzg5NDdlNmVjMGQ3IiwiY2xpZW50QXBpVmVyc2lvbiI6IjEuNDEuMCIsImlhdCI6MTUxODc3ODMxMywiZXhwIjoxNTE4NzgxOTEzfQ._yMRQ0IKY-9nN0gozYTDiJKvmR7GlCBIASlF6JI6GmQ";
 refreshToken = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ0eXBlIjoicmVmcmVzaFRva2VuIiwidXNlcklkIjoiZDkyZWIxYTgtMWY2MS00Yjg4LWFmYjUtYTliNDVhOWU0ODMzIiwidG9rZW5JZCI6ImI3NjE5YjcwLTkxYTktNDUxYi04ZjQ1LWM4OTQ3ZTZlYzBkNyIsImNsaWVudEFwaVZlcnNpb24iOiIxLjQxLjAiLCJkZXZpY2VJZCI6IjNiOTc3MGMwNmM2ZTg5ZDFhNTcyNzA5NjNmMTFjNzUxIiwiaWF0IjoxNTE4Nzc4MzEzfQ.kHmrmigCRlSwgUDk9LlZAKQ94ts9cOFFPdktaZCYwlY";
 user =     {
 allowedRecordingTime = 20;
 authenticatedEmail = 1;
 avatar =         (
 {
 height = 100;
 path = "d92eb1a8-1f61-4b88-afb5-a9b45a9e4833/thumb-1518778313213.jpg";
 storageId = "ap-southeast-2:com.doppeltime.media.production";
 type = imageThumbnail;
 url = "http://d2e3chkxlarwe7.cloudfront.net/d92eb1a8-1f61-4b88-afb5-a9b45a9e4833/thumb-1518778313213.jpg";
 urlS3 = "http://d2e3chkxlarwe7.cloudfront.net/d92eb1a8-1f61-4b88-afb5-a9b45a9e4833/thumb-1518778313213.jpg";
 uuid = "2963c125-86d0-415f-846e-49799f3f5639";
 width = 100;
 },
 {
 height = 200;
 path = "d92eb1a8-1f61-4b88-afb5-a9b45a9e4833/small-1518778313419.jpg";
 storageId = "ap-southeast-2:com.doppeltime.media.production";
 type = imageSmall;
 url = "http://d2e3chkxlarwe7.cloudfront.net/d92eb1a8-1f61-4b88-afb5-a9b45a9e4833/small-1518778313419.jpg";
 urlS3 = "http://d2e3chkxlarwe7.cloudfront.net/d92eb1a8-1f61-4b88-afb5-a9b45a9e4833/small-1518778313419.jpg";
 uuid = "9537a474-5d8f-4f9f-b882-5522d3fd6fc4";
 width = 200;
 },
 {
 height = 200;
 path = "d92eb1a8-1f61-4b88-afb5-a9b45a9e4833/large-1518778313370.jpg";
 storageId = "ap-southeast-2:com.doppeltime.media.production";
 type = imageLarge;
 url = "http://d2e3chkxlarwe7.cloudfront.net/d92eb1a8-1f61-4b88-afb5-a9b45a9e4833/large-1518778313370.jpg";
 urlS3 = "http://d2e3chkxlarwe7.cloudfront.net/d92eb1a8-1f61-4b88-afb5-a9b45a9e4833/large-1518778313370.jpg";
 uuid = "2b5e8cd9-d147-4dc1-a42d-67e13b895398";
 width = 200;
 }
 );
 country = PK;
 doNotShowMeTips = 0;
 eulaAccepted = "<null>";
 guest = 0;
 loginCount = 0;
 name = "Nabeel Hayat";
 numRated = 0;
 password = F8cbK23MNTh0c9mKJPqw842;
 passwordUpdatedDate = 1518778313501;
 preferredLanguage = "<null>";
 referredByCeleb =         (
 );
 sex = Male;
 status = ACTIVE;
 userId = "d92eb1a8-1f61-4b88-afb5-a9b45a9e4833";
 userType = 0;
 username = "1298165440201740@facebook.com";
 };
 }
 
 */
