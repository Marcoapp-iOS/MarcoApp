//
//  AppConstants.swift
//  MarcoApp
//
//  Created by Nabeel Hayat on 28/10/2017.
//  Copyright © 2017 GrayScaleLogic. All rights reserved.
//

import UIKit

enum GroupDBState: String {
    case Creating = "Creating"
    case MyGroups = "MyGroups"
    case DiscoverGroups = "DiscoverGroups"
}

class AppConstants: NSObject {
    
    
    static let coreDataPath = "MARCO-DB"
    static let coreDataName = "MarcoApp"
    
    static let kPUBNUB_PUBLISH_KEY = "pub-c-0fa8738e-06b4-4d8a-be81-6b1a8ccef7c1"
    static let kPUBNUB_SUBSCRIBE_KEY = "sub-c-a40d3be0-d9cd-11e8-911d-e217929ad048"
    static let kPUBNUB_PUBLISH_KEY_STAGING = "pub-c-8f8045c1-16be-41f5-b3b8-83ac79c32cb2"
    static let kPUBNUB_SUBSCRIBE_KEY_STAGING = "sub-c-62642f70-d61f-11e8-8338-f202706b73e5"
    
    static let kSTRIPE_PUBLISHABLE_KEY = ""
    static let kSTRIPE_TEST_PUBLISHABLE_KEY = "pk_test_8a46tuAiTQaGeFj9blukRKNR"
    
    static let kGOOGLE_API_KEY = "AIzaSyBDnlSJMWMypjIGk1QCFhbStrqZiNx1VM4"
    static let kTWITTER_CONSUMER_KEY = "3NJXtMaPJlM7l1NAuOV3c43gY"
    static let kTWITTER_CONSUMER_SECRET = "TwcO5N1HGShjxbkAibHBZyqrxy9BRoMPBPnTaTg6vTh43E9YWZ"
    
    static let kDynamicLink_URL = "https://marcotest.azurewebsites.net/"
    static let kDynamicLink_Domain = "marcoapp.page.link"
    static let kDynamicLink_BundleID = "com.greyscalelogic.marco"
    static let kDynamicLink_CustomScheme = "com.greyscalelogic.marco"
    static let kDynamicLink_AppStoreID = "1314793332"
    
    static let kDynamicLink_AndroidPackageID = "com.greyscalelogic.marco"
    static let kDynamicLink_AndroidMiniVersion = 15
    
    static let kBackgroundImage = "bg_image"
    
    // MARK: - Side Menu Embedded Segues
    
    static let kMenuSegues = "embedMenuLeftController"
    
    static let kMapSegues = "embedMapCenterController"
    static let kNewsFeedSegues = "embedNewsFeedCenterController"
    static let kDiscoverSegues = "embedDiscoverCenterController"
    static let kMyGroupsSegues = "embedMyGroupsCenterController"
    static let kMyProfileSegues = "embedMyProfileCenterController"
    static let kChatsSegues = "embedChatsCenterController"
    static let kNotificationsSegues = "embedNotificationsCenterController"
    static let kFavoritesSegues = "embedFavoritesCenterController"
    static let kInviteSegues = "embedInviteCenterController"
    static let kSettingsSegues = "embedSettingsCenterController"
    static let kContactSegues = "embedContactCenterController"
    
    static let seguesDefaultList = [AppConstants.kMapSegues, AppConstants.kNewsFeedSegues, AppConstants.kDiscoverSegues, AppConstants.kMyGroupsSegues, AppConstants.kChatsSegues, AppConstants.kNotificationsSegues, AppConstants.kFavoritesSegues, AppConstants.kInviteSegues, AppConstants.kSettingsSegues, AppConstants.kContactSegues]
    
    // MARK: - Web Services URL's
    
    static let baseApiURL = "https://marcotest.azurewebsites.net/api/"
    static let baseURL = "https://marcotest.azurewebsites.net/"
    
//    http://marcotest.azurewebsites.net/api/userprofiles/me/location
    
    static let kUserLocation = kUserProfiles + "/me/location"
    
    static let kRegisterSocial = baseApiURL + "Account/RegisterSocial"
    static let kGroups = baseApiURL + "groups"
    
    static let kUsers = baseApiURL + "Users"
    
    static let kPosts = baseApiURL + "Posts"
    
    static let kGroupMemberships = baseApiURL + "memberships"
    
    static let kCampaigns = baseApiURL + "campaigns"
    
    static let kUserFavorites = baseApiURL + "Favorites"
    
    static let kUserProfiles = baseApiURL + "UserProfiles"
    
    static let kMaritalStatus = "MaritalStatus"
    
    static let kChangeUserProfilePicture = "/me/ProfilePicture"
    static let kChangeUserCoverPicture = "/me/CoverPicture"
    static let kChangeGroupProfilePicture = "/ProfilePicture"
    static let kChangeGroupCoverPicture = "/CoverPicture"
    
}
