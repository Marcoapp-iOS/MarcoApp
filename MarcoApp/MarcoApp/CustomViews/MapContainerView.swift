//
//  MapContainerView.swift
//  MarcoApp
//
//  Created by Nabeel Hayat on 01/12/2017.
//  Copyright © 2017 GrayScaleLogic. All rights reserved.
//

import UIKit
import MapKit
//import GoogleMaps
//import GooglePlaces
import CoreLocation

let widthHeight: CGFloat = 56.0

class MapContainerView: UIView {

    // MARK: - Variables
    
    var locationManager = CLLocationManager()
    var currentLocation: CLLocation?
//    var mapView: GMSMapView!
    let regionRadius: CLLocationDistance = 1000
    var mapView: MKMapView!
    var myLocationButton: UIButton!
    
    var groupUsers: [UserProfile]? = nil {
        
        didSet {
            
            
        }
    }
    
    private var userAnnotationList: [UserAnnotation] = []
    
    // MARK: - Lifecycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        self.setupMapView()
    }
    
    // MARK: - Helper Functions
    
    private func setupMapView() {
    
        if TARGET_OS_SIMULATOR != 0 {
            
        }
        else {
            
            self.mapView = MKMapView(frame: CGRect(x: 0, y: 0, width: self.frame.size.width, height: self.frame.size.height))
            
            self.mapView.translatesAutoresizingMaskIntoConstraints = false
            
            self.myLocationButton = UIButton(type: .custom)
            self.myLocationButton.frame = CGRect(x: 0, y: 0, width: widthHeight, height: widthHeight)
            self.myLocationButton.setImage(UIImage(named: "ic_direction_btn"), for: .normal)
            self.myLocationButton.translatesAutoresizingMaskIntoConstraints = false
            
            self.myLocationButton.addTarget(self, action: #selector(didMyLocationButtonPressed(_:)), for: .touchUpInside)
        
            self.addSubview(self.mapView)
            self.addSubview(self.myLocationButton)
            
            self.setupConstraintsForView()
            
            self.configureMapView()
            
            self.setupMapLayout()
        }
        
    }
    
    private func setupConstraintsForView() {
    
        // Map View
        
        self.addConstraint(NSLayoutConstraint(item: self.mapView, attribute: .leading, relatedBy: .equal, toItem: self, attribute: .leading, multiplier: 1.0, constant: 0.0))
        
        self.addConstraint(NSLayoutConstraint(item: self.mapView, attribute: .trailing, relatedBy: .equal, toItem: self, attribute: .trailing, multiplier: 1.0, constant: 0.0))
        
        self.addConstraint(NSLayoutConstraint(item: self.mapView, attribute: .top, relatedBy: .equal, toItem: self, attribute: .top, multiplier: 1.0, constant: 0.0))
        
        self.addConstraint(NSLayoutConstraint(item: self.mapView, attribute: .bottom, relatedBy: .equal, toItem: self, attribute: .bottom, multiplier: 1.0, constant: 0.0))
        
        // Location Button
        
        self.addConstraint(NSLayoutConstraint(item: self.myLocationButton, attribute: .bottom, relatedBy: .equal, toItem: self, attribute: .bottom, multiplier: 1.0, constant: -30.0))
        
        self.addConstraint(NSLayoutConstraint(item: self.myLocationButton, attribute: .width, relatedBy: .equal, toItem: self.myLocationButton, attribute: .height, multiplier: 1.0/1.0, constant: 0.0))
        
        self.addConstraint(NSLayoutConstraint(item: self.myLocationButton, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: widthHeight))
        
        self.addConstraint(NSLayoutConstraint(item: self.myLocationButton, attribute: .centerX, relatedBy: .equal, toItem: self, attribute: .centerX, multiplier: 1.0, constant: 0.0))
    }
    
    private func setupMapLayout() {
        
        let initialLocation = CLLocation(latitude: 21.282778, longitude: -157.829444)
        centerMapOnLocation(location: initialLocation)
        
        self.mapView.delegate = self
        //    mapView.register(ArtworkMarkerView.self, forAnnotationViewWithReuseIdentifier: MKMapViewDefaultAnnotationViewReuseIdentifier)
        if #available(iOS 11.0, *) {
            self.mapView.register(UserAnnotationView.self, forAnnotationViewWithReuseIdentifier: MKMapViewDefaultAnnotationViewReuseIdentifier)
        } else {
            // Fallback on earlier versions
        }
//        self.loadInitialData()
        self.mapView.addAnnotations(self.userAnnotationList)
    }
    
