//
//  CreatePostViewController.swift
//  MarcoApp
//
//  Created by Nabeel Hayat on 25/11/2017.
//  Copyright © 2017 GrayScaleLogic. All rights reserved.
//

import UIKit

class CreatePostViewController: BaseViewController {

    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var textContainerView: UIView!
    @IBOutlet weak var bottomBarView: UIView!
    
    @IBOutlet weak var imageTileListView: ImageTileListView!
    @IBOutlet weak var messagePlaceholderField: UITextField!
    @IBOutlet weak var messageTextView: UITextView!
    
    @IBOutlet weak var addPhotoButton: UIButton!
    
    @IBOutlet weak var bottomBarViewBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var imageTileHeightConstraint: NSLayoutConstraint!
    
    var libraryEnabled: Bool = true
    var croppingEnabled: Bool = true
    var allowResizing: Bool = true
    var allowMoving: Bool = true
    var minimumSize: CGSize = CGSize(width: 200, height: 200)
    
    var croppingParameters: CroppingParameters {
        return CroppingParameters(isEnabled: croppingEnabled, allowResizing: allowResizing, allowMoving: allowMoving, minimumSize: minimumSize)
    }
    
    private var fileList: [UIImage] = []
    
    var groupId: String!
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.hideNavigationMenuButtonItem = true
        self.showBackButtonItem = true
        // Do any additional setup after loading the view.
        
