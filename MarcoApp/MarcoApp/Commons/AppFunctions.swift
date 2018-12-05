//
//  AppFunctions.swift
//  MarcoApp
//
//  Created by Nabeel Hayat on 28/10/2017.
//  Copyright © 2017 GrayScaleLogic. All rights reserved.
//

import UIKit
import MagicalRecord

struct Device {
    // iDevice detection code
    static let IS_IPAD             = UIDevice.current.userInterfaceIdiom == .pad
    static let IS_IPHONE           = UIDevice.current.userInterfaceIdiom == .phone
    static let IS_RETINA           = UIScreen.main.scale >= 2.0
    
    static let SCREEN_WIDTH        = Int(UIScreen.main.bounds.size.width)
    static let SCREEN_HEIGHT       = Int(UIScreen.main.bounds.size.height)
    static let SCREEN_MAX_LENGTH   = Int( max(SCREEN_WIDTH, SCREEN_HEIGHT) )
    static let SCREEN_MIN_LENGTH   = Int( min(SCREEN_WIDTH, SCREEN_HEIGHT) )
    
    static let IS_IPHONE_4_OR_LESS = IS_IPHONE && SCREEN_MAX_LENGTH  < 568
    static let IS_IPHONE_5         = IS_IPHONE && SCREEN_MAX_LENGTH == 568
    static let IS_IPHONE_6         = IS_IPHONE && SCREEN_MAX_LENGTH == 667
    static let IS_IPHONE_6P        = IS_IPHONE && SCREEN_MAX_LENGTH == 736
    static let IS_IPHONE_X         = IS_IPHONE && SCREEN_MAX_LENGTH == 812
}

class AppFunctions: NSObject {

    class func randomNumber(MIN: Int, MAX: Int)-> Int{
        return Int(arc4random_uniform(UInt32(MAX)) + UInt32(MIN));
    }
    
    class func getLoginUser() -> LoginUser {
        
        let loginUserEntity: LoginUserEntity = LoginUserEntity.mr_findFirst(in: .mr_default())!
        
        let loginUser: LoginUser = LoginUser(object: loginUserEntity)
        
        return loginUser
    }
    
    class func getUserProfile(from userId: String) -> UserProfile {
        
        let userProfileEntity: UserProfileEntity = UserProfileEntity.mr_findFirst(byAttribute: "userId", withValue: userId)!
        
        return ModelConvertor.convertToUserProfile(userProfileEntity)
    }
    
    // MARK: - MaritalStatus
    
    class func getMaritalStatusEntitiesList() -> [MaritalStatusEntity] {
        
        let maritalStatusListEntity: [MaritalStatusEntity] = MaritalStatusEntity.mr_findAll(in: .mr_default()) as! [MaritalStatusEntity]
        
        return maritalStatusListEntity
    }
    
    class func getMaritalStatusObjectsList() -> [MaritalStatusObject] {
        
        let maritalStatusListEntities: [MaritalStatusEntity] = self.getMaritalStatusEntitiesList()
        
        var maritalStatusListObjects: [MaritalStatusObject] = []
        
        for maritalStatusEntity: MaritalStatusEntity in maritalStatusListEntities {
            
            let maritalStatusObject: MaritalStatusObject = MaritalStatusObject(withTitle: maritalStatusEntity.statusTitle!, statusId: Int(maritalStatusEntity.statusId))
            
            maritalStatusListObjects.append(maritalStatusObject)
        }
        
        return maritalStatusListObjects
    }
    
    class func getMaritalStatusList() -> [String] {
        
        var maritalStatusLists: [String] = []
        
        let maritalStatusListObjects: [MaritalStatusObject] = self.getMaritalStatusObjectsList()
        
        for maritalStatusObject: MaritalStatusObject in maritalStatusListObjects {
            
            maritalStatusLists.append(maritalStatusObject.statusTitle)
        }
        
        return maritalStatusLists
    }
    
    // MARK: - Group Categories
    
    class func getGroupCategoryEntitiesList() -> [GroupCategoryEntity] {
        
        let groupCategoryListEntity: [GroupCategoryEntity] = GroupCategoryEntity.mr_findAll(in: .mr_default()) as! [GroupCategoryEntity]
        
        return groupCategoryListEntity
    }
    
    class func getGroupCategoriesObjectsList() -> [GroupCategoryObject] {
        
        let groupCategoryListEntities: [GroupCategoryEntity] = self.getGroupCategoryEntitiesList()
        
        var groupCategoryListObjects: [GroupCategoryObject] = []
        
        for groupCategoryEntity: GroupCategoryEntity in groupCategoryListEntities {

            let groupCategoryObject: GroupCategoryObject = GroupCategoryObject(withTitle: groupCategoryEntity.categoryTitle!, categoryId: Int(groupCategoryEntity.categoryId))
            
            groupCategoryListObjects.append(groupCategoryObject)
        }
        
        return groupCategoryListObjects
    }
    
    class func getGroupCategoriesList() -> [String] {
        
        var groupCategoriesLists: [String] = []
        
        let groupCategoriesListObjects: [GroupCategoryObject] = self.getGroupCategoriesObjectsList()
        
