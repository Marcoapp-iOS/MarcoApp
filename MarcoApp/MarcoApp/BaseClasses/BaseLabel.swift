//
//  BaseLabel.swift
//  MarcoApp
//
//  Created by Nabeel Hayat on 28/10/2017.
//  Copyright © 2017 GrayScaleLogic. All rights reserved.
//

import UIKit

class BaseLabel: UILabel {
    
    var fontSize: CGFloat = 14 {
    
        didSet {
        
            self.initialize()
        }
    }
    
    // MARK: - Lifecycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.initialize()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        self.initialize()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        self.initialize()
    }
    
    private func initialize() {
        
        self.tintColor = UIColor.white
        self.textColor = UIColor.white
        self.font = AppTheme.regularFont(withSize: self.fontSize);
    }
}