        self.setupViews()
    }
    
    override func didBackButtonPressed(_ sender: UIBarButtonItem) {
        
        if !self.messageTextView.text.isEmpty || self.fileList.count > 0  {

            self.showAlert("Warning", "Are you sure? you want to cancel this", .alert, "Yes, Sure", { (confirmAction) in
                
                super.didBackButtonPressed(sender)
                
            }, "No", { (cancelAction) in
                
                
            })
        }
        else {
         
            super.didBackButtonPressed(sender)
        }
    }
    
    override func didMenuButtonPressed(_ sender: UIBarButtonItem) {
        super.didMenuButtonPressed(sender)
        
    }
    
    // MARK: - Helper Functions
    
    func setupViews() {
        
        NotificationCenter.default.addObserver(self, selector: #selector(willShowKeyboard(_:)), name: Notification.Name.UIKeyboardWillShow, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(willHideKeyboard(_:)), name: Notification.Name.UIKeyboardWillHide, object: nil)
        
        self.messageTextView.delegate = self
        self.messageTextView.becomeFirstResponder()
        
        let rightNavigationItem = UIBarButtonItem(image: UIImage(named: "ic_nb_share"), style: .done, target: self, action: #selector(didCreatePostButtonPressed(_:)))
        
//        let negativeSpace:UIBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.fixedSpace, target: nil, action: nil)
////        negativeSpace.width = -10.0
        self.navigationItem.rightBarButtonItems = [rightNavigationItem]
     
        self.imageTileListView.delegate = self
        
        let swipeDown: UISwipeGestureRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(didSwipeDownGestrue(_:)))
        swipeDown.direction = .down
        swipeDown.numberOfTouchesRequired = 1
        
        self.view.addGestureRecognizer(swipeDown)
    }
    
    @objc func didSwipeDownGestrue(_ gesture: UIGestureRecognizer) {
        
        self.messageTextView.resignFirstResponder()
    }
    
    // MARK: - Button Actions
    
    @objc func didCreatePostButtonPressed(_ sender: UIBarButtonItem) {
        
        if !self.messageTextView.text.isEmpty {
        
            self.showPKHUD(WithMessage: "Creating post...")
            
            let parameters: [String : Any] = ["GroupId": self.groupId, "Text": self.messageTextView.text, "IsShareable": "\(true)", "IsCommentable": "\(true)"]
            
            print(parameters)
            
            ApiServices.shared.requestForCreateGroupPost(onTarget: self, fileList: self.fileList, parameters, successfull: { (successful) in
                
                self.hidePKHUD()
                
                self.navigationController?.popViewController(animated: true)
                self.dismiss(animated: true, completion: nil)
                
            }, failure: { (failure) in
                
                self.hidePKHUD()
                
                self.showAlert("Warning", "Something went wrong.", UIAlertControllerStyle.alert, "OK", { (action) in
                    
                    self.navigationController?.popViewController(animated: true)
                    self.dismiss(animated: true, completion: nil)
                })
            })
            
        }
        else {
            
            self.showAlert("Warning", "Please enter your post message.", .alert, "OK") { (okAction) in
                
                
            }
        }
    }
    
    @IBAction func didAddPhotoButtonPressed(_ sender: UIButton) {
    
        
        if UIScreen.main.bounds.size.width < self.minimumSize.width {
            
            let height: CGFloat = UIScreen.main.bounds.size.width / 1.875
            
            self.minimumSize = CGSize(width: UIScreen.main.bounds.size.width, height: height)
        }

        let libraryViewController = CameraViewController.imagePickerViewController(croppingParameters: croppingParameters) { (image, asset) in
            
            if let newImage: UIImage = image {
                
                let width = UIScreen.main.bounds.size.width
                
                let height = width/1.875
                
                let resizedImage: UIImage! = AppFunctions.resizeImageForImage(newImage, CGSize(width: width, height: height))
                
                self.fileList = [resizedImage]
                self.imageTileListView.setupViewWithImagesList(self.fileList)
            }
            
            self.dismiss(animated: true, completion: nil)
        }

        // Multi image selections
//        let libraryViewController = CameraViewController.imagePickerViewController(completion: { [weak self] assets in
//
//            if let assets = assets {
//
//                let images = ImageFetcher.resolveAssets(assets, size: largestPhotoSize())
//
//                self?.fileList = images
//                self?.imageTileListView.setupViewWithImagesList((self?.fileList)!)
//
//            }
//
//            self?.dismiss(animated: true, completion: nil)
//
//        })
        
        libraryViewController.view.tintColor = AppTheme.blueColor
        
        present(libraryViewController, animated: true, completion: nil)
        
    }
    
    // MARK: - Keyboard Notifications
    
    @objc func willShowKeyboard(_ notification: Notification) {
    
        let keyboardInfo: [AnyHashable : Any] = notification.userInfo!
        
        let keyboardRect = keyboardInfo[UIKeyboardFrameEndUserInfoKey] as! CGRect
        
        if #available(iOS 11.0, *) {
            self.bottomBarViewBottomConstraint.constant = keyboardRect.size.height - self.view.safeAreaInsets.bottom
        } else {
            // Fallback on earlier versions
            self.bottomBarViewBottomConstraint.constant = keyboardRect.size.height
        }
        
        UIView.animate(withDuration: 0.5, delay: 0.0, options: .curveEaseIn, animations: {
            
            self.view.layoutIfNeeded()
            
        }, completion: nil)
    }
    
    @objc func willHideKeyboard(_ notification: Notification) {
    
        
        if #available(iOS 11.0, *) {
            self.bottomBarViewBottomConstraint.constant = 0
        } else {
            // Fallback on earlier versions
            self.bottomBarViewBottomConstraint.constant = 0
        }
        
        UIView.animate(withDuration: 0.5, delay: 0.0, options: .curveEaseIn, animations: {
            
            self.view.layoutIfNeeded()
            
        }, completion: nil)
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

extension CreatePostViewController : ImageTileListViewDelegate {
    
    func didDelete(_ imageTileView: ImageTileView, _ tileListView: ImageTileListView, at index: Int) {
     
        self.fileList.remove(at: index)
        self.imageTileListView.setupViewWithImagesList(self.fileList)
    }
}

extension CreatePostViewController : UITextViewDelegate {

    func textViewDidChange(_ textView: UITextView) {
        
        if self.messageTextView == textView {
            
            if textView.text.characters.count > 0 {
                
                self.messagePlaceholderField.isHidden = true
            }
            else {
            
                self.messagePlaceholderField.isHidden = false
            }
        }
    }
}
