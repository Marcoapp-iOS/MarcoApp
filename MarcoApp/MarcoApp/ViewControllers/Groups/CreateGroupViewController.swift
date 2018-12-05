//
//  CreateGroupViewController.swift
//  MarcoApp
//
//  Created by Nabeel Hayat on 10/11/2017.
//  Copyright © 2017 GrayScaleLogic. All rights reserved.
//

import UIKit
import CoreGraphics
import CoreImage
import FCAlertView

protocol CreateGroupDelegate {
    
    func didCreateGroup(_ groupObject: GroupObject, _ profileImage: UIImage?, _ coverImage: UIImage?)
}

class CreateGroupViewController: BaseViewController {

    @IBOutlet weak var infoLabel: UILabel!
    @IBOutlet weak var nameTextField: UITextField!
    
    @IBOutlet weak var coverImageView: UIImageView!
    @IBOutlet weak var overlayView: BaseView!
    @IBOutlet weak var avatarImageView: RoundedImageView!
    @IBOutlet weak var avatarButton: UIButton!
    
    @IBOutlet weak var scrollView: TPKeyboardAvoidingScrollView!
    
    @IBOutlet weak var heightConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var categoryTextField: UITextField!
    
    @IBOutlet weak var publicButton: UIButton!
    @IBOutlet weak var privateButton: UIButton!
    @IBOutlet weak var privacyDetailLabel: UILabel!
    
    @IBOutlet weak var paidButton: UIButton!
    @IBOutlet weak var freeButton: UIButton!
    
    @IBOutlet weak var amountLabel: UILabel!
    @IBOutlet weak var amountTitleLabel: UILabel!
    
    @IBOutlet weak var amountButton: UIButton!
    
    @IBOutlet weak var typeHeightConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var descriptionTextView: UITextView!
    
    @IBOutlet weak var legalNoteLabel: UILabel!
    
    
    @IBOutlet weak var nameBarView: UIView!
    @IBOutlet weak var categoryBarView: UIView!
    @IBOutlet weak var privacyBarView: UIView!
    @IBOutlet weak var typeBarView: UIView!
    @IBOutlet weak var descriptionBarView: UIView!
    
    var delegate: CreateGroupDelegate!
    
    var isPrivateGroup: Bool = true
    var isPaidGroup: Bool = true
    
    var createdGroupObject: GroupObject! = nil
    
    var avatarPictureChanged: Bool = false
    var coverPictureChanged: Bool = false
    
    var avatarPictureURL: String = ""
    var coverPictureURL: String = ""
    
    var categoryId: Int = 1;
    
    var libraryEnabled: Bool = true
    var croppingEnabled: Bool = true
    var allowResizing: Bool = true
    var allowMoving: Bool = true
    
    var minimumProfileSize: CGSize = CGSize(width: 200, height: 200)
    
    var croppingProfileParameters: CroppingParameters {
        return CroppingParameters(isEnabled: croppingEnabled, allowResizing: allowResizing, allowMoving: allowMoving, minimumSize: minimumProfileSize)
    }
    
    var minimumCoverSize: CGSize = CGSize(width: 400, height: 200)
    
    var croppingCoverParameters: CroppingParameters {
        return CroppingParameters(isEnabled: croppingEnabled, allowResizing: allowResizing, allowMoving: allowMoving, minimumSize: minimumCoverSize)
    }
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.hideNavigationMenuButtonItem = true
        self.showBackButtonItem = true

        // Do any additional setup after loading the view.
        
