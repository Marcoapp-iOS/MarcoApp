//
//  ImageTileView.swift
//  MarcoApp
//
//  Created by Nabeel Hayat on 19/04/2018.
//  Copyright © 2018 GrayScaleLogic. All rights reserved.
//

import UIKit

protocol ImageTileListViewDelegate {
    
    func didDelete(_ imageTileView: ImageTileView, _ tileListView: ImageTileListView, at index: Int)
}

class ImageTileListView: UIView, ImageTileViewDelegate {
    
    private var scrollView: UIScrollView!
    
    var delegate: ImageTileListViewDelegate!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.initialize()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.initialize()
    }
    
    private func initialize() {
        
        self.scrollView = UIScrollView(frame: CGRect(x: 0, y: 0, width: self.frame.size.width, height: self.frame.size.height))
        self.scrollView.showsHorizontalScrollIndicator = true
        self.scrollView.showsVerticalScrollIndicator = false
        
        self.addSubview(self.scrollView)
    }
    
    func setupViewWithImagesList(_ imagesList: [UIImage]) {
        
        for subView in self.scrollView.subviews {
            
            subView.removeFromSuperview()
        }
        
        var index: Int = 0
        
        for currentImage in imagesList {
            
            let imageFrame: CGRect = self.getCurrentFrame(index)
            
            let imageTileView: ImageTileView = ImageTileView(frame: imageFrame)
            imageTileView.image = currentImage
            imageTileView.tag = index
            imageTileView.delegate = self
            self.scrollView.addSubview(imageTileView)
            
            index = index + 1
        }
        
        self.scrollView.contentSize = CGSize(width: CGFloat(imagesList.count + 1) * ((self.frame.size.height * 0.8) + 10), height: self.frame.size.height)
    }
    
    private func getCurrentFrame(_ index: Int) -> CGRect {
        
        let frameWidth: CGFloat = self.frame.size.height * 0.8
        let xAxis: CGFloat = (frameWidth + 10) * CGFloat(index)
        
        return CGRect(x: xAxis, y: 5, width: frameWidth, height: self.frame.size.height - 10)
    }
    
    // MARK: - ImageTileViewDelegate
    
    func didDelete(imageTile imageTileView: ImageTileView, at index: Int) {
     
        if self.delegate != nil {
            
            self.delegate.didDelete(imageTileView, self, at: index)
        }
    }
}

protocol ImageTileViewDelegate {
    
    func didDelete(imageTile imageTileView: ImageTileView, at index: Int)
}

class ImageTileView: UIView {

    private var imageView: UIImageView!
    private var deleteButton: UIButton!
    private var containerView: UIView!
    
    var image: UIImage! {
        
        didSet {
            
            self.imageView.image = image
        }
    }
    
    var delegate: ImageTileViewDelegate!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.initialize()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.initialize()
    }
    
    private func initialize() {
        
        let containerFrame: CGRect = CGRect(x: 0, y: 0, width: self.frame.size.width, height: self.frame.size.height)
        
        self.containerView = UIView(frame: containerFrame)
        self.containerView.backgroundColor = UIColor.clear
        
        self.imageView = UIImageView(frame: CGRect(x: 0, y: 15, width: self.containerView.frame.size.width - 15, height: self.containerView.frame.size.height - 15))
        self.imageView.layer.borderColor = AppTheme.blackColor.cgColor
        self.imageView.layer.borderWidth = 2.0
        self.imageView.layer.cornerRadius = 4
        self.imageView.layer.masksToBounds = true
        self.imageView.clipsToBounds = true
        
        self.deleteButton = UIButton(type: .custom)
        self.deleteButton.frame = CGRect(x: self.containerView.frame.size.width - 30, y: 0, width: 30, height: 30)
        self.deleteButton.setImage(UIImage(named: "ic_close"), for: .normal)
        self.deleteButton.addTarget(self, action: #selector(didDeleteButtonPressed(_:)), for: .touchUpInside)
        
        self.containerView.addSubview(self.imageView)
        self.containerView.addSubview(self.deleteButton)
        
        self.addSubview(self.containerView)
        
    }
    
    @objc open func didDeleteButtonPressed(_ sender: UIButton) {
        
        if self.delegate != nil {
            
            self.delegate.didDelete(imageTile: self, at: self.tag)
        }
    }
}
