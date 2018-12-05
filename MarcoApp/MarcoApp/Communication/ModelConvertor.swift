//
//  ModelConvertor.swift
//  MarcoApp
//
//  Created by Nabeel Hayat on 17/01/2018.
//  Copyright © 2018 GrayScaleLogic. All rights reserved.
//

import UIKit

class ModelConvertor: NSObject {
    
    class func convertToCampaignList(_ campaignMapperList: CampaignObjectMapperList) -> [CampaignObject] {
        
        var campaignsList: [CampaignObject] = []
        
        for campaignObjectMapper: CampaignObjectMapper in campaignMapperList.campaignList {
            
            campaignsList.append(ModelConvertor.convertToCampaignObject(campaignObjectMapper))
        }
        
        return campaignsList
    }
    
    class func convertToPostObjectsList(_ postsListMapper: PostsListMapper) -> [PostObject] {
        
        var postsList: [PostObject] = []
        
        for postObjectMapper: PostObjectMapper in postsListMapper.postsList {
        
            postsList.append(ModelConvertor.convertToPostObject(postObjectMapper))
        }
        
        return postsList
    }
    
    class func convertToCampaignObject(_ campaignObjectMapper: CampaignObjectMapper) -> CampaignObject {
        
        let campaignObject: CampaignObject = CampaignObject()
        
        campaignObject.campaignId = campaignObjectMapper.campaignId
        
        campaignObject.titleCampaign = campaignObjectMapper.titleCampaign
        campaignObject.descriptionCampaign = campaignObjectMapper.descriptionCampaign
        campaignObject.terminateCampaign = campaignObjectMapper.terminateCampaign
        campaignObject.statusCampaign = campaignObjectMapper.statusCampaign
        campaignObject.amountCampaign = campaignObjectMapper.amountCampaign
        campaignObject.startDateCampaign = campaignObjectMapper.startDateCampaign
        campaignObject.endDateCampaign = campaignObjectMapper.endDateCampaign
        
        campaignObject.collectedCampaign = campaignObjectMapper.collectedCampaign
        campaignObject.contributionCampaign = campaignObjectMapper.contributionCampaign
        campaignObject.contributorCampaign = campaignObjectMapper.contributorCampaign
        
        campaignObject.mediaList = campaignObjectMapper.mediaList
        
        campaignObject.createdByUser = ModelConvertor.convertToUserProfileFromMapper(campaignObjectMapper.createdByUser)
        
        return campaignObject
    }
    
    class func convertToPostObject(_ postObjectMapper: PostObjectMapper) -> PostObject {
        
        let postObject: PostObject = PostObject()
        
        postObject.postId = postObjectMapper.postId
        postObject.groupId = postObjectMapper.groupId
        postObject.userId = postObjectMapper.userId
        
        postObject.postText = postObjectMapper.postText
        postObject.postCreatedBy = postObjectMapper.postCreatedBy
        postObject.postCreatedDate = postObjectMapper.postCreatedDate
        postObject.postModifiedBy = postObjectMapper.postModifiedBy
        postObject.postModifiedDate = postObjectMapper.postModifiedDate
        
        postObject.createdByUser = ModelConvertor.convertToUserProfileFromMapper(postObjectMapper.createdByUser)
        
        postObject.isDeletedPost = postObjectMapper.isDeletedPost
        postObject.isCommentablePost = postObjectMapper.isCommentablePost
        postObject.isShareablePost = postObjectMapper.isShareablePost
        
        postObject.contents = ModelConvertor.convertToPostContentList(postObjectMapper.contents)
        
        postObject.comments = ModelConvertor.convertToPostCommentsList(postObjectMapper.comments)
        
        return postObject
    }
    
    class func convertToPostCommentsList(_ postCommentsList: [PostCommentMapper]) -> [PostComment] {
        
        var postCommentObjectList: [PostComment] = []
        
        for postCommentMapper: PostCommentMapper in postCommentsList {
            
            postCommentObjectList.append(ModelConvertor.convertToCommentObject(postCommentMapper))
        }
        
        return postCommentObjectList
    }
    
    class func convertToCommentObject(_ postCommentMappper: PostCommentMapper) -> PostComment {
        
        let postComment: PostComment = PostComment()
        
        postComment.commentId = postCommentMappper.commentId
        postComment.commentText = postCommentMappper.commentText
        postComment.commentCreateDate = postCommentMappper.commentCreateDate
        
        postComment.user = ModelConvertor.convertToUserProfileFromMapper(postCommentMappper.user)
        
        return postComment
    }
    
