//
//  NavigationTitleView.swift
//  MarcoApp
//
//  Created by Nabeel Hayat on 23/11/2017.
//  Copyright © 2017 GrayScaleLogic. All rights reserved.
//

import UIKit
import SDWebImage

let height: CGFloat = 20.0;

protocol NavigationTitleViewDelegate {
    
    func didTapOnTitleView(_ titleView: NavigationTitleView)
}

class NavigationTitleView: UIView {

    var delegate: NavigationTitleViewDelegate!
    
    var titleLabel: UILabel!
    var detailLabel: UILabel!
    
    var avatarImageView: RoundedImageView!
    
    // MARK: - Lifecycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    init(frame: CGRect, title: String, detailTitle: String, avatarImageURL: URL? = nil, placehoderImage: UIImage? = nil) {
        super.init(frame: frame)
        
        self.setTitle(title: title, detailTitle: detailTitle, avatarImageURL: avatarImageURL, placehoderImage: placehoderImage)
    }
//
//    init(frame: CGRect, title: String, detailTitle: String, avatarImage: UIImage? = nil) {
//        super.init(frame: frame)
//
//        self.setTitle(title: title, detailTitle: detailTitle, avatarImage: avatarImage)
//    }
//
    
    @objc func didTapOnTitleView(_ gesture: UIGestureRecognizer) {
        
        if self.delegate != nil {
            
            self.delegate.didTapOnTitleView(self)
        }
    }
    
    private func setTitle(title: String, detailTitle: String, avatarImageURL: URL? = nil, placehoderImage: UIImage? = nil) {
        
    
        let tap:UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(didTapOnTitleView(_:)))
        
        self.addGestureRecognizer(tap)
    
        self.titleLabel = UILabel()
        
        self.titleLabel.font = AppTheme.boldFont(withSize: 14)
        
        let attributedString: NSAttributedString = NSAttributedString(string: title, attributes: AppTheme.navigationBarfontAttributes)
        
        self.titleLabel.attributedText = attributedString
        self.titleLabel.isUserInteractionEnabled = false
        self.titleLabel.backgroundColor = UIColor.clear
        self.titleLabel.textColor = AppTheme.whiteColor
        self.titleLabel.numberOfLines = 1
        self.titleLabel.minimumScaleFactor = 0.5
        self.titleLabel.adjustsFontSizeToFitWidth = true
        self.titleLabel.textAlignment = (avatarImageURL == nil) ? .center : .left
        self.titleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        self.addSubview(self.titleLabel)
        
        if detailTitle != "" {
            
            self.detailLabel = UILabel()
            
            let attributedDetailString: NSAttributedString = NSAttributedString(string: detailTitle, attributes: AppTheme.navigationBarDetailfontAttributes)
            
            self.detailLabel.font = AppTheme.semiBoldFont(withSize: 11)
            self.detailLabel.attributedText = attributedDetailString
            self.detailLabel.isUserInteractionEnabled = false
            self.detailLabel.backgroundColor = UIColor.clear
            self.detailLabel.textColor = AppTheme.grayColor
            self.detailLabel.numberOfLines = 1
            self.detailLabel.minimumScaleFactor = 0.5
            self.detailLabel.adjustsFontSizeToFitWidth = true
            self.detailLabel.textAlignment = (avatarImageURL == nil) ? .center : .left
            self.detailLabel.translatesAutoresizingMaskIntoConstraints = false
            
//            self.addSubview(self.detailLabel)
        }
        
        if avatarImageURL == nil && placehoderImage == nil {
        
            self.addConstraintForView()
        }
        else {
        
            self.avatarImageView = RoundedImageView(frame: CGRect(x: 0, y: 0, width: height, height: height))
         
            self.avatarImageView.isBorder = false
            self.avatarImageView.imageBorderWidth = 0.5;
            self.avatarImageView.imageBorderColor = UIColor(hexString: "#cccccc")
            self.avatarImageView.isBorder = true
            self.avatarImageView.contentMode = .scaleToFill
            self.avatarImageView.translatesAutoresizingMaskIntoConstraints = false
            
            if avatarImageURL != nil {
                
                self.avatarImageView.sd_setImage(with: avatarImageURL, placeholderImage: placehoderImage) { (image, error, imageCacheType, url) in
                    
                }
            }
            else {
                
                self.avatarImageView.image = placehoderImage
            }
            
            self.addSubview(self.avatarImageView)
            
            self.addConstraintForViewWithImageView()
        }
        
        
    }
    
    private func addConstraintForViewWithImageView() {
    
        // image view
        
        self.addConstraint(NSLayoutConstraint(item: self.avatarImageView, attribute: .leading, relatedBy: .equal, toItem: self, attribute: .leading, multiplier: 1.0, constant: 0.0))
        
        self.addConstraint(NSLayoutConstraint(item: self.avatarImageView, attribute: .centerY, relatedBy: .equal, toItem: self, attribute: .centerY, multiplier: 1.0, constant: 0.0))
        
        self.addConstraint(NSLayoutConstraint(item: self.avatarImageView, attribute: .width, relatedBy: .equal, toItem: self.avatarImageView, attribute: .height, multiplier: 1/1, constant: 0.0))
        
        self.addConstraint(NSLayoutConstraint(item: self.avatarImageView, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: height))
        
        // title label
        
        self.addConstraint(NSLayoutConstraint(item: self.titleLabel, attribute: .leading, relatedBy: .equal, toItem: self.avatarImageView, attribute: .trailing, multiplier: 1.0, constant: 8.0))
        
        self.addConstraint(NSLayoutConstraint(item: self.titleLabel, attribute: .trailing, relatedBy: .equal, toItem: self, attribute: .trailing, multiplier: 1.0, constant: 0.0))
        
        self.addConstraint(NSLayoutConstraint(item: self.titleLabel, attribute: .top, relatedBy: .equal, toItem: self, attribute: .top, multiplier: 1.0, constant: 0.0))
        
        self.addConstraint(NSLayoutConstraint(item: self.titleLabel, attribute: .bottom, relatedBy: .equal, toItem: self, attribute: .bottom, multiplier: 1.0, constant: 0.0))
        
//        self.addConstraint(NSLayoutConstraint(item: self.detailLabel, attribute: .top, relatedBy: .equal, toItem: self.titleLabel, attribute: .bottom, multiplier: 1.0, constant: 0.0))
        
        
        // detail label
        
//        self.addConstraint(NSLayoutConstraint(item: self.detailLabel, attribute: .leading, relatedBy: .equal, toItem: self.avatarImageView, attribute: .trailing, multiplier: 1.0, constant: 12.0))
//
//        self.addConstraint(NSLayoutConstraint(item: self.detailLabel, attribute: .trailing, relatedBy: .equal, toItem: self, attribute: .trailing, multiplier: 1.0, constant: 0.0))
    }
    
    private func addConstraintForView() {
    
        // title label
        
        self.addConstraint(NSLayoutConstraint(item: self.titleLabel, attribute: .leading, relatedBy: .equal, toItem: self, attribute: .leading, multiplier: 1.0, constant: 0.0))
        
        self.addConstraint(NSLayoutConstraint(item: self.titleLabel, attribute: .trailing, relatedBy: .equal, toItem: self, attribute: .trailing, multiplier: 1.0, constant: 0.0))
        
        self.addConstraint(NSLayoutConstraint(item: self.titleLabel, attribute: .top, relatedBy: .equal, toItem: self, attribute: .top, multiplier: 1.0, constant: 0.0))
        
        self.addConstraint(NSLayoutConstraint(item: self.titleLabel, attribute: .bottom, relatedBy: .equal, toItem: self, attribute: .bottom, multiplier: 1.0, constant: 0.0))
        
//        self.addConstraint(NSLayoutConstraint(item: self.detailLabel, attribute: .top, relatedBy: .equal, toItem: self.titleLabel, attribute: .bottom, multiplier: 1.0, constant: 0.0))
        
        
        // detail label
        
//        self.addConstraint(NSLayoutConstraint(item: self.detailLabel, attribute: .leading, relatedBy: .equal, toItem: self, attribute: .leading, multiplier: 1.0, constant: 0.0))
//
//        self.addConstraint(NSLayoutConstraint(item: self.detailLabel, attribute: .trailing, relatedBy: .equal, toItem: self, attribute: .trailing, multiplier: 1.0, constant: 0.0))
        
        //self.addConstraint(NSLayoutConstraint(item: self.detailLabel, attribute: .bottom, relatedBy: .equal, toItem: self, attribute: .bottom, multiplier: 1.0, constant: 0.0))
    }
    
    
}
