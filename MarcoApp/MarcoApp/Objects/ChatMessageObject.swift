//
//  ChatMessageObject.swift
//  MarcoApp
//
//  Created by Nabeel Hayat on 31/10/2018.
//  Copyright © 2018 GrayScaleLogic. All rights reserved.
//

import UIKit
import ObjectMapper

class ChatMessageObject: NSObject {

    var message: String! = nil
    var publisher: String! = nil
    var date: String! = nil
    
    override init() {
        super.init()
        self.setupDefaultState()
    }
    
    init(object: UserProfileEntity) {
        super.init()
        self.setupDefaultState()
        
    }
    
    private func setupDefaultState() {
        
        self.message = ""
        self.publisher = ""
        self.date = ""
    }
}


class ChatMessageObjectMapper: BaseResponse {
    
    var message: String! = nil
    var publisher: String! = nil
    var date: String! = nil
    
    override func mapping(map: Map) {
        super.mapping(map: map)
        
        self.message <- map["text"]
        self.publisher <- map["publisher"]
        
        if map["Date"].isKeyPresent {
            
            self.date <- map["Date"]
        }
        else {
            
            self.date <- map["date"]
        }
    }
}
