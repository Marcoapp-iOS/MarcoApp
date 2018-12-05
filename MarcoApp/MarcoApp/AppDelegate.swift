
//  AppDelegate.swift
//  MarcoApp
//
//  Created by Nabeel Hayat on 28/10/2017.
//  Copyright © 2017 GrayScaleLogic. All rights reserved.
//

import UIKit
import CoreData
import CoreLocation
import MagicalRecord
import GoogleMaps
import GooglePlaces
import FacebookCore
import FacebookLogin
import Firebase
import UserNotifications
import FirebaseDynamicLinks


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var clientPubNub: PubNub!
    
    var locationManager = CLLocationManager()

    var window: UIWindow?
    let loginManager: LoginManager = LoginManager(loginBehavior: .native, defaultAudience: .everyone)
    

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        // When User Id is available then init pubnub client
        if AppDefaults.getLoggedUserId() != "" {
            
            self.initPubNubClient()
        }
        
        
        FirebaseApp.configure()
        
        STPPaymentConfiguration.shared().publishableKey = AppConstants.kSTRIPE_TEST_PUBLISHABLE_KEY
        
        SDKApplicationDelegate.shared.application(application, didFinishLaunchingWithOptions: launchOptions)
        
//        Twitter.sharedInstance().start(withConsumerKey: AppConstants.kTWITTER_CONSUMER_KEY, consumerSecret: AppConstants.kTWITTER_CONSUMER_SECRET)
        
        GMSServices.provideAPIKey(AppConstants.kGOOGLE_API_KEY)
        GMSPlacesClient.provideAPIKey(AppConstants.kGOOGLE_API_KEY)
       
