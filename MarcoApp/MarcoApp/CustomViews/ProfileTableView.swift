//
//  ProfileTableView.swift
//  MarcoApp
//
//  Created by Nabeel Hayat on 29/11/2017.
//  Copyright © 2017 GrayScaleLogic. All rights reserved.
//

import UIKit


enum ProfileValueType: IntegerLiteralType {
    case FirstName = 0
    case LastName
    case Email
    case Gender
    case MaritalStatus
    case BirthDay
    case Zodiac
    case Interests
    case Location
    case PhoneNumber
    case AboutMe
}

class ProfileTableView: TPKeyboardAvoidingTableView, UITableViewDelegate, UITableViewDataSource {
    
    fileprivate var parentViewController: UIViewController!
    
    fileprivate var updatedUserProfile: UserProfile!
    
    fileprivate var userProfile: UserProfile! {
    
        didSet {
        
            self.updatedUserProfile = userProfile
            self.setupProfileValueTypes()
        }
    }
    
    fileprivate var profileValueList: [ProfileValueType] = [ProfileValueType]()
    
    
    fileprivate var isEditMode: Bool = false
    fileprivate var isAdminUser: Bool = false
    
    fileprivate var isInvalidInfo: Bool = false
    
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
        
        self.register(UINib(nibName: "UserProfileTableViewCell", bundle: nil), forCellReuseIdentifier: "UserProfileTableViewCell")
        
        self.tableFooterView = UIView(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
        
        let defaultInset = self.contentInset
        
        self.contentInset = UIEdgeInsets(top: defaultInset.top, left: defaultInset.left, bottom: 34, right: defaultInset.right)
    }
    
    func setupTableView(WithParentViewController parentViewController: UIViewController, isEditMode:Bool, isAdminUser: Bool, userProfile: UserProfile) {
        
        self.parentViewController = parentViewController
        self.isEditMode = isEditMode
        self.isAdminUser = isAdminUser
        self.userProfile = userProfile
    }
    
    func setupTableView(WithParentViewController parentViewController: UIViewController, isEditMode:Bool, userProfile: UserProfile) {
        
        self.setupTableView(WithParentViewController: parentViewController, isEditMode: isEditMode, isAdminUser: false, userProfile: userProfile)
    }
    
    private func setupProfileValueTypes() {
        
        self.profileValueList.removeAll()
        
        if self.isEditMode {
            
            self.profileValueList.append(.FirstName)
            self.profileValueList.append(.LastName)
            self.profileValueList.append(.Email)
            self.profileValueList.append(.Gender)

            self.profileValueList.append(.MaritalStatus)

            self.profileValueList.append(.BirthDay)
            self.profileValueList.append(.Zodiac)
            self.profileValueList.append(.Interests)
            self.profileValueList.append(.Location)
            self.profileValueList.append(.PhoneNumber)
            self.profileValueList.append(.AboutMe)
        }
        else {
        
            if self.userProfile.firstName != "" && self.userProfile.firstName != nil {
                
                self.profileValueList.append(.FirstName)
            }
            
            if self.userProfile.lastName != "" && self.userProfile.lastName != nil {
                
                self.profileValueList.append(.LastName)
            }
            
            if self.userProfile.email != "" && self.userProfile.email != nil {
                
                self.profileValueList.append(.Email)
            }
            
            if self.userProfile.gender != "" && self.userProfile.gender != nil {
                
                self.profileValueList.append(.Gender)
            }
            
            if self.userProfile.maritalStatus != nil && self.userProfile.maritalStatus != nil {
                
                self.profileValueList.append(.MaritalStatus)
            }
            
            if self.userProfile.birthday != "" && self.userProfile.birthday != nil {
                
                self.profileValueList.append(.BirthDay)
                self.profileValueList.append(.Zodiac)
            }
            
            if self.userProfile.interest != "" && self.userProfile.interest != nil {
                
                self.profileValueList.append(.Interests)
            }
            
            if self.userProfile.locationAddress != "" && self.userProfile.locationAddress != nil {
                
                self.profileValueList.append(.Location)
            }
            
            if self.userProfile.phoneNumber != "" && self.userProfile.phoneNumber != nil {
                
                self.profileValueList.append(.PhoneNumber)
            }
            
            if self.userProfile.about != "" && self.userProfile.about != nil {
                
                self.profileValueList.append(.AboutMe)
            }
        }
        
        self.reloadData()
    }
    