        for groupCategoryObject: GroupCategoryObject in groupCategoriesListObjects {
            
            groupCategoriesLists.append(groupCategoryObject.categoryTitle)
        }
        
        return groupCategoriesLists
    }
    
    // MARK: - Group Prices
    
    class func getGroupPriceEntitiesList() -> [GroupPriceEntity] {
        
        let groupPriceListEntity: [GroupPriceEntity] = GroupPriceEntity.mr_findAll(in: .mr_default()) as! [GroupPriceEntity]
        
        return groupPriceListEntity
    }
    
    class func getGroupPricesObjectsList() -> [GroupPriceObject] {
        
        let groupPriceListEntities: [GroupPriceEntity] = self.getGroupPriceEntitiesList()
        
        var groupPriceListObjects: [GroupPriceObject] = []
        
        for groupPriceEntity: GroupPriceEntity in groupPriceListEntities {

            let groupPriceObject: GroupPriceObject = GroupPriceObject(withPrice: (groupPriceEntity.price?.doubleValue)!, priceId: Int(groupPriceEntity.priceId))
            
            groupPriceListObjects.append(groupPriceObject)
        }
        
        return groupPriceListObjects
    }
    
    class func getGroupPricesList() -> [String] {
        
        var groupPricesLists: [String] = []
        
        let groupPricesListObjects: [GroupPriceObject] = self.getGroupPricesObjectsList()
        
        for groupPriceObject: GroupPriceObject in groupPricesListObjects {
            
            let price: String = String(groupPriceObject.price)
            
            groupPricesLists.append("$"+price)
        }
        
        return groupPricesLists
    }
    
    static func getTimeFromString(_ dateString: String) -> Date {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "hh:mm:ss a"
        let date = dateFormatter.date(from:dateString)!
        return date
    }
    
    static func resizeImageForImage(_ currentImage: UIImage, _ size: CGSize) -> UIImage {
        
        if size.width > currentImage.size.width && size.height > currentImage.size.height {
            
            return currentImage
        }
        
        let cgImage: CGImage = currentImage.cgImage!
        
        let imageViewRect: CGRect = CGRect(x: 0, y: 0, width: size.width, height: size.height)
        
        let ratioRect = AVMakeRect(aspectRatio: currentImage.size, insideRect: imageViewRect)
        
        let width: CGFloat = ratioRect.size.width //cgImage.width / 2
        let height: CGFloat = ratioRect.size.height //cgImage.height / 2
        let bitsPerComponent: Int = cgImage.bitsPerComponent
        let bytesPerRow: Int = cgImage.bytesPerRow
        let colorSpace: CGColorSpace = cgImage.colorSpace!
        let bitmapInfo: CGBitmapInfo = cgImage.bitmapInfo
        
        let context: CGContext = CGContext.init(data: nil, width: Int(width), height: Int(height), bitsPerComponent: bitsPerComponent, bytesPerRow: bytesPerRow, space: colorSpace, bitmapInfo: bitmapInfo.rawValue)!
        
        context.interpolationQuality = CGInterpolationQuality.high
        
        context.draw(cgImage, in: CGRect(origin: CGPoint.zero, size: CGSize(width: width, height: height)))
        
        let scaledImage: CGImage = context.makeImage()!
        
        return UIImage(cgImage: scaledImage)
    }
    
    static func getDateFromServerString2(_ dateString:String) -> Date
    {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        dateFormatter.timeZone = TimeZone.ReferenceType(name: "UTC") as TimeZone! // TimeZone(name: "UTC") as TimeZone!
        let date = dateFormatter.date(from:dateString)
        return date!
    }
    
    static func getDateFromServerString(_ dateString:String) -> Date
    {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS"
        dateFormatter.timeZone = TimeZone.ReferenceType(name: "UTC") as TimeZone! // TimeZone(name: "UTC") as TimeZone!
        let date = dateFormatter.date(from:dateString)
        return date!
    }
    
    static func convertUTCTimeToLocalDateString(_ dateString: String) -> String {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS"
        dateFormatter.timeZone = TimeZone.ReferenceType(name: "UTC") as TimeZone! // TimeZone(name: "UTC") as TimeZone!
        let date = dateFormatter.date(from:dateString)
        
        dateFormatter.dateFormat = "MM/dd/yyyy hh:mm:ss a"
        dateFormatter.timeZone = TimeZone.ReferenceType.local
        let timeStamp = dateFormatter.string(from: date!)
        return timeStamp
    }
    
    static func getStringFromDate(_ date:Date) -> String
    {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/dd/yyyy hh:mm:ss a"
        let dateString = dateFormatter.string(from:date)
        return dateString
    }
    
    static func fetchGroupsFromDB(_ groupDBState: GroupDBState) -> [GroupObject] {
        
        let predicate: NSPredicate = NSPredicate(format: "groupSaveState == %@", groupDBState.rawValue)
        
        if let groupEntityList: [GroupEntity] = GroupEntity.mr_findAll(with: predicate) as? [GroupEntity] {
            
            return ModelConvertor.convertToGroupObjectList(groupEntityList)
        }
        else {
            
            return []
        }
    }
}
