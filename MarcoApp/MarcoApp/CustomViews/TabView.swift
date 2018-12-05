//
//  TabView.swift
//  MarcoApp
//
//  Created by Nabeel Hayat on 03/11/2017.
//  Copyright © 2017 GrayScaleLogic. All rights reserved.
//

import UIKit

protocol TabViewDelegate {

    func tabView(_ tabView: TabView, selectionChanged:Int)
}

class TabView: UIView {
    
    var delegate: TabViewDelegate!
    
    private var viewWidth: CGFloat = 0.0
    private var viewHeight: CGFloat = 0.0
    var indexSelected: Int = 0;
    private var arrayButtons: [TabViewButton] = []
    private var vIndicator: UIView!
    

    var selectedColor: UIColor!
    
    var unSelectedColor: UIColor!
    
    var indicatorColor: UIColor!
    
    // MARK: - Lifecycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    // MARK: - Button Action
    
    @objc func didTabButtonPressed(_ tabButton: TabViewButton) {
        
        let tagIndex = tabButton.tag
        
        self.setAllButtonUnselected()
        tabButton.setTabSelected(withColor: self.selectedColor)
        if let delegate = self.delegate {
            delegate.tabView(self, selectionChanged: tagIndex)
        }
        self.animateIndicatorToIndex(index: tagIndex)
        self.indexSelected = tagIndex
    }
    
    // MARK: - Helper Functions
    
    func animateIndicatorToIndex(index: Int) {
    
        UIView.animate(withDuration: 0.3) { 
            self.vIndicator.frame = CGRect(x: self.viewWidth * CGFloat(index), y: self.viewHeight, width: self.viewWidth, height: 2)
        }
    }
    
    func setAllButtonUnselected() {
    
        for view in self.subviews {
            if view.isKind(of: TabViewButton.self) {
                let tabButton: TabViewButton = view as! TabViewButton
                tabButton.setTabUnSelected(withColor: self.unSelectedColor)
            }
        }
    }
    
    func setupTabButtons(tabs: [String], isImages: Bool = false, selectedColor: UIColor = AppTheme.whiteColor, unSelectedColor: UIColor = AppTheme.grayColor, indicatorColor: UIColor = AppTheme.whiteColor) {
    
        self.selectedColor = selectedColor
        self.unSelectedColor = unSelectedColor
        self.indicatorColor = indicatorColor
        
        self.backgroundColor = UIColor.clear
        self.viewWidth = UIScreen.main.bounds.size.width / CGFloat(tabs.count)
        self.viewHeight = self.frame.size.height - 2

        var xStart: CGFloat = 0.0

        self.viewWidth = UIScreen.main.bounds.size.width / CGFloat(tabs.count)
        self.viewHeight = self.frame.size.height - 2
        
        for index in 0..<tabs.count {
            let title = tabs[index]
            
            let tabButton: TabViewButton = TabViewButton(type: .system)
            
            tabButton.setTab(withTitle: title, frame: CGRect(x: xStart, y: 0, width: self.viewWidth, height: self.viewHeight), isImages: isImages)
            
            tabButton.backgroundColor = UIColor.clear
            tabButton.tag = index
            
            tabButton.addTarget(self, action: #selector(didTabButtonPressed(_:)), for: .touchUpInside)
            
            if index == 0 {
                
                tabButton.setTabSelected(withColor: self.selectedColor)
                self.indexSelected = index
            }
            else {
            
                tabButton.setTabUnSelected(withColor: self.unSelectedColor)
            }
            
            self.addSubview(tabButton)
            
            xStart = xStart + self.viewWidth
        }
        
        self.vIndicator = UIView(frame: CGRect(x: 0, y: self.viewHeight, width: self.viewWidth, height: 2))
        
        self.vIndicator.backgroundColor = self.indicatorColor
        
        self.addSubview(self.vIndicator)
    }

}

class TabViewButton: UIButton {