//        AppDefaults.setAppOpenFirstTime(true)
        
        self.window?.rootViewController = AppUI.getRootViewController()
        
        MagicalRecord.setupCoreDataStack(withStoreNamed: "MarcoApp")
        
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
        
        MagicalRecord.setupCoreDataStack(withStoreNamed: "MarcoApp")
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
        
        if AppDefaults.getLoggedUserId() != "" && AppDefaults.isAppLoggedIn(){
            
            self.checkLocationChanges()
        }
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        // Saves changes in the application's managed object context before the application terminates.
    }
    
    
    func application(_ application: UIApplication, continue userActivity: NSUserActivity,
                     restorationHandler: @escaping ([Any]?) -> Void) -> Bool {
        
        if let incomingURL = userActivity.webpageURL {
            let handleLink = DynamicLinks.dynamicLinks().handleUniversalLink(incomingURL, completion: { (dynamicLink, error) in
                if let dynamicLink = dynamicLink, let _ = dynamicLink.url
                {
                    self.handleDynamicLink(dynamicLink)
                    
                } else {
                    // Check for errors
                }
            })
            return handleLink
        }
        return false
    }
    
    func application(_ application: UIApplication, open url: URL, sourceApplication: String?, annotation: Any) -> Bool {
    
        if let dynamicLink = DynamicLinks.dynamicLinks().dynamicLink(fromCustomSchemeURL: url) {
            // Handle the deep link. For example, show the deep-linked content or
            // apply a promotional offer to the user's account.
            // ...
            
            print("Your Dynamic Link parameter: \(dynamicLink)")
            
            return true
        }
        
        
        
        let handled: Bool = SDKApplicationDelegate.shared.application(application, open: url, sourceApplication: sourceApplication, annotation: annotation)
        
        // Add any custom logic here.
        return handled;
        
    }
    
    @available(iOS 9.0, *)
    func application(_ app: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any] = [:]) -> Bool {
        
        return application(app, open: url,
                           sourceApplication: options[UIApplicationOpenURLOptionsKey.sourceApplication] as? String,
                           annotation: "")
        
        // First, handle Facebook URL open request
       
//        return Twitter.sharedInstance().application(app, open: url, options: options)
        
        print(url)
        
        let handled: Bool = SDKApplicationDelegate.shared.application(app, open: url, options: options)
        
        // Add any custom logic here.
        return handled;
        
//        return true
    }
    
    // MARK:- Notification
    
    func pushNotificationHandler(_ userInfo: Dictionary<AnyHashable,Any>, isPlaySound: Bool = true) {
        
        if UIApplication.shared.applicationState == UIApplication.State.active {
          
        }
        else if UIApplication.shared.applicationState == UIApplication.State.background || UIApplication.shared.applicationState == UIApplication.State.inactive {
         
            print("Inactive \(UIApplication.shared.applicationState.rawValue)")
            
            // Parse the aps payload
            let apsPayload = userInfo["aps"] as! [String: AnyObject]
            
            // Play custom push notification sound (if exists) by parsing out the "sound" key and playing the audio file specified
            // For example, if the incoming payload is: { "sound":"tarzanwut.aiff" } the app will look for the tarzanwut.aiff file in the app bundle and play it
            
            if isPlaySound {
                
                if let mySoundFile : String = apsPayload["sound"] as? String {
                    playSound(fileName: mySoundFile)
                }
            }
            else {
                
                let publisher = apsPayload["publisher"] as! String
                //            let date = apsPayload["Date"] as! String
                //
                //            let title: String = alertDictionary["title"] as! String
                //            let body: String = alertDictionary["body"] as! String
                
                
                if publisher != AppDefaults.getLoggedUserId() {
                    
                    // Open chat controller
                    
                    self.openChatController(publisher)
                }
            }
        }
        
        
    }
    
    // Play the specified audio file with extension
    func playSound(fileName: String) {
        var sound: SystemSoundID = 0
        if let soundURL = Bundle.main.url(forAuxiliaryExecutable: fileName) {
            AudioServicesCreateSystemSoundID(soundURL as CFURL, &sound)
            AudioServicesPlaySystemSound(sound)
        }
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        
        self.pushNotificationHandler(userInfo, isPlaySound: false)
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any]) {
        
        self.pushNotificationHandler(userInfo)
    }
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        
        // Sometimes it’s useful to store the device token in UserDefaults
        UserDefaults.standard.set(deviceToken, forKey: "DeviceToken")
    }
    
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        
        print("didFail! with error: \(error)")
    }
    
    // MARK:- Helper Functions
    
    func openChatController(_ publisher: String) {
        
        print(self.window?.rootViewController as Any)
        
        if (self.window?.rootViewController?.isKind(of: RootViewController.self))! {
            
            let rootViewController: RootViewController = self.window?.rootViewController as! RootViewController
            
            print(rootViewController)
            
            if (rootViewController.contentViewController.isKind(of: MainTabBarViewController.self)) {
                
                let mainTabBarViewController: MainTabBarViewController = rootViewController.contentViewController as! MainTabBarViewController
                
                
                if mainTabBarViewController.selectedIndex == 3 {
                    
                    NotificationCenter.default.post(name: NSNotification.Name.DidOpenChatNotification, object: publisher)
                }
                else {
                
                    mainTabBarViewController.selectedIndex = 3;
                    
                    AppDefaults.setOpenChatPublisher(publisher)
                }
                
                
//                let groupDetailViewController: GroupDetailViewController = AppUI.mainStoryboard.instantiateViewController(withIdentifier: "GroupDetailViewController") as! GroupDetailViewController
//
//                let group: GroupObject = GroupObject()
//
//                group.groupId = groupId
//
//                groupDetailViewController.group = group
//                groupDetailViewController.isDeeplinking = true
//
//                let navController: BaseNavigationController = BaseNavigationController(navigationBarClass: BaseNavigationBar.self, toolbarClass: nil)
//
//                navController.setViewControllers([groupDetailViewController], animated: true)
//
//                let transition: CATransition = CATransition()
//                transition.duration = 0.3
//                transition.type = kCATransitionPush
//                transition.subtype = kCATransitionFromRight
//                self.window?.layer.add(transition, forKey: kCATransition)
//
//                mainTabBarViewController.selectedViewController!.present(navController, animated: true, completion: nil)
//
//                //            self.navigationController?.pushViewController(groupDetailViewController, animated: true)
            }
        }
        else if (self.window?.rootViewController?.isKind(of: LandingViewController.self))! {
            
            
        }
    }
    
    func checkLocationChanges() {
        
        self.checkLocationAuthorizationStatus()
        
        self.locationManager = CLLocationManager()
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
        self.locationManager.requestWhenInUseAuthorization()
        self.locationManager.distanceFilter = 1000
        self.locationManager.startUpdatingLocation()
        self.locationManager.delegate = self
        
//        Locator.requestAuthorizationIfNeeded(.always)
//        //
//        //        Locator.currentPosition(accuracy: .block, onSuccess: { (currentLocation) -> (Void) in
//        //
//        //            print(currentLocation.coordinate.latitude)
//        //            print(currentLocation.coordinate.longitude)
//        //
//        //        }) { (locationError, location) -> (Void) in
//        //
//        //
//        //        }
//        //
//        //        Locator.subscribeSignificantLocations(onUpdate: { newLocation in
//        //            print("New location \(newLocation)")
//        //        }) { (err, lastLocation) -> (Void) in
//        //            print("Failed with err: \(err)")
//        //        }
//        //
//        Locator.subscribePosition(accuracy: .city, onUpdate: { (location) -> (Void) in
//            print("New location received: \(location)")
//            
//            Locator.currentLocation?.coordinate.latitude != location.coordinate.latitude
//            
//            self.sendRequestForUpdateLocation(location)
//            
//        }) { (error, last) -> (Void) in
//            print("Failed with error: \(error)")
//        }
        
    }
    
    fileprivate func sendRequestForUpdateLocation(_ location: CLLocation) {
        
        let parameters: [String : Any] = ["Latitude":location.coordinate.latitude,
                                          "Longitude":location.coordinate.longitude]
        
        ApiServices.shared.requestForUpdateLocation(onTarget: self, parameters, successfull: { (success) in
            
            
            
        }) { (failure) in
            
            
        }
    }
    
    func initPubNubClient() {
       
        let configuration: PNConfiguration = PNConfiguration(publishKey: AppConstants.kPUBNUB_PUBLISH_KEY, subscribeKey: AppConstants.kPUBNUB_SUBSCRIBE_KEY)
        
        configuration.authKey = "MARCO_AUTH_KEY_2018"
        configuration.TLSEnabled = true
        configuration.uuid = AppDefaults.getLoggedUserId() //NSUUID().uuidString.lowercased()
        
        
        self.clientPubNub = PubNub.clientWithConfiguration(configuration)
        
        // filter
        let filterExpStr = "uuid != '\(self.clientPubNub.currentConfiguration().uuid)'"
        
        self.clientPubNub.filterExpression = filterExpStr
        
        // Configure logger
        self.clientPubNub.logger.enabled = true
        self.clientPubNub.logger.writeToFile = true
        self.clientPubNub.logger.maximumLogFileSize = (10 * 1024 * 1024);
        self.clientPubNub.logger.maximumNumberOfLogFiles = 10;
        self.clientPubNub.logger.setLogLevel(PNLogLevel.PNVerboseLogLevel.rawValue)
        
        /**
         Subscription process results arrive to listener which should adopt to PNObjectEventListener protocol
         and registered using:
         */
        self.clientPubNub.addListener(self)
        
        // subscribe to personal channel
        
        self.clientPubNub.subscribeToChannels([AppDefaults.getLoggedUserId()], withPresence: true)
        
        
        //        self.clientPubNub.subscribeToChannels(["my_channel2"], withPresence: true)
        
        //        self.clientPubNub.publish("Hello from the PubNub Swift SDK", toChannel: "my_channel1", compressed: false) { (status) in
        //
        //            if !status.isError {
        //
        //                print(status.data.information)
        //            }
        //            else {
        //
        //                print(status.errorData.information)
        //            }
        //        }
        
        //        print(self.clientPubNub.channels())
    }
    
    func handleDynamicLink(_ dynamicLink: DynamicLink) {
        print("Your Dynamic Link parameter: \(dynamicLink)")
        
        let url: URL = dynamicLink.url!
        
        let urlString: String = url.absoluteString
        
        //https://marcotest.azurewebsites.net/api/Groups/159
        // api/Groups/{groupId}
        
        let urlScheme: String = urlString.replacingOccurrences(of: "https://marcotest.azurewebsites.net/api/", with: "")
        
        let components: [String] = urlScheme.components(separatedBy: "/")
        
        if components.count >= 2 {
            
            let scheme: String = components[0]
            let itemId: String = components[1]
            
            if components.count == 3 {
                
                let lastComponent: String = components[2]
                
                if lastComponent == "" || lastComponent == " " {
                    
                    
                }
                else {
                    
                    
                }
            }
            
            if scheme == "Groups" {
                
                self.populateJoinGroupController(itemId)
            }
        }
        
    }
    
    private func populateJoinGroupController(_ itemId: String) {
        
        let groupId: Int = itemId.intValue
        
        print(self.window?.rootViewController as Any)
        
        if (self.window?.rootViewController?.isKind(of: RootViewController.self))! {
            
            let rootViewController: RootViewController = self.window?.rootViewController as! RootViewController
            
            print(rootViewController)
            
            if (rootViewController.contentViewController.isKind(of: MainTabBarViewController.self)) {
            
                let mainTabBarViewController: MainTabBarViewController = rootViewController.contentViewController as! MainTabBarViewController
                
                let groupDetailViewController: GroupDetailViewController = AppUI.mainStoryboard.instantiateViewController(withIdentifier: "GroupDetailViewController") as! GroupDetailViewController
                
                let group: GroupObject = GroupObject()
                
                group.groupId = groupId
                
                groupDetailViewController.group = group
                groupDetailViewController.isDeeplinking = true
                
                let navController: BaseNavigationController = BaseNavigationController(navigationBarClass: BaseNavigationBar.self, toolbarClass: nil)
                
                navController.setViewControllers([groupDetailViewController], animated: true)
                
                let transition: CATransition = CATransition()
                transition.duration = 0.3
                transition.type = kCATransitionPush
                transition.subtype = kCATransitionFromRight
                self.window?.layer.add(transition, forKey: kCATransition)
                
                mainTabBarViewController.selectedViewController!.present(navController, animated: true, completion: nil)
                
                //            self.navigationController?.pushViewController(groupDetailViewController, animated: true)
            }
        }
        else if (self.window?.rootViewController?.isKind(of: LandingViewController.self))! {
            
            AppDefaults.setDLJoinGroupId(itemId)
        }
    }
    
    func registerNotification() {
        
        // First we must determine your iOS type:
        // Note this will only work for iOS 8 and up, if you require iOS 7 notifications then
        // contact support@pubnub.com with your request
        if #available(iOS 10, *) {
            UNUserNotificationCenter.current().getNotificationSettings { (settings) in
                switch settings.authorizationStatus {
                case .notDetermined:
                    UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge], completionHandler: { (granted, error) in
                        // You might want to remove this, or handle errors differently in production
                        assert(error == nil)
                        if granted {
                            UIApplication.shared.registerForRemoteNotifications()
                        }
                    })
                case .authorized:
                    UIApplication.shared.registerForRemoteNotifications()
                case .denied:
                    let useNotificationsAlertController = UIAlertController(title: "Turn on notifications", message: "This app needs notifications turned on for the best user experience", preferredStyle: .alert)
                    let goToSettingsAction = UIAlertAction(title: "Go to settings", style: .default, handler: { (action) in
                        
                    })
                    let cancelAction = UIAlertAction(title: "Cancel", style: .default)
                    useNotificationsAlertController.addAction(goToSettingsAction)
                    useNotificationsAlertController.addAction(cancelAction)
                    self.window?.rootViewController?.present(useNotificationsAlertController, animated: true)
                case .provisional:
                    // The application is authorized to post non-interruptive user notifications.
                    break
                }
            }
        } else if #available(iOS 8, *) {
            let settings = UIUserNotificationSettings(types: [.badge, .sound, .alert], categories: nil)
            UIApplication.shared.registerUserNotificationSettings(settings)
        } else {
            print("We cannot handle iOS 7 or lower in this example. Contact support@pubnub.com")
        }
        
    }
}

