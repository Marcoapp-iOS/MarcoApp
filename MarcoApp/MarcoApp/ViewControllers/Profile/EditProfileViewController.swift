//
//  EditProfileViewController.swift
//  MarcoApp
//
//  Created by Nabeel Hayat on 01/12/2017.
//  Copyright © 2017 GrayScaleLogic. All rights reserved.
//

import UIKit
import ObjectMapper
import SDWebImage
import FacebookLogin
import FacebookCore

class EditProfileViewController: BaseViewController {

    @IBOutlet weak var profileTableView: ProfileTableView!
    
    @IBOutlet weak var coverImageView: UIImageView!
    @IBOutlet weak var avatarImageView: RoundedImageView!
    
    var userProfile: UserProfile!
    
    var profilePictureChanged: Bool = false
    var coverPhotoChanged: Bool = false
    
    var profilePictureURL: String = ""
    var coverPhotoURL: String = ""
    
    var showBackButton: Bool = false
    
    var libraryEnabled: Bool = true
    var croppingEnabled: Bool = true
    var allowResizing: Bool = true
    var allowMoving: Bool = true
    var minimumSize: CGSize = CGSize(width: 200, height: 200)
    
    var croppingParameters: CroppingParameters {
        return CroppingParameters(isEnabled: croppingEnabled, allowResizing: allowResizing, allowMoving: allowMoving, minimumSize: minimumSize)
    }
    
    var minimumCoverSize: CGSize = CGSize(width: 400, height: 200)
    
    var croppingCoverParameters: CroppingParameters {
        return CroppingParameters(isEnabled: croppingEnabled, allowResizing: allowResizing, allowMoving: allowMoving, minimumSize: minimumCoverSize)
    }
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.showBackButtonItem = self.showBackButton
        self.hideNavigationMenuButtonItem = !self.showBackButton
        // Do any additional setup after loading the view.
        
