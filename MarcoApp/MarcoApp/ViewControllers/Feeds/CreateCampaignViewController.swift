//
//  CreateCampaignViewController.swift
//  MarcoApp
//
//  Created by Nabeel Hayat on 05/09/2018.
//  Copyright © 2018 GrayScaleLogic. All rights reserved.
//

import UIKit

class CreateCampaignViewController: BaseViewController {
    
    @IBOutlet weak var titleView: UIView!
    @IBOutlet weak var descriptionView: UIView!
    @IBOutlet weak var campaignView: UIView!
    @IBOutlet weak var campaignDateView: UIView!
    @IBOutlet weak var campaignAmountView: UIView!
    
    @IBOutlet weak var imageTileListView: ImageTileListView!
    
    @IBOutlet weak var amountTextField: UITextField!
    @IBOutlet weak var endDateTextField: UITextField!
    @IBOutlet weak var startDateTextField: UITextField!
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var descriptionTextView: UITextView!
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var campaignLabel: UILabel!
    
    @IBOutlet weak var timeButton: UIButton!
    @IBOutlet weak var amountButton: UIButton!
    
    
    var isTimeBasedCampaign: Bool!
    var groupId: String!
    
    lazy var startDatePicker: UIDatePicker = {
        let picker = UIDatePicker()
        picker.datePickerMode = .date
        picker.minimumDate = Date()
        return picker
    }()
    
    lazy var endDatePicker: UIDatePicker = {
        let picker = UIDatePicker()
        picker.datePickerMode = .date
        picker.minimumDate = self.getDateForEndPicker()
        return picker
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.hideNavigationMenuButtonItem = true
        self.showBackButtonItem = true
        // Do any additional setup after loading the view.
       
        self.setupViews()
    }

    override func didBackButtonPressed(_ sender: UIBarButtonItem) {
            super.didBackButtonPressed(sender)
//        if !self.messageTextView.text.isEmpty || self.fileList.count > 0  {
//
//            self.showAlert("Warning", "Are you sure? you want to cancel this", .alert, "Yes, Sure", { (confirmAction) in
//
//                super.didBackButtonPressed(sender)
//
//            }, "No", { (cancelAction) in
//
//
//            })
//        }
//        else {
//
//            super.didBackButtonPressed(sender)
//        }
    }
    
    override func didMenuButtonPressed(_ sender: UIBarButtonItem) {
        super.didMenuButtonPressed(sender)
        
    }
    
    // MARK: - Helper Functions
    
    func getDateForEndPicker() -> Date {
        
        if self.startDateTextField.text == "" || self.startDateTextField == nil {
            
            return Date()
        }
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy/MM/dd"
        let dateValue: Date = formatter.date(from: self.startDateTextField.text!)!
        
        
        return dateValue.addingTimeInterval(((60*60)*24))
    }
    
    func setupViews() {
        
        self.isTimeBasedCampaign = false
        
        self.startDateTextField.delegate = self
        self.endDateTextField.delegate = self
        
//        NotificationCenter.default.addObserver(self, selector: #selector(willShowKeyboard(_:)), name: Notification.Name.UIKeyboardWillShow, object: nil)
//        
//        NotificationCenter.default.addObserver(self, selector: #selector(willHideKeyboard(_:)), name: Notification.Name.UIKeyboardWillHide, object: nil)
        
//        self.messageTextView.delegate = self
//        self.messageTextView.becomeFirstResponder()
        
        let rightNavigationItem = UIBarButtonItem(image: UIImage(named: "ic_nb_share"), style: .done, target: self, action: #selector(didCreateCampaignButtonPressed(_:)))
        
        //        let negativeSpace:UIBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.fixedSpace, target: nil, action: nil)
        ////        negativeSpace.width = -10.0
        self.navigationItem.rightBarButtonItems = [rightNavigationItem]
        
//        self.imageTileListView.delegate = self
        
        let swipeDown: UISwipeGestureRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(didSwipeDownGestrue(_:)))
        swipeDown.direction = .down
        swipeDown.numberOfTouchesRequired = 1
        
        self.view.addGestureRecognizer(swipeDown)
        
        self.showDatePicker()
    }
    
