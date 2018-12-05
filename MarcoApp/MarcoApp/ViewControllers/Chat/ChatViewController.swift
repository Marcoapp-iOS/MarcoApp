//
//  ChatViewController.swift
//  MarcoApp
//
//  Created by Nabeel Hayat on 09/12/2017.
//  Copyright © 2017 GrayScaleLogic. All rights reserved.
//

import UIKit
import PubNub
import SDWebImage
import ObjectMapper

class ChatViewController: JSQMessagesViewController {

    var messages = [JSQMessage]()
    //var conversation: Conversation?
    var incomingBubble: JSQMessagesBubbleImage!
    var outgoingBubble: JSQMessagesBubbleImage!
    //fileprivate var displayName: String!
    
    var userProfile: UserProfile!
    var loginUserProfile: UserProfile!
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        NotificationCenter.default.addObserver(self, selector: #selector(didReceiveMessageNotification(_:)), name: .DidReceiveMessageNotification, object: nil)
        
        self.setupViews()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        self.navigationController?.navigationBar.isTranslucent = false

        self.getChatHistory()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        self.navigationController?.navigationBar.isTranslucent = true

    }
    
    // MARK: - Helper Functions
    
    func setupViews() {

        self.navigationController?.navigationBar.barTintColor = AppTheme.blackColor

        self.view.backgroundColor = AppTheme.chatBgColor
        
        incomingBubble = JSQMessagesBubbleImageFactory().incomingMessagesBubbleImage(with: AppTheme.whiteColor)
        outgoingBubble = JSQMessagesBubbleImageFactory().outgoingMessagesBubbleImage(with: AppTheme.blackColor)
        
        collectionView?.collectionViewLayout.incomingAvatarViewSize = CGSize(width: kJSQMessagesCollectionViewAvatarSizeDefault, height:kJSQMessagesCollectionViewAvatarSizeDefault )
        collectionView?.collectionViewLayout.outgoingAvatarViewSize = CGSize(width: kJSQMessagesCollectionViewAvatarSizeDefault, height:kJSQMessagesCollectionViewAvatarSizeDefault )
        
        self.collectionView?.dataSource = self
        self.collectionView?.backgroundColor = AppTheme.chatBgColor
        
        self.automaticallyScrollsToMostRecentMessage = true
        self.collectionView?.collectionViewLayout.springinessEnabled = false
        
        self.collectionView?.showsVerticalScrollIndicator = true
        self.collectionView?.showsHorizontalScrollIndicator = true
        self.collectionView?.alwaysBounceVertical = true
        self.showTypingIndicator = false
        self.showLoadEarlierMessagesHeader = false
        self.scrollToBottom(animated: true)
        self.collectionView!.isUserInteractionEnabled = true
        self.collectionView!.allowsSelection = true
        self.collectionView?.reloadData()
        self.collectionView?.layoutIfNeeded()
    }
    
    fileprivate func getChatHistory() {
        
        self.appDelegate.clientPubNub.historyForChannel(self.userProfile.channel, start: nil, end: nil, limit: 100) { (result, status) in
            
            if let historyResult = result {
                
                print("Loaded history data: \(historyResult.data.messages) with start \(historyResult.data.start.intValue) and end \(historyResult.data.end.intValue)")
                
                self.handleHistoryResponse(historyResult.data)
            }
            
            if let historyStatus = status {
                
                print(historyStatus.authKey ?? "")
                print(historyStatus.uuid)
                print(historyStatus.origin)
                print(historyStatus.clientRequest ?? "")
            }
        }
    }
    
    fileprivate func parseMessageObject(messageObject: Any) {
        
        var messageObjectMapper: ChatMessageObjectMapper = ChatMessageObjectMapper()
        
        var invalidMessageFormat: Bool = false
        
        if messageObject is NSDictionary {
            
            messageObjectMapper = Mapper<ChatMessageObjectMapper>().map(JSONObject: messageObject)!
        }
        else if messageObject is String {
            
            messageObjectMapper = Mapper<ChatMessageObjectMapper>().map(JSONString: messageObject as! String)!
        }
        else {
            
            invalidMessageFormat = true
        }
        
        (invalidMessageFormat) ? () : self.handleMessageResponse(messageObjectMapper, true)
    }
    