        self.setupViews()
//        self.getUserInfoFromFB()
    }
    
    override func didBackButtonPressed(_ sender: UIBarButtonItem) {
        super.didBackButtonPressed(sender)
        
    }
    
    override func didMenuButtonPressed(_ sender: UIBarButtonItem) {
        super.didMenuButtonPressed(sender)
        
    }
    
    // MARK: - Helper Functions
    
    func setupViews() {
        
        let updateBarButtonItem: UIBarButtonItem = UIBarButtonItem(image: UIImage(named: "ic_nb_ok"), style: UIBarButtonItemStyle.done, target: self, action: #selector(didUpdateProfileButtonPressed(_:)))
        
//        let negativeSpace:UIBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.fixedSpace, target: nil, action: nil)
////        negativeSpace.width = -10.0
        self.navigationItem.rightBarButtonItems = [updateBarButtonItem]
        
        self.setupControls()
    }
    
    func setupControls() {
        
        if self.profileTableView != nil {
            
            self.profileTableView.setupTableView(WithParentViewController: self, isEditMode: true, userProfile: self.userProfile)

            
            if userProfile.profilePicture != nil && userProfile.profilePicture != "" {
                
                let url = URL(string: userProfile.profilePicture)
                
                self.avatarImageView.sd_setImage(with: url, placeholderImage: UIImage(named: "user_default")) { (image, error, imageCacheType, url) in
                    
                }            }
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

        }
    }
    
    func getUserInfoFromFB() {
        
        let parameters: [String: Any] = ["fields":"id, first_name, last_name, name, email, gender, birthday, relationship_status, picture.type(large), address, locale, timezone, location, about, friendlists"]
        
        let request: GraphRequest = GraphRequest(graphPath: "/\(AccessToken.current?.userId ?? "")", parameters: parameters)
        
        request.start { (response, requestResult) in
            
            switch requestResult {
            case .failed(let error):
                print("error in graph request:", error)
                break
            case .success(let graphResponse):
                if let responseDictionary = graphResponse.dictionaryValue {
                    
                    print(responseDictionary)
                    
//                    let userProfile:UserProfile? = Mapper<UserProfile>().map(JSON:responseDictionary)

                    
                    
//                    let editProfileViewController: EditProfileViewController = AppUICommons.getEditProfileViewController(userProfile!)
//                    editProfileViewController.userProfile = userProfile
//                    self.appDelegate.window?.rootViewController = editProfileViewController
                    
                }
            }
        }
        
        
    }
    
    private func updateUserProfilePicture() {
        
        //ImageBase64
        
        self.showPKHUD(WithMessage: "Uploading images...")
        
        let imageFile = AppFunctions.resizeImageForImage(self.avatarImageView.image!, CGSize(width: 200, height: 200))
        
        let urlString:String = AppConstants.kUserProfiles + AppConstants.kChangeUserProfilePicture
        
        ApiServices.shared.requestForUploadFile(onTarget: self, stringURL: urlString, fileImage: imageFile, uploadProgress: {(progress) in
            
        }, successfull: { (fileUrl, success) in
            
           // self.hidePKHUD()
            self.profilePictureChanged = false
            
            let fileValue:String = fileUrl.replacingOccurrences(of: "\"", with: "")
            self.profilePictureURL = fileValue
            self.updateUserCoverPhoto()
            
        }) { (failure) in
            
            self.hidePKHUD()
        }
        
    }
    
    private func updateUserCoverPhoto() {
        
        if self.coverPhotoChanged {
            
            //ImageBase64
            
            self.showPKHUD(WithMessage: "Uploading images...")
            
            let imageFile = AppFunctions.resizeImageForImage(self.coverImageView.image!, CGSize(width: 400, height: 200))
            
            let urlString:String = AppConstants.kUserProfiles + AppConstants.kChangeUserCoverPicture
            
            ApiServices.shared.requestForUploadFile(onTarget: self, stringURL: urlString,  fileImage: imageFile, uploadProgress: {(progress) in
                
            }, successfull: { (fileUrl, success) in
                
                //self.hidePKHUD()
                self.coverPhotoChanged = false
                let fileValue:String = fileUrl.replacingOccurrences(of: "\"", with: "")
                self.coverPhotoURL = fileValue
                self.updateUserProfile()
                
            }) { (failure) in
                
                self.hidePKHUD()
            }
        }
        else {
            
            self.updateUserProfile()
        }
    }
    
    private func updateUserProfile() {
        
        let userProfile: UserProfile = self.profileTableView.getUserProfile()
        
        let parameters: [String:Any] = ParametersHandler.parametersForSaveProfile(userProfile, profilePicture: self.profilePictureURL, coverPhoto: self.coverPhotoURL)
        
        self.showPKHUD(WithMessage: "Updating profile...")
        
        print(parameters)
        
        ApiServices.shared.requestForSaveMyProfile(onTarget: self, parameters, successfull: { (success) in
            
            self.getUpdatedProfile()
            
        }) { (failure) in
            
            self.hidePKHUD()
        }
    }
    
    private func getUpdatedProfile() {
        
        self.showPKHUD(WithMessage: "Getting profile...")
        
        ApiServices.shared.requestForMyProfile(onTarget: self, successfull: { (success, isProfileFound) in
            
            self.hidePKHUD()
            
            
            if self.profilePictureChanged {
                
                self.updateUserProfilePicture()
            }
            else if self.coverPhotoChanged {
                
                self.updateUserCoverPhoto()
            }
            else {
                
                if AppDefaults.isAppOpenFirstTime() || AppDefaults.isNewRegisterUser() {
                    
                    AppDefaults.setAppOpenFirstTime(false)
                    AppDefaults.setAppLoggedIn(true)
                    
                    self.appDelegate.window?.rootViewController = AppUI.getRootViewController()
                }
                else {
                    
                    NotificationCenter.default.post(name: Notification.Name.OnUpdateUserProfile, object: nil)
                }
            }
            
        }) { (failure) in
            
            self.hidePKHUD()
        }
    }
    
    // MARK: - Buttons Action
    
    @objc func didUpdateProfileButtonPressed(_ sender: UIBarButtonItem) {
        
        if self.profileTableView.isValidatedInformation() {
            
            self.updateUserProfile()
        }
        else {
            
        }
        
    }
    
    @IBAction func didCameraButtonPressed(_ sender: UIButton) {
        
        let cameraViewController = CameraViewController(croppingParameters: croppingParameters, allowsLibraryAccess: libraryEnabled) { [weak self] image, asset in
            
            if image != nil {
                self?.profilePictureChanged = true
                self?.avatarImageView.image = image
            }
            
            self?.dismiss(animated: true, completion: nil)
        }
        
        present(cameraViewController, animated: true, completion: nil)
        
    }
    
    @IBAction func didGalleryButtonPressed(_ sender: UIButton) {
     
        let cameraViewController = CameraViewController(croppingParameters: croppingCoverParameters, allowsLibraryAccess: libraryEnabled) { [weak self] image, asset in
            
            if image != nil {
                self?.coverPhotoChanged = true
                self?.coverImageView.image = image
            }
            
            self?.dismiss(animated: true, completion: nil)
        }
        
        present(cameraViewController, animated: true, completion: nil)
//
//        let photoLibraryController = CameraViewController.imagePickerViewController(croppingParameters: croppingParameters) { (image, asset) in
//
//            if image != nil {
//                self.coverPhotoChanged = true
//                self.coverImageView.image = image
//            }
//
//            self.dismiss(animated: true, completion: nil)
//        }
//
//        present(photoLibraryController, animated: true, completion: nil)
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
