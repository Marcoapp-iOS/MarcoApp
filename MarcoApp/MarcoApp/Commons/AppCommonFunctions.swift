//
//  AppCommonFunctions.swift
//  MarcoApp
//
//  Created by Nabeel Hayat on 28/10/2017.
//  Copyright © 2017 GrayScaleLogic. All rights reserved.
//

import UIKit

class AppCommonFunctions: NSObject {

    class func randomNumber(MIN: Int, MAX: Int)-> Int{
        return Int(arc4random_uniform(UInt32(MAX)) + UInt32(MIN));
    }
}
