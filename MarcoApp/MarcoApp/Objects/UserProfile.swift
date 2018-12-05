//
//  UserProfile.swift
//  MarcoApp
//
//  Created by Nabeel Hayat on 11/01/2018.
//  Copyright © 2018 GrayScaleLogic. All rights reserved.
//

import UIKit
import ObjectMapper

struct UserLocation {
    
    var latString: String! = nil
    var lonString: String! = nil
    
    var lat: Double! = nil
    var lon: Double! = nil
    
    init() {
        self.latString = "0"
        self.lonString = "0"
        
        self.lat = Double(self.latString)
        self.lon = Double(self.lonString)
    }
    
    init(lat: String, lon: String) {
        
        self.latString = lat
        self.lonString = lon
        
        self.lat = Double(self.latString)
        self.lon = Double(self.lonString)
    }
}

class UserProfileMapper: BaseResponse {

    var userIdInt: Int! = nil
    var userId: String! = nil
    var userSocialId: String! = nil
    var fullName: String! = nil
    var firstName: String! = nil
    var lastName: String! = nil
    var email: String! = nil
    var gender: String! = nil
    var birthday: String! = nil
    var maritalStatus: MaritalStatusObject = MaritalStatusObject()
    var about: String! = nil
    var timezone: Float! = nil
    var locale: String! = nil
    var profilePicture: String! = nil
    var coverPicture: String! = nil
    var locationAddress: String! = nil
    var interest: String! = nil
    var designation: String! = nil
    var phoneNumber: String! = nil
    var zodiac: String! = nil
    var location: UserLocation! = nil
    
    var isOnline: Bool! = nil
    var isFavorite: Bool! = nil
    var lastSeen: String! = nil
    
    var isStripeCustomer: Bool! = nil
    
    var channel: String! = nil
    
    override init() {
        super.init()
    }
    
