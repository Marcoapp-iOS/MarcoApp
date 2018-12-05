//
//  GroupObject.swift
//  MarcoApp
//
//  Created by Nabeel Hayat on 08/03/2018.
//  Copyright © 2018 GrayScaleLogic. All rights reserved.
//

import UIKit
import ObjectMapper

class GroupCreateObject: NSObject {
    
    var groupId: Int!
    var profileProgress: CGFloat = 0.0
    var coverProgress: CGFloat = 0.0
    var indexPath: IndexPath!
    
    var isAvatarPicture: Bool = false
    var isCoverPicture: Bool = false
    
    var avatarPictureChanged: Bool = false
    var coverPictureChanged: Bool = false
    
    override init() {
        super.init()
    }
    
    init(groupId: Int) {
        super.init()
        
        self.groupId = groupId
    }
    
    init(groupId: Int, indexPath: IndexPath) {
        super.init()
        
        self.groupId = groupId
        self.indexPath = indexPath
    }
}

class GroupObjectMapper: Mappable {
    
    var groupId: Int! = nil
    var groupTitle: String! = nil
    var groupDescription: String! = nil
    var groupProfilePicture: String! = nil
    var groupCoverPicture: String! = nil
    var groupCreatedBy: String! = nil
    var groupCategoryId: Int! = nil
    var groupPrice: Double! = nil
    var groupPriceId: Int! = nil
    var isPaidGroup: Bool! = nil
    var isPrivateGroup: Bool! = nil
    var groupCreatedDate: String! = nil
    var groupJoinDate: String! = nil
    var groupModifiedDate: String! = nil
    var isDeletedGroup: Bool! = nil
    var totalMembers: NSNumber! = nil
    
    var totalPosts: NSNumber! = nil
    
    var groupCreator: UserProfileMapper! = nil
    
    var isUserCanJoin: Bool! = nil
    
    var groupMembers: [UserProfileMapper] = []
        
    init() {
        
    }
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        
        if map["Id"].isKeyPresent {
            
            self.groupId <- map["Id"]
        }
        else if map["GroupId"].isKeyPresent {
            
            self.groupId <- map["GroupId"]
        }
        
        self.groupTitle <- map["Title"]
        self.groupDescription <- map["Description"]
        self.groupProfilePicture <- map["ProfilePicture"]
        self.groupCoverPicture <- map["CoverPicture"]
        self.groupCreatedBy <- map["CreatedBy"]
        self.groupCategoryId <- map["CategoryId"]
        self.groupPrice <- map["Price"]
        self.groupPriceId <- map["DefaultPriceId"]
        self.groupCreatedDate <- map["CreatedDate"]
        self.groupJoinDate <- map["JoinDate"]
        self.groupModifiedDate <- map["ModifiedDate"]
        self.isPaidGroup <- map["IsPaid"]
        self.isPrivateGroup <- map["IsPrivate"]
        self.isDeletedGroup <- map["IsDeleted"]
        
        self.isUserCanJoin <- map["CanJoin"]
        self.totalPosts <- map["TotalPosts"]
        
        self.totalMembers <- map["TotalMembers"]
        
        if map["TotalMembers"].isKeyPresent {
            
            self.totalMembers <- map["TotalMembers"]
        }
        if map["Strength"].isKeyPresent {
            
            self.totalMembers <- map["Strength"]
        }
        
        if map["Members"].isKeyPresent {

            self.groupMembers <- map["Members"]
        }
        else {

            self.groupMembers <- map["GroupUsers"]
        }
        
        if map["User"].isKeyPresent {
        
            self.groupCreator <- map["User"]
        }
        else {
            
            self.groupCreator <- map["GroupCreator"]
        }
        
    }
}

class GroupObject: NSObject {

    var groupId: Int! = nil
    var groupCategoryId: Int! = nil
    var groupPriceId: Int! = nil
    
    var groupPrice: Double! = nil
    
    var totalMembers: NSNumber! = nil
    