    var tabImageView: UIImageView!
    var tabTitleLabel: UILabel!
    var isImages: Bool!
    var title: String!
    // MARK: - Lifecycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func setTab(withTitle title: String, frame: CGRect, isImages: Bool = false) {
        
        self.backgroundColor = UIColor.clear
        self.tintColor = AppTheme.whiteColor
        self.frame = frame
        self.isImages = isImages;
        self.title = title;
        
        
        if self.isImages {
            
            self.tabImageView = UIImageView(image: UIImage.getImage(withName: title, imageColor: AppTheme.grayColor))
         
            self.tabImageView?.isUserInteractionEnabled = false
            self.tabImageView?.translatesAutoresizingMaskIntoConstraints = false
            
            self.addSubview(self.tabImageView!)
            
            self.addConstraintsForImageView()
        }
        else {
        
            self.tabTitleLabel = UILabel()
            
            self.tabTitleLabel.font = AppTheme.boldFont(withSize: 12)
            
            let text = NSMutableAttributedString(string: title)
            
            self.tabTitleLabel.attributedText = text.setFont(font: AppTheme.boldFont(withSize: 12), kerningValue: 100)
            self.tabTitleLabel.isUserInteractionEnabled = false
            self.tabTitleLabel.backgroundColor = UIColor.clear
            self.tabTitleLabel.numberOfLines = 1
            self.tabTitleLabel.minimumScaleFactor = 0.5
            self.tabTitleLabel.adjustsFontSizeToFitWidth = true
            self.tabTitleLabel.textAlignment = .center
            self.tabTitleLabel.translatesAutoresizingMaskIntoConstraints = false
            
            self.addSubview(self.tabTitleLabel)
            
            self.addConstraintsForTitleLabel()
        }
    }
    
    // MARK: - Constraints
    
    func addConstraintsForImageView() {
        
        self.addConstraint(NSLayoutConstraint(item: self.tabImageView!, attribute: .width, relatedBy: .equal, toItem: self.tabImageView!, attribute: .height, multiplier: 1/1, constant: 0))
        
        self.addConstraint(NSLayoutConstraint(item: self.tabImageView!, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 25))
    
        self.addConstraint(NSLayoutConstraint(item: self.tabImageView!, attribute: .centerX, relatedBy: .equal, toItem: self, attribute: .centerX, multiplier: 1, constant: 0))
        
        self.addConstraint(NSLayoutConstraint(item: self.tabImageView!, attribute: .centerY, relatedBy: .equal, toItem: self, attribute: .centerY, multiplier: 1, constant: 0))
    }
    
    func addConstraintsForTitleLabel() {
     
        let padding: CGFloat = 2.0
        
        self.addConstraint(NSLayoutConstraint(item: self.tabTitleLabel!, attribute: .leading, relatedBy: .equal, toItem: self, attribute: .leading, multiplier: 1, constant: padding))
        
        self.addConstraint(NSLayoutConstraint(item: self.tabTitleLabel!, attribute: .trailing, relatedBy: .equal, toItem: self, attribute: .trailing, multiplier: 1, constant: padding))
        
        self.addConstraint(NSLayoutConstraint(item: self.tabTitleLabel!, attribute: .top, relatedBy: .equal, toItem: self, attribute: .top, multiplier: 1, constant: 0))
        
        self.addConstraint(NSLayoutConstraint(item: self.tabTitleLabel!, attribute: .bottom, relatedBy: .equal, toItem: self, attribute: .bottom, multiplier: 1, constant: 0))
    }
    
    // MARK: - Helper functions
    
    func setTabSelected(withColor color: UIColor) {
    
        if self.isImages {
            
            self.tabImageView.image = UIImage.getImage(withName: title, imageColor: color)
            
        }
        else {
        
            self.tabTitleLabel.textColor = color
        }
    }
    
    func setTabUnSelected(withColor color: UIColor) {
    
        if self.isImages {
            
            self.tabImageView.image = UIImage.getImage(withName: title, imageColor: color)
        }
        else {
            
            self.tabTitleLabel.textColor = color
        }
    }
}
