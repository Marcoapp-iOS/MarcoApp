//
//  BaseImageView.swift
//  MarcoApp
//
//  Created by Nabeel Hayat on 28/10/2017.
//  Copyright © 2017 GrayScaleLogic. All rights reserved.
//

import UIKit

class BaseImageView: UIImageView {
    
    @IBInspectable
    /// Border color of view; also inspectable from Storyboard.
    public var imageBorderColor: UIColor? {
        get {
            guard let color = layer.borderColor else {
                return nil
            }
            return UIColor(cgColor: color)
        }
        set {
            guard let color = newValue else {
                layer.borderColor = nil
                return
            }
            layer.borderColor = color.cgColor
        }
    }
    
    @IBInspectable
    /// Border width of view; also inspectable from Storyboard.
    public var imageBorderWidth: CGFloat {
        get {
            return layer.borderWidth
        }
        set {
            layer.borderWidth = newValue
        }
    }

    // MARK: - Lifecycle
    
    @IBInspectable var isBorder: Bool = true {
        
        didSet {
            
            switch isBorder {
            case true:
                
                self.showBorder()
                
            case false:
                
                self.hideBorder()
            }
        }
    }
    
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
        
        if self.isBorder {
        
            self.showBorder()
        }
        else {
        
            self.hideBorder()
        }   
    }
    
    private func showBorder() {
    
        self.layer.borderColor = self.imageBorderColor?.cgColor
        self.layer.borderWidth = self.imageBorderWidth
        self.layer.masksToBounds = true
        self.clipsToBounds = true
    }

    private func hideBorder() {
    
        self.layer.borderColor = nil
        self.layer.borderWidth = 0
        self.layer.masksToBounds = false
        self.clipsToBounds = false
    }
}