    fileprivate func handleHistoryResponse(_ historyData: PNHistoryData) {
        
        for messageObject: Any in historyData.messages {
            
            self.parseMessageObject(messageObject: messageObject)
        }
        
        self.collectionView?.reloadData()

        self.scrollToBottom(animated: true)
    }
    
    fileprivate func handleMessageResponse(_ messageObject: ChatMessageObjectMapper, _ isHistory: Bool = false) {
        
        if messageObject.message != nil {
         
            let message: String = messageObject.message
            let publisher: String = messageObject.publisher
            let date: String = messageObject.date
            
            let publisherProfile: UserProfile = (publisher == self.userProfile.userId) ? userProfile : loginUserProfile
            
            let newMessage: JSQMessage = JSQMessage(senderId: publisher, senderDisplayName: publisherProfile.firstName, date: Date(), text: message)
            
            self.messages.append(newMessage)
            
            if isHistory {
                
                self.collectionView?.reloadData()
            }
            else {
                self.finishReceivingMessage(animated: true)
            }
            
            //        if let messageString: String = messageObject as? String {
            //
            //            print(messageString)
            //        }
            //
            //        if let messageDictionary: [String: String] = messageObject as? [String: String]  {
            //
            //            let message: String = messageDictionary["text"]!
            //            let publisher: String = messageDictionary["publisher"]!
            //            //                let date: String = messageDictionary["date"]!
            //            let publisherProfile: UserProfile = (publisher == self.userProfile.userId) ? userProfile : loginUserProfile
            //
            //            let newMessage: JSQMessage = JSQMessage(senderId: publisher, senderDisplayName: publisherProfile.firstName, date: Date(), text: message)
            //
            //            self.messages.append(newMessage)
            //
            //            if isHistory {
            //
            //                self.collectionView?.reloadData()
            //            }
            //            else {
            //                self.finishReceivingMessage(animated: true)
            //            }
            //        }
        }
    }
    
    func getChatMessageMapperString(_ message: String, publisher: String, date: String) -> String {
        
        let chatMessageObjectMapper: ChatMessageObjectMapper = ChatMessageObjectMapper()
        
        chatMessageObjectMapper.message = message
        chatMessageObjectMapper.publisher = publisher
        chatMessageObjectMapper.date = date
        
        let stringMapper = Mapper<ChatMessageObjectMapper>().toJSONString(chatMessageObjectMapper, prettyPrint: false)
        
        return stringMapper!
    }
    
    func sendRequestForPublishMessage(_ message: String) {
        
        let messageString: String = self.getChatMessageMapperString(message, publisher: self.loginUserProfile.userId, date: Date().dateString())
        
        let payloads = [
            "aps" : [
                "alert" : [
                    "title" : self.loginUserProfile.firstName,
                    "body" : message],
                "sound" : "marco_alert.aiff",
                "publisher" : self.loginUserProfile.userId,
                "date" : Date().dateString()]
            ] as [String : Any]
        
        let metaData = ["uuid": self.appDelegate.clientPubNub.currentConfiguration().uuid]
        
        self.appDelegate.clientPubNub.publish(messageString, toChannel: self.userProfile.channel, mobilePushPayload: payloads, storeInHistory: true, compressed: true, withMetadata: metaData) { (status) in
            
            
        }
        
        let messageObject: [String: Any] = ["text": message, "publisher": self.loginUserProfile.userId, "date": Date().dateString()]
        
        let notifiObject: Any = messageObject as Any
        
        self.parseMessageObject(messageObject: notifiObject)
    }
    
