//
//  TempDataModel.swift
//  MarcoApp
//
//  Created by Nabeel Hayat on 07/12/2017.
//  Copyright © 2017 GrayScaleLogic. All rights reserved.
//

import UIKit
import ObjectMapper

class TempDataModelMapper: BaseResponse {
    
    var Total: Int!
    var TotalPages: Int!
    var PreviousLink: String!
    var NextPageLink: String!
    var Data: [TempdataMapper] = []
    
    
    override init() {
        super.init()
    }
    
    override func mapping(map: Map) {
        super.mapping(map: map)
    }
}

class TempdataMapper: BaseResponse {
    
    var id: String!
    
    override init() {
        super.init()
    }
    
    override func mapping(map: Map) {
        super.mapping(map: map)
    }
}

//class TempDataModel: NSObject {
//
//    var userProfile: UserProfile = UserProfile(index: 19)
//    
//    private override init() {
//        super.init()
//    }
//    
//    class func getList(with numberOfRows: Int) -> [UserProfile] {
//    
//        return TempDataModel().getUserList(with: numberOfRows)
//    }
//    
//    func getUserList(with numberOfRows: Int) -> [UserProfile] {
//    
//        var userList: [UserProfile] = []
//        
//        for index in 0..<numberOfRows {
//            
//            userList.append(UserProfile(index: index))
//        }
//        
//        return userList
//    }
//}

//class UserGroup: NSObject {
//
//    var groupName: String!
//    var userProfile: UserProfile!
//    var groupMembers: [String] = []
//
//    var index: Int = 0;
//
//    var groupCoverPhoto: String! {
//
//        get {
//
//            return ["group-cover-photo.png","group-cover-photo-2.png","group-cover-photo-3.png","group-cover-photo-4.png"][index]
//        }
//
//        set {
//
//        }
//    }
//
//    var groupDetailCoverPhoto: String! {
//
//        get {
//
//            return ["group-detail-cover-photo.png","group-detail-cover-photo-2.png","group-detail-cover-photo-3.png","group-cover-photo-4.png"][index]
//        }
//
//        set {
//
//        }
//    }
//
//    var feedList: [String] {
//
//        get {
//
//            return ["feed-post-img-2.png","feed-post-img-3.png","feed-post-img-1.png","feed-post-img-4.png"];
//        }
//
//        set {
//
//        }
//    }
//
//    override init() {
//        super.init()
//
//    }
//
//    init(index: Int) {
//        super.init()
//
//        self.index = index
//        self.userProfile = UserProfile(index: AppFunctions.randomNumber(MIN: 0, MAX: 19))
//
//        self.groupMembers.append(UserProfile(index: AppFunctions.randomNumber(MIN: 0, MAX: 19)).avatar)
//        self.groupMembers.append(UserProfile(index: AppFunctions.randomNumber(MIN: 0, MAX: 19)).avatar)
//        self.groupMembers.append(UserProfile(index: AppFunctions.randomNumber(MIN: 0, MAX: 19)).avatar)
//        self.groupMembers.append(UserProfile(index: AppFunctions.randomNumber(MIN: 0, MAX: 19)).avatar)
//        self.groupMembers.append(UserProfile(index: AppFunctions.randomNumber(MIN: 0, MAX: 19)).avatar)
//    }
//
//}

