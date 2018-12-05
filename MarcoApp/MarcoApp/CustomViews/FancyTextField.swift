//
//  FancyTextField.swift
//  MarcoApp
//
//  Created by Nabeel Hayat on 04/01/2018.
//  Copyright © 2018 GrayScaleLogic. All rights reserved.
//

import UIKit

protocol FancyTextFieldDelegate {
    
    func willShowKeyboard(_ fancyTextField: FancyTextField, _ notification: Notification)
    func willHideKeyboard(_ fancyTextField: FancyTextField, _ notification: Notification)
    
    func didShowKeyboard(_ fancyTextField: FancyTextField, _ notification: Notification)
    func didHideKeyboard(_ fancyTextField: FancyTextField, _ notification: Notification)
    
    func fancyTextFieldShouldEndEditing(_ fancyTextField: FancyTextField) -> Bool
    func fancyTextFieldShouldBeginEditing(_ fancyTextField: FancyTextField) -> Bool
    func fancyTextField(_ fancyTextField: FancyTextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool
    func fancyTextFieldShouldClear(_ fancyTextField: FancyTextField) -> Bool
    func fancyTextFieldDidEndEditing(_ fancyTextField: FancyTextField, reason: UITextFieldDidEndEditingReason)
    func fancyTextFieldDidBeginEditing(_ fancyTextField: FancyTextField)
    func fancyTextFieldDidEndEditing(_ fancyTextField: FancyTextField)
    func fancyTextFieldShouldReturn(_ fancyTextField: FancyTextField) -> Bool
}

class FancyTextField: UIView {

    @IBOutlet var contentView: UIView!
    
    @IBOutlet weak var bottomBarView: UIView!
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var placeholderLabel: UILabel!
    
    @IBOutlet weak var placeholderTopConstraint: NSLayoutConstraint!
    
    @IBInspectable var isSecureText: Bool = false {
        
        didSet {
            
            if self.textField != nil {
                
                self.textField.isSecureTextEntry = isSecureText
            }
        }
    }
    
    @IBInspectable var textColor: UIColor = .white {
        
        didSet {
            if self.textField != nil {
                
                self.textField.textColor = textColor
            }
        }
    }
    
    @IBInspectable var placeholderTextColor: UIColor = .darkGray {
        
        didSet {
            if self.placeholderLabel != nil {
                
                self.placeholderLabel.textColor = placeholderTextColor
            }
        }
    }
    
    @IBInspectable var placeholderActiveTextColor: UIColor = .lightGray {
        
        didSet {
            self.layoutIfNeeded()
        }
    }
    
    @IBInspectable var placeholder: String = "" {
        
        didSet {
            if self.placeholderLabel != nil {
                
                self.placeholderLabel.text = placeholder
            }
        }
    }
    
    @IBInspectable var bottomBorderColor: UIColor = .darkGray {
        
        didSet {
            if self.bottomBarView != nil {
                
                self.bottomBarView.backgroundColor = bottomBorderColor
            }
        }
    }
    @IBInspectable var bottomActiveBorderColor: UIColor = .lightGray {
        
        didSet {
            self.layoutIfNeeded()
        }
    }
    
    override func resignFirstResponder() -> Bool {
        super.resignFirstResponder()
        
        self.textField.resignFirstResponder()
        return true
    }
    
    override func becomeFirstResponder() -> Bool {
        super.becomeFirstResponder()
        
        self.textField.becomeFirstResponder()
        return true
    }
    
    var delegate: FancyTextFieldDelegate!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    
        self.initialize()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        self.initialize()
    }
    
    // MARK: - Helper Functions
    