    func receiveMessagePressed(_ sender: UIBarButtonItem) {
        /**
         *  DEMO ONLY
         *
         *  The following is simply to simulate received messages for the demo.
         *  Do not actually do this.
         */
        
        /**
         *  Show the typing indicator to be shown
         */
        self.showTypingIndicator = !self.showTypingIndicator
        
        /**
         *  Scroll to actually view the indicator
         */
        self.scrollToBottom(animated: true)
        
        /**
         *  Copy last sent message, this will be the new "received" message
         */
        var copyMessage = self.messages.last?.copy()
        
        if (copyMessage == nil) {
            copyMessage = JSQMessage(senderId: AvatarIdJobs, displayName: getName(User.Jobs), text: "First received!")
        }
        
        var newMessage:JSQMessage!
        var newMediaData:JSQMessageMediaData!
        var newMediaAttachmentCopy:AnyObject?
        
        if (copyMessage! as AnyObject).isMediaMessage() {
            /**
             *  Last message was a media message
             */
            let copyMediaData = (copyMessage! as AnyObject).media
            
            switch copyMediaData {
            case is JSQPhotoMediaItem:
                let photoItemCopy = (copyMediaData as! JSQPhotoMediaItem).copy() as! JSQPhotoMediaItem
                photoItemCopy.appliesMediaViewMaskAsOutgoing = false
                
                newMediaAttachmentCopy = UIImage(cgImage: photoItemCopy.image!.cgImage!)
                
                /**
                 *  Set image to nil to simulate "downloading" the image
                 *  and show the placeholder view5017
                 */
                photoItemCopy.image = nil;
                
                newMediaData = photoItemCopy
            case is JSQLocationMediaItem:
                let locationItemCopy = (copyMediaData as! JSQLocationMediaItem).copy() as! JSQLocationMediaItem
                locationItemCopy.appliesMediaViewMaskAsOutgoing = false
                newMediaAttachmentCopy = locationItemCopy.location!.copy() as AnyObject?
                
                /**
                 *  Set location to nil to simulate "downloading" the location data
                 */
                locationItemCopy.location = nil;
                
                newMediaData = locationItemCopy;
            case is JSQVideoMediaItem:
                let videoItemCopy = (copyMediaData as! JSQVideoMediaItem).copy() as! JSQVideoMediaItem
                videoItemCopy.appliesMediaViewMaskAsOutgoing = false
                newMediaAttachmentCopy = (videoItemCopy.fileURL! as NSURL).copy() as AnyObject?
                
                /**
                 *  Reset video item to simulate "downloading" the video
                 */
                videoItemCopy.fileURL = nil;
                videoItemCopy.isReadyToPlay = false;
                
                newMediaData = videoItemCopy;
            case is JSQAudioMediaItem:
                let audioItemCopy = (copyMediaData as! JSQAudioMediaItem).copy() as! JSQAudioMediaItem
                audioItemCopy.appliesMediaViewMaskAsOutgoing = false
                newMediaAttachmentCopy = (audioItemCopy.audioData! as NSData).copy() as AnyObject?
                
                /**
                 *  Reset audio item to simulate "downloading" the audio
                 */
                audioItemCopy.audioData = nil;
                
                newMediaData = audioItemCopy;
            default:
                assertionFailure("Error: This Media type was not recognised")
            }
            
            newMessage = JSQMessage(senderId: AvatarIdJobs, displayName: getName(User.Jobs), media: newMediaData)
        }
        else {
            /**
             *  Last message was a text message
             */
            
            newMessage = JSQMessage(senderId: AvatarIdJobs, displayName: getName(User.Jobs), text: (copyMessage! as AnyObject).text)
        }
        
        /**
         *  Upon receiving a message, you should:
         *
         *  1. Play sound (optional)
         *  2. Add new JSQMessageData object to your data source
         *  3. Call `finishReceivingMessage`
         */
        
        self.messages.append(newMessage)
        self.finishReceivingMessage(animated: true)
        
        if newMessage.isMediaMessage {
            /**
             *  Simulate "downloading" media
             */
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + Double(Int64(1 * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)) {
                /**
                 *  Media is "finished downloading", re-display visible cells
                 *
                 *  If media cell is not visible, the next time it is dequeued the view controller will display its new attachment data
                 *
                 *  Reload the specific item, or simply call `reloadData`
                 */
                
                switch newMediaData {
                case is JSQPhotoMediaItem:
                    (newMediaData as! JSQPhotoMediaItem).image = newMediaAttachmentCopy as? UIImage
                    self.collectionView!.reloadData()
                case is JSQLocationMediaItem:
                    (newMediaData as! JSQLocationMediaItem).setLocation(newMediaAttachmentCopy as? CLLocation, withCompletionHandler: {
                        self.collectionView!.reloadData()
                    })
                case is JSQVideoMediaItem:
                    (newMediaData as! JSQVideoMediaItem).fileURL = newMediaAttachmentCopy as? URL
                    (newMediaData as! JSQVideoMediaItem).isReadyToPlay = true
                    self.collectionView!.reloadData()
                case is JSQAudioMediaItem:
                    (newMediaData as! JSQAudioMediaItem).audioData = newMediaAttachmentCopy as? Data
                    self.collectionView!.reloadData()
                default:
                    assertionFailure("Error: This Media type was not recognised")
                }
            }
        }
    }
    