    var groupTitle: String! = nil
    var groupDescription: String! = nil
    var groupProfilePicture: String! = nil
    var groupCoverPicture: String! = nil
    var groupCreatedBy: String! = nil
    var groupCreatedDate: String! = nil
    var groupJoinDate: String! = nil
    var groupModifiedDate: String! = nil
    
    var isPaidGroup: Bool! = nil
    var isPrivateGroup: Bool! = nil
    var isDeletedGroup: Bool! = nil
    var isUserCanJoin: Bool! = nil
    
    var isCreatedGroup: Bool! = nil
    
    var groupCreator: UserProfile! = nil
    
    var groupMembers: [UserProfile] = []
    
    var totalPosts: NSNumber! = nil
    
    var profileImage: UIImage!
    var coverImage: UIImage!
    
    override init() {
        super.init()
        self.setupDefaultState()
    }
    
//    init(object: UserProfileEntity) {
//        super.init()
//        self.setupDefaultState()
//        
//    }
    
    init(with response: [String: Any]) {
        super.init()
        self.setupDefaultState()
        
        if response["GroupId"] != nil {
            
            self.groupId = response["GroupId"] as? Int
        }
        else {
            self.groupId = -1
        }
        
        if response["Title"] != nil {
            
            self.groupTitle = response["Title"] as? String
        }
        else {
            self.groupTitle = ""
        }
        
        if response["Description"] != nil {
            
            self.groupDescription = response["Description"] as? String
        }
        else {
            self.groupDescription = ""
        }
        
        if response["ProfilePicture"] != nil {
            
            self.groupProfilePicture = response["ProfilePicture"] as? String
        }
        else {
            self.groupProfilePicture = ""
        }
        
        if response["CoverPicture"] != nil {
            
            self.groupCoverPicture = response["CoverPicture"] as? String
        }
        else {
            self.groupCoverPicture = ""
        }
        
        if response["CreatedBy"] != nil {
            
            self.groupCreatedBy = response["CreatedBy"] as? String
        }
        else {
            self.groupCreatedBy = ""
        }
        
        if response["CategoryId"] != nil {
            
            self.groupCategoryId = response["CategoryId"] as? Int
        }
        else {
            self.groupCategoryId = -1
        }
        
        if response["Price"] != nil {
            
            self.groupPrice = response["Price"] as? Double
        }
        else {
            self.groupPrice = 0.99
        }
        
        if response["DefaultPriceId"] != nil {
            
            self.groupPriceId = response["DefaultPriceId"] as? Int
        }
        else {
            self.groupPriceId = 1
        }
        
        if response["IsPaid"] != nil {
            
            self.isPaidGroup = response["IsPaid"] as? Bool
        }
        else {
            self.isPaidGroup = true
        }
        
        if response["IsPrivate"] != nil {
            
            self.isPrivateGroup = response["IsPrivate"] as? Bool
        }
        else {
            self.isPrivateGroup = true
        }
        
        if response["CreatedDate"] != nil {
            
            self.groupCreatedDate = response["CreatedDate"] as? String
        }
        else {
            self.groupCreatedDate = ""
        }
        
        if response["JoinDate"] != nil {
            
            self.groupJoinDate = response["JoinDate"] as? String
        }
        else {
            self.groupJoinDate = ""
        }
        
        if response["ModifiedDate"] != nil {
            
            self.groupModifiedDate = response["ModifiedDate"] as? String
        }
        else {
            self.groupModifiedDate = ""
        }
        
        if response["IsDeleted"] != nil {
            
            self.isDeletedGroup = response["IsDeleted"] as? Bool
        }
        else {
            self.isDeletedGroup = false
        }
        
        if response["TotalMembers"] != nil {
            
            self.totalMembers = response["TotalMembers"] as? NSNumber
        }
        else {
            
            self.totalMembers = 1
        }
        
        if response["CanJoin"] != nil {
            
            self.isUserCanJoin = response["CanJoin"] as? Bool
        }
        else {
            self.isUserCanJoin = false
        }
        
        if response["GroupUsers"] != nil {
            
            for groupMember: [String : Any] in response["GroupUsers"] as! [[String : Any]] {
         
                self.groupMembers.append(UserProfile(with: groupMember))
            }
        }
        else {
            
            self.groupMembers = []
        }
    }
    
