//
//  ParametersConverter.swift
//  MarcoApp
//
//  Created by Nabeel Hayat on 16/02/2018.
//  Copyright © 2018 GrayScaleLogic. All rights reserved.
//

import UIKit

class ParametersConverter: NSObject {

    class func convertToSaveProfileParameters(_ userProfileMapper: UserProfileMapper) -> [String:Any] {
        
//        let interest = (userProfileMapper.interest != nil && userProfileMapper.interest=="") ? [userProfileMapper.interest] : []
        
        let interest = (userProfileMapper.interest != nil && userProfileMapper.interest=="") ? [] : []
        
        let latitude: Decimal = Decimal(userProfileMapper.location.lat)
        let longitude: Decimal = Decimal(userProfileMapper.location.lon)
        
        let meritalStatus: Decimal = Decimal(integerLiteral: userProfileMapper.maritalStatus.statusId)
        
        let parameters: [String : Any] = ["FirstName":userProfileMapper.firstName, "LastName":userProfileMapper.lastName,"Phone":userProfileMapper.phoneNumber,"Location":userProfileMapper.locationAddress,"DOB":userProfileMapper.birthday,"Gender":userProfileMapper.gender,"Title":userProfileMapper.designation,"MeritalStatusId":meritalStatus,"About":userProfileMapper.about,"ProfilePicture":userProfileMapper.profilePicture,"CoverPicture":userProfileMapper.coverPicture,"Latitude":latitude,"Longitude":longitude,"Locale":userProfileMapper.locale,"Interests":interest]
        
        return parameters
    }
}
