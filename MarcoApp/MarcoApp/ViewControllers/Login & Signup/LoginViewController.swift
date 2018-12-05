//
//  LoginViewController.swift
//  MarcoApp
//
//  Created by Nabeel Hayat on 30/11/2017.
//  Copyright © 2017 GrayScaleLogic. All rights reserved.
//

import UIKit
import FacebookLogin
import FacebookCore

class LoginViewController: BaseViewController {

    @IBOutlet var scrollView: UIScrollView!
    
    @IBOutlet weak var containerView: UIView!
    
    @IBOutlet weak var usernameTextField: FancyTextField!
    @IBOutlet weak var passwordTextField: FancyTextField!
    
    @IBOutlet weak var forgetPasswordButton: UIButton!
    @IBOutlet weak var loginFBButton: UIButton!
    @IBOutlet weak var loginTwitterButton: UIButton!
    @IBOutlet weak var loginButton: UIButton!
    
    @IBOutlet weak var signupButton: UIButton!
    
    
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.hideNavigationMenuButtonItem = true
        self.showBackButtonItem = false
        // Do any additional setup after loading the view.
        
        self.setupViews()
    }
    
    override func didBackButtonPressed(_ sender: UIBarButtonItem) {
        super.didBackButtonPressed(sender)
        
    }
    
    override func didMenuButtonPressed(_ sender: UIBarButtonItem) {
        super.didMenuButtonPressed(sender)
        
    }
    
    // MARK: - Helper Functions
    
    func setupViews() {
        
        self.usernameTextField.delegate = self
        self.passwordTextField.delegate = self
        
        self.usernameTextField.textField.returnKeyType = .next
        self.passwordTextField.textField.returnKeyType = .done
        
        
        let gesture: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleTapGesture(_:)))
        
        gesture.numberOfTapsRequired = 1;
        
        self.scrollView.addGestureRecognizer(gesture)
        
    }
    
    @objc func handleTapGesture(_ gesture:UITapGestureRecognizer) {
        
        self.dismissKeyboard()
    }
    
    func dismissKeyboard() {
        
        _ = self.usernameTextField.resignFirstResponder()
        _ = self.passwordTextField.resignFirstResponder()
        
        self.resetScrollView()
    }
    
    func resetScrollView() {
        
        UIView.animate(withDuration: 0.7) {
            
            self.scrollView.setContentOffset(CGPoint.zero, animated: true)
        }
    }
    
//    @IBAction func didLoginButtonPressed(_ sender: UIButton) {
//        
////        let tokenString: String = FBSDKAccessToken.current().tokenString
////
////        print(tokenString)
//
//        
////        let store = Twitter.sharedInstance().sessionStore
////        if let userID = store.session()?.userID {
////            store.logOutUserID(userID)
////            Twitter.sharedInstance().sessionStore.logOutUserID(userID)
////        }
////
////
////        Twitter.sharedInstance().logIn(completion: { (session, error) in
////            if (session != nil) {
////                print("signed in as \(session?.authToken ?? "")");
////
////                print(session!.userID)
////                print(session!.userName)
////                print(session!.authToken)
////                print(session!.authTokenSecret)
////
////            } else {
////                print("error: \(error?.localizedDescription ?? "")");
////            }
////        })
//        
//        let loginManager: LoginManager = LoginManager(loginBehavior: .systemAccount, defaultAudience: .everyone)
//        
//        loginManager.logIn(readPermissions: [.publicProfile, .email, .userFriends], viewController: self) { (loginResult) in
//            
//            switch loginResult {
//            case .failed(let error):
//                print(error)
//            case .cancelled:
//                print("User cancelled login.")
//            case .success( _, _, _):
//                print("Logged in!")
//            }
//        }
//    }
    
    // MARK: - LoginButtonDelegate
    
//    func loginButtonDidCompleteLogin(_ loginButton: LoginButton, result: LoginResult) {
//        
//        switch result {
//        case .failed(let error):
//            print(error)
//        case .cancelled:
//            print("User cancelled login.")
//        case .success(grantedPermissions: _, declinedPermissions: _, token: let accessToken):
//            print("Logged in! Access Token: \(accessToken)")
//        }
//    }
    
//    func loginButtonDidLogOut(_ loginButton: LoginButton) {
//        
//    }
    
    // MARK: - Button Actions
    
    @IBAction func didSignupButtonPressed(_ sender: UIButton) {
        
        
    }
    
    @IBAction func didLoginButtonPressed(_ sender: UIButton) {
        
        self.dismissKeyboard()
    }
    
    @IBAction func didLoginFBButtonPressed(_ sender: UIButton) {
        
        
    }
    
    @IBAction func didLoginTwitterButtonPressed(_ sender: UIButton) {
    }
    
    @IBAction func didForgetPasswordButtonPressed(_ sender: UIButton) {
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

extension LoginViewController: FancyTextFieldDelegate {
    
    func fancyTextFieldDidBeginEditing(_ fancyTextField: FancyTextField) {
        
        self.scrollView.setContentOffset(CGPoint(x: 0, y: fancyTextField.frame.origin.y - 100), animated: true)
        
        UIView.animate(withDuration: 0.7) {
        
            self.scrollView.layoutIfNeeded()
        }
    }
    
    func fancyTextFieldDidEndEditing(_ fancyTextField: FancyTextField) {
        
        self.resetScrollView()
    }
    
    func fancyTextFieldShouldReturn(_ fancyTextField: FancyTextField) -> Bool {
        
        if self.usernameTextField == fancyTextField {
            
            _ = self.passwordTextField.becomeFirstResponder()
        }
        else if (self.passwordTextField == fancyTextField) {
            
            self.dismissKeyboard()
        }
        
        return true
    }
    
    func fancyTextField(_ fancyTextField: FancyTextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        var usernameString: NSString = self.usernameTextField.textField.text! as NSString
        var passwordString: NSString = self.passwordTextField.textField.text! as NSString
        
        if self.usernameTextField == fancyTextField {
            
            usernameString = usernameString.replacingCharacters(in: range, with: string) as NSString
        }
        else {
         
            passwordString = passwordString.replacingCharacters(in: range, with: string) as NSString
        }
        
        if usernameString != "" && passwordString != "" {
            
            // show
            self.loginButton.isHidden = false
        }
        else if usernameString == "" || passwordString == "" {
            
            // hide
            self.loginButton.isHidden = true
        }
        else {
            
            //
        }
        
        return true
    }
}