    private func initialize() {
        
        Bundle.main.loadNibNamed("FancyTextField", owner: self, options: nil)
        addSubview(contentView)
        contentView.frame = bounds
        contentView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        
        self.textField.delegate = self
        self.textField.isSecureTextEntry = isSecureText
        
        self.placeholderLabel.font = AppTheme.regularFont(withSize: 18)
        self.placeholderLabel.textColor = self.placeholderTextColor
        self.bottomBarView.backgroundColor = self.bottomBorderColor
        self.textField.textColor = self.textColor
        self.placeholderLabel.text = self.placeholder
        
        NotificationCenter.default.addObserver(self, selector: #selector(willShowKeyboard(_:)), name: Notification.Name.UIKeyboardWillShow, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(willHideKeyboard(_:)), name: Notification.Name.UIKeyboardWillHide, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(didShowKeyboard(_:)), name: Notification.Name.UIKeyboardDidShow, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(didHideKeyboard(_:)), name: Notification.Name.UIKeyboardDidHide, object: nil)
    }
    
    @objc func willShowKeyboard(_ notification: Notification) {
        
        if let delegate = self.delegate {
            
            delegate.willShowKeyboard(self, notification)
        }
    }
    
    @objc func willHideKeyboard(_ notification: Notification) {
        
        if let delegate = self.delegate {
            
            delegate.willHideKeyboard(self, notification)
        }
    }
    
    @objc func didShowKeyboard(_ notification: Notification) {
        
        if let delegate = self.delegate {
            
            delegate.didShowKeyboard(self, notification)
        }
    }
    
    @objc func didHideKeyboard(_ notification: Notification) {
        
        if let delegate = self.delegate {
            
            delegate.didHideKeyboard(self, notification)
        }
    }
    
    fileprivate func animateBecomeFirstResponder(completion: @escaping (Bool) -> Void) {
        
        self.placeholderTopConstraint.constant = 0
        self.placeholderLabel.font = AppTheme.regularFont(withSize: 14)
        self.placeholderLabel.textColor = self.placeholderActiveTextColor
        self.bottomBarView.backgroundColor = self.bottomActiveBorderColor
        
        UIView.animate(withDuration: 0.3, animations: {
            
            self.layoutIfNeeded()
            
        }) { (finished) in
         
            completion(finished)
        }
    }
    
    fileprivate func animateResignFirstResponder() {
        
        self.placeholderTopConstraint.constant = self.textField.frame.origin.y
        self.placeholderLabel.font = AppTheme.regularFont(withSize: 18)
        self.placeholderLabel.textColor = self.placeholderTextColor
        self.bottomBarView.backgroundColor = self.bottomBorderColor
        
        
        UIView.animate(withDuration: 0.3) {
            
            self.layoutIfNeeded()
            
        }
    }
    
}

extension FancyTextField: UITextFieldDelegate {
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
     
        if let delegate = self.delegate {
            
            return delegate.fancyTextFieldShouldEndEditing(self)
        }
        
        return true
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        
        if let delegate = self.delegate {
            
            return delegate.fancyTextFieldShouldBeginEditing(self)
        }
        
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        if let delegate = self.delegate {
         
            return delegate.fancyTextField(self, shouldChangeCharactersIn:range, replacementString:string)
        }
        
        return true
    }
    
    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        
        if let delegate = self.delegate {
            
            return delegate.fancyTextFieldShouldClear(self)
        }
        
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField, reason: UITextFieldDidEndEditingReason) {
        
        if textField.text == "" {
            
            self.animateResignFirstResponder()
        }
        
        if let delegate = self.delegate {
            
            delegate.fancyTextFieldDidEndEditing(self, reason: reason)
        }
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
        if textField.text == "" {
            
            self.animateBecomeFirstResponder(completion: { (finished) in
                
                if let delegate = self.delegate {
                    
                    delegate.fancyTextFieldDidBeginEditing(self)
                }
            })
        }
        else {
         
            if let delegate = self.delegate {
                
                delegate.fancyTextFieldDidBeginEditing(self)
            }
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        if textField.text == "" {
        
            self.animateResignFirstResponder()
        }
        
        if let delegate = self.delegate {
            
            delegate.fancyTextFieldDidEndEditing(self)
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        if let delegate = self.delegate {
         
            return delegate.fancyTextFieldShouldReturn(self)
        }
        
        return true
    }
}

extension FancyTextFieldDelegate {
    
    func willShowKeyboard(_ fancyTextField: FancyTextField, _ notification: Notification) {
        
    }
    
    func willHideKeyboard(_ fancyTextField: FancyTextField, _ notification: Notification) {
        
    }
    
    func didShowKeyboard(_ fancyTextField: FancyTextField, _ notification: Notification) {
        
    }
    
    func didHideKeyboard(_ fancyTextField: FancyTextField, _ notification: Notification) {
        
    }
    
    func fancyTextFieldShouldEndEditing(_ fancyTextField: FancyTextField) -> Bool {
        
        return true
    }
    
    func fancyTextFieldShouldBeginEditing(_ fancyTextField: FancyTextField) -> Bool {
        
        return true
    }
    
    func fancyTextField(_ fancyTextField: FancyTextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        return true
    }
    
    func fancyTextFieldShouldClear(_ fancyTextField: FancyTextField) -> Bool {
        
        return true
    }
    
    func fancyTextFieldDidEndEditing(_ fancyTextField: FancyTextField, reason: UITextFieldDidEndEditingReason) {
        
    }
    
    func fancyTextFieldDidBeginEditing(_ fancyTextField: FancyTextField) {
        
    }
    
    func fancyTextFieldDidEndEditing(_ fancyTextField: FancyTextField) {
        
    }
    
    func fancyTextFieldShouldReturn(_ fancyTextField: FancyTextField) -> Bool {
        
        return true
    }
}