//class UserProfile: NSObject {
//
//    var index: Int = 0;
//
//    var feedList: [String] {
//
//        get {
//
//            return ["feed-post-img-2.png","feed-post-img-4.png","feed-post-img-1.png","feed-post-img-3.png"];
//        }
//    }
//
//    var name: String! {
//
//        get {
//
//            return ["Otto Magallanes",
//                    "Spencer Mullet",
//                    "Laveta Seager",
//                    "Daysi Rascoe",
//                    "Tomika Luckie",
//                    "Randall Polich",
//                    "Julian Doctor",
//                    "Brendan Melnick",
//                    "Tomasa Tremper",
//                    "Chanda Bodie",
//                    "Sheron Leadbetter",
//                    "Polly Camacho",
//                    "June Child",
//                    "Lasonya Nuno",
//                    "Eliz Sleeper",
//
//                    "Chung Garrison",
//                    "Jc Garrido",
//                    "Connie Mormon",
//                    "Mariano Silveria",
//                    "Jason Estevez"][index]
//        }
//
//        set {
//
//            self.name = newValue
//        }
//    }
//
//    var designation: String! {
//
//        get {
//
//            return ["Takeaway Rembrandt",
//                    "Champion of Photography",
//                    "Count of Calories",
//                    "Lady Dada",
//                    "Modernist Maestro",
//                    "Hero of the House",
//                    "Like a BOSS",
//                    "Man With a Guitar",
//
//                    "Weightlifting Wizard",
//                    "Starchitect",
//                    "Helvetica Hero",
//                    "18 Wheeler Dealer",
//                    "The Amateur",
//                    "American Gothic",
//                    "Doctor Faustus",
//
//
//                    "Scrooge McDuck",
//                    "Rebel by Choice",
//                    "Master of Your Domain",
//                    "Hamburglar",
//                    "Starving Artist"][index]
//        }
//
//        set {
//
//            self.designation = newValue
//        }
//    }
//
//    var email: String! {
//
//        get {
//
//            return ["otto.magallanes@company.com",
//                    "spencer.mullet@company.com",
//                    "laveta.seager@company.com",
//                    "daysi.rascoe@company.com",
//                    "tomika.luckie@company.com",
//                    "randall.polich@company.com",
//                    "julian.doctor@company.com",
//                    "brendan.melnick@company.com",
//
//                    "tomasa.tremper@company.com",
//                    "chanda.bodie@company.com",
//                    "sleadbetter@company.com",
//                    "pcamacho@company.com",
//                    "june.child@company.com",
//                    "lasonya.nuno@company.com",
//                    "eliz.sleeper@company.com",
//
//
//                    "chung.garrison@company.com",
//                    "jgarrido@company.com",
//                    "connie.mormon@company.com",
//                    "mariano.silveria@company.com",
//                    "jason.estevez@company.com"][index]
//        }
//
//        set {
//
//            self.email = newValue
//        }
//    }
//
//    var gender: String! {
//
//        get {
//
//            return ["Male",
//                    "Male",
//                    "Female",
//                    "Female",
//                    "Female",
//                    "Male",
//                    "Male",
//                    "Male",
//
//                    "Female",
//                    "Female",
//                    "Female",
//                    "Female",
//                    "Female",
//                    "Female",
//                    "Female",
//
//
//                    "Male",
//                    "Male",
//                    "Male",
//                    "Male",
//                    "Male"][index]
//        }
//
//        set {
//
//            self.gender = newValue
//        }
//    }
//
//    var maritalStatus: String! {
//
//        get {
//
//            return ["single",
//                    "divorced",
//                    "single",
//                    "single",
//                    "divorced",
//                    "divorced",
//                    "single",
//                    "married",
//
//                    "married",
//                    "single",
//                    "married",
//                    "single",
//                    "married",
//                    "married",
//                    "single",
//
//                    "married",
//                    "single",
//                    "single",
//                    "married",
//                    "divorced"][index]
//        }
//
//        set {
//
//            self.maritalStatus = newValue
//        }
//    }
//
//    var dob: String! {
//
//        get {
//
//            return ["17/11/86",
//                    "24/03/89",
//                    "27/05/89",
//                    "14/07/88",
//                    "24/12/98",
//                    "15/02/97",
//                    "27/12/89",
//                    "07/07/90",
//
//                    "10/03/89",
//                    "24/09/86",
//                    "11/06/81",
//                    "02/03/97",
//                    "07/07/99",
//                    "05/12/90",
//                    "21/06/99",
//
//
//                    "16/05/93",
//                    "18/11/96",
//                    "11/12/83",
//                    "20/10/91",
//                    "10/07/90"][index]
//        }
//
//        set {
//
//            self.dob = newValue
//        }
//    }
//
//    var interest: String! {
//
//        get {
//
//            return ["Saving the world",
//                    "",
//                    "",
//                    "",
//                    "",
//                    "reading, listening to music, and silence.",
//                    "",
//                    "",
//
//                    "",
//                    "",
//                    "",
//                    "",
//                    "",
//                    "Fashion, Art",
//                    "",
//
//
//                    "Persistence.Perfection.Patience.",
//                    "",
//                    "I write to find strength.",
//                    "",
//                    "sports or politics or horses"][index]
//        }
//
//        set {
//
//            self.interest = newValue
//        }
//    }
//
//    var location: String! {
//
//        get {
//
//            return ["Washington, District of Columbia",
//                    "San Francisco, California",
//                    "Dallas,Texas",
//                    "Chesapeake, Virginia",
//                    "Orlando, Florida",
//                    "Los AngelesCalifornia",
//                    "Houston, Texas",
//                    "Oklahoma City, Oklahoma",
//
//                    "Jersey City, New Jersey",
//                    "Los Angeles, California",
//                    "Washington, District of Columbia",
//                    "Houston, Texas",
//                    "Tampa, Florida",
//                    "San Fransisco, California",
//                    "Tampa, Florida",
//
//
//                    "Las Vegas, Nevada",
//                    "Los Angeles, California",
//                    "San Francisco, California",
//                    "Jersey City, New Jersey",
//                    "San Francisco, California"][index]
//        }
//
//        set {
//
//            self.location = newValue
//        }
//    }
//    var phone: String! {
//
//        get {
//
//            return ["(103) 489-1941",
//                    "(860) 122-1135",
//                    "(514) 889-0963",
//                    "(288) 607-5272",
//                    "(673) 971-2434",
//                    "(682) 195-2378",
//                    "(924) 115-0642",
//                    "(808) 756-7539",
//
//                    "(553) 679-5503",
//                    "(474) 438-2378",
//                    "(512) 493-8899",
//                    "(881) 795-8514",
//                    "(260) 487-6232",
//                    "(623) 806-4487",
//
//
//                    "(440) 850-1183",
//                    "(804) 556-3316",
//                    "(361) 738-4925",
//                    "(840) 259-6207",
//                    "(320) 651-5407",
//                    "(983) 403-6849"][index]
//        }
//
//        set {
//
//            self.phone = newValue
//        }
//    }
//    var about: String! {
//
//        get {
//
//            return ["",
//                    "",
//                    "",
//                    "",
//                    "",
//                    "",
//                    "",
//                    "",
//                    "",
//                    "",
//                    "",
//                    "",
//                    "",
//                    "",
//                    "",
//                    "",
//                    "",
//                    "",
//                    "",
//                    ""][index]
//        }
//
//        set {
//
//            self.about = newValue
//        }
//    }
//    var avatar: String! {
//
//        get {
//
//            return ["01.jpg",
//                    "02.jpg",
//                    "08.jpg",
//                    "04.jpg",
//                    "06.jpg",
//                    "03.jpg",
//                    "05.jpg",
//                    "10.jpg",
//
//                    "11.jpg",
//                    "13.jpg",
//                    "14.jpg",
//                    "15.jpg",
//                    "16.jpg",
//                    "17.jpg",
//                    "18.jpg",
//
//
//                    "12.jpg",
//                    "19.jpg",
//                    "20.jpg",
//                    "21.jpg",
//                    "09.jpg"][index]
//        }
//
//        set {
//
//            self.avatar = newValue
//        }
//    }
//
//    override init() {
//        super.init()
//
////        self.name = ""
////        self.designation = ""
////        self.email = ""
////        self.gender = ""
////        self.maritalStatus = ""
////        self.dob = ""
////        self.interest = ""
////        self.location = ""
////        self.phone = ""
////        self.about = ""
////        self.avatar = ""
//    }
//
//    init(index: Int) {
//        super.init()
//
//        self.index = index
//    }
//
//
//}