    class func convertToPostContentList(_ postContentMapperList: [PostContentMapper]) -> [PostContent] {
        
        var postContentsList: [PostContent] = []
        
        for postContentMapper: PostContentMapper in postContentMapperList {
            
            postContentsList.append(ModelConvertor.convertToPostContent(postContentMapper))
        }
        
        return postContentsList
        
    }
    
    class func convertToPostContent(_ postContentMapper: PostContentMapper) -> PostContent {
        
        let postContent: PostContent = PostContent()
        
        postContent.postId = postContentMapper.postId
        postContent.contentURL = postContentMapper.contentURL
        postContent.contentCreatedDate = postContentMapper.contentCreatedDate
        postContent.contentModifiedDate = postContentMapper.contentModifiedDate
        
        return postContent
    }
    
    class func convertToGroupObjectList(_ groupsEntityList: [GroupEntity]) -> [GroupObject] {
        
        var groupsList: [GroupObject] = []
        
        for groupEntity: GroupEntity in groupsEntityList {
            
            groupsList.append(ModelConvertor.convertToGroupObject(groupEntity))
        }
        
        return groupsList
    }
    
    class func convertToGroupObject(_ groupEntity: GroupEntity) -> GroupObject {
        
        let groupObject: GroupObject = GroupObject()
        
        groupObject.groupId = Int(groupEntity.groupId)
        groupObject.groupCategoryId = Int(groupEntity.groupCategoryId)
        groupObject.groupPriceId = Int(groupEntity.groupPriceId)
        
        groupObject.groupPrice = groupEntity.groupPrice
        
        groupObject.totalMembers = NSNumber(value: groupEntity.groupTotalMembers)
        
        groupObject.groupTitle = groupEntity.groupTitle
        groupObject.groupDescription = groupEntity.groupDescription
        groupObject.groupProfilePicture = groupEntity.groupProfilePicture
        groupObject.groupCoverPicture = groupEntity.groupCoverPicture
        groupObject.groupCreatedDate = groupEntity.groupCreatedDate
        groupObject.groupJoinDate = groupEntity.groupJoinDate
        groupObject.groupModifiedDate = groupEntity.groupModifiedDate
        
        
        groupObject.isPaidGroup = groupEntity.isPaidGroup
        groupObject.isPrivateGroup = groupEntity.isPrivateGroup
        groupObject.isDeletedGroup = groupEntity.isDeletedGroup
        groupObject.isUserCanJoin = groupEntity.isUserCanJoin
        
        groupObject.groupCreator = ModelConvertor.convertToGroupMember(groupEntity.groupMember!
)
        groupObject.groupCreatedBy = (groupEntity.groupCreatedBy == nil || groupEntity.groupCreatedBy == "") ? groupObject.groupCreator.userId : groupEntity.groupCreatedBy
        
        groupObject.groupMembers = []
        
        return groupObject
    }
    
    class func convertToGroupObjectList(_ groupsListMapper: GroupsListMapper) -> [GroupObject] {
        
        var groupsList: [GroupObject] = []
        
        for groupObjectMapper: GroupObjectMapper in groupsListMapper.groupsList {
            
            groupsList.append(ModelConvertor.convertToGroupObject(groupObjectMapper))
        }
        
        return groupsList
    }

    class func convertToGroupObject(_ groupObjectMapper: GroupObjectMapper) -> GroupObject {
        
        let groupObject: GroupObject = GroupObject()
        
        groupObject.groupId = groupObjectMapper.groupId
        groupObject.groupTitle = groupObjectMapper.groupTitle
        groupObject.groupDescription = groupObjectMapper.groupDescription
        groupObject.groupProfilePicture = groupObjectMapper.groupProfilePicture
        groupObject.groupCoverPicture = groupObjectMapper.groupCoverPicture
        
        groupObject.groupCategoryId = groupObjectMapper.groupCategoryId
        groupObject.groupPrice = groupObjectMapper.groupPrice
        groupObject.groupPriceId = groupObjectMapper.groupPriceId
        groupObject.isPaidGroup = groupObjectMapper.isPaidGroup
        groupObject.isPrivateGroup = groupObjectMapper.isPrivateGroup
        groupObject.groupCreatedDate = groupObjectMapper.groupCreatedDate
        groupObject.groupJoinDate = groupObjectMapper.groupJoinDate
        groupObject.groupModifiedDate = groupObjectMapper.groupModifiedDate
        groupObject.isDeletedGroup = groupObjectMapper.isDeletedGroup
        groupObject.totalMembers = groupObjectMapper.totalMembers
        groupObject.totalPosts = groupObjectMapper.totalPosts
        groupObject.isUserCanJoin = groupObjectMapper.isUserCanJoin
        