    override func mapping(map: Map) {
        super.mapping(map: map)
        
        
        if map["StripeCustomer"].isKeyPresent {
            
            self.isStripeCustomer <- map["StripeCustomer"]
        }
        else {
            
            self.isStripeCustomer = false
        }
        
        if map["Channel"].isKeyPresent {
            
            self.channel <- map["Channel"]
        }
        else if map["User.Channel"].isKeyPresent {
            
            self.channel <- map["User.Channel"]
        }
        else {
            
            self.channel = ""
        }
        
        if map["id"].isKeyPresent {
            
            self.userId <- map["id"]
        }
        if map["Id"].isKeyPresent {
            
            self.userId <- map["Id"]
            self.userIdInt <- map["Id"]
        }
        if map["User.Id"].isKeyPresent {
            
            self.userId <- map["User.Id"]
            self.userIdInt <- map["User.Id"]
        }
        else {
        
            if map["UserId"].isKeyPresent {
                
                self.userId <- map["UserId"]
            }
        }
        
        if map["name"].isKeyPresent {
            
            self.fullName <- map["name"]
        }
        else {
        
            self.fullName = ""
        }
        
        if map["first_name"].isKeyPresent {
        
            self.firstName <- map["first_name"]
        }
        if map["Idol.FirstName"].isKeyPresent {
            
            self.firstName <- map["Idol.FirstName"]
        }
        if map["User.FirstName"].isKeyPresent {
            
            self.firstName <- map["User.FirstName"]
        }
        else {
            
            self.firstName <- map["FirstName"]
        }
        
        if map["last_name"].isKeyPresent {
            
            self.lastName <- map["last_name"]
        }
        if map["Idol.LastName"].isKeyPresent {
            
            self.lastName <- map["Idol.LastName"]
        }
        if map["User.LastName"].isKeyPresent {
            
            self.lastName <- map["User.LastName"]
        }
        else {
            
            self.lastName <- map["LastName"]
        }
        
        if map["email"].isKeyPresent {
            
            self.email <- map["email"]
        }
        else {
            
            self.email <- map["Email"]
        }
        
        if map["gender"].isKeyPresent {
            
            self.gender <- map["gender"]
        }
        else {
            
            self.gender <- map["Gender"]
        }
        
        if map["birthday"].isKeyPresent {
            
            self.birthday <- map["birthday"]
        }
        else {
            self.birthday <- map["DOB"]

            if self.birthday != nil {
                
                self.birthday = self.birthday.stringDate(ofFormat: "yyyy-MM-dd'T'HH:mm:ss", toFormat: "MMM dd, yyyy")
                self.zodiac = self.birthday.getZodiacSign()
            }
        }
        
        if map["phone"].isKeyPresent {
            
            self.phoneNumber <- map["Phone"]
        }
        else {
            
            self.phoneNumber <- map["Phone"]
        }
        
        if map["location.name"].isKeyPresent {
            
            self.locationAddress <- map["location.name"]
        }
        else {
            
            self.locationAddress <- map["Location"]
        }
        
//        self.maritalStatus <- map["relationship_status"]
        if map["about"].isKeyPresent {
            
            self.about <- map["about"]
        }
        else {
            
            self.about <- map["About"]
        }
        
        
        if map["timezone"].isKeyPresent {
            
            self.timezone <- map["timezone"]
        }
        else {
            
            self.timezone = 0
        }
        
        if map["locale"].isKeyPresent {
            
            self.locale <- map["locale"]
        }
        else {
            
            self.locale <- map["Locale"]
        }
        
        if map["picture.data.url"].isKeyPresent {
            
            self.profilePicture <- map["picture.data.url"]
        }
        else if map["Idol.Picture"].isKeyPresent {
            
            self.profilePicture <- map["Idol.Picture"]
        }
        else if map["User.ProfilePicture"].isKeyPresent {
            
            self.profilePicture <- map["User.ProfilePicture"]
        }
        else if map["picture"].isKeyPresent {
            
            self.profilePicture <- map["picture"]
        }
        else if map["Picture"].isKeyPresent {
            
            self.profilePicture <- map["Picture"]
        }
        else {
            
            self.profilePicture <- map["ProfilePicture"]
        }
        
        if map["CoverPicture"].isKeyPresent {
            
            self.coverPicture <- map["CoverPicture"]
        }
        else if map["User.CoverPicture"].isKeyPresent {
            
            self.profilePicture <- map["User.CoverPicture"]
        }
        else {
            
            self.coverPicture = ""
        }
        
        if map["Title"].isKeyPresent {
            
            
            self.designation <- map["Title"]
        }
        else {
            
            self.designation = ""
        }
        
        if map["MeritalStatusId"].isKeyPresent {
            
            self.maritalStatus = MaritalStatusObject()
            self.maritalStatus.statusId  <- map["MeritalStatusId"]
            self.maritalStatus.statusTitle = self.maritalStatus.statusId.getMaritalStatus()
            
        }
        else {
            
            self.maritalStatus = MaritalStatusObject()
        }
        
        if map["Latitude"].isKeyPresent && map["Longitude"].isKeyPresent {
            
            self.location = UserLocation()
            
            self.location.lat <- map["Latitude"]
            self.location.lon <- map["Longitude"]
            
        }
        else if map["Idol.Location.Latitude"].isKeyPresent && map["Idol.Location.Longitude"].isKeyPresent {
            
            self.location = UserLocation()
            
            self.location.lat <- map["Idol.Location.Latitude"]
            self.location.lon <- map["Idol.Location.Longitude"]
        }
        else if map["Coordinate.Latitude"].isKeyPresent && map["Coordinate.Longitude"].isKeyPresent {
            
            self.location = UserLocation()
            
            self.location.lat <- map["Coordinate.Latitude"]
            self.location.lon <- map["Coordinate.Longitude"]
        }
        else if map["User.Coordinate.Latitude"].isKeyPresent && map["User.Coordinate.Longitude"].isKeyPresent {
            
            self.location = UserLocation()
            
            self.location.lat <- map["User.Coordinate.Latitude"]
            self.location.lon <- map["User.Coordinate.Longitude"]
        }
        else {

            self.location = UserLocation()
        }
        
        if map["Interests"].isKeyPresent {
            
            
            self.interest <- map["Interests"]
        }
        else {
            
            self.interest = ""
        }
        
        if map["IsOnline"].isKeyPresent {
            
            
            self.isOnline <- map["IsOnline"]
        }
        else {
            
            self.isOnline = false
        }
        
        if map["IsFavorite"].isKeyPresent {
            
            
            self.isFavorite <- map["IsFavorite"]
        }
        else {
            
            self.isFavorite = false
        }
        
        if map["LastSeen"].isKeyPresent {
            
            
            self.lastSeen <- map["LastSeen"]
        }
        if map["User.LastSeen"].isKeyPresent {
            
            
            self.lastSeen <- map["User.LastSeen"]
        }
        else {
            
            self.lastSeen = ""
        }
        
    }
    
}

