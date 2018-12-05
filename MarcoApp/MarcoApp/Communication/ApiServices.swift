//
//  ApiServices.swift
//  MarcoApp
//
//  Created by Nabeel Hayat on 10/01/2018.
//  Copyright © 2018 GrayScaleLogic. All rights reserved.
//

import UIKit
import Alamofire
import MagicalRecord
import CoreData
import ObjectMapper

final class ApiServices: NSObject {
    
    var reachabilityManager = NetworkReachabilityManager()
    
    // MARK: - Singleton Instance
    static let shared = ApiServices()
    
    private override init() {
        super.init()
        
        self.startMonitoring()
        
        Alamofire.SessionManager.default.session.configuration.timeoutIntervalForRequest = 30
    }
    
    // MARK: - Helper Functions
    
    func startMonitoring() {
        
        reachabilityManager?.listener = { status in
            print("Network Status Changed: \(status)")
            
            switch status {
            case .notReachable:
                
                break
                
            case .unknown, .reachable(.ethernetOrWiFi), .reachable(.wwan):
                break
                
            }
        }
        
        reachabilityManager?.startListening()
    }
    
    
    func isCheckReachable() -> Bool {
        
        return (reachabilityManager?.isReachable)!
    }
    
    private func getRequestHeader() -> HTTPHeaders {

        print(#function)
        
//        let loginUserEntity: LoginUserEntity = LoginUserEntity.mr_findFirst(in: .mr_default())!
//
//        let loginUser: LoginUser = LoginUser(object: loginUserEntity)

        let loginUser: LoginUser = AppFunctions.getLoginUser()
        
        let value = loginUser.tokenType + " " + loginUser.accessToken
        
        print("Token: \(value)")
        
        let headers: [String: String] = ["Authorization":value]
        
        return headers
    }
    
    // MARK: - Api Services
    
    
    
    // MARK: - Profile
    
    func requestForSaveMyProfile(onTarget: AnyObject!, _ parameters: [String : Any], successfull:@escaping (_ isSuccess: Bool)->(), failure:@escaping (_ isFailure: Bool)->()) {
        
        if self.isCheckReachable() {
            
            
            let headers: HTTPHeaders = self.getRequestHeader();
            
            print(parameters)
            
            Alamofire.request(AppConstants.kUserProfiles, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers).responseString(completionHandler: { (response) in
                
                if response.result.isSuccess {
                    
                    print(response.result.value!)
                    
                    successfull(true)
                }
                
                if response.result.isFailure {
                    print("response: \(response.error ?? "" as! Error)")
                    
                    failure(false)
                }
                
            })
        }
        else {
            
            //            CommonsUI.showAlertForInternetConnection(onTarget, okayAction: {
            //
            //            })
        }
    }
    
    func requestForMyProfile(onTarget: AnyObject!, successfull:@escaping (_ isSuccess: Bool, _ isProfileFound: Bool)->(), failure:@escaping (_ isFailure: Bool)->()) {
        
        if self.isCheckReachable() {
            
            
            let headers: HTTPHeaders = self.getRequestHeader();
            
            Alamofire.request(AppConstants.kUserProfiles + "/me", method: .get, parameters: nil, encoding: JSONEncoding.default, headers: headers).responseString(completionHandler: { (response) in
                
                if response.result.isSuccess {
                    
                    print(response.result.value!)
                    
                    let messageObjectMapper = Mapper<MessageObjectMapper>().map(JSONString: response.result.value!)
                    
                    if messageObjectMapper != nil {
                        
                        if messageObjectMapper?.message == "User profile not found" {
                         
                            successfull(true, false)
                        }
                        else {
                            
                            self.handleLoginResponse(response: response, successfull: { (success, isProfileFound) in
                                
                                successfull(success, isProfileFound)
                            })
                        }
                    }
                    else {
                        
                        self.handleLoginResponse(response: response, successfull: { (success, isProfileFound) in
                            
                            successfull(success, isProfileFound)
                        })
                    }
                    
                    
//                    if let message = response.result.value as! [String: Any] {
//
//
//                    }
//
//                    if response.result.value!["Message"] == "User profile not found" {
//
//                        successfull(true, true)
//                    }
//                    else {
//
//
//                    }
                }
                
                if response.result.isFailure {
                    print("response: \(response.error ?? "" as! Error)")
                    
                    failure(false)
                }
                
            })
        }
        else {
            
            //            CommonsUI.showAlertForInternetConnection(onTarget, okayAction: {
            //
            //            })
        }
        
    }
    
    func requestForUserProfile(onTarget: AnyObject!, _ userId: String, successfull:@escaping (_ isSuccess: Bool, _ userProfile: UserProfile)->(), failure:@escaping (_ isFailure: Bool, _ errorMessage: String)->()) {
        
        if self.isCheckReachable() {
            
            
            let headers: HTTPHeaders = self.getRequestHeader();
            
            let urlString: String = AppConstants.kUserProfiles + "/\(userId)"
            
            Alamofire.request(urlString, method: .get, parameters: nil, encoding: URLEncoding.default, headers: headers).responseString(completionHandler: { (response) in
                
                if response.result.isSuccess {
                    
                    print(response.result.value!)
                    
                    
                    let userProfileMapper: UserProfileMapper = Mapper<UserProfileMapper>().map(JSONString: response.result.value!)!
                    
                    
                    if userProfileMapper.errorMessage.isEmpty {
                    
                        successfull(true, ModelConvertor.convertToUserProfileFromMapper(userProfileMapper))
                    }
                    else {
                        
                        failure(false, userProfileMapper.errorMessage)
                    }
                    
                    
                }
                
                if response.result.isFailure {
                    print("response: \(response.error ?? "" as! Error)")
                    
                    failure(false, response.error.debugDescription)
                }
                
            })
        }
        else {
            
            //            CommonsUI.showAlertForInternetConnection(onTarget, okayAction: {
            //
            //            })
        }
        
    }
    
    // MARK: - Login & Signup
    
    private func handleLoginResponse(response: DataResponse<String>, successfull:@escaping (_ isSuccess: Bool, _ isProfileFound: Bool)->()) {
        
        let userProfileMapper: UserProfileMapper = Mapper<UserProfileMapper>().map(JSONString: response.result.value!)!
        
        
        ResponseHandler.profileResponse(userProfileMapper, completion: { (success) in
            
            successfull(success, true)
        })
    }
    
    func requestForMaritalStatusList(onTarget: AnyObject!, successfull:@escaping (_ isSuccess: Bool)->(), failure:@escaping (_ isFailure: Bool)->()) {
        print(#function)
        if self.isCheckReachable() {
            
            
//            let headers: HTTPHeaders = self.getRequestHeader();
            
            let urlString: String = AppConstants.kUsers + "/" + AppConstants.kMaritalStatus
            Alamofire.request(urlString, method: .get, parameters: nil, encoding: JSONEncoding.default).responseString(completionHandler: { (response) in
                
                if response.result.isSuccess {
                    
                    print(response.result.value!)
                    
                    let maritalStatusList: MaritalStatusListMapper = Mapper<MaritalStatusListMapper>().map(JSONString: response.result.value!)!
                    
                    ResponseHandler.maritalStatusResponse(maritalStatusList, completion: { (success) in
                        
                        successfull(true)
                    })
                }
                
                if response.result.isFailure {
                    print("response: \(response.error ?? "" as! Error)")
                    
                    failure(false)
                }
                
            })
        }
        else {
            
            //            CommonsUI.showAlertForInternetConnection(onTarget, okayAction: {
            //
            //            })
        }
        
    }
    
    func requestForRegisterSocial(onTarget: AnyObject!, _ parameters: [String : Any], isBackground: Bool, successfull:@escaping (_ isSuccess: Bool, _ hasRegisterUser: Bool)->(), failure:@escaping (_ isFailure: Bool)->()) {
        
        if self.isCheckReachable() {
            
            if !isBackground {
                
//                CommonHUD.showProgressHUD(WithMessage: "Logging In")
            }
            
            Alamofire.request(AppConstants.kRegisterSocial, method: .post, parameters: parameters, encoding: JSONEncoding.default).responseString(completionHandler: { (response) in
                
                if response.result.isSuccess {
                    
                    print(response.result.value!)
                    
                    let loginUser = Mapper<LoginUserMapper>().map(JSONString: response.result.value!)
                
                    ResponseHandler.loginResponse(loginUser!, completion: { (success) in
                        
                        successfull(success, (loginUser?.hasRegistered)!)
                    })
                }
                
                if response.result.isFailure {
                    print("response: \(response.error ?? "" as! Error)")
                    
                    failure(false)
                }
            })
        }
        else {
            
//            CommonsUI.showAlertForInternetConnection(onTarget, okayAction: {
//
//            })
        }

    }
    
    // MARK: - Groups
    
    func requestForGroupDefaultCategories(onTarget: AnyObject!, isBackground: Bool, successfull:@escaping (_ isSuccess: Bool)->(), failure:@escaping (_ isFailure: Bool)->()) {
        
        if self.isCheckReachable() {
            
            if !isBackground {
                
                //                CommonHUD.showProgressHUD(WithMessage: "Logging In")
            }
            
            let headers: HTTPHeaders = self.getRequestHeader();
            
            Alamofire.request(AppConstants.kGroups + "/Categories", method: .get, parameters: nil, encoding: JSONEncoding.default, headers: headers).responseString(completionHandler: { (response) in
                
                if response.result.isSuccess {
                    
                    print(response.result.value!)
                    
                    let groupCategoriesList: GroupCategoriesListMapper = Mapper<GroupCategoriesListMapper>().map(JSONString: response.result.value!)!
                    
                    ResponseHandler.groupCategoriesResponse(groupCategoriesList, completion: { (success) in
                        
                        successfull(true)
                    })
                }
                
                if response.result.isFailure {
                    print("response: \(response.error ?? "" as! Error)")
                    
                    failure(false)
                }
            })
        }
        else {
            
            //            CommonsUI.showAlertForInternetConnection(onTarget, okayAction: {
            //
            //            })
        }
    }
    
    func requestForGroupDefaultPrices(onTarget: AnyObject!, isBackground: Bool, successfull:@escaping (_ isSuccess: Bool)->(), failure:@escaping (_ isFailure: Bool)->()) {
        
        if self.isCheckReachable() {
            
            if !isBackground {
                
                //                CommonHUD.showProgressHUD(WithMessage: "Logging In")
            }
            
            let headers: HTTPHeaders = self.getRequestHeader();
            
            Alamofire.request(AppConstants.kGroups + "/Prices", method: .get, parameters: nil, encoding: JSONEncoding.default, headers: headers).responseString(completionHandler: { (response) in
                
                if response.result.isSuccess {
                    
                    print(response.result.value!)
                    
                    let groupPricesList: GroupPricesListMapper = Mapper<GroupPricesListMapper>().map(JSONString: response.result.value!)!
                    
                    ResponseHandler.groupPricesResponse(groupPricesList, completion: { (success) in
                        
                        successfull(true)
                    })
                }
                
                if response.result.isFailure {
                    print("response: \(response.error ?? "" as! Error)")
                    
                    failure(false)
                }
            })
        }
        else {
            
            //            CommonsUI.showAlertForInternetConnection(onTarget, okayAction: {
            //
            //            })
        }
    }
    
    func requestForCreateGroup(onTarget: AnyObject!, _ parameters: [String : Any], isBackground: Bool, successfull:@escaping (_ isSuccess: Bool, _ createdGroup: GroupObject)->(), failure:@escaping (_ isFailure: Bool)->()) {
        
        if self.isCheckReachable() {
            
            if !isBackground {
                
                //                CommonHUD.showProgressHUD(WithMessage: "Logging In")
            }
            
            let headers: HTTPHeaders = self.getRequestHeader();
            
            Alamofire.request(AppConstants.kGroups, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers).responseString(completionHandler: { (response) in
                
                if response.result.isSuccess {
                    
                    print(response.result.value!)

                    let groupObjectMapper: GroupObjectMapper = Mapper<GroupObjectMapper>().map(JSONString: response.result.value!)!
                    
                    ResponseHandler.groupResponse(false, GroupDBState.Creating, groupObjectMapper, completion: { (result) in
                        
                        if result {
                    
                            successfull(true, ModelConvertor.convertToGroupObject(groupObjectMapper))
                        }
                        else {
                            
                            successfull(false, ModelConvertor.convertToGroupObject(groupObjectMapper))
                        }
                    })
                }
                
                if response.result.isFailure {
                    print("response: \(response.error ?? "" as! Error)")
                    
                    failure(false)
                }
            })
        }
        else {
            
            //            CommonsUI.showAlertForInternetConnection(onTarget, okayAction: {
            //
            //            })
        }
        
    }
    
    func requestForPublicGroups(onTarget: AnyObject!, _ parameters: [String : Any], successfull:@escaping (_ isSuccess: Bool, _ groupsList: [GroupObject])->(), failure:@escaping (_ isFailure: Bool)->()) {
        
        if self.isCheckReachable() {
            
            
            let headers: HTTPHeaders = self.getRequestHeader();
            
            let urlString: String = AppConstants.kGroups + "/?groupType=public"
            
            Alamofire.request(urlString, method: .get, parameters: nil, encoding: URLEncoding.default, headers: headers).responseString(completionHandler: { (response) in
                
                if response.result.isSuccess {
                    
                    print(response.result.value!)
                    
                    let groupsListMapper: GroupsListMapper = Mapper<GroupsListMapper>().map(JSONString: response.result.value!)!
                    
                    ResponseHandler.groupListResponse(.DiscoverGroups, groupsListMapper, completion: { (result) in
                        
                        if result {
                            
                            successfull(true, ModelConvertor.convertToGroupObjectList(groupsListMapper))
                        }
                        else {
                        
                            successfull(false, ModelConvertor.convertToGroupObjectList(groupsListMapper))
                        }
                    })
                }
                
                if response.result.isFailure {
                    print("response: \(response.error ?? "" as! Error)")
                    
                    failure(false)
                }
                
            })
        }
        else {
            
            //            CommonsUI.showAlertForInternetConnection(onTarget, okayAction: {
            //
            //            })
        }
    }
    
    func requestForSearchMyGroups(onTarget: AnyObject!, _ title: String, successfull:@escaping (_ isSuccess: Bool, _ groupsList: [GroupObject])->(), failure:@escaping (_ isFailure: Bool)->()) {
        
        if self.isCheckReachable() {
            
            let headers: HTTPHeaders = self.getRequestHeader();
            
            let urlString: String = AppConstants.kGroups + "/me/?groupTitle=\(title)"
            
            Alamofire.request(urlString, method: .get, parameters: nil, encoding: URLEncoding.default, headers: headers).responseString(completionHandler: { (response) in
                
                if response.result.isSuccess {
                    
                    print(response.result.value!)
                    
                    let groupsListMapper: GroupsListMapper = Mapper<GroupsListMapper>().map(JSONString: response.result.value!)!
                    
                    successfull(true, ModelConvertor.convertToGroupObjectList(groupsListMapper))
                }
                
                if response.result.isFailure {
                    print("response: \(response.error ?? "" as! Error)")
                    
                    failure(false)
                }
                
            })
        }
        else {
            
            //            CommonsUI.showAlertForInternetConnection(onTarget, okayAction: {
            //
            //            })
        }
    }
    
    func requestForSearchPublicGroups(onTarget: AnyObject!, _ title: String, successfull:@escaping (_ isSuccess: Bool, _ groupsList: [GroupObject])->(), failure:@escaping (_ isFailure: Bool)->()) {
        
        if self.isCheckReachable() {
            
            
            let headers: HTTPHeaders = self.getRequestHeader();
            
            let urlString: String = AppConstants.kGroups + "/?groupTitle=\(title)"
            
            Alamofire.request(urlString, method: .get, parameters: nil, encoding: URLEncoding.default, headers: headers).responseString(completionHandler: { (response) in
                
                if response.result.isSuccess {
                    
                    print(response.result.value!)
                    
                    let groupsListMapper: GroupsListMapper = Mapper<GroupsListMapper>().map(JSONString: response.result.value!)!
                    
                    successfull(true, ModelConvertor.convertToGroupObjectList(groupsListMapper))
                }
                
                if response.result.isFailure {
                    print("response: \(response.error ?? "" as! Error)")
                    
                    failure(false)
                }
                
            })
        }
        else {
            
            //            CommonsUI.showAlertForInternetConnection(onTarget, okayAction: {
            //
            //            })
        }
    }
    
    func requestForAllUsers(onTarget: AnyObject!, successfull:@escaping (_ isSuccess: Bool, _ groupsList: [UserProfile])->(), failure:@escaping (_ isFailure: Bool)->()) {
        
        if self.isCheckReachable() {
            
            let headers: HTTPHeaders = self.getRequestHeader();
            
            let urlString: String = AppConstants.kUsers + "/?pagesize=1000"
            
            Alamofire.request(urlString, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: headers).responseString(completionHandler: { (response) in
                
                if response.result.isSuccess {
                    
                    print(response.result.value!)
                    
                    let userProfileListMapper: UserProfileListMapper = Mapper<UserProfileListMapper>().map(JSONString: response.result.value!)!
                    
                    successfull(true, ModelConvertor.convertToUserProfileList(userProfileListMapper))
                }
                
                if response.result.isFailure {
                    print("response: \(response.error ?? "" as! Error)")
                    
                    failure(false)
                }
                
            })
        }
        else {
            
            //            CommonsUI.showAlertForInternetConnection(onTarget, okayAction: {
            //
            //            })
        }
        
    }
    
    func requestForMarcoUsers(onTarget: AnyObject!, successfull:@escaping (_ isSuccess: Bool, _ groupsList: [UserProfile])->(), failure:@escaping (_ isFailure: Bool)->()) {
        
        if self.isCheckReachable() {
            
            
            let headers: HTTPHeaders = self.getRequestHeader();
            
            Alamofire.request(AppConstants.kUsers, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: headers).responseString(completionHandler: { (response) in
                
                if response.result.isSuccess {
                    
                    print(response.result.value!)
                    
                    let userProfileListMapper: UserProfileListMapper = Mapper<UserProfileListMapper>().map(JSONString: response.result.value!)!

                    successfull(true, ModelConvertor.convertToUserProfileList(userProfileListMapper))
                }
                
                if response.result.isFailure {
                    print("response: \(response.error ?? "" as! Error)")
                    
                    failure(false)
                }
                
            })
        }
        else {
            
            //            CommonsUI.showAlertForInternetConnection(onTarget, okayAction: {
            //
            //            })
        }
        
    }
    
    func requestForMyGroups(onTarget: AnyObject!, successfull:@escaping (_ isSuccess: Bool, _ groupsList: [GroupObject])->(), failure:@escaping (_ isFailure: Bool)->()) {
        
        if self.isCheckReachable() {
            
            
            let headers: HTTPHeaders = self.getRequestHeader();
            
            let urlString: String = AppConstants.kGroups + "/me"
            
            Alamofire.request(urlString, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: headers).responseString(completionHandler: { (response) in
                
                if response.result.isSuccess {
                    
                    print(response.result.value!)
                    
                    let groupsListMapper: GroupsListMapper = Mapper<GroupsListMapper>().map(JSONString: response.result.value!)!
                    
                    ResponseHandler.groupListResponse(.MyGroups, groupsListMapper, completion: { (result) in
                        
                        if result {
                            
                            successfull(true, ModelConvertor.convertToGroupObjectList(groupsListMapper))
                        }
                        else {
                            
                            successfull(false, ModelConvertor.convertToGroupObjectList(groupsListMapper))
                        }
                    })
                }
                
                if response.result.isFailure {
                    print("response: \(response.error ?? "" as! Error)")
                    
                    failure(false)
                }
                
            })
        }
        else {
            
            //            CommonsUI.showAlertForInternetConnection(onTarget, okayAction: {
            //
            //            })
        }
        
    }
    
    func requestForUserGroups(onTarget: AnyObject!, _ userId: String, successfull:@escaping (_ isSuccess: Bool, _ groupsList: [GroupObject])->(), failure:@escaping (_ isFailure: Bool)->()) {
        
        if self.isCheckReachable() {
            
            
            let headers: HTTPHeaders = self.getRequestHeader();
            
            let urlString: String = AppConstants.kGroups + "/?userId=\(userId)"
            
            Alamofire.request(urlString, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: headers).responseString(completionHandler: { (response) in
                
                if response.result.isSuccess {
                    
                    print(response.result.value!)
                    
                    let groupsListMapper: GroupsListMapper = Mapper<GroupsListMapper>().map(JSONString: response.result.value!)!
                    
                    successfull(true, ModelConvertor.convertToGroupObjectList(groupsListMapper))
                }
                
                if response.result.isFailure {
                    print("response: \(response.error ?? "" as! Error)")
                    
                    failure(false)
                }
                
            })
        }
        else {
            
            //            CommonsUI.showAlertForInternetConnection(onTarget, okayAction: {
            //
            //            })
        }
        
    }
    
    func requestForGroupDetail(onTarget: AnyObject!, _ parameters: [String : Any], successfull:@escaping (_ isSuccess: Bool, _ groupDetail: GroupObject)->(), failure:@escaping (_ isFailure: Bool)->()) {
        
        if self.isCheckReachable() {
            
            let headers: HTTPHeaders = self.getRequestHeader();
            
            let urlString: String = AppConstants.kGroups + "/" + (parameters["GroupId"] as? String)!
            
            Alamofire.request(urlString, method: .get, parameters: parameters, encoding: URLEncoding.default, headers: headers).responseString(completionHandler: { (response) in
                
                if response.result.isSuccess {
                    
                    print(response.result.value!)
                    
                    let groupObjectListMapper: GroupsListMapper = Mapper<GroupsListMapper>().map(JSONString: response.result.value!)!
                    
                    let groupObjectMapper: GroupObjectMapper = groupObjectListMapper.groupsList[0]
                    
                    successfull(true, ModelConvertor.convertToGroupObject(groupObjectMapper))
                    
                }
                
                if response.result.isFailure {
                    print("response: \(response.error ?? "" as! Error)")
                    
                    failure(false)
                }
                
            })
        }
        else {
            
            //            CommonsUI.showAlertForInternetConnection(onTarget, okayAction: {
            //
            //            })
        }
        
    }
    
    func requestForJoinGroup(onTarget: AnyObject!, _ groupId: String, parameters: [String: Any], successfull:@escaping (_ isSuccess: Bool, _ message: String)->(), failure:@escaping (_ isFailure: Bool)->()) {
        
        if self.isCheckReachable() {
            
            
            let headers: HTTPHeaders = self.getRequestHeader();
            
            //Groups/8/Memberships
            let urlString: String = AppConstants.kGroups + "/" + groupId + "/Memberships"
            
            print(parameters)
            
            Alamofire.request(urlString, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers).responseString(completionHandler: { (response) in
                
                if response.result.isSuccess {
                    
                    print(response.result.value!)
                
                    let messageObjectMapper: MessageObjectMapper = Mapper<MessageObjectMapper>().map(JSONString: response.result.value!)!
                    
                    successfull(true, messageObjectMapper.message)
                }
                
                if response.result.isFailure {
                    print("response: \(response.error ?? "" as! Error)")
                    
                    failure(false)
                }
                
            })
        }
        else {
            
            //            CommonsUI.showAlertForInternetConnection(onTarget, okayAction: {
            //
            //            })
        }
        
    }
    
    func requestForGetGroupPosts(onTarget: AnyObject!, _ parameters: [String : Any], successfull:@escaping (_ isSuccess: Bool, _ postObjectsList: [PostObject])->(), failure:@escaping (_ isFailure: Bool)->()) {
        
        if self.isCheckReachable() {
            
            let headers: HTTPHeaders = self.getRequestHeader();
            
            let urlString: String = AppConstants.kGroups + "/" + (parameters["GroupId"] as! String) + "/Posts"
            
            Alamofire.request(urlString, method: .get, parameters: nil, encoding: URLEncoding.default, headers: headers).responseString(completionHandler: { (response) in
                
                if response.result.isSuccess {
                    
                    print(response.result.value!)
                    
                    let postsListMapper: PostsListMapper = Mapper<PostsListMapper>().map(JSONString: response.result.value!)!
                    
                    successfull(true, ModelConvertor.convertToPostObjectsList(postsListMapper))
                }
                
                if response.result.isFailure {
                    print("response: \(response.error ?? "" as! Error)")
                    
                    failure(false)
                }
                
            })
        }
        else {
            
            //            CommonsUI.showAlertForInternetConnection(onTarget, okayAction: {
            //
            //            })
        }
        
    }
    
    func requestForCreateGroupPost(onTarget: AnyObject!, fileList: [UIImage], _ parameters: [String : Any], successfull:@escaping (_ isSuccess: Bool)->(), failure:@escaping (_ isFailure: Bool)->()) {
        
        if self.isCheckReachable() {
            
            let mimeType = "type/*"
            
            let headers: HTTPHeaders = self.getRequestHeader();
            
            Alamofire.upload(multipartFormData: { (multipartFormData) in
            
                for i in 0..<fileList.count {
            
                    let fileImage: UIImage = fileList[i]
                    
                    let fileName = "fileUpload\(i).jpeg"
                    
                    let imageData: Data = UIImageJPEGRepresentation(fileImage, 1.0)!
                
                    multipartFormData.append(imageData, withName: "file", fileName: fileName, mimeType: mimeType)
                }
                
                for (key, value) in parameters {
                    if let data = (value as AnyObject).data(using: String.Encoding.utf8.rawValue) {
                        multipartFormData.append(data, withName: key)
                    }
                }
                
            }, usingThreshold: UInt64.init(),
               to: AppConstants.kPosts,
               method: .post,
               headers: headers,
               encodingCompletion: { (encodingResult) in
                
                switch encodingResult {
                    
                case .success(request: let upload, streamingFromDisk: _, streamFileURL: _):
                    
                    upload.uploadProgress(queue: DispatchQueue.main, closure: { (progress) in
                        
                        print(progress)
                    })
                    
                    upload.responseString(completionHandler: { (response) in
                        
                        print(response.result.value!)
                        
                        successfull(true)
                        
//                        let fileURLMapper: FileURLMapper = Mapper<FileURLMapper>().map(JSONString: response.result.value!)!
//                        
//                        if fileURLMapper.urlString == nil {
//                            
//                            failure(true)
//                        }
//                        else {
//                            
//                            successfull(true)
//                        }
                        
                    })
                    
                case .failure(let encodingError):
                    
                    print(encodingError)
                    
                    failure(false)
                }
            })
            
        }
        else {
            
            //            CommonsUI.showAlertForInternetConnection(onTarget, okayAction: {
            //
            //            })
        }
        
    }
    
    func requestForGetGroupUsers(onTarget: AnyObject!, _ groupId: String, successfull:@escaping (_ isSuccess: Bool, _ userProfileList: [UserProfile])->(), failure:@escaping (_ isFailure: Bool)->()) {
        
        if self.isCheckReachable() {
            
            let headers: HTTPHeaders = self.getRequestHeader();
            
            let urlString: String = AppConstants.kGroups + "/" + groupId + "/memberships"
            
            Alamofire.request(urlString, method: .get, parameters: nil, encoding: URLEncoding.default, headers: headers).responseString(completionHandler: { (response) in
                
                if response.result.isSuccess {
                    
                    print(response.result.value!)
                    
                    let userListMapper: 
                        UserProfileListMapper = Mapper<UserProfileListMapper>().map(JSONString: response.result.value!)!
                    
                    successfull(true, ModelConvertor.convertToUserProfileList(userListMapper))
                }
                
                if response.result.isFailure {
                    print("response: \(response.error ?? "" as! Error)")
                    
                    failure(false)
                }
                
            })
        }
        else {
            
            //            CommonsUI.showAlertForInternetConnection(onTarget, okayAction: {
            //
            //            })
        }
    }
    
    func requestForCreatePostComment(onTarget: AnyObject!, _ postId: String, commentText: String, successfull:@escaping (_ isSuccess: Bool)->(), failure:@escaping (_ isFailure: Bool)->()) {
        
        if self.isCheckReachable() {
            
            let headers: HTTPHeaders = self.getRequestHeader();
            
            //http://localhost:3921/api/Service/Posts/2/Comments
            let urlString: String = AppConstants.kPosts + "/" + postId + "/Comments"
            
            Alamofire.request(urlString, method: .post, parameters: ["Text": commentText], encoding: URLEncoding.default, headers: headers).responseString(completionHandler: { (response) in
                
                if response.result.isSuccess {
                    
                    print(response.result.value!)
  
                    successfull(true)
                }
                
                if response.result.isFailure {
                    print("response: \(response.error ?? "" as! Error)")
                    
                    failure(false)
                }
                
            })
        }
        else {
            
            //            CommonsUI.showAlertForInternetConnection(onTarget, okayAction: {
            //
            //            })
        }
    }
    
    func requestForGetPostDetail(onTarget: AnyObject!, _ postId: String, successfull:@escaping (_ isSuccess: Bool, _ userProfile: PostObject)->(), failure:@escaping (_ isFailure: Bool)->()) {
        
        if self.isCheckReachable() {
            
            let headers: HTTPHeaders = self.getRequestHeader();
            
            //http://localhost:3921/api/Posts/2
            let urlString: String = AppConstants.kPosts + "/" + postId
            
            Alamofire.request(urlString, method: .get, parameters: nil, encoding: URLEncoding.default, headers: headers).responseString(completionHandler: { (response) in
                
                if response.result.isSuccess {
                    
                    print(response.result.value!)
                    
                    
                    let postObjectMapper: PostObjectMapper = Mapper<PostObjectMapper>().map(JSONString: response.result.value!)!
                    
                    
                    successfull(true, ModelConvertor.convertToPostObject(postObjectMapper))
                }
                
                if response.result.isFailure {
                    print("response: \(response.error ?? "" as! Error)")
                    
                    failure(false)
                }
                
            })
        }
        else {
            
            //            CommonsUI.showAlertForInternetConnection(onTarget, okayAction: {
            //
            //            })
        }
    }
    
    // MARK: - Settings
    
    func requestForUpdateLocation(onTarget: AnyObject!, _ parameters: [String: Any], successfull:@escaping (_ isSuccess: Bool)->(), failure:@escaping (_ isFailure: Bool)->()) {
        
        if self.isCheckReachable() {
         
            let headers: HTTPHeaders = self.getRequestHeader();
            
            Alamofire.request(AppConstants.kUserLocation, method: .put, parameters: parameters, encoding: JSONEncoding.default, headers: headers).responseString(completionHandler: { (response) in
                
                if response.result.isSuccess {
                    
                    print(response.result.value!)
                    
                    successfull(true)
                }
                
                if response.result.isFailure {
                    print("response: \(response.error ?? "" as! Error)")
                    
                    failure(false)
                }
                
            })
        }
        else {
            
            //            CommonsUI.showAlertForInternetConnection(onTarget, okayAction: {
            //
            //            })
        }
    }
    
    func requestForUpdateGroupSettings(onTarget: AnyObject!, _ groupId: String, _ parameters: [String: Any], successfull:@escaping (_ isSuccess: Bool)->(), failure:@escaping (_ isFailure: Bool)->()) {
        
        if self.isCheckReachable() {
            
            let headers: HTTPHeaders = self.getRequestHeader();
            
            let urlString: String = AppConstants.kGroupMemberships + "/" + groupId + "/preferences"
            
            //memberships/{id}/preferences
            
            Alamofire.request(urlString, method: .put, parameters: parameters, encoding: JSONEncoding.default, headers: headers).responseString(completionHandler: { (response) in
                
                if response.result.isSuccess {
                    
                    print(response.result.value!)
                    
                    successfull(true)
                }
                
                if response.result.isFailure {
                    print("response: \(response.error ?? "" as! Error)")
                    
                    failure(false)
                }
                
            })
        }
        else {
            
            //            CommonsUI.showAlertForInternetConnection(onTarget, okayAction: {
            //
            //            })
        }
    }
    
    // MARK: - Campaign
    
    func requestForMakeCampaignPayment(onTarget: AnyObject!, _ parameters: [String: Any], successfull:@escaping (_ isSuccess: Bool)->(), failure:@escaping (_ isFailure: Bool)->()) {
        
        if self.isCheckReachable() {
            
            let headers: HTTPHeaders = self.getRequestHeader();
            
            let urlString: String = AppConstants.kCampaigns + "/Collections"
            
            Alamofire.request(urlString, method: .post, parameters: parameters, encoding: URLEncoding.default, headers: headers).responseString(completionHandler: { (response) in
                
                if response.result.isSuccess {
                    
                    print(response.result.value!)
                    
                    successfull(true)
                }
                
                if response.result.isFailure {
                    print("response: \(response.error ?? "" as! Error)")
                    
                    failure(false)
                }
                
            })
        }
        else {
            
            //            CommonsUI.showAlertForInternetConnection(onTarget, okayAction: {
            //
            //            })
        }
    }
    
    func requestForCreateCampaign(onTarget: AnyObject!, fileList: [UIImage], _ parameters: [String: Any], successfull:@escaping (_ isSuccess: Bool)->(), failure:@escaping (_ isFailure: Bool)->()) {
        
        if self.isCheckReachable() {
            
            let mimeType = "type/*"
            
            print(parameters)
            
            let headers: HTTPHeaders = self.getRequestHeader();
            
            
            Alamofire.upload(multipartFormData: { (multipartFormData) in
                
                for i in 0..<fileList.count {
                    
                    let fileImage: UIImage = fileList[i]
                    
                    let fileName = "fileUpload\(i).jpeg"
                    
                    let imageData: Data = UIImageJPEGRepresentation(fileImage, 1.0)!
                    
                    multipartFormData.append(imageData, withName: "file", fileName: fileName, mimeType: mimeType)
                }
                
                for (key, value) in parameters {
                    if let data = (value as AnyObject).data(using: String.Encoding.utf8.rawValue) {
                        multipartFormData.append(data, withName: key)
                    }
                }
                
            }, usingThreshold: SessionManager.multipartFormDataEncodingMemoryThreshold,
               to: AppConstants.kCampaigns,
               method: .post,
               headers: headers,
               encodingCompletion: { (encodingResult) in
                
                switch encodingResult {
                    
                case .success(request: let upload, streamingFromDisk: _, streamFileURL: _):
                    
                    upload.uploadProgress(queue: DispatchQueue.main, closure: { (progress) in
                        
                        print(progress)
                    })
                    
                    upload.responseString(completionHandler: { (response) in
                        
                        print(response.result.value!)
                        
                        successfull(true)
                        
                    })
                    
                case .failure(let encodingError):
                    
                    print(encodingError)
                    
                    failure(false)
                }
            })
            
//            let headers: HTTPHeaders = self.getRequestHeader();
//
//            print(parameters)
//
//            Alamofire.request(AppConstants.kCreateCampaign, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers).responseString { (response) in
//
//                if response.result.isSuccess {
//
//                    print(response.result.value!)
//
//                }
//
//                if response.result.isFailure {
//                    print("response: \(response.error ?? "" as! Error)")
//
//                    failure(false)
//                }
//            }
            
        }
        else {
            
            //            CommonsUI.showAlertForInternetConnection(onTarget, okayAction: {
            //
            //            })
        }
    }
    
    func requestForGetGroupCampaigns(onTarget: AnyObject!, _ groupId: String, successfull:@escaping (_ isSuccess: Bool, _ campaignObjectsList: [CampaignObject])->(), failure:@escaping (_ isFailure: Bool)->()) {
        
        if self.isCheckReachable() {
            
            let headers: HTTPHeaders = self.getRequestHeader();
            
            let urlString: String = AppConstants.kGroups + "/" + groupId + "/Campaigns"
            
            Alamofire.request(urlString, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: headers).responseString(completionHandler: { (response) in
                
                if response.result.isSuccess {
                    
                    print(response.result.value!)
                    
                    let campaignObjectMapperList: CampaignObjectMapperList = Mapper<CampaignObjectMapperList>().map(JSONString: response.result.value!)!

                    successfull(true, ModelConvertor.convertToCampaignList(campaignObjectMapperList))
                }
                
                if response.result.isFailure {
                    print("response: \(response.error ?? "" as! Error)")
                    
                    failure(false)
                }
                
            })
        }
        else {
            
            //            CommonsUI.showAlertForInternetConnection(onTarget, okayAction: {
            //
            //            })
        }
        
    }
    
    // MARK: - Feeds

    func requestForGetUserFeeds(onTarget: AnyObject!, successfull:@escaping (_ isSuccess: Bool, _ postObjectsList: [PostObject])->(), failure:@escaping (_ isFailure: Bool)->()) {
        
        if self.isCheckReachable() {
            
            let headers: HTTPHeaders = self.getRequestHeader();
            
            let urlString: String = AppConstants.kUsers + "/feeds" + "?pageSize=100"
            
            Alamofire.request(urlString, method: .get, parameters: nil, encoding: URLEncoding.default, headers: headers).responseString(completionHandler: { (response) in
                
                if response.result.isSuccess {
                    
                    print(response.result.value!)
                    
                    let postsListMapper: PostsListMapper = Mapper<PostsListMapper>().map(JSONString: response.result.value!)!
                    
                    successfull(true, ModelConvertor.convertToPostObjectsList(postsListMapper))
                }
                
                if response.result.isFailure {
                    print("response: \(response.error ?? "" as! Error)")
                    
                    failure(false)
                }
            })
        }
        else {
            
            //            CommonsUI.showAlertForInternetConnection(onTarget, okayAction: {
            //
            //            })
        }
    }
    
    // MARK: - Favorites
    
    func requestForUserFavorites(onTarget: AnyObject!, successfull:@escaping (_ userProfileList: [UserProfile], _ isSuccess: Bool)->(), failure:@escaping (_ isFailure: Bool)->()) {
        
        if self.isCheckReachable() {
            
            let headers: HTTPHeaders = self.getRequestHeader();
            
            Alamofire.request(AppConstants.kUserFavorites, method: .get, parameters: nil, encoding: URLEncoding.default, headers: headers).responseString(completionHandler: { (response) in
                
                if response.result.isSuccess {
                    
                    print(response.result.value!)
                    
                    let userProfileList: UserProfileListMapper = Mapper<UserProfileListMapper>().map(JSONString: response.result.value!)!
                    
                    
                    successfull(ModelConvertor.convertToUserProfileList(userProfileList.userProfileList), true)
                }
                
                if response.result.isFailure {
                    print("response: \(response.error ?? "" as! Error)")
                    
                    failure(false)
                }
                
            })
        }
        else {
            
            //            CommonsUI.showAlertForInternetConnection(onTarget, okayAction: {
            //
            //            })
        }
    }
    
    func requestForAddToFavorite(onTarget: AnyObject!,  _ parameters: [String : Any], successfull:@escaping (_ isSuccess: Bool, _ message: String)->(), failure:@escaping (_ isFailure: Bool)->()) {
        
        if self.isCheckReachable() {
            //1b7155bc-a710-4ce3-8ad4-d99a212d15f0
            let headers: HTTPHeaders = self.getRequestHeader();
            
            Alamofire.request(AppConstants.kUserFavorites, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers).responseString(completionHandler: { (response) in
                
                if response.result.isSuccess {
                    
                    print(response.result.value!)
                    
                    
                    let messageObjectMapper: MessageObjectMapper = Mapper<MessageObjectMapper>().map(JSONString: response.result.value!)!
                    
                    if messageObjectMapper.message == "" {
                    
                        successfull(true, "")
                    }
                    else {
                        
                        successfull(true, messageObjectMapper.message)
                    }
                    
                }
                
                if response.result.isFailure {
                    print("response: \(response.error ?? "" as! Error)")
                    
                    failure(false)
                }
                
            })
        }
        else {
            
            //            CommonsUI.showAlertForInternetConnection(onTarget, okayAction: {
            //
            //            })
        }
    }
    
    func requestForDeleteFavorite(onTarget: AnyObject!,  _ favoriteId: String, successfull:@escaping (_ isSuccess: Bool)->(), failure:@escaping (_ isFailure: Bool)->()) {
        
        if self.isCheckReachable() {
            
            let headers: HTTPHeaders = self.getRequestHeader();
            
            let urlString: String = AppConstants.kUserFavorites + favoriteId + "/"
            
            Alamofire.request(urlString, method: .delete, parameters: nil, encoding: URLEncoding.default, headers: headers).responseString(completionHandler: { (response) in
                
                if response.result.isSuccess {
                    
                    print(response.result.value!)
                    
                    //                    let postsListMapper: PostsListMapper = Mapper<PostsListMapper>().map(JSONString: response.result.value!)!
                    //
                    //                    successfull(true, ModelConvertor.convertToPostObjectsList(postsListMapper))
                }
                
                if response.result.isFailure {
                    print("response: \(response.error ?? "" as! Error)")
                    
                    failure(false)
                }
                
            })
        }
        else {
            
            //            CommonsUI.showAlertForInternetConnection(onTarget, okayAction: {
            //
            //            })
        }
    }
    
    // MARK: - File Uploading
    
    func requestForUploadFile(onTarget: AnyObject!, stringURL: String, groupId: Int = -1, fileImage: UIImage, uploadProgress:@escaping (_ progress: Progress)->(), successfull:@escaping (_ fileUrl: String, _ isSuccess: Bool)->(), failure:@escaping (_ isFailure: Bool)->()) {
        
        if self.isCheckReachable() {
            
            let fileName = "testingUpload.jpeg"
            let mimeType = "type/*"
            // let imageData: Data = UIImagePNGRepresentation(image)!
            let imageData: Data = UIImageJPEGRepresentation(fileImage, 1.0)!
            
            
            let headers: HTTPHeaders = self.getRequestHeader();
            
            Alamofire.upload(multipartFormData: { (multipartFormData) in
                
                multipartFormData.append(imageData, withName: "file", fileName: fileName, mimeType: mimeType)
                
                if groupId != -1 {
                
                    multipartFormData.append("\(groupId)".data(using: String.Encoding.utf8, allowLossyConversion: false)!, withName: "GroupId")
                }
                
            }, usingThreshold: UInt64.init(),
               to: stringURL,
               method: .post,
               headers: headers,
               encodingCompletion: { (encodingResult) in
                
                switch encodingResult {
                    
                case .success(request: let upload, streamingFromDisk: _, streamFileURL: _):
                    
                    upload.uploadProgress(queue: DispatchQueue.main, closure: { (progress) in
                        
//                        print(progress)
                        uploadProgress(progress)
                    })
                    
                    upload.responseString(completionHandler: { (response) in
                        
                        print(response.result.value!)
                        
                        let fileURLMapper: FileURLMapper = Mapper<FileURLMapper>().map(JSONString: response.result.value!)!
                        
                        if fileURLMapper.urlString == nil {
                            
                            failure(true)
                        }
                        else {
                        
                            successfull(fileURLMapper.urlString, true)
                        }
                        
                    })
                    
                case .failure(let encodingError):
                    
                    print(encodingError.localizedDescription)
                    
                    failure(false)
                }
            })
            
        }
        else {
            
//            CommonsUI.showAlertForInternetConnection(onTarget, okayAction: {
//
//            })
        }
    }
}



