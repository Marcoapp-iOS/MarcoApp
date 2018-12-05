//
//  UserDetailAnnotationView.swift
//  MarcoApp
//
//  Created by Nabeel Hayat on 09/11/2018.
//  Copyright © 2018 GrayScaleLogic. All rights reserved.
//

import UIKit
import SDWebImage

typealias DidSelectChat = (_ sender: UIButton) -> Void

class UserDetailAnnotationView: UIView {
    
    @IBOutlet var contentView: UIView!
    @IBOutlet weak var chatButton: UIButton!
    @IBOutlet weak var moreButton: UIButton!
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var userAvatarImageView: RoundedImageView!
    
    var didSelectChat: DidSelectChat?
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        commonInit()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        commonInit()
    }
    
    private func commonInit() {
        
        Bundle.main.loadNibNamed("UserDetailAnnotationView", owner: self, options: nil)
        addSubview(contentView)
        contentView.frame = self.bounds
        contentView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
    }
    
    
    func set(Title title: String, imageUrl: URL?, _ didSelectChat: @escaping DidSelectChat) {
        
        self.didSelectChat = didSelectChat
        
        self.titleLabel.text = title
        
        self.chatButton.setImage(UIImage.getImage(withName: "ic_chat", imageColor: AppTheme.grayColor), for: .normal)
        
        if imageUrl == nil {
            
            userAvatarImageView.image = UIImage(named: "user_default")
            
        }
        else {
        
            userAvatarImageView.sd_setImage(with: imageUrl, placeholderImage: UIImage(named: "user_default"), options: .highPriority) { (image, error, cache, url) in
                
            }
        }
        
    }

    
    @IBAction func didMoreButtonPressed(_ sender: UIButton) {
        
    }
    
    @IBAction func didChatButtonPressed(_ sender: UIButton) {
        
        if self.didSelectChat != nil {
            
            self.didSelectChat!(sender)
        }
    }
    
    
//    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
//        let hitView = super.hitTest(point, with: event)
//        if (hitView != nil)
//        {
//            
//            if (hitView?.isKind(of: UIButton.self))! {
//                
//                let sender: UIButton = hitView as! UIButton
//                
//                sender.sendActions(for: .touchUpInside)
//                
//            }
//            else {
//                
//                self.superview?.bringSubview(toFront: self)
//            }
//        }
//        return hitView
//    }
    
    
}
