//
//  FeedDetailViewController.swift
//  MarcoApp
//
//  Created by Nabeel Hayat on 25/11/2017.
//  Copyright © 2017 GrayScaleLogic. All rights reserved.
//

import UIKit
import SDWebImage

class FeedDetailViewController: BaseViewController {

    @IBOutlet weak var feedImageView: UIImageView!
    @IBOutlet weak var feedTitleLabel: UILabel!
    @IBOutlet weak var feedDetailLabel: UILabel!
    
    @IBOutlet weak var commentTableView: UITableView!
    
    
    @IBOutlet weak var commentTextField: UITextField!
    
    @IBOutlet weak var sendButton: UIButton!
    
    @IBOutlet weak var imageViewHConstraint: NSLayoutConstraint!
    @IBOutlet weak var containerHConstraint: NSLayoutConstraint!
    @IBOutlet weak var commentBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var commentPlaceholder: UIView!
    @IBOutlet weak var commentPlaceholderLabel: UILabel!
    
    var imageName: String!
    var postName: String!
    var userImageName: String!
    
    var postObject: PostObject!
    
    var commentHeightList: [CGFloat] = []
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.hideNavigationMenuButtonItem = true
        self.showBackButtonItem = true
        // Do any additional setup after loading the view.
        
        self.setupViews()
        self.sendRequestForGetPostDetail()
    }
    
    override func didBackButtonPressed(_ sender: UIBarButtonItem) {
        super.didBackButtonPressed(sender)
        self.commentTextField.resignFirstResponder()
    }
    
    override func didMenuButtonPressed(_ sender: UIBarButtonItem) {
        super.didMenuButtonPressed(sender)
        
    }
    
    // MARK: - Helper Functions
    
    func setupViews() {
        
        let tapGesture: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(didTapPressed(_:)))
        
        self.view.addGestureRecognizer(tapGesture)
        
        NotificationCenter.default.addObserver(self, selector: #selector(willShowKeyboard(_:)), name: Notification.Name.UIKeyboardWillShow, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(willHideKeyboard(_:)), name: Notification.Name.UIKeyboardWillHide, object: nil)
        
        self.commentPlaceholderLabel.font = AppTheme.regularFont(withSize: 14)
        
        self.setTitleView(title: self.postObject.createdByUser.fullName, detailTitle: "", avatarImageURL: URL(string: self.postObject.createdByUser.profilePicture), placehoderImage: UIImage.getImage(withName: "user_default", imageColor: UIColor(hexString: "#cccccc")))
        
        self.feedTitleLabel.text = self.postObject.postText
        
        let height: CGFloat = self.postObject.postText.height(withConstrainedWidth: UIScreen.main.bounds.size.width - 32, font: AppTheme.boldFont(withSize: 16)) + 40
        
        if self.postObject.contents.count > 0 {
            
            let postContent: PostContent = postObject.contents[0]
            
            if postContent.contentURL != "" {
                
                self.containerHConstraint.constant = 200 + height
                self.imageViewHConstraint.constant = 200
                
                let urlString: URL = URL(string: postContent.contentURL)!
                
                self.feedImageView.sd_setImage(with: urlString, placeholderImage: nil) { (image, error, imageCacheType, url) in
                    
                }
            }
            else {
                
                self.feedImageView.image = nil
                self.containerHConstraint.constant = height
                self.imageViewHConstraint.constant = 0
            }
        }
        else {
         
            self.feedImageView.image = nil
            self.containerHConstraint.constant = height
            self.imageViewHConstraint.constant = 0
        }
        
        self.commentTableView.delegate = self
        self.commentTableView.dataSource = self
        
        self.commentTableView.register(UINib(nibName: "CommentTableViewCell", bundle: nil), forCellReuseIdentifier: "CommentTableViewCell")
        
        self.commentTableView.tableFooterView = UIView()
    }
    
    func didTapPressed(_ tapGesture: UITapGestureRecognizer) {
        
        self.view.endEditing(true)
        self.commentTextField.resignFirstResponder()
    }
    
    // MARK: - Keyboard Notifications
    
    @objc func willShowKeyboard(_ notification: Notification) {
        
        let keyboardInfo: [AnyHashable : Any] = notification.userInfo!
        
        let keyboardRect = keyboardInfo[UIKeyboardFrameEndUserInfoKey] as! CGRect
        
        if #available(iOS 11.0, *) {
            self.commentBottomConstraint.constant = keyboardRect.size.height - self.view.safeAreaInsets.bottom
        } else {
            // Fallback on earlier versions
            self.commentBottomConstraint.constant = keyboardRect.size.height
        }
        
        UIView.animate(withDuration: 0.5, delay: 0.0, options: .curveEaseIn, animations: {
            
            self.view.layoutIfNeeded()
            
        }, completion: nil)
    }
    
    @objc func willHideKeyboard(_ notification: Notification) {
        
        
        if #available(iOS 11.0, *) {
            self.commentBottomConstraint.constant = 0
        } else {
            // Fallback on earlier versions
            self.commentBottomConstraint.constant = 0
        }
        
        UIView.animate(withDuration: 0.5, delay: 0.0, options: .curveEaseIn, animations: {
            
            self.view.layoutIfNeeded()
            
        }, completion: nil)
    }
    
    // MARK: - Web Services
    
    fileprivate func sendRequestForCreatePostComment() {
        
        self.showPKHUD(WithMessage: "Posting Comment...")
        
        ApiServices.shared.requestForCreatePostComment(onTarget: self, String(self.postObject.postId), commentText: self.commentTextField.text!, successfull: { (success) in
            
            self.commentTextField.text = ""
            
            self.sendRequestForGetPostDetail(true)
            
            self.hidePKHUD()
            
        }) { (failure) in
            
            self.hidePKHUD()
        }
    }
    
    fileprivate func sendRequestForGetPostDetail(_ isBackground: Bool = false) {
        
        if !isBackground {
        
            self.showPKHUD(WithMessage: "Getting Detail...")
        }
        
        ApiServices.shared.requestForGetPostDetail(onTarget: self, String(self.postObject.postId), successfull: { (success, postObject) in
            
            self.hidePKHUD()
            
            self.postObject = postObject
            
            self.calculateHeightForComments()
            
            if self.postObject.comments.count > 0 {
             
                self.commentPlaceholder.isHidden = true
                self.commentPlaceholderLabel.isHidden = true
                self.commentTableView.isHidden = false
                self.commentTableView.reloadData()
            }
            else  {
                
                self.commentPlaceholder.isHidden = false
                self.commentPlaceholderLabel.isHidden = false
                self.commentTableView.isHidden = true
            }
            
        }) { (failure) in
            
            self.hidePKHUD()
        }
    }
    
    fileprivate func calculateHeightForComments() {
        
        let font: UIFont = AppTheme.mediumFont(withSize: 14)
        let width: CGFloat = UIScreen.main.bounds.width - 16
        
        for postComment: PostComment in self.postObject.comments {
            
            let height: CGFloat = postComment.commentText.height(withConstrainedWidth: width, font: font)
            
            self.commentHeightList.append(height)
        }
    }
    
    // MARK: - UIButton Actions
    
    @IBAction func didSendButtonPressed(_ sender: UIButton) {
        
        self.sendRequestForCreatePostComment()
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

// MARK: - UITableViewDelegate

extension FeedDetailViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return self.postObject.comments.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let commentCell: CommentTableViewCell = tableView.dequeueReusableCell(withIdentifier: "CommentTableViewCell", for: indexPath) as! CommentTableViewCell
        
        let postComment: PostComment = self.postObject.comments[indexPath.row]
        
        commentCell.usernameLabel.text = postComment.user.fullName
        
        commentCell.detailLabel.text = "Commented " + self.getDateForPostedComment(postComment.commentCreateDate)
        
        commentCell.titleLabel.text = postComment.commentText
        
        if let userProfile: UserProfile = postComment.user {
            
            if userProfile.profilePicture != nil && userProfile.profilePicture != "" {
                
                let urlString: URL = URL(string: userProfile.profilePicture)!
                
                commentCell.avatarImageView.sd_setImage(with: urlString, placeholderImage: UIImage(named: "user_default")) { (image, error, imageCacheType, url) in
                    
                }
            }
            else {
                
                commentCell.avatarImageView.image = UIImage(named: "user_default")
            }
        }
        else {
            
            commentCell.avatarImageView.image = UIImage(named: "user_default")
        }
        
        return commentCell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        let commentTextHeight: CGFloat = self.commentHeightList[indexPath.row]
        
        return 72 + commentTextHeight
    }
    
    fileprivate func getDateForPostedComment(_ stringDate: String) -> String {
        
        let date: Date = AppFunctions.getDateFromServerString(stringDate)
        
        return date.prettyDate()
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        self.view.endEditing(true)
    }
    
}