    func isValidatedInformation() -> Bool {
     
        
        if self.userProfile.email != "" {
            
            if (self.userProfile.email.isValidEmail) {
                
                self.isInvalidInfo = false
                self.reloadData()
                return true
            }
            else {
                
                self.isInvalidInfo = true
                self.reloadData()
                return false
            }
        }
        else {
            
            self.isInvalidInfo = true
            self.reloadData()
            return false
        }
    }
    
    func getUserProfile() -> UserProfile {
        print(#function)
        return updatedUserProfile
    }
    
    // MARK: - UITableViewDataSource
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return self.profileValueList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell: UserProfileTableViewCell = tableView.dequeueReusableCell(withIdentifier: "UserProfileTableViewCell", for: indexPath) as! UserProfileTableViewCell
        
//        let cell: ProfileTableViewCell = tableView.dequeueReusableCell(withIdentifier: "ProfileTableViewCell", for: indexPath) as! ProfileTableViewCell

        let profileValueType: ProfileValueType = self.profileValueList[indexPath.row]

        cell.indexPath = indexPath
        cell.profileValueType = profileValueType
        cell.delegate = self

        if self.isEditMode {

            cell.titleTextField.isHidden = false
            cell.titleTextLabel.isHidden = true
        }
        else {

            cell.titleTextField.isHidden = true
            cell.titleTextLabel.isHidden = false
        }

        cell.titleTextView.isHidden = true

        switch profileValueType {
        case .FirstName:

            cell.titleLabel.text = "First Name"
            cell.titleTextLabel.text = userProfile.firstName
            cell.titleTextField.text = userProfile.firstName

            cell.topConstraint.constant = 15
            cell.separatorView.isHidden = true

            break
        case .LastName:

            cell.titleLabel.text = "Last Name"
            cell.titleTextLabel.text = userProfile.lastName
            cell.titleTextField.text = userProfile.lastName

            cell.topConstraint.constant = 0
            cell.separatorView.isHidden = false

            break
        case .Email:

            cell.titleLabel.text = "Email"
            cell.titleTextLabel.text = userProfile.email
            cell.titleTextField.text = userProfile.email

            cell.titleTextField.keyboardType = .emailAddress

            cell.separatorView.backgroundColor = (self.isInvalidInfo) ? AppTheme.invalidColor : AppTheme.separatorColor
            
            cell.topConstraint.constant = 15
            cell.separatorView.isHidden = false

            break
        case .Gender:

            cell.titleLabel.text = "Gender"
            cell.titleTextLabel.text = userProfile.gender
            cell.titleTextField.text = userProfile.gender

            cell.topConstraint.constant = 15
            cell.separatorView.isHidden = true

            break
        case .MaritalStatus:

            cell.titleLabel.text = "Marital Status"

            cell.titleTextLabel.text = userProfile.maritalStatus.statusTitle
            cell.titleTextField.text = userProfile.maritalStatus.statusTitle

            cell.topConstraint.constant = 0
            cell.separatorView.isHidden = true

            break
        case .BirthDay:

            cell.titleLabel.text = "Birthday"
            cell.titleTextLabel.text = userProfile.birthday
            cell.titleTextField.text = userProfile.birthday

            cell.topConstraint.constant = 0
            cell.separatorView.isHidden = true

            break
        case .Zodiac:

            cell.titleLabel.text = "Zodiac"
            cell.titleTextLabel.text = userProfile.zodiac
            cell.titleTextField.text = userProfile.zodiac

            cell.topConstraint.constant = 0
            cell.separatorView.isHidden = false

            break
        case .Interests:

            cell.titleLabel.text = "Interests"
            cell.titleTextLabel.text = userProfile.interest
            cell.titleTextField.text = userProfile.interest

            cell.topConstraint.constant = 15
            cell.separatorView.isHidden = false

            break
        case .Location:

            cell.titleLabel.text = "Location"
            cell.titleTextLabel.text = userProfile.locationAddress
            cell.titleTextField.text = userProfile.locationAddress

            cell.topConstraint.constant = 15
            cell.separatorView.isHidden = true

            break
        case .PhoneNumber:

            cell.titleLabel.text = "Phone Number"
            cell.titleTextLabel.text = userProfile.phoneNumber
            cell.titleTextField.text = userProfile.phoneNumber

            cell.titleTextField.keyboardType = .numberPad

            cell.topConstraint.constant = 0
            cell.separatorView.isHidden = false

            break
        case .AboutMe:

            cell.titleLabel.text = "About Me"
            cell.titleTextLabel.text = userProfile.about
//            cell.titleTextField.text = userProfile.about
            cell.titleTextField.isHidden = true
            cell.titleTextView.isHidden = false
            cell.titleTextView.text = userProfile.about

            cell.heightConstraint.constant = 190 - 40
            cell.topConstraint.constant = 15
            cell.separatorView.isHidden = true

            break
        }
        
        return cell
    }
    