        groupObject.groupCreator = ModelConvertor.convertToUserProfileFromMapper(groupObjectMapper.groupCreator)
        
        groupObject.groupCreatedBy = (groupObjectMapper.groupCreatedBy == nil || groupObjectMapper.groupCreatedBy == "") ? groupObject.groupCreator.userId : groupObjectMapper.groupCreatedBy
        
        
        return groupObject
    }
    
    class func convertToGroupMember(_ userProfileEntity: GroupMembersEntity) -> UserProfile {
        
        let userProfileMapper: UserProfile = UserProfile()
        
        userProfileMapper.userId = userProfileEntity.userId
        
        if userProfileEntity.fullName == "" {
            
            userProfileMapper.fullName = userProfileEntity.firstName! + " " + userProfileEntity.lastName!
        }
        else {
            userProfileMapper.fullName = userProfileEntity.fullName
        }
        
        userProfileMapper.channel = userProfileEntity.channel
        
        userProfileMapper.firstName = userProfileEntity.firstName
        userProfileMapper.lastName = userProfileEntity.lastName
        userProfileMapper.email = userProfileEntity.email
        userProfileMapper.gender = userProfileEntity.gender
        userProfileMapper.birthday = userProfileEntity.birthday
        userProfileMapper.maritalStatus.statusTitle = userProfileEntity.maritalStatus
        userProfileMapper.maritalStatus.statusId = userProfileEntity.maritalStatus?.getMaritalStatusId()
        userProfileMapper.about = userProfileEntity.about
        userProfileMapper.timezone = userProfileEntity.timezone
        userProfileMapper.locale = userProfileEntity.locale
        userProfileMapper.profilePicture = userProfileEntity.profilePicture
        userProfileMapper.locationAddress = userProfileEntity.locationAddress
        userProfileMapper.interest = userProfileEntity.interest
        userProfileMapper.designation = userProfileEntity.designation
        userProfileMapper.phoneNumber = userProfileEntity.phoneNumber
        userProfileMapper.location.lat = Double(userProfileEntity.locationLat)
        userProfileMapper.location.lon = Double(userProfileEntity.locationLon)
        userProfileMapper.zodiac = userProfileEntity.zodiac
        userProfileMapper.coverPicture = userProfileEntity.coverPicture
        userProfileMapper.isStripeCustomer = false
        
        return userProfileMapper
    }
    
    class func convertToUserProfile(_ userProfileEntity: UserProfileEntity) -> UserProfile {
        
        let userProfileMapper: UserProfile = UserProfile()
        
        userProfileMapper.userId = userProfileEntity.userId
        
        if userProfileEntity.fullName == "" {
            
            userProfileMapper.fullName = userProfileEntity.firstName! + " " + userProfileEntity.lastName!
        }
        else {
            userProfileMapper.fullName = userProfileEntity.fullName
        }
        
        userProfileMapper.channel = userProfileEntity.channel
        
        userProfileMapper.firstName = userProfileEntity.firstName
        userProfileMapper.lastName = userProfileEntity.lastName
        userProfileMapper.email = userProfileEntity.email
        userProfileMapper.gender = userProfileEntity.gender
        userProfileMapper.birthday = userProfileEntity.birthday
        userProfileMapper.maritalStatus.statusTitle = userProfileEntity.maritalStatus
        userProfileMapper.maritalStatus.statusId = userProfileEntity.maritalStatus?.getMaritalStatusId()
        userProfileMapper.about = userProfileEntity.about
        userProfileMapper.timezone = userProfileEntity.timezone
        userProfileMapper.locale = userProfileEntity.locale
        userProfileMapper.profilePicture = userProfileEntity.profilePicture
        userProfileMapper.locationAddress = userProfileEntity.locationAddress
        userProfileMapper.interest = userProfileEntity.interest
        userProfileMapper.designation = userProfileEntity.designation
        userProfileMapper.phoneNumber = userProfileEntity.phoneNumber
        userProfileMapper.location.lat = Double(userProfileEntity.locationLat)
        userProfileMapper.location.lon = Double(userProfileEntity.locationLon)
        userProfileMapper.zodiac = userProfileEntity.zodiac
        userProfileMapper.coverPicture = userProfileEntity.coverPicture
        
        userProfileMapper.isFavorite = userProfileEntity.isFavorite
        userProfileMapper.isStripeCustomer = userProfileEntity.isStripeCustomer
        
