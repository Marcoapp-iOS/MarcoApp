//
//  RootViewController.swift
//  MarcoApp
//
//  Created by Nabeel Hayat on 27/10/2017.
//  Copyright © 2017 GrayScaleLogic. All rights reserved.
//

import UIKit

class RootViewController: RESideMenu {

    var userProfile: UserProfile! 
    
    // MARK:- Lifecycle
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.contentViewController = AppUI.mainStoryboard.instantiateViewController(withIdentifier: AppConstants.kDiscoverSegues)
        self.leftMenuViewController = AppUI.mainStoryboard.instantiateViewController(withIdentifier: AppConstants.kMenuSegues)
        self.backgroundImage = UIImage(named: AppConstants.kBackgroundImage)
        
        self.blurBackgroundImageView = true
        self.scaleBackgroundImageView = true
        self.parallaxEnabled = true
        self.fadeMenuView = true
        self.menuPrefersStatusBarHidden = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        NotificationCenter.default.addObserver(self, selector: #selector(RootViewController.setupUserProfile), name: Notification.Name.OnUpdateCoverPicture, object: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override var prefersStatusBarHidden: Bool {
    
        return true
    }
    
    @objc private func setupUserProfile() {
        
        self.userProfile = AppFunctions.getUserProfile(from: AppDefaults.getLoggedUserId())
        
        if self.userProfile.coverPicture != nil && self.userProfile.coverPicture != "" {
            
            let fileValue:String = self.userProfile.coverPicture.replacingOccurrences(of: "\"", with: "")
            
            let imageURL = URL(string: fileValue)
            
            
            do {
                let imageData = try Data(contentsOf: imageURL!)
                self.backgroundImage = UIImage(data: imageData)!
                
            } catch {
                
                print("URL is empty or invalid")
            }
            
        }
        else {
            
            self.backgroundImage = UIImage(named: AppConstants.kBackgroundImage)
        }
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

// MARK:- RESideMenuDelegate

extension RootViewController: RESideMenuDelegate {

    func sideMenu(_ sideMenu: RESideMenu!, didRecognizePanGesture recognizer: UIPanGestureRecognizer!) {
        
    }
    
    func sideMenu(_ sideMenu: RESideMenu!, willShowMenuViewController menuViewController: UIViewController!) {
        
    }
    
    func sideMenu(_ sideMenu: RESideMenu!, didShowMenuViewController menuViewController: UIViewController!) {
        
    }
    
    func sideMenu(_ sideMenu: RESideMenu!, willHideMenuViewController menuViewController: UIViewController!) {
        
    }
    
    func sideMenu(_ sideMenu: RESideMenu!, didHideMenuViewController menuViewController: UIViewController!) {
        
    }
}