class UserProfile: NSObject {
    
    var userId: String! = nil
    var userSocialId: String! = nil
    var fullName: String! = nil
    var firstName: String! = nil
    var lastName: String! = nil
    var email: String! = nil
    var gender: String! = nil
    var birthday: String! = nil
    var maritalStatus: MaritalStatusObject = MaritalStatusObject()
    var about: String! = nil
    var timezone: Float! = nil
    var locale: String! = nil
    var profilePicture: String! = nil
    var coverPicture: String! = nil
    var locationAddress: String! = nil
    var interest: String! = nil
    var designation: String! = nil
    var phoneNumber: String! = nil
    var zodiac: String! = nil
    var location: UserLocation! = nil
    
    var isOnline: Bool! = nil
    var isFavorite: Bool! = nil
    var lastSeen: String! = nil
    
    var isStripeCustomer: Bool! = nil
    var channel: String! = nil
    
    override init() {
        super.init()
        self.setupDefaultState()
    }
    
    init(object: UserProfileEntity) {
        super.init()
        self.setupDefaultState()
        
    }
    
    init(with response: [String: Any]) {
        super.init()
        self.setupDefaultState()
        
        if response["StripeCustomer"] != nil {
            
            self.isStripeCustomer = (response["StripeCustomer"] as! Bool)
        }
        else  {
            
            self.isStripeCustomer = false
        }
        
        if response["UserId"] != nil && response["UserId"] != nil {
            
            self.userId = (response["UserId"] as! String)
        }
        else {
            
            self.userId = ""
        }
        
        if response["Channel"] != nil && response["Channel"] != nil {
            
            self.channel = (response["Channel"] as! String)
        }
        else {
            
            self.channel = ""
        }
        
        if response["FirstName"] != nil && response["LastName"] != nil {
            
            self.fullName = "\(response["FirstName"] as! String) \(response["LastName"] as! String)"
        }
        else {
            
            self.fullName = ""
        }
        
        if response["LastName"] != nil {
            
            self.lastName = (response["LastName"] as! String)
        }
        else {
            
            self.lastName = ""
        }
        
        if response["Gender"] != nil {
            
            
            self.gender = (response["Gender"] as! String).capitalizingFirstLetter()
        }
        else {
            
            self.gender = ""
        }
        
        if response["Phone"] != nil {
            
            
            self.phoneNumber = (response["Phone"] as! String)
        }
        else {
            
            self.phoneNumber = ""
        }
        
        if response["Location"] != nil {
            
            
            self.locationAddress = (response["Location"] as! String)
        }
        else {
            
            self.locationAddress = ""
        }
        
        if response["DOB"] != nil {
            
            
            self.birthday = (response["DOB"] as! String)
            self.zodiac = self.birthday.getZodiacSign()
        }
        else {
            
            self.birthday = ""
            self.zodiac = ""
        }
        
        if response["Title"] != nil {
            
            
            self.designation = (response["Title"] as! String)
        }
        else {
            
            self.designation = ""
        }
        
        if response["MeritalStatusId"] != nil {
            
            let statusId: Int = response["MeritalStatusId"] as! Int
            self.maritalStatus = MaritalStatusObject(withTitle: statusId.getMaritalStatus(), statusId: statusId)
        }
        else {
            
            self.maritalStatus = MaritalStatusObject()
        }
        
        if response["about"] != nil {
            
            
            self.about = (response["about"] as! String)
        }
        else {
            
            self.about = ""
        }
        
        if response["ProfilePicture"] != nil {
            
            
            self.profilePicture = (response["ProfilePicture"] as! String)
        }
        else {
            
            self.profilePicture = ""
        }
        
        if response["CoverPicture"] != nil {
            
            
            self.coverPicture = (response["CoverPicture"] as! String)
        }
        else {
            
            self.coverPicture = ""
        }
        
        if response["Latitude"] != nil && response["Longitude"] != nil {
            
            
            self.location = UserLocation(lat: String(describing: response["Latitude"]), lon: String(response["Longitude"] as! Int))
        }
        else {
            
            self.location = UserLocation(lat: "0", lon: "0")
        }
        
        if response["Locale"] != nil {
            
            
            self.locale = (response["Locale"] as! String)
        }
        else {
            
            self.locale = ""
        }
        
        if response["Interests"] != nil {
            
            
            self.interest = (response["Interests"] as! String)
        }
        else {
            
            self.interest = ""
        }
    }
    
