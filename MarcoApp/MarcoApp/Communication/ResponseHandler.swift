//
//  ResponseHandler.swift
//  MarcoApp
//
//  Created by Nabeel Hayat on 17/01/2018.
//  Copyright © 2018 GrayScaleLogic. All rights reserved.
//

import UIKit
import MagicalRecord
import CoreData


class ResponseHandler: NSObject {

    //        if groupDBState == .Creating {
    //
    //        }
    //        else if groupDBState == .MyGroups {
    //
    //            let predicate: NSPredicate = NSPredicate(format: "groupSaveState=%@", groupDBState as! CVarArg)
    //
    //            GroupEntity.mr_deleteAll(matching: predicate)
    //        }
    //        else if groupDBState == .DiscoverGroups {
    //
    //            let predicate: NSPredicate = NSPredicate(format: "groupSaveState=%@", groupDBState as! CVarArg)
    //
    //            GroupEntity.mr_deleteAll(matching: predicate)
    //        }
    
    static func groupListResponse(_ groupDBState: GroupDBState, _ responseList: GroupsListMapper, completion: @escaping (_ result: Bool) -> Void) {
        
        if groupDBState == .Creating {
        }
        else {
        
            let predicate: NSPredicate = NSPredicate(format: "groupSaveState == %@", groupDBState.rawValue)
            
            GroupEntity.mr_deleteAll(matching: predicate)
            
        }
        
        for groupObjectMapper: GroupObjectMapper in responseList.groupsList {
            
            self.groupResponse(true, groupDBState, groupObjectMapper, completion: { (success) in
                
                
            })
        }
        
        NSManagedObjectContext.mr_default().mr_saveToPersistentStoreAndWait()
    
        completion(true)
    }

    static func updateGroup(_ response: GroupObject, completion: @escaping (_ result: Bool) -> Void) {
        
        MagicalRecord.save({ (localContext) in
            
            let predicate: NSPredicate = NSPredicate(format: "groupId == %@", String(response.groupId))
            
            if let groupEntity: GroupEntity = GroupEntity.mr_findFirst(with: predicate) {
                
                groupEntity.groupId = Int32(response.groupId)
                groupEntity.groupCategoryId = (response.groupCategoryId != nil) ? Int32(response.groupCategoryId) : 0
                groupEntity.groupPriceId = (response.groupPriceId != nil) ? Int32(response.groupPriceId) : 0
                
                groupEntity.groupPrice = (response.groupPrice != nil) ? response.groupPrice : 0
                
                groupEntity.groupTotalMembers = (response.totalMembers != nil) ? Int32(response.totalMembers.intValue) : 1
                
                groupEntity.groupTitle = (response.groupTitle != nil) ? response.groupTitle : ""
                groupEntity.groupDescription = (response.groupDescription != nil) ? response.groupDescription : ""
                groupEntity.groupProfilePicture = (response.groupProfilePicture != nil) ? response.groupProfilePicture : ""
                groupEntity.groupCoverPicture = (response.groupCoverPicture != nil) ? response.groupCoverPicture : ""
                
                groupEntity.groupCreatedDate = (response.groupCreatedDate != nil) ? response.groupCreatedDate : ""
                groupEntity.groupJoinDate = (response.groupJoinDate != nil) ? response.groupJoinDate : ""
                groupEntity.groupModifiedDate = (response.groupModifiedDate != nil) ? response.groupModifiedDate : ""
                
                groupEntity.isPaidGroup = (response.isPaidGroup != nil) ? response.isPaidGroup : false
                groupEntity.isPrivateGroup = (response.isPrivateGroup != nil) ? response.isPrivateGroup : false
                
                groupEntity.isDeletedGroup = (response.isDeletedGroup != nil) ? response.isDeletedGroup : false
                
                groupEntity.groupSaveState = GroupDBState.MyGroups.rawValue //groupDBState.rawValue
                
                groupEntity.groupMember = ResponseHandler.getGroupMemberResponse(response.groupCreator)
                
                groupEntity.groupCreatedBy = (response.groupCreatedBy == nil || response.groupCreatedBy == "") ? response.groupCreator.userId : response.groupCreatedBy
            }
            
        }) { (success, error) in
            
            completion(success)
        }
    }
    