    // MARK: - UITableViewDelegate
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
print(#function)
        
//        return 75.0
        
        let profileValueType: ProfileValueType = self.profileValueList[indexPath.row]
        
        switch profileValueType {
        case .FirstName:
            
            return 75.0
            
        case .LastName:
            
            return 75.0
            
        case .Email:
            
            return 90.0
            
        case .Gender:
            
            return 75.0
            
        case .MaritalStatus:
            
            return 60.0
            
        case .BirthDay:
            
            return 60.0
            
        case .Zodiac:
            
            return 75.0
            
        case .Interests:
            
            return 90.0
            
        case .Location:
            
            return 75.0
            
        case .PhoneNumber:
            
            return 75.0
            
        case .AboutMe:
            
            return 190.0
            
        }

        return 0;
        
//        let text: NSString = "Any parent will tell you that colic is one of the most excruciating experiences of early parenthood. The baby cries as if in dire pain, and there just seems to be nothing for a parent to do. A baby is suspected to have -- -30"
//
//        let attributes: [String : Any] = [NSFontAttributeName: AppTheme.regularFont(withSize: 16)]
//
//        let textFrame = text.boundingRect(with: CGSize(width: self.frame.size.width - 60, height: CGFloat.greatestFiniteMagnitude), options: .usesLineFragmentOrigin, attributes: attributes, context: nil)
//
//        let bottomSpaing: CGFloat = 40.0;
//
//        var estimatedHeight: CGFloat = 880.0;
//
//        var offset: CGFloat = 0.0
//        if textFrame.size.height > 24 {
//
//            offset = textFrame.size.height
//        }
//
//        estimatedHeight = estimatedHeight + offset
//
//        // Default Height
//        return estimatedHeight;
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        print(#function)
    }

}

extension ProfileTableView: UserProfileTableViewCellDelegate {
    