        self.setupViews()
    }

    override func didBackButtonPressed(_ sender: UIBarButtonItem) {
        
        if self.nameTextField.text != "" || self.descriptionTextView.text != "" {
            
            let alertView: FCAlertView = FCAlertView()
            
            alertView.addButton("Cancel", withActionBlock: {
                
            })
            
            alertView.showAlert(inView: self, withTitle: "Warning", withSubtitle: "Are you sure your want to discard your changes?", withCustomImage: nil, withDoneButtonTitle: "YES", andButtons: nil)
            
            alertView.doneActionBlock({
            
                super.didBackButtonPressed(sender)
            })
        }
        else {
            
            super.didBackButtonPressed(sender)
        }
    }
    
    override func didMenuButtonPressed(_ sender: UIBarButtonItem) {
        super.didMenuButtonPressed(sender)
        
    }
    
    // MARK: - Helper Functions
    
    func setupViews() {
        
        self.nameTextField.delegate = self
        self.categoryTextField.delegate = self
        self.descriptionTextView.delegate = self
        
        let attributedHeadText: NSMutableAttributedString = NSMutableAttributedString(string: "GROUP INFO")
        
        self.infoLabel.attributedText = attributedHeadText.setFont(font: AppTheme.regularFont(withSize: 10), kerningValue: 80.0)
        
        let attributedNameText: NSMutableAttributedString = NSMutableAttributedString(string: "")
        
        self.nameTextField.attributedText = attributedNameText.setFont(font: AppTheme.regularFont(withSize: 16), kerningValue: 40.0)
        self.categoryTextField.attributedText = attributedNameText.setFont(font: AppTheme.regularFont(withSize: 16), kerningValue: 40.0)
//        self.amountLabel.attributedText = attributedNameText.setFont(font: AppTheme.regularFont(withSize: 16), kerningValue: 40.0)
        self.descriptionTextView.attributedText = attributedNameText.setFont(font: AppTheme.regularFont(withSize: 16), kerningValue: 40.0)
        
        self.categoryTextField.text = "Social"
        
        self.navigationItem.title = "Create New Group"
    
        let createBarButtonItem: UIBarButtonItem = UIBarButtonItem(image: UIImage(named: "ic_nb_ok"), style: UIBarButtonItemStyle.done, target: self, action: #selector(didCreateGroupButtonPressed(_:)))
        
//        let negativeSpace:UIBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.fixedSpace, target: nil, action: nil)
////        negativeSpace.width = -10.0
        self.navigationItem.rightBarButtonItems = [createBarButtonItem]
        
        self.avatarImageView.image = UIImage.getImage(withName: "group-default", imageColor: UIColor(hexString: "#cccccc"))
    }

    func showCategoryList() {
        
        self.view.endEditing(true)
        
        let genderAlert = UIAlertController()
        
        let values: PickerViewViewController.Values = [AppFunctions.getGroupCategoriesList()]
        
        genderAlert.addPickerView(values: values, action: { (controller, picker, index, values) in
            
            self.categoryTextField.text = values.first?.item(at: index.row)
        })
        
        genderAlert.addAction(title: "Done", style: .cancel)
        genderAlert.show()
    }
    
    func showPriceList() {
        
        self.view.endEditing(true)
        
        let genderAlert = UIAlertController()
        
        let values: PickerViewViewController.Values = [AppFunctions.getGroupPricesList()]
        
        genderAlert.addPickerView(values: values, action: { (controller, picker, index, values) in
            
            self.amountLabel.text = values.first?.item(at: index.row)
        })
        
        genderAlert.addAction(title: "Done", style: .cancel)
        genderAlert.show()
    }
    
    // MARK: - Buttons Action
    
    @IBAction func didAmountButtonPressed(_ sender: UIButton) {
        
        self.showPriceList()
    }
    
    @IBAction func didGalleryButtonPressed(_ sender: UIButton) {
        
        if UIScreen.main.bounds.size.width < self.minimumCoverSize.width {
            
            let height: CGFloat = UIScreen.main.bounds.size.width / 2
        
            self.minimumCoverSize = CGSize(width: UIScreen.main.bounds.size.width, height: height)
        }
        
        let cameraViewController = CameraViewController(croppingParameters: croppingCoverParameters, allowsLibraryAccess: libraryEnabled) { [weak self] image, asset in
            
            if image != nil {
                self?.coverPictureChanged = true
                self?.coverImageView.image = image
            }
            
            self?.dismiss(animated: true, completion: nil)
        }
        
        present(cameraViewController, animated: true, completion: nil)
    }
    
    @IBAction func didAvatarButtonPressed(_ sender: UIButton) {
        
        let cameraViewController = CameraViewController(croppingParameters: croppingProfileParameters, allowsLibraryAccess: libraryEnabled) { [weak self] image, asset in
            
            if image != nil {
                self?.avatarPictureChanged = true
                self?.avatarImageView.image = image
            }
            
            self?.dismiss(animated: true, completion: nil)
        }
        
        present(cameraViewController, animated: true, completion: nil)
    }
    
    @IBAction func didCategoryButtonPressed(_ sender: UIButton) {
        
        self.showCategoryList()
    }
    
    @IBAction func didPublicButtonPressed(_ sender: UIButton) {
        
        self.isPrivateGroup = false
        
        self.publicButton.setImage(UIImage(named: "radio-on"), for: .normal)
        self.privateButton.setImage(UIImage(named: "radio-off"), for: .normal)
        
        self.privacyDetailLabel.text = "Public means everyone can see and join your group."
    }
    
    @IBAction func didPrivateButtonPressed(_ sender: UIButton) {
        
        self.isPrivateGroup = true
        
        self.publicButton.setImage(UIImage(named: "radio-off"), for: .normal)
        self.privateButton.setImage(UIImage(named: "radio-on"), for: .normal)
        
        self.privacyDetailLabel.text = "Private means only the people you invite will be able to see and join your group."
    }
    
    @IBAction func didPaidButtonPressed(_ sender: UIButton) {
        
        self.isPaidGroup = true
        
        self.freeButton.setImage(UIImage(named: "radio-off"), for: .normal)
        self.paidButton.setImage(UIImage(named: "radio-on"), for: .normal)
        
        self.typeHeightConstraint.constant = 94
        
        self.amountButton.isHidden = false
        self.amountTitleLabel.isHidden = false
        self.amountLabel.isHidden = false
        self.amountLabel.text = "$0.99"
    }
    
    @IBAction func didFreeButtonPressed(_ sender: UIButton) {
        
        self.isPaidGroup = false
        
        self.freeButton.setImage(UIImage(named: "radio-on"), for: .normal)
        self.paidButton.setImage(UIImage(named: "radio-off"), for: .normal)
        
        self.typeHeightConstraint.constant = 46
        
        self.amountButton.isHidden = true
        self.amountTitleLabel.isHidden = true
        self.amountLabel.isHidden = true
    }
    
    @objc func didCreateGroupButtonPressed(_ sender: UIBarButtonItem) {
        
        self.view.endEditing(true)
        
        if self.nameTextField.text != "" && self.descriptionTextView.text != "" {

            self.nameBarView.backgroundColor = AppTheme.separatorColor
            self.descriptionBarView.backgroundColor = AppTheme.separatorColor
            
            self.createNewGroup()
        }
        else {
            
            if self.nameTextField.text == "" {
                
                self.nameBarView.backgroundColor = AppTheme.invalidColor
                
            }
            else {
                
                self.nameBarView.backgroundColor = AppTheme.separatorColor
            }
            
            if self.descriptionTextView.text == "" {
            
                self.descriptionBarView.backgroundColor = AppTheme.invalidColor
            }
            else {
                
                self.descriptionBarView.backgroundColor = AppTheme.separatorColor
            }
        }
    }
    
    // MARK: - Web Services
    
    
    //    ["isPaid": false, "Price": 0.98999999999999999, "DefaultPriceId": 1, "Title": "Hayat’s Foundation ", "isPrivate": false, "CategoryId": 5, "Description": "You can help poor people’s with donation. We raising funds all over the world, "]
    //    {"Message":"An error has occurred."}
    
    // ["Title": "testing group", "isPrivate": true, "isPaid": false, "CategoryId": 1, "Description": "ABC"]
    // {"Message":"An error has occurred."}
    
    
    func createNewGroup() {
        
        self.showPKHUD(WithMessage: "Processing...")
        
        let priceValue: Double = (self.isPaidGroup) ? (self.amountLabel.text?.removeFormatAmount())! : 0
    
        let priceId: Int = priceValue.rounded(toPlaces: 2).getGroupPriceId()
        
        
        self.categoryId = (self.categoryTextField.text?.getGroupCategoryId())!
        
        let parameters: [String:Any] = ParametersHandler.parametersForCreateGroup(title: self.nameTextField.text!, description: self.descriptionTextView.text, categoryId: self.categoryId, price: priceValue, defaultPriceId: priceId, isPaid: self.isPaidGroup, isPrivate: self.isPrivateGroup)
        
        print(parameters)
        
        ApiServices.shared.requestForCreateGroup(onTarget: self, parameters, isBackground: false, successfull: { (success, createdObject) in
        
            self.hidePKHUD()
            
            self.createdGroupObject = createdObject
            self.uploadImages()
            
        }) { (failure) in
            
            self.hidePKHUD()
        }
    }
    
    fileprivate func resizeImageFroThumbnail() {
        
        
    }
    
    func uploadImages() {
        
        let coverImage: UIImage! = (self.coverPictureChanged) ? AppFunctions.resizeImageForImage(self.coverImageView.image!, CGSize(width: 400, height: 200)) : nil
        
        let profileImage: UIImage! = (self.avatarPictureChanged) ? AppFunctions.resizeImageForImage(self.avatarImageView.image!, CGSize(width: 200, height: 200)) : nil
        
        if self.delegate != nil {
            
            self.createdGroupObject.isCreatedGroup = true
            
            self.createdGroupObject.profileImage = profileImage
            self.createdGroupObject.coverImage = coverImage
            
            self.delegate.didCreateGroup(self.createdGroupObject, profileImage, coverImage)
            
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    func uploadCoverPicture() {
        
        if self.coverPictureChanged {
        
            self.showPKHUD(WithMessage: "Uploading images...")
            
            let imageFile = self.coverImageView.image?.resizeImage(1024)
            
            let urlString: String = AppConstants.kGroups + AppConstants.kChangeGroupCoverPicture
            
            ApiServices.shared.requestForUploadFile(onTarget: self, stringURL: urlString, groupId: self.createdGroupObject.groupId, fileImage: imageFile!, uploadProgress: {(progress) in
                
            }, successfull: { (fileUrl, success) in
                
//                self.hidePKHUD()
                self.coverPictureChanged = false
                let fileValue:String = fileUrl.replacingOccurrences(of: "\"", with: "")
                self.coverPictureURL = fileValue
                
                self.createdGroupObject.groupCoverPicture = fileValue
                
                self.uploadAvatarPicture()
                
            }) { (failure) in
                
                self.hidePKHUD()
            }
        }
        else {
            
            self.uploadAvatarPicture()
        }
    }
    
    func uploadAvatarPicture() {
        
        if self.avatarPictureChanged {
            
            self.showPKHUD(WithMessage: "Uploading images...")
            
            let imageFile = self.avatarImageView.image?.resizeImage(200)
            
            let urlString: String = AppConstants.kGroups + AppConstants.kChangeGroupProfilePicture
            
            ApiServices.shared.requestForUploadFile(onTarget: self, stringURL: urlString, groupId: self.createdGroupObject.groupId, fileImage: imageFile!, uploadProgress: {(progress) in
                
            }, successfull: { (fileUrl, success) in
                //{"URL":"https://marcoapp.blob.core.windows.net/marco/4984e8ef-b0f5-458c-8c6e-6addc8fe9167.jpg"}
                
//                self.hidePKHUD()
                self.avatarPictureChanged = false
                let fileValue:String = fileUrl.replacingOccurrences(of: "\"", with: "")
                self.avatarPictureURL = fileValue
                self.createdGroupObject.groupProfilePicture = fileValue
                self.showCreatedGroupController()
                
            }) { (failure) in
                
                self.hidePKHUD()
            }
        }
        else {
            
            self.showCreatedGroupController()
        }
    }
    
    func showCreatedGroupController() {
        
        self.hidePKHUD()
        
        let groupCreatedViewController: GroupCreatedViewController = self.storyboard?.instantiateViewController(withIdentifier: "GroupCreatedViewController") as! GroupCreatedViewController
        
        groupCreatedViewController.createdGroup = self.createdGroupObject
        
        self.navigationController?.pushViewController(groupCreatedViewController, animated: true)
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

extension CreateGroupViewController: UITextFieldDelegate, UITextViewDelegate {
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        
        if self.categoryTextField == textField {
            
            self.showCategoryList()
            return false
        }
        
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    
        if self.nameTextField == textField {
            
            self.nameTextField.resignFirstResponder()
            self.categoryTextField.becomeFirstResponder()
        }
        else if self.categoryTextField == textField {
            
            self.categoryTextField.resignFirstResponder()
            self.descriptionTextView.becomeFirstResponder()
        }
        
        return true
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        
    }
    
}








