//
//  BaseButton.swift
//  MarcoApp
//
//  Created by Nabeel Hayat on 28/10/2017.
//  Copyright © 2017 GrayScaleLogic. All rights reserved.
//

import UIKit

class BaseButton: UIButton {

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
        
        self.titleLabel?.textColor = UIColor.white
        self.tintColor = UIColor.white
        self.titleLabel?.font = UIFont(name: "", size: 14);
    }
}