    static func groupResponse(_ isListObject: Bool = false, _ groupDBState: GroupDBState, _ response: GroupObject, completion: @escaping (_ result: Bool) -> Void) {
     
        if let groupEntity: GroupEntity = GroupEntity.mr_createEntity() {
            
            groupEntity.groupId = Int32(response.groupId)
            groupEntity.groupCategoryId = Int32(response.groupCategoryId)
            groupEntity.groupPriceId = Int32(response.groupPriceId)
            
            groupEntity.groupPrice = (response.groupPrice != nil) ? response.groupPrice : 0
            
            groupEntity.groupTotalMembers = Int32(response.totalMembers.intValue)
            
            groupEntity.groupTitle = response.groupTitle
            groupEntity.groupDescription = response.groupDescription
            groupEntity.groupProfilePicture = response.groupProfilePicture
            groupEntity.groupCoverPicture = response.groupCoverPicture
            
            groupEntity.groupCreatedDate = response.groupCreatedDate
            groupEntity.groupJoinDate = response.groupJoinDate
            groupEntity.groupModifiedDate = response.groupModifiedDate
            
            groupEntity.isPaidGroup = response.isPaidGroup
            groupEntity.isPrivateGroup = response.isPrivateGroup
            groupEntity.isDeletedGroup = response.isDeletedGroup
            
            if groupDBState == GroupDBState.DiscoverGroups {
                
                groupEntity.isUserCanJoin = response.isUserCanJoin
            }
            
            groupEntity.groupSaveState = groupDBState.rawValue
            
            groupEntity.groupMember = ResponseHandler.getGroupMemberResponse(response.groupCreator)
            
            groupEntity.groupCreatedBy = (response.groupCreatedBy == nil || response.groupCreatedBy == "") ? response.groupCreator.userId : response.groupCreatedBy
            
            if !isListObject {
                
                NSManagedObjectContext.mr_default().mr_saveToPersistentStoreAndWait()
            }
            
            completion(true)
        }
        else {
            
            completion(false)
        }
    }
    
    static func groupResponse(_ isListObject: Bool = false, _ groupDBState: GroupDBState, _ response: GroupObjectMapper, completion: @escaping (_ result: Bool) -> Void) {
        
        if let groupEntity: GroupEntity = GroupEntity.mr_createEntity() {
            
            groupEntity.groupId = Int32(response.groupId)
            groupEntity.groupCategoryId = (response.groupCategoryId != nil) ? Int32(response.groupCategoryId) : 0
            groupEntity.groupPriceId = (response.groupPriceId != nil) ? Int32(response.groupPriceId) : 0
            
            groupEntity.groupPrice = (response.groupPrice != nil) ? response.groupPrice : 0
            
            groupEntity.groupTotalMembers = Int32(response.totalMembers.intValue)
            
            groupEntity.groupTitle = response.groupTitle
            groupEntity.groupDescription = response.groupDescription
            groupEntity.groupProfilePicture = response.groupProfilePicture
            groupEntity.groupCoverPicture = response.groupCoverPicture
            
            groupEntity.groupCreatedDate = response.groupCreatedDate
            groupEntity.groupJoinDate = response.groupJoinDate
            groupEntity.groupModifiedDate = response.groupModifiedDate
            
            groupEntity.totalPosts = (response.totalPosts != nil) ?Int32(response.totalPosts.intValue) : 0
            
            groupEntity.isPaidGroup = (response.isPaidGroup != nil) ? response.isPaidGroup : false
            groupEntity.isPrivateGroup = response.isPrivateGroup
            
            groupEntity.isDeletedGroup = (response.isDeletedGroup != nil) ? response.isDeletedGroup : false
            
            if groupDBState == GroupDBState.DiscoverGroups {
                
                groupEntity.isUserCanJoin = response.isUserCanJoin
            }
            
            groupEntity.groupSaveState = groupDBState.rawValue
            
            groupEntity.groupMember = ResponseHandler.getGroupMemberResponseFromMapper(response.groupCreator)
         
            groupEntity.groupCreatedBy = (response.groupCreatedBy == nil || response.groupCreatedBy == "") ? response.groupCreator.userId : response.groupCreatedBy
            
            if !isListObject {
            
                NSManagedObjectContext.mr_default().mr_saveToPersistentStoreAndWait()
            }
            
            completion(true)
        }
        else {
            
            completion(false)
        }
    }
    
    static func groupPricesResponse(_ response: GroupPricesListMapper, completion: @escaping (_ result: Bool) -> Void) {
        
        if GroupPriceEntity.mr_truncateAll() {
            
            for groupPrice: GroupPriceMapper in response.groupPricesList {
                
                let priceEntity = GroupPriceEntity.mr_createEntity()
                
                priceEntity?.priceId = Int32(groupPrice.priceId)
                priceEntity?.price = NSDecimalNumber(value: groupPrice.price)
            }
        }
        
        NSManagedObjectContext.mr_default().mr_saveToPersistentStoreAndWait()
        
        completion(true)
    }
    
