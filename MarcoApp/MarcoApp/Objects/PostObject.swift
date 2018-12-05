//
//  PostObject.swift
//  MarcoApp
//
//  Created by Nabeel Hayat on 19/04/2018.
//  Copyright © 2018 GrayScaleLogic. All rights reserved.
//

import UIKit
import ObjectMapper

class PostContent: NSObject {
    
    var postId: Int! = nil
    var contentURL: String! = nil
    var contentCreatedDate: String! = nil
    var contentModifiedDate: String! = nil

    override init() {
        super.init()
        self.setupDefaultState()
    }
    
    private func setupDefaultState() {
        
        self.postId = 0
        self.contentURL = ""
        self.contentCreatedDate = ""
        self.contentModifiedDate = ""
    }
    
//
//    {"PostId":4,"Url":"https://marcoapp.blob.core.windows.net/marco/e97f5fa5-a4c0-4675-8b0b-db5b2ded470c.jpg","CreatedDate":"2018-04-20T03:39:50.43","ModifiedDate":"2018-04-20T03:39:50.43"}
    
}

class PostContentMapper: Mappable {
    
    var postId: Int! = nil
    var contentURL: String! = nil
    var contentCreatedDate: String! = nil
    var contentModifiedDate: String! = nil
    
    init() {
        
    }
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        
        self.postId <- map["PostId"]
        self.contentURL <- map["Url"]
        self.contentCreatedDate <- map["CreatedDate"]
        self.contentModifiedDate <- map["ModifiedDate"]
    }
}

class PostObject: NSObject {

    var postId: Int! = nil
    var groupId: Int! = nil
    var userId: Int! = nil
    
    var postText: String! = nil
    var postCreatedBy: String! = nil
    var postCreatedDate: String! = nil
    var postModifiedDate: String! = nil
    var postModifiedBy: String! = nil
    
    var createdByUser: UserProfile! = nil
    
    var isDeletedPost: Bool! = nil
    var isCommentablePost: Bool! = nil
    var isShareablePost: Bool! = nil
    
    var contents: [PostContent] = []
    
    var comments: [PostComment] = []
    
    override init() {
        super.init()
        self.setupDefaultState()
    }
    
    private func setupDefaultState() {
        
        self.postId = 0
        self.groupId = 0
        self.userId = 0
        
        self.postText = ""
        self.postCreatedBy = ""
        self.postCreatedDate = ""
        self.postModifiedBy = ""
        self.postModifiedDate = ""
        
        self.isDeletedPost = false
        self.isCommentablePost = true
        self.isShareablePost = true
        
        self.createdByUser = nil
        
        self.contents = []
        
        self.comments = []
    }
}

class CampaignObjectMapperList: Mappable {
 
    var campaignList: [CampaignObjectMapper] = []

    init() {
        
    }
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        
        self.campaignList <- map["Data"]
    }
}

class CampaignObject: NSObject {
    
    var campaignId: Int! = nil
    
    var titleCampaign: String! = nil
    var descriptionCampaign: String! = nil
    var terminateCampaign: String! = nil
    var statusCampaign: String! = nil
    var startDateCampaign: String! = nil
    var endDateCampaign: String! = nil
    
    var amountCampaign: CGFloat! = nil
    var collectedCampaign: CGFloat! = nil
    var contributionCampaign: CGFloat! = nil
    var contributorCampaign: Int! = nil
    
    var mediaList: [String] = []
    
    var createdByUser: UserProfile! = nil
    
    override init() {
        super.init()
        self.setupDefaultState()
    }
    
    private func setupDefaultState() {
        
        self.campaignId = 0
        
        self.titleCampaign = ""
        self.descriptionCampaign = ""
        self.terminateCampaign = ""
        self.statusCampaign = ""
        self.amountCampaign = 0.0
        self.startDateCampaign = ""
        self.endDateCampaign = ""
        
        self.collectedCampaign = 0
        self.contributionCampaign = 0
        self.contributorCampaign = 0
        
        self.mediaList = []
        
        self.createdByUser = nil
    }
}

class CampaignObjectMapper: Mappable {
    
    var campaignId: Int! = nil
    
    var titleCampaign: String! = nil
    var descriptionCampaign: String! = nil
    var terminateCampaign: String! = nil
    var statusCampaign: String! = nil
    var startDateCampaign: String! = nil
    var endDateCampaign: String! = nil
   
    var amountCampaign: CGFloat! = nil
    var collectedCampaign: CGFloat! = nil
    var contributionCampaign: CGFloat! = nil
    var contributorCampaign: Int! = nil
    
    var mediaList: [String] = []
    
    var createdByUser: UserProfileMapper! = nil
    
    init() {
        
    }
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        
        self.campaignId <- map["Id"]
        self.titleCampaign <- map["Title"]
        self.descriptionCampaign <- map["Description"]
        self.terminateCampaign <- map["Terminate"]
        self.statusCampaign <- map["Status"]
        self.amountCampaign <- map["Amount"]
        self.startDateCampaign <- map["Start"]
        self.endDateCampaign <- map["End"]
        self.collectedCampaign <- map["collection.Amount"]
        self.contributorCampaign <- map["collection.Count"]
        self.contributionCampaign <- map["contribution"]
        
