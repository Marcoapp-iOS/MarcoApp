//
//  UserProfileTableViewCell.swift
//  MarcoApp
//
//  Created by Nabeel Hayat on 31/01/2018.
//  Copyright © 2018 GrayScaleLogic. All rights reserved.
//

import UIKit

protocol UserProfileTableViewCellDelegate {
    
    func userProfileTableViewCell(_ cell: UserProfileTableViewCell, textFieldShouldReturn textField: UITextField, at indexPath: IndexPath) -> Bool
    func userProfileTableViewCell(_ cell: UserProfileTableViewCell, textFieldShouldBeginEditing textField: UITextField, at indexPath: IndexPath) -> Bool
    
    func userProfileTableViewCell(_ cell: UserProfileTableViewCell, textFieldDidBeginEditing textField: UITextField, at indexPath: IndexPath)
    func userProfileTableViewCell(_ cell: UserProfileTableViewCell, textFieldDidEndEditing textField: UITextField, at indexPath: IndexPath)
    
    func userProfileTableViewCell(_ cell: UserProfileTableViewCell, textViewShouldReturn textView: UITextView, at indexPath: IndexPath) -> Bool
    func userProfileTableViewCell(_ cell: UserProfileTableViewCell, textViewShouldBeginEditing textView: UITextView, at indexPath: IndexPath) -> Bool
    
    func userProfileTableViewCell(_ cell: UserProfileTableViewCell, textViewDidBeginEditing textView: UITextView, at indexPath: IndexPath)
    func userProfileTableViewCell(_ cell: UserProfileTableViewCell, textViewDidEndEditing textView: UITextView, at indexPath: IndexPath)
}

class UserProfileTableViewCell: UITableViewCell, UITextFieldDelegate, UITextViewDelegate {
    
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var titleTextField: UITextField!
    
    @IBOutlet weak var titleTextLabel: UILabel!
    
    @IBOutlet weak var titleTextView: UITextView!
    @IBOutlet weak var separatorView: UIView!
    
    @IBOutlet weak var heightConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var topConstraint: NSLayoutConstraint!
    
    var profileValueType: ProfileValueType!
    
    var delegate: UserProfileTableViewCellDelegate!
    
    var indexPath: IndexPath!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        self.selectionStyle = .none
        self.titleTextView.delegate = self
        self.titleTextField.delegate = self
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    // MARK:- UITextFieldDelegate
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
    
        if self.delegate != nil {
            
            return delegate.userProfileTableViewCell(self, textFieldShouldBeginEditing: textField, at: self.indexPath)
        }
        
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
        if self.delegate != nil {
            
            delegate.userProfileTableViewCell(self, textFieldDidBeginEditing: textField, at: self.indexPath)
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        if self.delegate != nil {
            
            delegate.userProfileTableViewCell(self, textFieldDidEndEditing: textField, at: self.indexPath)
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    
        if self.delegate != nil {
            
            return delegate.userProfileTableViewCell(self, textFieldShouldReturn: textField, at: self.indexPath)
        }
        
        return true
    }
    
    // MARK:- UITextViewDelegate
    
    func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
        
        if self.delegate != nil {
            
            return delegate.userProfileTableViewCell(self, textViewShouldBeginEditing: textView, at: self.indexPath)
        }
        
        return true
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        
        if self.delegate != nil {
            
            delegate.userProfileTableViewCell(self, textViewDidBeginEditing: textView, at: self.indexPath)
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        
        if self.delegate != nil {
            
            delegate.userProfileTableViewCell(self, textViewDidEndEditing: textView, at: self.indexPath)
        }
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if(text == "\n") {
            textView.resignFirstResponder()
            
            if self.delegate != nil {
                
                return delegate.userProfileTableViewCell(self, textViewShouldReturn: textView, at: self.indexPath)
            }
            
            return false
        }
        return true
    }
}