    static func groupCategoriesResponse(_ response: GroupCategoriesListMapper, completion: @escaping (_ result: Bool) -> Void) {
     
        if GroupCategoryEntity.mr_truncateAll() {
            
            for groupCategory: GroupCategoryMapper in response.groupCategoriesList {
             
                let categoryEntity = GroupCategoryEntity.mr_createEntity()
                
                categoryEntity?.categoryId = Int32(groupCategory.categoryId)
                categoryEntity?.categoryTitle = groupCategory.categoryTitle
            }
        }
        
        NSManagedObjectContext.mr_default().mr_saveToPersistentStoreAndWait()
        
        completion(true)
    }
    
    static func maritalStatusResponse(_ response: MaritalStatusListMapper, completion: @escaping (_ result: Bool) -> Void) {
        
        if MaritalStatusEntity.mr_truncateAll() {
            
            for maritalStatus:MaritalStatusMapper in response.maritalStatusList {
                
                let maritalStatusEntity = MaritalStatusEntity.mr_createEntity()
                
                maritalStatusEntity?.statusId = Int32(maritalStatus.statusId)
                maritalStatusEntity?.statusTitle = maritalStatus.statusTitle
            }
        }
        
        NSManagedObjectContext.mr_default().mr_saveToPersistentStoreAndWait()
        
        completion(true)
    }
    
    static func getGroupMemberResponse(_ response: UserProfile) -> GroupMembersEntity {
        
        let userProfileEntity: GroupMembersEntity = GroupMembersEntity.mr_createEntity()!
        
        userProfileEntity.userId = (response.userId != nil) ? response.userId : AppDefaults.getLoggedUserId()
        userProfileEntity.fullName = (response.fullName != nil) ? response.fullName : ""
        userProfileEntity.firstName = (response.firstName != nil) ? response.firstName : ""
        userProfileEntity.lastName = (response.lastName != nil) ? response.lastName : ""
        userProfileEntity.gender = (response.gender != nil) ? response.gender : ""
        userProfileEntity.birthday = (response.birthday != nil) ? response.birthday : ""
        userProfileEntity.zodiac = (response.zodiac != nil) ? response.zodiac : ""
        userProfileEntity.maritalStatus = (response.maritalStatus.statusTitle != nil) ? response.maritalStatus.statusTitle : "Single"
        userProfileEntity.email = (response.email != nil) ? response.email : ""
        userProfileEntity.designation = (response.designation != nil) ? response.designation : ""
        userProfileEntity.locationAddress = (response.locationAddress != nil) ? response.locationAddress : ""
        userProfileEntity.about = (response.about != nil) ? response.about : ""
        userProfileEntity.phoneNumber = (response.phoneNumber != nil) ? response.phoneNumber : ""
        userProfileEntity.interest = (response.interest != nil) ? response.interest : ""
        userProfileEntity.locale = (response.locale != nil) ? response.locale : ""
        userProfileEntity.profilePicture = (response.profilePicture != nil) ? response.profilePicture : ""
        userProfileEntity.coverPicture = (response.coverPicture != nil) ? response.coverPicture : ""
        userProfileEntity.timezone = (response.timezone != nil) ? response.timezone : 0
        userProfileEntity.userSocialId = (response.userSocialId != nil) ? response.userSocialId : ""
        userProfileEntity.locationLat = (response.location.lat != nil) ? Float(response.location.lat) : 0
        userProfileEntity.locationLon = (response.location.lon != nil) ? Float(response.location.lon) : 0
        
        return userProfileEntity
    }
    
    static func getGroupMemberResponseFromMapper(_ response: UserProfileMapper) -> GroupMembersEntity {
        
        let userProfileEntity: GroupMembersEntity = GroupMembersEntity.mr_createEntity()!
        
        userProfileEntity.userId = (response.userId != nil) ? response.userId : AppDefaults.getLoggedUserId()
        userProfileEntity.fullName = (response.fullName != nil) ? response.fullName : ""
        userProfileEntity.firstName = (response.firstName != nil) ? response.firstName : ""
        userProfileEntity.lastName = (response.lastName != nil) ? response.lastName : ""
        userProfileEntity.gender = (response.gender != nil) ? response.gender : ""
        userProfileEntity.birthday = (response.birthday != nil) ? response.birthday : ""
        userProfileEntity.zodiac = (response.zodiac != nil) ? response.zodiac : ""
        userProfileEntity.maritalStatus = (response.maritalStatus.statusTitle != nil) ? response.maritalStatus.statusTitle : "Single"
        userProfileEntity.email = (response.email != nil) ? response.email : ""
        userProfileEntity.designation = (response.designation != nil) ? response.designation : ""
        userProfileEntity.locationAddress = (response.locationAddress != nil) ? response.locationAddress : ""
        userProfileEntity.about = (response.about != nil) ? response.about : ""
        userProfileEntity.phoneNumber = (response.phoneNumber != nil) ? response.phoneNumber : ""
        userProfileEntity.interest = (response.interest != nil) ? response.interest : ""
        userProfileEntity.locale = (response.locale != nil) ? response.locale : ""
        userProfileEntity.profilePicture = (response.profilePicture != nil) ? response.profilePicture : ""
        userProfileEntity.coverPicture = (response.coverPicture != nil) ? response.coverPicture : ""
        userProfileEntity.timezone = (response.timezone != nil) ? response.timezone : 0
        userProfileEntity.userSocialId = (response.userSocialId != nil) ? response.userSocialId : ""
        userProfileEntity.locationLat = (response.location.lat != nil) ? Float(response.location.lat) : 0
        userProfileEntity.locationLon = (response.location.lon != nil) ? Float(response.location.lon) : 0
        
        return userProfileEntity
    }
    
