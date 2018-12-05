//
//  AppTheme.swift
//  MarcoApp
//
//  Created by Nabeel Hayat on 28/10/2017.
//  Copyright © 2017 GrayScaleLogic. All rights reserved.
//

import UIKit

class AppTheme: NSObject {

    // MARK: - Main Theme
    
    static var cardTheme: STPTheme = {
        let theme: STPTheme = STPTheme.default()
        theme.primaryBackgroundColor = AppTheme.blackColor
        theme.accentColor = AppTheme.whiteColor
        theme.primaryForegroundColor = AppTheme.whiteColor
        theme.secondaryBackgroundColor = AppTheme.grayColor
        return theme
    }()
    
    /// COLORS
//    static var blackColor: UIColor = UIColor(red: 35/255, green: 36/255, blue: 38/255, alpha: 1.0)
    static var blackColor: UIColor = UIColor(hue: 220.0/360, saturation: 8.0/100, brightness: 15.0/100, alpha: 1.0) //UIColor(red: 0/255, green: 0/255, blue: 0/255, alpha: 1.0)
    

    static var whiteColor: UIColor = UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 1.0)
    
    static var grayColor: UIColor = UIColor(red: 136/255, green: 136/255, blue: 136/255, alpha: 1.0)
    static var blueColor: UIColor = UIColor(red: 0/255, green: 159/255, blue: 232/255, alpha: 1.0)
    static var separatorColor: UIColor = UIColor(red: 184/255, green: 184/255, blue: 184/255, alpha: 1.0)
    
    static var invalidColor: UIColor = UIColor(red: 248/255, green: 0/255, blue: 0/255, alpha: 1.0)
    
    static var disableUIColor: UIColor = UIColor(red: 178/255, green: 178/255, blue: 178/255, alpha: 1.0)
    
    static var imageGrayColor: UIColor = UIColor(red: 167/255, green: 167/255, blue: 167/255, alpha: 1.0)
    
    static var chatBgColor: UIColor = UIColor(red: 239/255, green: 240/255, blue: 242/255, alpha: 1.0)
    
    static var borderColor: UIColor = UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 1.0)
    static var textColor: UIColor = UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 1.0)
    
    static var likeHeartColor: UIColor = UIColor(red: 238/255, green: 91/255, blue: 91/255, alpha: 1.0)
    
    static var tableViewGroupColor: UIColor = UIColor(red: 235/255, green: 235/255, blue: 241/255, alpha: 1.0)
    
    /// SIZES
    static var primaryBorderWidth: CGFloat = 2.0
    
    /// FONTS
    static func regularFont(withSize size: CGFloat) -> UIFont {
    
        return UIFont(name: "Lato-Regular", size: size)!
    }
    
    static func semiBoldFont(withSize size: CGFloat) -> UIFont {
        
        return UIFont(name: "Lato-Semibold", size: size)!
    }
    
    static func mediumFont(withSize size: CGFloat) -> UIFont {
        
        return UIFont(name: "Lato-Medium", size: size)!
    }
    
    static func boldFont(withSize size: CGFloat) -> UIFont {
        
        return UIFont(name: "Lato-Bold", size: size)!
    }
    
    // MARK: - Navigation Theme
    
    static var navigationBarfontAttributes = [NSAttributedStringKey.font: boldFont(withSize: 18)]
    static var navigationBarDetailfontAttributes = [NSAttributedStringKey.font: semiBoldFont(withSize: 15)]
    
    static var statusBarHeight: CGFloat = 20.0
    static var navigationBarHeight: CGFloat = 184.0
}
