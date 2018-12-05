//
//  BaseResponse.swift
//  MarcoApp
//
//  Created by Nabeel Hayat on 10/01/2018.
//  Copyright © 2018 GrayScaleLogic. All rights reserved.
//

import UIKit
import ObjectMapper

class BaseResponse: NSObject, Mappable {

    var status : Int?
    var errorMessage: String! = nil
    
    override init() {
        super.init()
    }
    
    convenience required init?(map: Map) {
        self.init()
    }
    
    func mapping(map: Map) {
        status <- map["status"]
        
        if map["Message"].isKeyPresent {
            
            self.errorMessage <- map["Message"]
        }
        else {
            
            self.errorMessage = ""
        }
    }
}