    static func profileResponse(_ response: UserProfileMapper, completion: @escaping (_ result: Bool) -> Void) {
        
        if UserProfileEntity.mr_truncateAll() {
            
            let userProfileEntity = UserProfileEntity.mr_createEntity()
            
            userProfileEntity?.userId = (response.userId != nil) ? response.userId : AppDefaults.getLoggedUserId()
            userProfileEntity?.fullName = (response.fullName != nil) ? response.fullName : ""
            userProfileEntity?.firstName = (response.firstName != nil) ? response.firstName : ""
            userProfileEntity?.lastName = (response.lastName != nil) ? response.lastName : ""
            userProfileEntity?.gender = (response.gender != nil) ? response.gender : ""
            userProfileEntity?.birthday = (response.birthday != nil) ? response.birthday : ""
            userProfileEntity?.zodiac = (response.zodiac != nil) ? response.zodiac : ""
            userProfileEntity?.maritalStatus = (response.maritalStatus.statusTitle != nil) ? response.maritalStatus.statusTitle : "Single"
            userProfileEntity?.email = (response.email != nil) ? response.email : ""
            userProfileEntity?.designation = (response.designation != nil) ? response.designation : ""
            userProfileEntity?.locationAddress = (response.locationAddress != nil) ? response.locationAddress : ""
            userProfileEntity?.about = (response.about != nil) ? response.about : ""
            userProfileEntity?.phoneNumber = (response.phoneNumber != nil) ? response.phoneNumber : ""
            userProfileEntity?.interest = (response.interest != nil) ? response.interest : ""
            userProfileEntity?.locale = (response.locale != nil) ? response.locale : ""
            userProfileEntity?.profilePicture = (response.profilePicture != nil) ? response.profilePicture : ""
            userProfileEntity?.coverPicture = (response.coverPicture != nil) ? response.coverPicture : ""
            userProfileEntity?.timezone = (response.timezone != nil) ? response.timezone : 0
            userProfileEntity?.userSocialId = (response.userSocialId != nil) ? response.userSocialId : ""
            userProfileEntity?.locationLat = (response.location.lat != nil) ? Float(response.location.lat) : 0
            userProfileEntity?.locationLon = (response.location.lon != nil) ? Float(response.location.lon) : 0
            userProfileEntity?.isStripeCustomer = (response.isStripeCustomer != nil) ? response.isStripeCustomer : false
            userProfileEntity?.isFavorite = (response.isFavorite != nil) ? response.isFavorite : false
            
            AppDefaults.setIsStripeUser((userProfileEntity?.isStripeCustomer)!)
        }
        
        NSManagedObjectContext.mr_default().mr_saveToPersistentStoreAndWait()
        
        completion(true)
    }
    
    static func loginResponse(_ response: LoginUserMapper, completion: @escaping (_ result: Bool) -> Void) {
        
        
        if LoginUserEntity.mr_truncateAll() {
            
            let loginUser = LoginUserEntity.mr_createEntity()
            
            loginUser?.userId = response.userId
            loginUser?.userName = response.userName
            loginUser?.accessToken = response.accessToken
            loginUser?.tokenType = response.tokenType
            loginUser?.expiresIn = response.expiresIn
            loginUser?.expiresDate = response.expiresDate
            loginUser?.issuedDate = response.issuedDate
            loginUser?.hasRegistered = response.hasRegistered
            
            AppDefaults.setAppAccessToken(response.accessToken)
            AppDefaults.setLoggedUserId(response.userId)
            
        }
        
        NSManagedObjectContext.mr_default().mr_saveToPersistentStoreAndWait()
        
        completion(true)
    }
}