extension AppDelegate: CLLocationManagerDelegate {
    
    // MARK: - CLLocationManager
    
    func checkLocationAuthorizationStatus() {
        if CLLocationManager.authorizationStatus() == .authorizedAlways {
        } else {
            self.locationManager.requestAlwaysAuthorization()
        }
    }
    
    // MARK: - CLLocationManagerDelegate
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        if let location = locations.first {
            
            let initialLocation = CLLocation(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
//            self.centerMapOnLocation(location: initialLocation)
            
            self.sendRequestForUpdateLocation(initialLocation)
            
        }
    }
    
    // Handle authorization for the location manager.
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .restricted:
            print("Location access was restricted.")
        case .denied:
            print("User denied access to location.")
            // Display the map using the default location.
//            mapView.isHidden = false
            self.locationManager.requestAlwaysAuthorization()
        case .notDetermined:
            print("Location status not determined.")
        case .authorizedAlways: fallthrough
        case .authorizedWhenInUse:
            print("Location status is OK.")
            
//            mapView.showsUserLocation = true
        }
    }
    
    // Handle location manager errors.
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        locationManager.stopUpdatingLocation()
        print("Error: \(error)")
    }
}

extension AppDelegate: PNObjectEventListener {
    
    // Handle subscription status change.
    func client(_ client: PubNub, didReceive status: PNStatus) {
        
        if status.operation == .subscribeOperation {

            // Check whether received information about successful subscription or restore.
            if status.category == .PNConnectedCategory || status.category == .PNReconnectedCategory {

                let subscribeStatus: PNSubscribeStatus = status as! PNSubscribeStatus
                if subscribeStatus.category == .PNConnectedCategory {

                    // This is expected for a subscribe, this means there is no error or issue whatsoever.

                }
                else {
                    
                    self.window?.rootViewController?.hidePKHUD()

                    /**
                     This usually occurs if subscribe temporarily fails but reconnects. This means there was
                     an error but there is no longer any issue.
                     */
                }
            }
            else if status.category == .PNUnexpectedDisconnectCategory {

                /**
                 This is usually an issue with the internet connection, this is an error, handle
                 appropriately retry will be called automatically.
                 */
            }
                // Looks like some kind of issues happened while client tried to subscribe or disconnected from
                // network.
            else {

                let errorStatus: PNErrorStatus = status as! PNErrorStatus
                if errorStatus.category == .PNAccessDeniedCategory {

                    /**
                     This means that PAM does allow this client to subscribe to this channel and channel group
                     configuration. This is another explicit error.
                     */
                }
                else {

                    /**
                     More errors can be directly specified by creating explicit cases for other error categories
                     of `PNStatusCategory` such as: `PNDecryptionErrorCategory`,
                     `PNMalformedFilterExpressionCategory`, `PNMalformedResponseCategory`, `PNTimeoutCategory`
                     or `PNNetworkIssuesCategory`
                     */
                }
            }
        }
    }
    
    
    // Handle new message from one of channels on which client has been subscribed.
    func client(_ client: PubNub, didReceiveMessage message: PNMessageResult) {
        // Reference to channel group to which belong chat where message has been sent.
        let subscription = message.data.subscription
        print("\(message.data.publisher) sent message to '\(message.data.channel)' at \(message.data.timetoken): \(message.data.message ?? "")")
        print(subscription!)
        
        if message.data.channel == AppDefaults.getLoggedUserId() {
            
            let messageDict: [String : String] = (message.data.message as? [String : String])!
            
            
            let messageStr: String = messageDict["text"]!
            
            if messageStr == "subscribe" {
                
                let channel: String = messageDict["channel"]!
                
                self.clientPubNub.subscribeToChannels([channel], withPresence: true)
            }
        }
        else {
            
            NotificationCenter.default.post(name: NSNotification.Name.DidReceiveMessageNotification, object: message.data.message)
        }
    }
    
