//
//  BadgeLabel.swift
//  MarcoApp
//
//  Created by Nabeel Hayat on 31/10/2017.
//  Copyright © 2017 GrayScaleLogic. All rights reserved.
//

import UIKit

class BadgeLabel: UIView {
    
    @IBOutlet weak var titleLabel: UILabel!

    var text: String = "" {
    
        didSet {
        
            if text == "" || text == "0" {
                
                self.isHidden = true
            }
            else {
            
                self.isHidden = false
            }
            
            self.titleLabel.text = text;
            self.layoutIfNeeded()
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
        
        self.backgroundColor = AppTheme.blueColor
        
        self.layer.cornerRadius = self.frame.size.height / 2
        self.layer.masksToBounds = true
        self.clipsToBounds = true
    }
}