    // MARK: - Notification
    
    @objc func didReceiveMessageNotification(_ notification: Notification) {
        
        let notifiObject: Any = notification.object!
        
        self.parseMessageObject(messageObject: notifiObject)
        
        self.collectionView?.reloadData()
    }
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
}

// MARK: JSQMessagesViewController method overrides

extension ChatViewController {
    
    override func didPressSend(_ button: UIButton, withMessageText text: String, senderId: String, senderDisplayName: String, date: Date) {
        
        self.inputToolbar.contentView?.textView?.text = ""
        
        if text != "" {
            
            self.sendRequestForPublishMessage(text)
        }
    }
    
    override func didPressAccessoryButton(_ sender: UIButton) {
        
    }
}

//MARK: JSQMessages CollectionView DataSource

extension ChatViewController {

    override func senderId() -> String {
        return self.loginUserProfile.userId
    }
    
    override func senderDisplayName() -> String {
        return self.loginUserProfile.firstName
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return messages.count
    }
    
    fileprivate func setAvatarImage(_ cell: JSQMessagesCollectionViewCell, profilePicture: String) {
    
        let avatarUrl: String? = profilePicture
        
        if avatarUrl != "" && avatarUrl != nil {
            
            cell.avatarImageView?.sd_setImage(with: URL(string: avatarUrl!)!, placeholderImage: UIImage(named: "user_default"), options: .refreshCached, progress: nil, completed: { (image, error, imageCacheType, url) in
                
                
            })
        }
        else {
            
            cell.avatarImageView?.image = UIImage(named: "user_default")
        }
        
        cell.avatarImageView?.layer.cornerRadius = (cell.avatarImageView?.frame.size.height)!/2.0
        cell.avatarImageView?.layer.masksToBounds = false
        cell.avatarImageView?.clipsToBounds = true
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        /**
         *  Override point for customizing cells
         */
        
        let cell: JSQMessagesCollectionViewCell = super.collectionView(collectionView, cellForItemAt: indexPath) as! JSQMessagesCollectionViewCell
        
        let message = self.messages[indexPath.row]
        
        //check if outgoing
        if message.senderId == self.senderId() {
            
            self.setAvatarImage(cell, profilePicture: self.loginUserProfile.profilePicture)
            
            cell.textView?.textColor = AppTheme.whiteColor
        }
        else{
            
            self.setAvatarImage(cell, profilePicture: self.userProfile.profilePicture)
            
            cell.textView?.textColor = AppTheme.blackColor
            
         
        }
            return cell;
    }
    
    override func collectionView(_ collectionView: JSQMessagesCollectionView, messageDataForItemAt indexPath: IndexPath) -> JSQMessageData {
        return messages[indexPath.item]
    }
    
    override func collectionView(_ collectionView: JSQMessagesCollectionView, messageBubbleImageDataForItemAt indexPath: IndexPath) -> JSQMessageBubbleImageDataSource {
        
        return messages[indexPath.item].senderId == self.senderId() ? outgoingBubble : incomingBubble
    }
    
    override func collectionView(_ collectionView: JSQMessagesCollectionView, avatarImageDataForItemAt indexPath: IndexPath) -> JSQMessageAvatarImageDataSource? {
        
        let message: JSQMessage = messages[indexPath.item]
        
        let avatarInitials = JSQMessagesAvatarImageFactory().avatarImage(withUserInitials: message.senderDisplayName, backgroundColor: AppTheme.whiteColor, textColor: AppTheme.blackColor, font: AppTheme.mediumFont(withSize: 14))
            
        
        return avatarInitials
    }
    
