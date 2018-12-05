//
//  ParametersHandler.swift
//  MarcoApp
//
//  Created by Nabeel Hayat on 22/02/2018.
//  Copyright © 2018 GrayScaleLogic. All rights reserved.
//

import UIKit

class ParametersHandler: NSObject {

    class func parametersForCreateGroup(title:String, description: String, categoryId: Int, price: Double, defaultPriceId: Int, isPaid: Bool, isPrivate: Bool) -> [String : Any] {
     
        if isPaid {
           
            let parameters: [String: Any] = ["Title":title, "Description":description, "CategoryId":categoryId, "Price": price, "DefaultPriceId":defaultPriceId, "isPaid":isPaid, "isPrivate":isPrivate]
            
            return parameters
        }
        else {
            
            let parameters: [String: Any] = ["Title":title, "Description":description, "CategoryId":categoryId, "isPaid":isPaid, "isPrivate":isPrivate]
            
            return parameters
        }
        
    }

    class func parametersForSaveProfile(_ userProfile: UserProfile, profilePicture: String, coverPhoto: String) -> [String : Any] {
        
        let latitude: Decimal = Decimal(userProfile.location.lat)
        let longitude: Decimal = Decimal(userProfile.location.lon)
        
        var interest: String = ""
        
        if let interestValue = userProfile.interest {
            interest = interestValue
        }
        
        var interestList: [String] = []
        
        if interest != "" {
            
            interestList.append(interest)
        }
        
        var profilePictureURL = userProfile.profilePicture
        var coverPhotoURL = userProfile.coverPicture
        
        if profilePicture != "" {
            
            profilePictureURL = profilePicture
        }
        
        if coverPhoto != "" {
            
            coverPhotoURL = coverPhoto
        }
        
        let parameters: [String: Any] = ["FirstName":userProfile.firstName, "LastName":userProfile.lastName, "Phone":userProfile.phoneNumber, "Email": userProfile.email, "Location":userProfile.locationAddress, "DOB":userProfile.birthday, "Gender":userProfile.gender, "Title":userProfile.designation, "MeritalStatusId":userProfile.maritalStatus.statusId, "About":userProfile.about, "ProfilePicture":profilePictureURL!, "CoverPicture":coverPhotoURL!, "Latitude":latitude, "Longitude":longitude, "Locale":userProfile.locale, "Interests":interestList]
        
        return parameters
    }
}