    init(WithFBResponse response: [String: Any]) {
        super.init()
        self.setupDefaultState()
        
        
        if response["name"] != nil {
            
            self.fullName = (response["name"] as! String)
        }
        else {
            
            self.fullName = ""
        }
        
        if response["first_name"] != nil {
            
            self.firstName = (response["first_name"] as! String)
        }
        else {
            
            self.firstName = ""
        }
        
        if response["Channel"] != nil {
            
            self.channel = (response["Channel"] as! String)
        }
        else {
            
            self.channel = ""
        }
        
        if response["last_name"] != nil {
            
            self.lastName = (response["last_name"] as! String)
        }
        else {
            
            self.lastName = ""
        }
        
        if response["email"] != nil {
            
            self.email = (response["email"] as! String)
        }
        else {
            
            self.email = ""
        }
        
        if response["gender"] != nil {
            
            
            self.gender = (response["gender"] as! String).capitalizingFirstLetter()
        }
        else {
            
            self.gender = ""
        }
        
        if response["birthday"] != nil {
            
            self.birthday = (response["birthday"] as! String).stringDate(ofFormat: "MM/dd/yyyy", toFormat: "MMM dd, yyyy")
            
            self.zodiac = self.birthday.getZodiacSign()
        }
        else {
            self.zodiac = ""
            self.birthday = ""
        }
        
        if response["locale"] != nil {
            
            self.locale = (response["locale"] as! String)
        }
        else {
            
            self.locale = ""
        }
        
        if response["relationship_status"] != nil {

            let status = response["relationship_status"] as! String
            
            self.maritalStatus.statusId = status.getMaritalStatusId()
            
            self.maritalStatus.statusTitle = self.maritalStatus.statusId.getMaritalStatus()
        }
        else {

            self.maritalStatus.statusTitle = "Single"
            self.maritalStatus.statusId = 1
        }
        
        if response["id"] != nil {
            
            self.userSocialId = (response["id"] as! String)
        }
        else {
            
            self.userSocialId = ""
        }
        
        if response["about"] != nil {
            
            self.about = (response["about"] as! String)
        }
        else {
            
            self.about = ""
        }
        
        if response["timezone"] != nil {
            
            self.timezone = (response["timezone"] as! Float)
        }
        else {
            
            self.timezone = 0
        }
        
        if response["picture"] != nil {
            
            let data: [String: Any] = response["picture"] as! [String: Any]
            
            if data["data"] != nil {
            
                let dataDict: [String: Any] = data["data"] as! [String : Any]
                
                if dataDict["url"] != nil {
                    
                    self.profilePicture = (dataDict["url"] as! String)
                }
                else {
                    
                    self.profilePicture = ""
                }
            }
            else {
             
                self.profilePicture = ""
            }
        }
        else {
            
            self.profilePicture = ""
        }
        
        if response["location"] != nil {
            
            let location: [String:Any] = response["location"] as! [String : Any]
            self.locationAddress = (location["name"] as! String)
        }
        else {
            
            self.locationAddress = ""
        }
        
    }
    
