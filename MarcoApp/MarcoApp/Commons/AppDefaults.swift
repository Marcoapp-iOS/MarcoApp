//
//  AppDefaults.swift
//  MarcoApp
//
//  Created by Nabeel Hayat on 09/01/2018.
//  Copyright © 2018 GrayScaleLogic. All rights reserved.
//

import UIKit
import Foundation

class AppDefaults: NSObject {
    
    static let kAppOpenFirstTime = "AppOpenFirstTime"
    static let kNewRegisterUser = "NewRegisterUser"
    static let kAppLoggedIn = "AppLoggedIn"
    static let kIsStripeUser = "IsStripeUser"
    static let kHasRegister = "HasRegister"
    static let kIsProfileCreated = "IsProfileCreated"
    static let kProfileSavedFirstTime = "ProfileSavedFirstTime"
    static let kAppAccessToken = "AppAccessToken"
    static let kLoggedUserId = "LoggedUserId"
    static let kDLJoinGroupId = "DLJoinGroupId"
    static let kOpenChatPublisher = "OpenChatPublisher"

    class func setAppOpenFirstTime(_ firstTime: Bool) {
        
        UserDefaults.standard.set(firstTime, forKey: kAppOpenFirstTime)
        UserDefaults.standard.synchronize()
    }
    
    class func isAppOpenFirstTime() -> Bool {
        
        if UserDefaults.standard.object(forKey: kAppOpenFirstTime) != nil {
            
            let value: Bool = UserDefaults.standard.object(forKey: kAppOpenFirstTime) as! Bool
            
            return value;
        }
        else {
            
            return true
        }
    }
    
    class func setNewRegisterUser(_ newRegisterUser: Bool) {
        
        UserDefaults.standard.set(newRegisterUser, forKey: kNewRegisterUser)
        UserDefaults.standard.synchronize()
    }
    
    class func isNewRegisterUser() -> Bool {
        
        if UserDefaults.standard.object(forKey: kNewRegisterUser) != nil {
            
            let value: Bool = UserDefaults.standard.object(forKey: kNewRegisterUser) as! Bool
            
            return value;
        }
        else {
            
            return true
        }
    }
    
    class func setProfileSavedFirstTime() {
        
        UserDefaults.standard.set(true, forKey: kProfileSavedFirstTime)
        UserDefaults.standard.synchronize()
    }
    
    class func isProfileSavedFirstTime() -> Bool {
        
        if UserDefaults.standard.object(forKey: kProfileSavedFirstTime) != nil {
            
            let value: Bool = UserDefaults.standard.object(forKey: kProfileSavedFirstTime) as! Bool
            
            return value;
        }
        else {
            
            return false
        }
    }
    
    class func setIsStripeUser(_ value: Bool) {
        
        UserDefaults.standard.set(value, forKey: kIsStripeUser)
        UserDefaults.standard.synchronize()
    }
    
    class func isStripeUser() -> Bool {
        
        if UserDefaults.standard.object(forKey: kIsStripeUser) != nil {
            
            let value: Bool = UserDefaults.standard.object(forKey: kIsStripeUser) as! Bool
            
            return value;
        }
        else {
            
            return false
        }
    }
    
    class func setHasRegister(_ value: Bool) {
        
        UserDefaults.standard.set(value, forKey: kHasRegister)
        UserDefaults.standard.synchronize()
    }
    
    class func hasRegister() -> Bool {
        
        if UserDefaults.standard.object(forKey: kHasRegister) != nil {
            
            let value: Bool = UserDefaults.standard.object(forKey: kHasRegister) as! Bool
            
            return value;
        }
        else {
            
            return false
        }
    }
    
    class func setIsProfileCreated(_ value: Bool) {
        
        UserDefaults.standard.set(value, forKey: kIsProfileCreated)
        UserDefaults.standard.synchronize()
    }
    
    class func isProfileCreated() -> Bool {
        
        if UserDefaults.standard.object(forKey: kIsProfileCreated) != nil {
            
            let value: Bool = UserDefaults.standard.object(forKey: kIsProfileCreated) as! Bool
            
            return value;
        }
        else {
            
            return false
        }
    }
    
    
    class func setAppLoggedIn(_ value: Bool) {
        
        UserDefaults.standard.set(value, forKey: kAppLoggedIn)
        UserDefaults.standard.synchronize()
    }
    
    class func isAppLoggedIn() -> Bool {
        
        if UserDefaults.standard.object(forKey: kAppLoggedIn) != nil {
            
            let value: Bool = UserDefaults.standard.object(forKey: kAppLoggedIn) as! Bool
            
            return value;
        }
        else {
            
            return false
        }
    }
    
    class func setLoggedUserId(_ userId: String) {
        
        UserDefaults.standard.set(userId, forKey: kLoggedUserId)
        UserDefaults.standard.synchronize()
    }
    
    class func getLoggedUserId() -> String {
        
        if UserDefaults.standard.object(forKey: kLoggedUserId) != nil {
            
            let value: String = UserDefaults.standard.object(forKey: kLoggedUserId) as! String
            
            return value;
        }
        else {
            
            return ""
        }
    }
    
    class func setOpenChatPublisher(_ groupId: String) {
        
        UserDefaults.standard.set(groupId, forKey: kOpenChatPublisher)
        UserDefaults.standard.synchronize()
    }
    
    class func getOpenChatPublisher() -> String {
        
        if UserDefaults.standard.object(forKey: kOpenChatPublisher) != nil {
            
            let value: String = UserDefaults.standard.object(forKey: kOpenChatPublisher) as! String
            
            return value;
        }
        else {
            
            return ""
        }
    }
    
    class func setDLJoinGroupId(_ groupId: String) {
        
        UserDefaults.standard.set(groupId, forKey: kDLJoinGroupId)
        UserDefaults.standard.synchronize()
    }
    
    class func getDLJoinGroupId() -> String {
        
        if UserDefaults.standard.object(forKey: kDLJoinGroupId) != nil {
            
            let value: String = UserDefaults.standard.object(forKey: kDLJoinGroupId) as! String
            
            return value;
        }
        else {
            
            return ""
        }
    }
    
    class func setAppAccessToken(_ accessToken: String) {
        
        UserDefaults.standard.set(accessToken, forKey: kAppAccessToken)
        UserDefaults.standard.synchronize()
    }
    
    class func getAppAccessToken() -> String {
        
        if UserDefaults.standard.object(forKey: kAppAccessToken) != nil {
            
            let value: String = UserDefaults.standard.object(forKey: kAppAccessToken) as! String
            
            return value;
        }
        else {
            
            return ""
        }
    }
    
}