    func client(_ client: PubNub, didReceivePresenceEvent event: PNPresenceEventResult) {
        
        if event.data.channel == event.data.subscription {
            
            // Presence event has been received on channel group stored in event.data.subscription.
        }
        else {
            
            // Presence event has been received on channel stored in event.data.channel.
        }
        
        if event.data.presenceEvent == "state-change" {
            
            print("UUID: \(event.data.presence.uuid ?? "") Event: \(event.data.presenceEvent) TimeToken: \(event.data.presence.timetoken) Channel: \(event.data.channel) Occupancy: \(event.data.presence.occupancy)")
        }
        else if event.data.presenceEvent == "join" {
         
//            NotificationCenter.default.post(name: NSNotification.Name.DidSubscribeUserNotification, object: event.data.channel)
        }
        else {
            
            print("UUID: \(event.data.presence.uuid ?? "") TimeToken: \(event.data.presence.timetoken) Channel: \(event.data.channel) State: \(event.data.presence.state)")
            
        }
    }
    
    // MARK:- PUBNUB Notification
    
    func pubNubAddPushNotifications(_ channels: [String], completion: @escaping PNPushNotificationsStateModificationCompletionBlock) {
        
        guard let deviceToken: Data = UserDefaults.standard.value(forKey: "DeviceToken") as? Data else {
            
            return
        }
        
        self.clientPubNub.addPushNotificationsOnChannels(channels, withDevicePushToken: deviceToken, andCompletion: completion)
    }
    
    func pubNubRemovePushNotification(_ channels: [String], completion: @escaping PNPushNotificationsStateModificationCompletionBlock) {
        
        guard let deviceToken: Data = UserDefaults.standard.value(forKey: "DeviceToken") as? Data else {
            
            return
        }
        
        self.clientPubNub.removePushNotificationsFromChannels(channels, withDevicePushToken: deviceToken, andCompletion: completion)
    }
    
    func pubNubRemoveAllPushNotifications(_ completion: @escaping PNPushNotificationsStateModificationCompletionBlock) {
        
        guard let deviceToken: Data = UserDefaults.standard.value(forKey: "DeviceToken") as? Data else {
            
            return
        }
        
        self.clientPubNub.removeAllPushNotificationsFromDeviceWithPushToken(deviceToken, andCompletion: completion)
    }
    
    func pubNubGetAllPushNotifications(_ completion: @escaping PNPushNotificationsStateAuditCompletionBlock) {
        
        guard let deviceToken: Data = UserDefaults.standard.value(forKey: "DeviceToken") as? Data else {
            
            return
        }
        
        self.clientPubNub.pushNotificationEnabledChannelsForDeviceWithPushToken(deviceToken, andCompletion: completion)
    }
}