    private func setupDefaultState() {
        
        self.groupId = -1
        self.groupTitle = ""
        self.groupDescription = ""
        self.groupProfilePicture = ""
        self.groupCoverPicture = ""
        self.groupCreatedBy = ""
        self.groupCategoryId = 1
        self.groupPrice = 0.99
        self.groupPriceId = 0
        self.isPaidGroup = true
        self.isPrivateGroup = true
        self.groupCreatedDate = ""
        self.groupJoinDate = ""
        self.groupModifiedDate = ""
        self.isDeletedGroup = false
        self.totalMembers = 1
        self.isUserCanJoin = false
        self.groupCreator = nil
        self.groupMembers = []
    }
        
}

// MARK: - Group List

class GroupsListMapper: Mappable {
    
    var groupsList: [GroupObjectMapper] = []
    
    init() {
        
    }
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        
        if map["Groups"].isKeyPresent {
        
            self.groupsList <- map["Groups"]
        }
        if map["Data"].isKeyPresent {
            
            self.groupsList <- map["Data"]
        }
    }
}

// MARK: - Group Categories

class GroupCategoriesListMapper: Mappable {
    
    var groupCategoriesList: [GroupCategoryMapper] = []
    
    init() {
        
    }
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        
        self.groupCategoriesList <- map["GroupCategories"]
    }
}

class GroupCategoryMapper: Mappable {
    
    
    var categoryId: Int! = nil
    var categoryTitle: String! = nil
    
    init() {
        
    }
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        
        self.categoryId <- map["Id"]
        self.categoryTitle <- map["Title"]
    }
    
}

class GroupCategoryObject: NSObject {
    
    var categoryId: Int! = nil
    var categoryTitle: String! = nil
    
    override init() {
        super.init()
        self.categoryTitle = "Social"
        self.categoryId = 1
    }
    
    init(withTitle title: String, categoryId: Int) {
        super.init()
        self.categoryTitle = title
        self.categoryId = categoryId
    }
    
//    init(object: GroupCategoryEntity) {
//
//
//    }
    
    init(WithResponse response: [String: Any]) {
        
        if response["Id"] != nil {
            
            self.categoryId = response["Id"] as? Int
        }
        else {
            
            self.categoryId = 1
        }
        
        if response["Title"] != nil {
            
            self.categoryTitle = response["Title"] as? String
        }
        else {
            
            self.categoryTitle = "Social"
        }
    }
}


// MARK:- Group Prices

class GroupPricesListMapper: Mappable {
    
    var groupPricesList: [GroupPriceMapper] = []
    
    init() {
        
    }
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        
        self.groupPricesList <- map["GroupDefaultPrices"]
    }
}

class GroupPriceMapper: Mappable {
    
    
    var priceId: Int! = nil
    var price: Double! = nil
    
    init() {
        
    }
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        
        self.priceId <- map["Id"]
        self.price <- map["Price"]
    }
    
}

class GroupPriceObject: NSObject {
    
    var priceId: Int! = nil
    var price: Double! = nil
    
    override init() {
        super.init()
        self.price = 0.99
        self.priceId = 1
    }
    
    init(withPrice price: Double, priceId: Int) {
        super.init()
        self.price = price
        self.priceId = priceId
    }
    
    //    init(object: GroupPriceEntity) {
    //
    //
    //    }
    
    init(WithResponse response: [String: Any]) {
        
        if response["Id"] != nil {
            
            self.priceId = response["Id"] as? Int
        }
        else {
            
            self.priceId = 1
        }
        
        if response["Price"] != nil {
            
            self.price = response["Price"] as? Double
        }
        else {
            
            self.price = 0.99
        }
    }
}
