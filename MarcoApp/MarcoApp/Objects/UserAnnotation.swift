//
//  UserAnnotation.swift
//  MarcoApp
//
//  Created by Nabeel Hayat on 08/11/2018.
//  Copyright © 2018 GrayScaleLogic. All rights reserved.
//

import UIKit
import MapKit

class UserAnnotation: NSObject, MKAnnotation {

    let title: String?
    let locationName: String
    let discipline: String
    let coordinate: CLLocationCoordinate2D
    
    let userProfile: UserProfile!
    let index: Int!
    
//    init(title: String, locationName: String, discipline: String, coordinate: CLLocationCoordinate2D) {
//        self.title = title
//        self.locationName = locationName
//        self.discipline = discipline
//        self.coordinate = coordinate
//
//        super.init()
//    }
    
    init(userProfile: UserProfile, at index: Int) {
        
        self.title = userProfile.fullName
        self.locationName = (userProfile.locationAddress != nil) ? userProfile.locationAddress : ""
        let userProfilePicture: String = (userProfile.profilePicture == nil || userProfile.profilePicture == "") ? "" : userProfile.profilePicture
        
        self.discipline = userProfilePicture
        self.coordinate = CLLocationCoordinate2D(latitude: userProfile.location.lat, longitude: userProfile.location.lon)
        
        self.userProfile = userProfile
        self.index = index
        
        super.init()
    }
    
    var subtitle: String? {
        return locationName
    }
    
    // pinTintColor for disciplines: Sculpture, Plaque, Mural, Monument, other
    var markerTintColor: UIColor  {
        switch discipline {
        case "Monument":
            return .red
        case "Mural":
            return .cyan
        case "Plaque":
            return .blue
        case "Sculpture":
            return .purple
        default:
            return .clear
        }
    }
    
    var imageName: String? {
        if discipline == "" { return "map_marker" }
        return "map_marker"
    }
    
    // Annotation right callout accessory opens this mapItem in Maps app
    func mapItem() -> MKMapItem {
        let addressDict = [CNPostalAddressStreetKey: subtitle!]
        let placemark = MKPlacemark(coordinate: coordinate, addressDictionary: addressDict)
        let mapItem = MKMapItem(placemark: placemark)
        mapItem.name = title
        return mapItem
    }
}
