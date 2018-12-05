//
//  MenuObject.swift
//  MarcoApp
//
//  Created by Nabeel Hayat on 28/10/2017.
//  Copyright © 2017 GrayScaleLogic. All rights reserved.
//

import UIKit

class MenuObject: NSObject {

    var menuTitle: String?
    var badgeValue: String?
    var imageName: String?
    var selectedImageName: String?
    var isSelected: Bool?
    
    override init() {
        super.init()
        
        self.menuTitle = ""
        self.badgeValue = ""
        self.imageName = ""
        self.selectedImageName = ""
        self.isSelected = false
    }
    
    init(with title: String, imageName: String, badgeValue: String, isSelected: Bool) {
        super.init()
        
        self.menuTitle = title
        self.selectedImageName = imageName + "_a"
        self.imageName = imageName
        self.badgeValue = badgeValue
        self.isSelected = isSelected
    }
    
    class func getDefaultMenuList() -> [MenuObject] {
        
        var menuArray: [MenuObject] = []
        
        menuArray.append(MenuObject(with: "Map", imageName: "ic_map_tb", badgeValue: "", isSelected: false))
        menuArray.append(MenuObject(with: "Newsfeed", imageName: "ic_newsfeed_tb", badgeValue: "", isSelected: true))
        menuArray.append(MenuObject(with: "Discover", imageName: "ic_discover_tb", badgeValue: "", isSelected: false))
        menuArray.append(MenuObject(with: "My Groups", imageName: "ic_my_groups_tb", badgeValue: "", isSelected: false))
        menuArray.append(MenuObject(with: "Chats", imageName: "ic_chat_tb", badgeValue: "", isSelected: false))
        menuArray.append(MenuObject(with: "Notifications", imageName: "ic_notifications_tb", badgeValue: "", isSelected: false))
        menuArray.append(MenuObject(with: "Favorites", imageName: "ic_favorites_tb", badgeValue: "", isSelected: false))
        menuArray.append(MenuObject(with: "Invite Friends", imageName: "ic_invite_tb", badgeValue: "", isSelected: false))
        menuArray.append(MenuObject(with: "Settings", imageName: "ic_settings_tb", badgeValue: "", isSelected: false))
        menuArray.append(MenuObject(with: "ContactUs", imageName: "ic_contact_tb", badgeValue: "", isSelected: false))
        
        return menuArray
    }
    
    class func getAdminMenuList() -> [MenuObject] {
        
        var menuArray: [MenuObject] = []
        
        menuArray.append(MenuObject(with: "Map", imageName: "ic_map_tb", badgeValue: "", isSelected: false))
        menuArray.append(MenuObject(with: "Newsfeed", imageName: "ic_newsfeed_tb", badgeValue: "", isSelected: true))
        menuArray.append(MenuObject(with: "Discover", imageName: "ic_discover_tb", badgeValue: "", isSelected: false))
        menuArray.append(MenuObject(with: "My Groups", imageName: "ic_my_groups_tb", badgeValue: "", isSelected: false))
        menuArray.append(MenuObject(with: "Chats", imageName: "ic_chat_tb", badgeValue: "", isSelected: false))
        menuArray.append(MenuObject(with: "Notifications", imageName: "ic_notifications_tb", badgeValue: "", isSelected: false))
        menuArray.append(MenuObject(with: "Favorites", imageName: "ic_favorites_tb", badgeValue: "", isSelected: false))
        menuArray.append(MenuObject(with: "Invite Friends", imageName: "ic_invite_tb", badgeValue: "", isSelected: false))
        menuArray.append(MenuObject(with: "Settings", imageName: "ic_settings_tb", badgeValue: "", isSelected: false))
        menuArray.append(MenuObject(with: "ContactUs", imageName: "ic_contact_tb", badgeValue: "", isSelected: false))
        
        return menuArray
    }
}