    private func showDatePicker() {
        
        //ToolBar
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        
        //done button & cancel button
        let doneButton = UIBarButtonItem(title: "Done", style: UIBarButtonItemStyle.done, target: self, action: #selector(doneDatePicker(_:)))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: "Cancel", style: UIBarButtonItemStyle.plain, target: self, action: #selector(cancelDatePicker(_:)))
        toolbar.setItems([doneButton,spaceButton,cancelButton], animated: false)
        
        self.startDatePicker.addTarget(self, action: #selector(didValueChanged(_:)), for: .valueChanged)
        self.endDatePicker.addTarget(self, action: #selector(didValueChanged(_:)), for: .valueChanged)
        
        // add toolbar to textField
        self.startDateTextField.inputAccessoryView = toolbar
        self.endDateTextField.inputAccessoryView = toolbar
        // add datepicker to textField
        self.startDateTextField.inputView = startDatePicker
        self.endDateTextField.inputView = endDatePicker
        
    }
    
    @objc func didValueChanged(_ datePicker: UIDatePicker) {
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy/MM/dd"
        let dateValue: String = formatter.string(from: datePicker.date)
        
        if datePicker == self.startDatePicker {
            
            self.startDateTextField.text = dateValue
        }
        else if datePicker == self.endDatePicker {
            
            self.endDateTextField.text = dateValue
        }
        
        self.changeTextFieldsState()
    }
    
    @objc func doneDatePicker(_ datePicker: UIDatePicker) {
        
        self.resignTextFieldsFirstResponder()
        
        self.changeTextFieldsState()
    }
    
    @objc func cancelDatePicker(_ datePicker: UIDatePicker) {
        
        self.resignTextFieldsFirstResponder()
        
        self.changeTextFieldsState()
    }
    
    @objc func didSwipeDownGestrue(_ gesture: UIGestureRecognizer) {
        
//        self.messageTextView.resignFirstResponder()
    }
    
    fileprivate func resignTextFieldsFirstResponder() {
    
        if self.startDateTextField.isFirstResponder {
            
            self.startDateTextField.resignFirstResponder()
        }
        else if self.endDateTextField.isFirstResponder {
            
            self.endDateTextField.resignFirstResponder()
        }
    }
    
    fileprivate func changeTextFieldsState() {
        
        if self.startDateTextField.text == "" {
            
            self.endDateTextField.isEnabled = false
        }
        else {
            
            self.endDateTextField.isEnabled = true
        }
    }
    
    // MARK: - Button Actions
    
    @IBAction func didTimeButtonPressed(_ sender: UIButton) {
        
        self.isTimeBasedCampaign = true
        
        self.amountButton.setImage(UIImage(named: "radio-off"), for: .normal)
        self.timeButton.setImage(UIImage(named: "radio-on"), for: .normal)
        
        self.campaignAmountView.isHidden = true
        self.campaignDateView.isHidden = false
        
        if self.startDateTextField.text == "" {
        
            self.endDateTextField.isEnabled = false
        }
    }
    
    @IBAction func didAmountButtonPressed(_ sender: UIButton) {
        
        self.isTimeBasedCampaign = false
        
        self.timeButton.setImage(UIImage(named: "radio-off"), for: .normal)
        self.amountButton.setImage(UIImage(named: "radio-on"), for: .normal)
        
        self.campaignAmountView.isHidden = false
        self.campaignDateView.isHidden = true
    }
    
    fileprivate func createCampaign() {
        
        self.titleTextField.resignFirstResponder()
        self.descriptionTextView.resignFirstResponder()
        self.startDateTextField.resignFirstResponder()
        self.endDateTextField.resignFirstResponder()
        self.amountTextField.resignFirstResponder()
        
        self.showPKHUD(WithMessage: "Create group campaign...")
        
        self.sendRequestForCreateCampaign()
    }
    
    @objc func didCreateCampaignButtonPressed(_ sender: UIBarButtonItem) {
        
        if self.titleTextField.text != "" {
            
            if self.isTimeBasedCampaign {
                
                if self.startDateTextField.text != "" && self.endDateTextField.text != "" {
                    
                    // create time base campaign
                    self.createCampaign()
                }
                else {
                    // alert
                    
                    self.showAlert("Warning", "Please enter Start and End date of campaign.", .alert, "OK") { (okAction) in
                        
                    }
                }
            }
            else {
                
                if self.amountTextField.text != "" {
                    
                    // create amount base campaign
                    self.createCampaign()
                }
                else {
                    // alert
                    
                    self.showAlert("Warning", "Please enter total Amount your want to collect.", .alert, "OK") { (okAction) in
                        
                    }
                }
            }
        }
        else {
            
            // alert
            
            self.showAlert("Warning", "Please enter campaign title.", .alert, "OK") { (okAction) in
                
            }
        }
        
        
        
        
//
//        if !self.messageTextView.text.isEmpty || self.fileList.count > 0  {
//
//            let parameters: [String : Any] = ["GroupId": self.groupId, "Text": self.messageTextView.text, "IsShareable": "\(true)", "IsCommentable": "\(true)"]
//
//            print(parameters)
//
//            ApiServices.shared.requestForCreateGroupPost(onTarget: self, fileList: self.fileList, parameters, successfull: { (successful) in
//
//                self.hidePKHUD()
//
//                self.navigationController?.popViewController(animated: true)
//                self.dismiss(animated: true, completion: nil)
//
//            }, failure: { (failure) in
//
//                self.hidePKHUD()
//            })
//
//        }
    }
    
    // MARK: - Web Services
    
    private func getDictionaryForCreateCampaign() -> [String: Any] {
        
        let terminateValue: String = (self.isTimeBasedCampaign) ? "Time" : "Collection"
        let campaignAmount: String = (self.isTimeBasedCampaign) ? "" : self.amountTextField.text!
        let groupId: String = self.groupId!
        let description: String = self.descriptionTextView.text!
        
        let parameters: [String: Any] = ["Description": description, "Title": self.titleTextField.text!, "Terminate": terminateValue, "Amount": campaignAmount, "GroupId": groupId, "Start": self.startDateTextField.text!, "End": self.endDateTextField.text!]
        
        
        return parameters
    }
    
    private func sendRequestForCreateCampaign() {
        
        ApiServices.shared.requestForCreateCampaign(onTarget: self, fileList: [], self.getDictionaryForCreateCampaign(), successfull: { (success) in
            
            self.hidePKHUD()
            
            self.navigationController?.popViewController(animated: true)
            
        }) { (failure) in
            
            self.hidePKHUD()
            
            self.navigationController?.popViewController(animated: true)
        }
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

extension CreateCampaignViewController: UITextFieldDelegate {
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
     
        if textField == self.endDateTextField {
            
            self.endDatePicker.minimumDate = self.getDateForEndPicker()
        }
        
        self.changeTextFieldsState()
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        self.changeTextFieldsState()
    }
}
