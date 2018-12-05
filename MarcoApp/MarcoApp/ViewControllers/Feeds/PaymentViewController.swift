//
//  PaymentViewController.swift
//  MarcoApp
//
//  Created by Nabeel Hayat on 08/09/2018.
//  Copyright © 2018 GrayScaleLogic. All rights reserved.
//

import UIKit

class PaymentViewController: BaseViewController {

    @IBOutlet weak var cardImageView: UIImageView!
    
    @IBOutlet weak var amountView: UIView!
    @IBOutlet weak var amountImageView: UIImageView!
    @IBOutlet weak var amountTextField: UITextField!
    @IBOutlet weak var amountLabel: UILabel!
    
    @IBOutlet weak var cardLabel: UILabel!
    @IBOutlet weak var cardView: UIView!
    
    var cardTextField: STPPaymentCardTextField!
    
    fileprivate var isContributePayments: Bool = false
    
    fileprivate var selectedCampaignID: Int!
    fileprivate var campaignAmount: String!
    
    var doneButton: UIBarButtonItem!
    
    
    var campaignObject: CampaignObject!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.hideNavigationMenuButtonItem = true
        self.showBackButtonItem = true
        // Do any additional setup after loading the view.
        
        self.populateLayout()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func didBackButtonPressed(_ sender: UIBarButtonItem) {
        super.didBackButtonPressed(sender)
        
    }
    
    override func didMenuButtonPressed(_ sender: UIBarButtonItem) {
        super.didMenuButtonPressed(sender)
        
    }
    
    override func didTapOnTitleView(_ titleView: NavigationTitleView) {
        super.didTapOnTitleView(titleView)
        
    }
    
    fileprivate func populateLayout() {
        
        self.title = "Contribution"
        
        self.amountTextField.delegate = self;
        
        self.doneButton = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(didDoneButtonPressed(_:)))
        
        self.navigationItem.rightBarButtonItem = self.doneButton
        
        
    }
    
    @objc func didDoneButtonPressed(_ barButtonItem: UIBarButtonItem) {
        
        self.campaignAmount = self.amountTextField.text
        
        self.campaignAmount = (self.campaignAmount as NSString).replacingOccurrences(of: "$", with: "")
        
        if self.campaignAmount != "" && self.campaignAmount != nil {
            
            self.isContributePayments = false
            
            self.selectedCampaignID = self.campaignObject.campaignId
            
            let addCardViewController = STPAddCardViewController()
//            addCardViewController.delegate = self
            
            self.navigationController?.pushViewController(addCardViewController, animated: true)
        }
        else  {
            
            let alertViewController: UIAlertController = UIAlertController(title: "Warning", message: "Please enter amount for contribution.", preferredStyle: .alert)
            
            let action: UIAlertAction = UIAlertAction(title: "OK", style: .default) { (alertAction) in
                
                
            }
            
            alertViewController.addAction(action)
            
            self.present(alertViewController, animated: true, completion: nil)
        }
    }
    
    @objc func didCancelButtonPressed(_ barButtonItem: UIBarButtonItem) {
        
        
    }
    
    // MARK: Web Services
    
    
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

extension PaymentViewController: UITextFieldDelegate {

    func textFieldDidBeginEditing(_ textField: UITextField) {
        
    }

    func textFieldDidEndEditing(_ textField: UITextField) {
        
    }
}
