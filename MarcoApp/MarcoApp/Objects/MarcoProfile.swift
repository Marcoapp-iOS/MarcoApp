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
    
    var lat: String! = nil
    var lon: String! = nil
    
    init(lat: String, lon: String) {
        self.lat = lat
        self.lon = lon
    }
}

class UserProfile: Mappable {

    
    var userId: String! = nil
    var userSocialId: String! = nil
    var fullName: String! = nil
    var firstName: String! = nil
    var lastName: String! = nil
    var email: String! = nil
    var gender: String! = nil
    var birthday: String! = nil
    var meritalStatus: String! = nil
    var about: String! = nil
    var timezone: Float! = nil
    var locale: String! = nil
    var profilePicture: String! = nil
    var locationAddress: String! = nil
    var phoneNumber: String! = nil
    var zodiac: String! = nil
    var location: UserLocation! = nil
    
    
    init() {
        
    }
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        
        self.userSocialId <- map["id"]
        self.fullName <- map["name"]
        self.firstName <- map["first_name"]
        self.lastName <- map["last_name"]
        self.email <- map["email"]
        self.gender <- map["gender"]
        self.birthday <- map["birthday"]
        self.meritalStatus <- map["relationship_status"]
        self.about <- map["about"]
        self.timezone <- map["timezone"]
        self.locale <- map["locale"]
        self.profilePicture <- map["picture.data.url"]
        self.locationAddress <- map["location.name"]
    }
    
}
