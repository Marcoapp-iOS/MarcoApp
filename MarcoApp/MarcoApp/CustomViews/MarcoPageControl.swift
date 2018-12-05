//
//  MarcoPageControl.swift
//  MarcoApp
//
//  Created by Nabeel Hayat on 09/01/2018.
//  Copyright © 2018 GrayScaleLogic. All rights reserved.
//

import UIKit

class MarcoPageControl: UIPageControl {

    override var numberOfPages: Int {
        
        didSet {
            
            self.updatePageDots()
        }
    }
    
    override var currentPage: Int {
        
        didSet {
            
            self.updatePageDots()
        }
    }
    
    var selectedImage: UIImage!
    var unSelectedImage: UIImage!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.pageIndicatorTintColor = UIColor.clear
        self.currentPageIndicatorTintColor = UIColor.clear
        self.clipsToBounds = false
        
        self.selectedImage = UIImage(named: "tile_progress_circle_tapped")
        self.unSelectedImage = UIImage(named: "tile_progress_circle")
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        self.selectedImage = UIImage(named: "tile_progress_circle_tapped")
        self.unSelectedImage = UIImage(named: "tile_progress_circle")
    }
    
    // MARK: - Helper functions
    
    func updateCurrentPage() {
        
        self.currentPage = 0
        self.updatePageDots()
    }
    
    private func updatePageDots() {
        
        var i: Int = 0
        
        for view: UIView in self.subviews {
            
            let dot: UIImageView = self.imageViewForSubview(view)
            
            if i == self.currentPage {
                
                dot.image = self.selectedImage
            }
            else {
                dot.image = self.unSelectedImage
            }
            
            i = i + 1;
        }
    }
    
    private func imageViewForSubview(_ view: UIView) -> UIImageView {

        var dot: UIImageView? = nil
        
        if view.isKind(of: UIView.self) {
            
            for subview: UIView in view.subviews {
                    
                if subview.isKind(of: UIImageView.self) {
                    
                    dot = (subview as! UIImageView)
                    break
                }
            }
            
            if dot == nil {
                
                dot = UIImageView(frame: CGRect(x: 0, y: 0, width: view.frame.size.width, height: view.frame.size.height))
                view.addSubview(dot!)
            }
        }
        else {
            dot = (view as! UIImageView)
        }
        
        return dot!
    }
    
}