    override func collectionView(_ collectionView: JSQMessagesCollectionView, attributedTextForCellTopLabelAt indexPath: IndexPath) -> NSAttributedString? {
        /**
         *  This logic should be consistent with what you return from `heightForCellTopLabelAtIndexPath:`
         *  The other label text delegate methods should follow a similar pattern.
         *
         *  Show a timestamp for every 3rd message
         */
        if (indexPath.item % 3 == 0) {
            let message = self.messages[indexPath.item]
            
            return JSQMessagesTimestampFormatter.shared().attributedTimestamp(for: message.date)
        }
        
        return nil
    }
    
    override func collectionView(_ collectionView: JSQMessagesCollectionView, attributedTextForMessageBubbleTopLabelAt indexPath: IndexPath) -> NSAttributedString? {
        let message = messages[indexPath.item]
        
        // Displaying names above messages
        //Mark: Removing Sender Display Name
        /**
         *  Example on showing or removing senderDisplayName based on user settings.
         *  This logic should be consistent with what you return from `heightForCellTopLabelAtIndexPath:`
         */
//        if defaults.bool(forKey: Setting.removeSenderDisplayName.rawValue) {
//            return nil
//        }
        
        if message.senderId == self.senderId() {
            return nil
        }
        
        return NSAttributedString(string: message.senderDisplayName)
    }
    
    override func collectionView(_ collectionView: JSQMessagesCollectionView, layout collectionViewLayout: JSQMessagesCollectionViewFlowLayout, heightForCellTopLabelAt indexPath: IndexPath) -> CGFloat {
        /**
         *  Each label in a cell has a `height` delegate method that corresponds to its text dataSource method
         */
        
        /**
         *  This logic should be consistent with what you return from `attributedTextForCellTopLabelAtIndexPath:`
         *  The other label height delegate methods should follow similarly
         *
         *  Show a timestamp for every 3rd message
         */
        if indexPath.item % 3 == 0 {
            return kJSQMessagesCollectionViewCellLabelHeightDefault
        }
        
        return 0.0
    }
    
    override func collectionView(_ collectionView: JSQMessagesCollectionView, layout collectionViewLayout: JSQMessagesCollectionViewFlowLayout, heightForMessageBubbleTopLabelAt indexPath: IndexPath) -> CGFloat {
        
        /**
         *  Example on showing or removing senderDisplayName based on user settings.
         *  This logic should be consistent with what you return from `attributedTextForCellTopLabelAtIndexPath:`
         */
//        if defaults.bool(forKey: Setting.removeSenderDisplayName.rawValue) {
//            return 0.0
//        }
        
        /**
         *  iOS7-style sender name labels
         */
        let currentMessage = self.messages[indexPath.item]
        
        if currentMessage.senderId == self.senderId() {
            return 0.0
        }
        
        if indexPath.item - 1 > 0 {
            let previousMessage = self.messages[indexPath.item - 1]
            if previousMessage.senderId == currentMessage.senderId {
                return 0.0
            }
        }
        
        return kJSQMessagesCollectionViewCellLabelHeightDefault;
    }
    
    override func collectionView(_ collectionView: JSQMessagesCollectionView, didDeleteMessageAt indexPath: IndexPath) {
        
    }
    
    override func collectionView(_ collectionView: JSQMessagesCollectionView, didTapMessageBubbleAt indexPath: IndexPath) {
        
    }
    
    override func collectionView(_ collectionView: JSQMessagesCollectionView, didTapCellAt indexPath: IndexPath, touchLocation: CGPoint) {
        
    }
    
    override func collectionView(_ collectionView: JSQMessagesCollectionView, didTapAvatarImageView avatarImageView: UIImageView, at indexPath: IndexPath) {
        
    }
    
    override func collectionView(_ collectionView: JSQMessagesCollectionView, attributedTextForCellBottomLabelAt indexPath: IndexPath) -> NSAttributedString? {
     
        return nil
    }
    
    override func collectionView(_ collectionView: JSQMessagesCollectionView, header headerView: JSQMessagesLoadEarlierHeaderView, didTapLoadEarlierMessagesButton sender: UIButton) {
        
    }
    
    override func collectionView(_ collectionView: JSQMessagesCollectionView, layout collectionViewLayout: JSQMessagesCollectionViewFlowLayout, heightForCellBottomLabelAt indexPath: IndexPath) -> CGFloat {
        
        return 0.0;
    }

}