        self.createdByUser <- map["User"]
    }
}

class PostObjectMapper: Mappable {
    
    var postId: Int! = nil
    var groupId: Int! = nil
    var userId: Int! = nil
    
    var postText: String! = nil
    var postCreatedBy: String! = nil
    
    var createdByUser: UserProfileMapper! = nil
    
    var postCreatedDate: String! = nil
    var postModifiedDate: String! = nil
    var postModifiedBy: String! = nil
    
    var isDeletedPost: Bool! = nil
    var isCommentablePost: Bool! = nil
    var isShareablePost: Bool! = nil
    
    var contents: [PostContentMapper] = []
    
    var comments: [PostCommentMapper] = []
    
    init() {
        
    }
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        
        if map["Id"].isKeyPresent {
        
            self.postId <- map["Id"]
        }
        else if map["PostId"].isKeyPresent {
            
            self.postId <- map["PostId"]
        }
        else if map["Data.Id"].isKeyPresent {
            
            self.postId <- map["Data.Id"]
        }
        
        if map["GroupId"].isKeyPresent {
            
            self.groupId <- map["GroupId"]
        }
        
        if map["UserId"].isKeyPresent {
            
            self.userId <- map["UserId"]
        }
        
        if map["Text"].isKeyPresent {
            
            self.postText <- map["Text"]
        }
        else if map["Data.Text"].isKeyPresent {
            
            self.postText <- map["Data.Text"]
        }
        
        if map["User"].isKeyPresent {
            
            self.createdByUser <- map["User"]
        }
        else if map["Data.User"].isKeyPresent {
            
            self.createdByUser <- map["Data.User"]
        }
        
        if map["CreatedDate"].isKeyPresent {
            
            self.postCreatedDate <- map["CreatedDate"]
        }
        else if map["Data.CreatedDate"].isKeyPresent {
            
            self.postCreatedDate <- map["Data.CreatedDate"]
        }
        
        self.postCreatedBy <- map["CreatedBy"]
        self.postModifiedDate <- map["ModifiedDate"]
        self.postModifiedBy <- map["ModifiedBy"]
        
        self.isDeletedPost <- map["IsDeleted"]
        self.isCommentablePost <- map["IsCommentable"]
        self.isShareablePost <- map["IsShareable"]
        
        if map["Contents"].isKeyPresent {
            
            self.contents <- map["Contents"]
        }
        else if map["Data.Contents"].isKeyPresent {
            
            self.contents <- map["Data.Contents"]
        }
        
        if map["Comments"].isKeyPresent {
            
            self.comments <- map["Comments"]
        }
        else if map["Data.Comments"].isKeyPresent {
            
            self.comments <- map["Data.Comments"]
        }
    }
}

/*
 
 {"PostId":1,"GroupId":32,"UserId":"04b6ddf0-6107-4bb9-bbe6-65e6440c5786","Text":"My First Post","CreatedBy":"04b6ddf0-6107-4bb9-bbe6-65e6440c5786","CreatedDate":"2018-04-18T15:08:49.343","ModifiedDate":"2018-04-18T15:08:49.343","ModifiedBy":"04b6ddf0-6107-4bb9-bbe6-65e6440c5786","IsCommentable":false,"IsShareable":false,"IsDeleted":false,"Contents":[]}
 
 */

// MARK: - Post List

class PostsListMapper: Mappable {
    
    var postsList: [PostObjectMapper] = []
    
    init() {
        
    }
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
    
        if map["Posts"].isKeyPresent {
            
            self.postsList <- map["Posts"]
        }
        if map["Data"].isKeyPresent {
            
            self.postsList <- map["Data"]
        }
        else {
            
            self.postsList <- map["data"]
        }
    }
}

// MARK: - Post Comment

class PostComment: NSObject {
    
    var commentId: Int!
    var commentText: String!
    var commentCreateDate: String!
    var user: UserProfile!
    
    override init() {
        super.init()
        self.setupDefaultState()
    }
    
    private func setupDefaultState() {
        
        self.commentId = 0
        
        self.commentText = ""
        self.commentCreateDate = ""
        
        self.user = nil
    }
}

class PostCommentMapper: Mappable {
    
    var commentId: Int!
    var commentText: String!
    var commentCreateDate: String!
    var user: UserProfileMapper!
    
    init() {
        
    }
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        
        self.commentId <- map["ID"]
        self.commentText <- map["Text"]
        self.commentCreateDate <- map["CreatedDate"]
        self.user <- map["User"]
    }
}

// MARK: - Post Comments List

class PostCommentsListMapper: Mappable {
    
    var postCommentsList: [PostObjectMapper] = []
    
    init() {
        
    }
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        
        if map["Comments"].isKeyPresent {
            
            self.postCommentsList <- map["Comments"]
        }
        else {
            
            self.postCommentsList <- map["data"]
        }
    }
}
