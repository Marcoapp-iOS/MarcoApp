//
//  AppUI.swift
//  MarcoApp
//
//  Created by Nabeel Hayat on 28/10/2017.
//  Copyright © 2017 GrayScaleLogic. All rights reserved.
//

import UIKit

class AppUI: NSObject {

    static let mainStoryboard = UIStoryboard(name: "Main", bundle: nil)
    
    class func getEditProfileViewController() -> EditProfileViewController {
        
        let editProfileViewController: EditProfileViewController = AppUI.mainStoryboard.instantiateViewController(withIdentifier: "EditProfileViewController") as! EditProfileViewController
        
        return editProfileViewController
    }
    
    class func getLandingViewController() -> LandingViewController {
        
        let landingViewController: LandingViewController = AppUI.mainStoryboard.instantiateViewController(withIdentifier: "LandingViewController") as! LandingViewController
        
        return landingViewController
    }
    
    class func getLoginViewController() -> LoginViewController {
        
        let loginViewController: LoginViewController = AppUI.mainStoryboard.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
        
        return loginViewController
    }
    
    class func getRootMainViewController() -> RootViewController {
        
        let rootViewController: RootViewController = AppUI.mainStoryboard.instantiateViewController(withIdentifier: "RootViewController") as! RootViewController
        
        return rootViewController
    }
    
    class func getRootViewController() -> UIViewController {
        
        if AppDefaults.isAppOpenFirstTime() {
            
            // show landing pages
            
            return AppUI.getLandingViewController()
        }
        else if AppDefaults.isAppLoggedIn() {
            
            // show main page
            
            return AppUI.getRootMainViewController()
        }
        else {
            
            // show login page
            
            return AppUI.getLandingViewController()
        }
        
    }
}