//    private func loadInitialData() {
//
//        // 1
//        guard let fileName = Bundle.main.path(forResource: "PublicArt", ofType: "json")
//            else { return }
//        let optionalData = try? Data(contentsOf: URL(fileURLWithPath: fileName))
//
//        guard
//            let data = optionalData,
//            // 2
//            let json = try? JSONSerialization.jsonObject(with: data),
//            // 3
//            let dictionary = json as? [String: Any],
//            // 4
//            let works = dictionary["data"] as? [[Any]]
//            else { return }
//        // 5
//        let validWorks = works.flatMap { UserAnnotation(userProfile: $0, at: <#Int#>) }
//        userAnnotationList.append(contentsOf: validWorks)
//
//
////        for userProfile: UserProfile in self.groupUsers! {
////
////            let userAnnotation: UserAnnotation = UserAnnotation(title: userProfile.firstName, locationName: "", discipline: "", coordinate: CLLocationCoordinate2DMake(userProfile.location.lat, userProfile.location.lon))
////
////            self.userAnnotationList.append(userAnnotation)
////        }
//    }
    
    func centerMapOnLocation(location: CLLocation) {
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(location.coordinate,
                                                                  regionRadius, regionRadius)
        self.mapView.setRegion(coordinateRegion, animated: true)
    }

    private func configureMapView() {

        self.locationManager = CLLocationManager()
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
        self.locationManager.requestWhenInUseAuthorization()
        self.locationManager.distanceFilter = 50
        self.locationManager.startUpdatingLocation()
        self.locationManager.delegate = self
    }
    
    @objc func didMyLocationButtonPressed(_ sender: UIButton) {
    
    }
}

extension MapContainerView : CLLocationManagerDelegate {
    
    // MARK: - CLLocationManagerDelegate
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        if let location = locations.first {
            
            let initialLocation = CLLocation(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
            self.centerMapOnLocation(location: initialLocation)
            
//            let camera = GMSCameraPosition(target: location.coordinate, zoom: 15, bearing: 0, viewingAngle: 0)
//
//            mapView.isMyLocationEnabled = true
//
//            if mapView.isHidden {
//                mapView.isHidden = false
//                mapView.camera = camera
//            } else {
//                mapView.animate(to: camera)
//            }
            
        }
        /*
         if let location = locations.first {
         self.myLocation = location
         Utitlity.sharedInstance.user_current_location = location
         locationManager.stopUpdatingLocation()
         
         mapView.camera = GMSCameraPosition(target: location.coordinate, zoom: 15, bearing: 0, viewingAngle: 0)
         
         
         mapView.isMyLocationEnabled = true
         //Load Events from server against user location
         if didFindLocation == false {
         didFindLocation = true
         
         if UserDefaults.standard.bool(forKey: "isUserLoging") == false {
         //   getAllPublicEventFromServer()
         }else{
         //    self.getPublicEventsFromServer()
         }
         }
         }
         */
    }
    
    // Handle authorization for the location manager.
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .restricted:
            print("Location access was restricted.")
        case .denied:
            print("User denied access to location.")
            // Display the map using the default location.
            mapView.isHidden = false
            locationManager.requestAlwaysAuthorization()
        case .notDetermined:
            print("Location status not determined.")
        case .authorizedAlways: fallthrough
        case .authorizedWhenInUse:
            print("Location status is OK.")
            
            mapView.showsUserLocation = true
        }
    }
    
    // Handle location manager errors.
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        locationManager.stopUpdatingLocation()
        print("Error: \(error)")
    }
}

// MARK: - MKMapViewDelegate

extension MapContainerView: MKMapViewDelegate {
    
    //   1
    //  func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
    //    guard let annotation = annotation as? Artwork else { return nil }
    //    // 2
    //    let identifier = "marker"
    //    var view: MKMarkerAnnotationView
    //    if let dequeuedView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier)
    //      as? MKMarkerAnnotationView { // 3
    //      dequeuedView.annotation = annotation
    //      view = dequeuedView
    //    } else {
    //      // 4
    //      view = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: identifier)
    //      view.canShowCallout = true
    //      view.calloutOffset = CGPoint(x: -5, y: 5)
    //      view.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
    //    }
    //    return view
    //  }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView,
                 calloutAccessoryControlTapped control: UIControl) {
        let location = view.annotation as! UserAnnotation
        let launchOptions = [MKLaunchOptionsDirectionsModeKey:
            MKLaunchOptionsDirectionsModeDriving]
        location.mapItem().openInMaps(launchOptions: launchOptions)
    }
}

// MARK: - GMSMapViewDelegate
//extension MapContainerView : GMSMapViewDelegate {
//
//    func mapView(_ mapView: GMSMapView, didTapAt coordinate: CLLocationCoordinate2D) {
//
//        print("You tapped at \(coordinate.latitude), \(coordinate.longitude)")
//
//    }
//
//    func mapView(_ mapView: GMSMapView, didTap marker: GMSMarker) -> Bool {
//
//        /*let appDelegate = UIApplication.shared.delegate as! AppDelegate
//
//         let event_Id: String = marker.userData as! String
//
//         print("You tapped \(marker.title ?? ""), \n at \(marker.position.latitude), \(marker.position.latitude)")
//
//         print("Event ID: \(event_Id)")
//
//         let eventDetailViewController: UINavigationController = Utitlity.getEventDetailViewController(WithEventID: String(event_Id))
//
//         let navigationVC: UINavigationController = appDelegate.window?.rootViewController as! UINavigationController
//
//         navigationVC.present(eventDetailViewController, animated: true, completion: nil)*/
//
//        return true;
//    }
//
//    //    func mapView(_ mapView: GMSMapView, markerInfoWindow marker: GMSMarker) -> UIView? {
//    //
//    //        let infoView = UIView()
//    //        infoView.frame = CGRect(x: 0, y: 0, width: 90, height: 90) //CGRectMake(0, 0, 90, 90);
//    //        // Setting the bg as red just to illustrate
//    //        infoView.backgroundColor = constants.getThemeTextColor()
//    //        return infoView;
//    //    }
//
//}
