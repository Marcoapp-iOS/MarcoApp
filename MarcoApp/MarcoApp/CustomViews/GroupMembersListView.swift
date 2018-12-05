 //
//  GroupMembersListView.swift
//  MarcoApp
//
//  Created by Nabeel Hayat on 01/11/2017.
//  Copyright © 2017 GrayScaleLogic. All rights reserved.
//

import UIKit
import SDWebImage

protocol GroupMembersListViewDelegate {
    
    func groupMembersListView(_ groupMembersListView: GroupMembersListView, didDetailButtonPressed sender: UIButton)
}

class GroupMembersListView: UIButton {

    var groupMembersList = [UserProfile]() {
        
        didSet {
            
            self.initialize()
        }
    }
    
    override var bounds: CGRect {
        didSet {
            
            self.updateImageFrame()
        }
    }
    
    fileprivate var imageViewsList = [RoundedImageView]()
    private var totalCount = 0
    var delegate: GroupMembersListViewDelegate!
    
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
        
        //self.initialize()
    }
    
    private func initialize() {
        
        if self.groupMembersList.count > 0 {
            
            if self.imageViewsList.count > 0 {
                
                self.imageViewsList.removeAll()
            }
            
            self.setTitle("", for: .normal)
            self.addTarget(self, action: #selector(GroupMembersListView.didGroupMembersDetailButtonPressed(_:)), for: .touchUpInside)
            
//            self.totalCount = (self.groupMembersListView.count <= 5) ? self.groupMembersListView.count : self.groupMembersListView.count + 1
            
            var imageFrame = self.getFrame()
            let count = self.groupMembersList.count
            for index in 1...count {
                
                let imageView: RoundedImageView = RoundedImageView(frame: imageFrame)
                imageView.isBorder = false
                imageFrame = self.getFrame(forIndex: index)
                
                self.imageViewsList.append(imageView)
                
                self.addSubview(imageView)
        
                if count == index {
                    break
                }
            }
            
            var index = 0
            
            for imageView in self.imageViewsList {
                
//                if index != (self.imageViewsList.count - 1) {
                
//                    let groupMember = self.groupMembersListView[index]
                    
//                    if groupMember.avatarUrl != "" {
//                        
//                        let url = URL(string: groupMember.avatarUrl)
//                        
//                        
//                        imageView.af_setImage(withURL: url!, placeholderImage: UIImage(named: "user_default"), filter: nil, progress: nil, progressQueue: DispatchQueue.main, imageTransition: .crossDissolve(0.2), runImageTransitionIfCached: true, completion: { (responseImage) in
//                            
//                            
//                        })
//                    }
//                    else {
//                        
//                        imageView.image = UIImage(named: "user_default")
//                    }
                
                
                let userProfile: UserProfile =  self.groupMembersList[index]
                
                let imageName: String = userProfile.profilePicture

                if imageName != "" {
                    
                    let imageURL: URL = URL(string: imageName)!
                    
                    imageView.sd_setImage(with: imageURL, placeholderImage: UIImage(named: "user_default")) { (image, error, imageCacheType, url) in
                        
                    }
                }
                else {
                    
                    imageView.image = UIImage(named: "user_default")
                }
//                let image = UIImage(named: imageName)
//
//                if image == nil {
//
//                    imageView.image = UIImage(named: "user_default")
//                }
//                else {
//
//                    imageView.image = image
//                }
                
//                }
//                else {
//                    
//                    let image = UIImage.getImage(withName: "ic_more_members", imageColor: UIColor.white)
//                    
//                    imageView.image = image
//                    imageView.backgroundColor = UIColor.lightGray
//                    imageView.borderColor = UIColor.white
//                    
//                }
                
                
                index = index + 1
            }
        }
    }
    
    fileprivate func updateImageFrame() {
    
        for subview: UIView in self.subviews {
            
            subview.removeFromSuperview()
        }
        var index: Int = 0
        
        for imageView: RoundedImageView in self.imageViewsList {
            
            imageView.frame = self.getFrame(forIndex: index);
            self.addSubview(imageView)
            
            index = index + 1;
        }
    }
    
    fileprivate func getFrame(forIndex index: Int = 0) -> CGRect {
        
        let frameHeight: CGFloat = self.frame.size.height
        let frameWidth: CGFloat = self.frame.size.width
        let imageWidth: CGFloat = 24
        let totalImages = CGFloat(self.groupMembersList.count)
        
        let spacing = (10 * (totalImages - 1))
        let totalImagesWidth = (imageWidth * totalImages)
        let xAxis: CGFloat = (frameWidth - (totalImagesWidth + spacing))/2
        
        let currentImageXAxis = CGFloat(xAxis + (imageWidth + 10) * CGFloat(index))
        
        let yAxis: CGFloat = (frameHeight - imageWidth)/2
        
        return CGRect(x: currentImageXAxis, y:yAxis, width: imageWidth, height: imageWidth)
    }
    
    @objc func didGroupMembersDetailButtonPressed(_ sender: UIButton) {
        
        
        if let delegate = self.delegate {
            
            delegate.groupMembersListView(self, didDetailButtonPressed: sender)
        }
        
    }
}

