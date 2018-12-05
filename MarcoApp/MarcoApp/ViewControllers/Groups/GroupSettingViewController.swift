//
//  GroupSettingViewController.swift
//  MarcoApp
//
//  Created by Nabeel Hayat on 25/11/2017.
//  Copyright © 2017 GrayScaleLogic. All rights reserved.
//

import UIKit

class GroupSettingViewController: BaseViewController {

    @IBOutlet weak var settingTableView: UITableView!
    
    
    var groupObject: GroupObject!
    
    var isShowMyLoaction: Bool = true
    var isMuteNotification: Bool = false
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.hideNavigationMenuButtonItem = true
        self.showBackButtonItem = true
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
        
        self.settingTableView.delegate = self
        self.settingTableView.dataSource = self
    
        self.title = "Settings"
        
//        self.setTitleView(title: "Nomads Club", detailTitle: "Public Group - 56.7K Members")
    }
    
    // MARK: - Web Services
    
    fileprivate func sendRequestForUpdateGroupSettings() {
        
        let parameters: [String : Any] = ["ShowLocation": self.isShowMyLoaction, "MuteNotificatoins" : self.isMuteNotification]
        
        ApiServices.shared.requestForUpdateGroupSettings(onTarget: self, String(self.groupObject.groupId), parameters, successfull: { (success) in
            
        }) { (failure) in
            
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

extension GroupSettingViewController : UITableViewDelegate, UITableViewDataSource {

    // MARK: - UITableViewDataSource
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell: GroupSettingTableViewCell = tableView.dequeueReusableCell(withIdentifier: "GroupSettingTableViewCell", for: indexPath) as! GroupSettingTableViewCell
        
        cell.indexPath = indexPath
        cell.delegate = self
        
        cell.settingTitle.text = (indexPath.row == 0) ? "Show My Location" : "Mute Notification"
        cell.settingImageView.image = (indexPath.row == 0) ? UIImage.getImage(withName: "ic_direction", imageColor: AppTheme.imageGrayColor) : UIImage.getImage(withName: "notification-on", imageColor: AppTheme.imageGrayColor)
        
        cell.settingSwitch.isOn = (indexPath.row == 0) ? self.isShowMyLoaction : self.isMuteNotification
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40.0
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: self.settingTableView.frame.size.width, height: 40))
        
        headerView.backgroundColor = AppTheme.tableViewGroupColor
        
        let titleLabel = UILabel(frame: CGRect(x: 40, y: 0, width: self.settingTableView.frame.size.width-80, height: 40))
        
        let attributedNameText: NSMutableAttributedString = NSMutableAttributedString(string: "GROUP SETTING")
        
        titleLabel.attributedText = attributedNameText.setFont(font: AppTheme.regularFont(withSize: 10), kerningValue: 80.0)
        
        titleLabel.textColor = AppTheme.blackColor
        titleLabel.numberOfLines = 1
        titleLabel.minimumScaleFactor = 0.5
        
        headerView.addSubview(titleLabel)
        
        return headerView
    }
    
    // MARK: - UITableViewDelegate
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 90.0;
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
    }
}

extension GroupSettingViewController : GroupSettingTableViewCellDelegate {
    
    func didValueChanged(_ sender: UISwitch, at indexPath: IndexPath) {
        
        if indexPath.row == 0 {
            // Location Value Changed
            
            self.isShowMyLoaction = sender.isOn
        }
        else if indexPath.row == 1 {
            // Notification Value Changed
            
            self.isMuteNotification = sender.isOn
        }
        
        self.sendRequestForUpdateGroupSettings()
        
    }
}