        return userProfileMapper
    }

    
    class func convertToUserProfileMapper(_ userProfile: UserProfile) -> UserProfileMapper {
        
        let userProfileMapper: UserProfileMapper = UserProfileMapper()
        
        userProfileMapper.userId = userProfile.userId
        
        if userProfile.fullName == "" {
            
            userProfileMapper.fullName = userProfile.firstName + " " + userProfile.lastName
        }
        else {
            userProfileMapper.fullName = userProfile.fullName
        }
        
        userProfileMapper.channel = userProfile.channel
        
        userProfileMapper.firstName = userProfile.firstName
        userProfileMapper.lastName = userProfile.lastName
        userProfileMapper.email = userProfile.email
        userProfileMapper.gender = userProfile.gender
        userProfileMapper.birthday = userProfile.birthday

//        userProfileMapper.meritalStatus = userProfile.meritalStatus

        userProfileMapper.maritalStatus = userProfile.maritalStatus

        userProfileMapper.about = userProfile.about
        userProfileMapper.timezone = userProfile.timezone
        userProfileMapper.locale = userProfile.locale
        userProfileMapper.profilePicture = userProfile.profilePicture
        userProfileMapper.locationAddress = userProfile.locationAddress
        userProfileMapper.interest = userProfile.interest
        userProfileMapper.designation = userProfile.designation
        userProfileMapper.phoneNumber = userProfile.phoneNumber
        userProfileMapper.location = userProfile.location
        userProfileMapper.zodiac = userProfile.zodiac
        userProfileMapper.coverPicture = userProfile.coverPicture
        userProfileMapper.isFavorite = userProfile.isFavorite
        
        return userProfileMapper
    }
    
    class func convertToUserProfileList(_ userProfileList: [UserProfileMapper]) -> [UserProfile] {
        
        var profilesList: [UserProfile] = []
        
        for userProfileMapper: UserProfileMapper in userProfileList {
            
            profilesList.append(ModelConvertor.convertToUserProfileFromMapper(userProfileMapper))
        }
        
        return profilesList
    }
    
    class func convertToUserProfileList(_ userProfileListMapper: UserProfileListMapper) -> [UserProfile] {
        
        var profilesList: [UserProfile] = []
        
        for userProfileMapper: UserProfileMapper in userProfileListMapper.userProfileList {
            
            profilesList.append(ModelConvertor.convertToUserProfileFromMapper(userProfileMapper))
        }
        
        return profilesList
    }
    
    class func convertToUserProfileFromMapper(_ userProfile: UserProfileMapper) -> UserProfile {
        
        let userProfileMapper: UserProfile = UserProfile()
        
        if userProfile.userId == "" || userProfile.userId == nil {
            
            if userProfile.userIdInt != nil {
                
                userProfileMapper.userId = String(userProfile.userIdInt)
            }
            else {
                
                userProfileMapper.userId = ""
            }
        }
        else {
         
            userProfileMapper.userId = userProfile.userId
        }
        
        if userProfile.fullName == "" {
            
            if let firstName: String = userProfile.firstName {
                
                userProfileMapper.fullName = firstName
                
                if let lastName: String = userProfile.lastName {
                 
                    userProfileMapper.fullName = userProfileMapper.fullName + " " + lastName
                }
            }
        }
        else {
            userProfileMapper.fullName = userProfile.fullName
        }
        
        userProfileMapper.channel = userProfile.channel
        
        userProfileMapper.firstName = userProfile.firstName
        userProfileMapper.lastName = userProfile.lastName
        userProfileMapper.email = userProfile.email
        userProfileMapper.gender = userProfile.gender
        userProfileMapper.birthday = userProfile.birthday
        
        //        userProfileMapper.meritalStatus = userProfile.meritalStatus
        
        userProfileMapper.maritalStatus = userProfile.maritalStatus
        
        userProfileMapper.about = userProfile.about
        userProfileMapper.timezone = userProfile.timezone
        userProfileMapper.locale = userProfile.locale
        userProfileMapper.profilePicture = userProfile.profilePicture
        userProfileMapper.locationAddress = userProfile.locationAddress
        userProfileMapper.interest = userProfile.interest
        userProfileMapper.designation = userProfile.designation
        userProfileMapper.phoneNumber = userProfile.phoneNumber
        userProfileMapper.location = userProfile.location
        userProfileMapper.zodiac = userProfile.zodiac
        userProfileMapper.coverPicture = userProfile.coverPicture
        userProfileMapper.isFavorite = userProfile.isFavorite
        
        return userProfileMapper
    }
    
}
