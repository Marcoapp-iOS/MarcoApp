//
//  UserAnnotationViews.swift
//  MarcoApp
//
//  Created by Nabeel Hayat on 08/11/2018.
//  Copyright © 2018 GrayScaleLogic. All rights reserved.
//

import UIKit
import MapKit
import SDWebImage

@available(iOS 11.0, *)
class UserMarkerView: MKMarkerAnnotationView {
    
    override var annotation: MKAnnotation? {
        willSet {
            guard let artwork = newValue as? UserAnnotation else { return }
            canShowCallout = true
            calloutOffset = CGPoint(x: -5, y: 5)
            rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
            
//            markerTintColor = artwork.markerTintColor
//            glyphText = String(artwork.title!.first!)
            if let imageName = artwork.imageName {
                glyphImage = UIImage(named: imageName)
            } else {
                glyphImage = nil
            }
        }
    }
}

class UserAnnotationView: MKAnnotationView {
    
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        let hitView = super.hitTest(point, with: event)
        if (hitView != nil)
        {
            
            if (hitView?.isKind(of: UIButton.self))! {
               
                let sender: UIButton = hitView as! UIButton
                
                sender.sendActions(for: .touchUpInside)
                
            }
            else {
            
                self.superview?.bringSubview(toFront: self)
            }
        }
        return hitView
    }
    override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        let rect = self.bounds
        var isInside: Bool = rect.contains(point)
        if(!isInside)
        {
            for view in self.subviews
            {
                isInside = view.frame.contains(point)
                if isInside
                {
                    break
                }
            }
        }
        return isInside
    }

    override var annotation: MKAnnotation? {
        willSet {
            guard let artwork = newValue as? UserAnnotation else {return}
            
            canShowCallout = false
//            calloutOffset = CGPoint(x: -5, y: 5)
//            let mapsButton = UIButton(frame: CGRect(origin: CGPoint.zero,
//                                                    size: CGSize(width: 30, height: 30)))
////            mapsButton.setBackgroundImage(UIImage(named: "user_default"), for: UIControlState())
//            rightCalloutAccessoryView = mapsButton
            //      rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
            
            if let imageName = artwork.imageName {
                image = UIImage(named: imageName)
            } else {
                image = nil
            }
            
//            let detailLabel = UILabel()
//            detailLabel.numberOfLines = 0
//            detailLabel.font = detailLabel.font.withSize(12)
//            detailLabel.text = artwork.subtitle
//            detailCalloutAccessoryView = detailLabel
        }
    }
}