    /*
     
     ["relationship_status": Single, ]
     
     */
    
    private func setupDefaultState() {
        
        self.userId = ""
        self.userSocialId = ""
        self.fullName = ""
        self.firstName = ""
        self.lastName = ""
        self.email = ""
        self.gender = ""
        self.birthday = ""
        self.maritalStatus = MaritalStatusObject()
        self.about = ""
        self.timezone = 0
        self.locale = ""
        self.profilePicture = ""
        self.coverPicture = ""
        self.locationAddress = ""
        self.interest = ""
        self.designation = ""
        self.phoneNumber = ""
        self.zodiac = ""
        self.isStripeCustomer = false
        self.location = UserLocation(lat: "0", lon: "0")
    }
    
}

class UserProfileListMapper: Mappable {
    
    var userProfileList: [UserProfileMapper] = []
    
    init() {
        
    }
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        
        if map["SingleAppUser"].isKeyPresent {
            
            self.userProfileList <- map["SingleAppUser"]
        }
        if map["GroupUsers"].isKeyPresent {
            
            self.userProfileList <- map["GroupUsers"]
        }
        if map["Data"].isKeyPresent {
            
            self.userProfileList <- map["Data"]
        }
        else {
        }
    }
}

// MARK:- Marital Status

class MaritalStatusListMapper: Mappable {

    var maritalStatusList: [MaritalStatusMapper] = []
    
    init() {
        
    }
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        
        self.maritalStatusList <- map["MeritalStatuses"]
    }
}

class MaritalStatusMapper: Mappable {
    
    
    var statusId: Int! = nil
    var statusTitle: String! = nil
    
    init() {
        
    }
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        
        self.statusId <- map["Id"]
        self.statusTitle <- map["Title"]
    }
    
}

class MaritalStatusObject: NSObject {
    
    var statusId: Int! = nil
    var statusTitle: String! = nil
    
    override init() {
        super.init()
        self.statusTitle = "Single"
        self.statusId = 1
    }
    
    init(withTitle title: String, statusId: Int) {
        super.init()
        self.statusTitle = title
        self.statusId = statusId
    }
    
    init(object: UserProfileEntity) {
        
        
    }
    
    init(WithFBResponse response: [String: Any]) {
        
        if response["Id"] != nil {
            
            self.statusId = (response["Id"] as! Int)
        }
        else {
            
            self.statusId = 1
        }
        
        if response["Title"] != nil {
            
            self.statusTitle = (response["Title"] as! String)
        }
        else {
            
            self.statusTitle = "Single"
        }
    }
}

class MessageObjectMapper: Mappable {
    
    var message: String! = nil
    
    init() {
        
    }
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        
        
        if map["Message"].isKeyPresent {
        
            self.message <- map["Message"]
        }
        else {
            
            self.message = ""
        }
    }
    
}

class FileURLMapper: Mappable {
    
    var urlString: String! = nil
    
    init() {
        
    }
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        
        self.urlString <- map["URL"]
    }
    
}
