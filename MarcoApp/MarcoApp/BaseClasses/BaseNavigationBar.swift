//
//  BaseNavigationBar.swift
//  MarcoApp
//
//  Created by Nabeel Hayat on 07/12/2017.
//  Copyright © 2017 GrayScaleLogic. All rights reserved.
//

import UIKit

class BaseNavigationBar: UINavigationBar {

    //set NavigationBar's height
    var customHeight : CGFloat = 66
    
    private var yAxis: CGFloat = 20.0
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)

        self.initialize()
    }

    override init(frame: CGRect) {
        super.init(frame: frame)

        self.initialize()
    }
    
    override func sizeThatFits(_ size: CGSize) -> CGSize {
        return CGSize(width: UIScreen.main.bounds.width, height: customHeight)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        for subview in self.subviews {
            var stringFromClass = NSStringFromClass(subview.classForCoder)
            
            print("Bar View Class: \(stringFromClass)")
            
            if stringFromClass.contains("BarBackground") {
                subview.frame = CGRect(x: 0, y: 0, width: self.frame.width, height: customHeight)
                //                subview.backgroundColor = .yellow
                
            }
            
            
            
            stringFromClass = NSStringFromClass(subview.classForCoder)
            if stringFromClass.contains("BarContent") {
                
                subview.frame = CGRect(x: subview.frame.origin.x, y: yAxis, width: subview.frame.width, height: customHeight)
//                                subview.backgroundColor = .green
            }
        }
    }
    
    private func initialize() {
        
        if (Device.IS_IPHONE_X){
            
            yAxis = 0.0
        }
        
        
        self.barStyle = UIBarStyle.black;
        self.isTranslucent = true
        self.barTintColor = AppTheme.blackColor
        self.tintColor = AppTheme.textColor
        
        self.titleTextAttributes = AppTheme.navigationBarfontAttributes
        
        UIBarButtonItem.appearance().setTitleTextAttributes(AppTheme.navigationBarfontAttributes, for: UIControlState.normal)
        
        BaseNavigationBar.appearance().setBackgroundImage(
            UIImage(),
            for: .any,
            barMetrics: .default)
        
        BaseNavigationBar.appearance().shadowImage = UIImage()
        
        frame = CGRect(x: frame.origin.x, y:  0, width: frame.size.width, height: customHeight)
    }
}