    func userProfileTableViewCell(_ cell: UserProfileTableViewCell, textFieldShouldBeginEditing textField: UITextField, at indexPath: IndexPath) -> Bool {
        print(#function)
        let profileValueType: ProfileValueType = self.profileValueList[indexPath.row]
        
        switch profileValueType {
        case .FirstName:
            break
        case .LastName:
            break
        case .Email:
            break
        case .Gender:
            
            self.endEditing(true)

            let genderAlert = UIAlertController()

            let values: PickerViewViewController.Values = [["Male","Female"]]

            genderAlert.addPickerView(values: values, action: { (controller, picker, index, values) in

                cell.titleTextField.text = values.first?.item(at: index.row)

                self.updatedUserProfile.gender = cell.titleTextField.text
            })

            genderAlert.addAction(title: "Done", style: .cancel)
            
            self.parentViewController.present(genderAlert, animated: true, completion: nil)
            
            return false
            
        case .MaritalStatus:
            
            self.endEditing(true)
            
            let genderAlert = UIAlertController()
            
            let values: PickerViewViewController.Values = [AppFunctions.getMaritalStatusList()]
            
            genderAlert.addPickerView(values: values, action: { (controller, picker, index, values) in
                
                cell.titleTextField.text = values.first?.item(at: index.row)
                
                self.updatedUserProfile.maritalStatus.statusTitle = cell.titleTextField.text
                self.updatedUserProfile.maritalStatus.statusId = cell.titleTextField.text?.getMaritalStatusId()
            })
            
            genderAlert.addAction(title: "Done", style: .cancel)
            self.parentViewController.present(genderAlert, animated: true, completion: nil)
            
            return false
            
        case .BirthDay:
            
            self.endEditing(true)

            let genderAlert = UIAlertController()

            genderAlert.addDatePicker(mode: UIDatePickerMode.date, date: Date(), action: { (date) in

                cell.titleTextField.text = date.dateString(ofFormat: "MMM dd, yyyy")

                self.updatedUserProfile.birthday = cell.titleTextField.text!
                
//                let birthday: String = cell.titleTextField.text!
//                self.updatedUserProfile.birthday = birthday.stringDate(ofFormat: "dd-MMM-yyyy", toFormat: "MMM dd, yyyy")
//                
                self.updatedUserProfile.zodiac = self.updatedUserProfile.birthday.getZodiacSign()
                self.userProfile.zodiac = self.updatedUserProfile.zodiac
                
                self.reloadRows(at: [IndexPath(row: indexPath.row + 1, section:indexPath.section)], with: UITableViewRowAnimation.none)
                
            })

            genderAlert.addAction(title: "Done", style: .cancel)
            self.parentViewController.present(genderAlert, animated: true, completion: nil)
            
            return false
            
        case .Zodiac:
            
//            self.endEditing(true)
//
//            let genderAlert = UIAlertController()
//
//            genderAlert.addDatePicker(mode: UIDatePickerMode.date, date: Date(), action: { (date) in
//
//                cell.titleTextField.text = date.dateString().getZodiacSign()
//                self.updatedUserProfile.zodiac = cell.titleTextField.text
//            })
//
//            genderAlert.addAction(title: "Done", style: .cancel)
//            genderAlert.show()
            
            return false
            
        case .Interests:
            break
        case .Location:
            break
        case .PhoneNumber:
            break
        case .AboutMe:
            break
        }
        
        return true
    }
    
    func userProfileTableViewCell(_ cell: UserProfileTableViewCell, textFieldShouldReturn textField: UITextField, at indexPath: IndexPath) -> Bool {
        print(#function)
        let profileValueType: ProfileValueType = self.profileValueList[indexPath.row]
        
        switch profileValueType {
        case .FirstName:
            break
        case .LastName:
            break
        case .Email:
            break
        case .Gender:
            
            return false
        case .MaritalStatus:
            break
        case .BirthDay:
            
            return false
        case .Zodiac:
            break
        case .Interests:
            break
        case .Location:
            break
        case .PhoneNumber:
            break
        case .AboutMe:
            break
        }
        
        return true
    }
    
    func userProfileTableViewCell(_ cell: UserProfileTableViewCell, textFieldDidBeginEditing textField: UITextField, at indexPath: IndexPath) {
        print(#function)
    }
    
    func userProfileTableViewCell(_ cell: UserProfileTableViewCell, textFieldDidEndEditing textField: UITextField, at indexPath: IndexPath) {
     print(#function)
        let profileValueType: ProfileValueType = self.profileValueList[indexPath.row]
        
        switch profileValueType {
        case .FirstName:
            
            self.updatedUserProfile.firstName = textField.text
            
            break
        case .LastName:
            
            self.updatedUserProfile.lastName = textField.text
            
            break
        case .Email:
            
            self.updatedUserProfile.email = textField.text

            break
        case .Gender:
            break
        case .MaritalStatus:
            break
        case .BirthDay:
            break
        case .Zodiac:
            break
        case .Interests:
            
            self.updatedUserProfile.interest = textField.text
            
            break
        case .Location:
            
            self.updatedUserProfile.locationAddress = textField.text
            
            break
        case .PhoneNumber:
            
            self.updatedUserProfile.phoneNumber = textField.text
            
            break
        case .AboutMe:
            break
        }
    }
    
    // Text View
    
    func userProfileTableViewCell(_ cell: UserProfileTableViewCell, textViewShouldBeginEditing textView: UITextView, at indexPath: IndexPath) -> Bool {
        print(#function)
        let profileValueType: ProfileValueType = self.profileValueList[indexPath.row]
        
        if profileValueType == .AboutMe {
            
            return true
        }
        else {
            
            return true
        }
    }
 
    func userProfileTableViewCell(_ cell: UserProfileTableViewCell, textViewShouldReturn textView: UITextView, at indexPath: IndexPath) -> Bool {
        print(#function)
        let profileValueType: ProfileValueType = self.profileValueList[indexPath.row]
        
        if profileValueType == .AboutMe {
            
            return true
        }
        else {
            
            return true
        }
    }
    
    func userProfileTableViewCell(_ cell: UserProfileTableViewCell, textViewDidBeginEditing textView: UITextView, at indexPath: IndexPath) {
        print(#function)
    }
    
    func userProfileTableViewCell(_ cell: UserProfileTableViewCell, textViewDidEndEditing textView: UITextView, at indexPath: IndexPath) {
        print(#function)
        let profileValueType: ProfileValueType = self.profileValueList[indexPath.row]
        
        if profileValueType == .AboutMe {
            
            self.updatedUserProfile.about = textView.text
        }
    }
}


/*
 
 switch profileValueType {
 case .FirstName:
 break
 case .LastName:
 break
 case .Email:
 break
 case .Gender:
 break
 case .MaritalStatus:
 break
 case .BirthDay:
 break
 case .Zodiac:
 break
 case .Interests:
 break
 case .Location:
 break
 case .PhoneNumber:
 break
 case .AboutMe:
 break
 }
 
 */

