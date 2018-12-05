//
//  LoginUser.swift
//  MarcoApp
//
//  Created by Nabeel Hayat on 18/01/2018.
//  Copyright © 2018 GrayScaleLogic. All rights reserved.
//

import UIKit
import ObjectMapper

class LoginUser: NSObject {
    
    var userId: String! = nil
    var userName: String! = nil
    var accessToken: String! = nil
    var tokenType: String! = nil
    var expiresIn: String! = nil
    var issuedDate: String! = nil
    var expiresDate: String! = nil
    var hasRegistered: Bool! = nil
    
    init(object: LoginUserEntity) {
        
        self.userId = object.userId
        self.userName = object.userName
        self.accessToken = object.accessToken
        self.tokenType = object.tokenType
        self.expiresIn = object.expiresIn
        self.expiresDate = object.expiresDate
        self.issuedDate = object.issuedDate
        self.hasRegistered = object.hasRegistered
    }
}

class LoginUserMapper: Mappable {
    
    var userId: String! = nil
    var userName: String! = nil
    var accessToken: String! = nil
    var tokenType: String! = nil
    var expiresIn: String! = nil
    var issuedDate: String! = nil
    var expiresDate: String! = nil
    var hasRegistered: Bool! = nil
    
    init() {}
    required init?(map: Map) {}
    
    func mapping(map: Map) {
        
        self.userId <- map["userId"]
        self.userName <- map["userName"]
        self.accessToken <- map["access_token"]
        self.tokenType <- map["token_type"]
        self.expiresIn <- map["expires_in"]
        self.issuedDate <- map["issued"]
        self.expiresDate <- map["expires"]
        self.hasRegistered <- map["hasRegistered"]
    }
    
}
