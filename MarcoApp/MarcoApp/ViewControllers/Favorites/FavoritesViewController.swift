//
//  FavoritesViewController.swift
//  MarcoApp
//
//  Created by Nabeel Hayat on 01/12/2017.
//  Copyright © 2017 GrayScaleLogic. All rights reserved.
//

import UIKit

class FavoritesViewController: BaseViewController {

    @IBOutlet weak var favoritesTableView: MembersTableView!
    @IBOutlet weak var placeholderView: UIView!
    
    var userList: [UserProfile] = [UserProfile]()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.hideNavigationMenuButtonItem = false
        self.showBackButtonItem = false
        // Do any additional setup after loading the view.
        
        
        self.setupViews()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.sendRequestForFavorites()
    }
    
    override func didBackButtonPressed(_ sender: UIBarButtonItem) {
        super.didBackButtonPressed(sender)
        
    }
    
    override func didMenuButtonPressed(_ sender: UIBarButtonItem) {
        super.didMenuButtonPressed(sender)
        
    }
    
    // MARK: - Helper Functions
    
    func setupViews() {
     
//        self.userList = TempDataModel.getList(with: 16)
        
        self.favoritesTableView.isFavoritesView = true
        self.favoritesTableView.isChatButtonHidden = false
        self.favoritesTableView.parentViewController = self
        self.favoritesTableView.membersDelegate = self
//        self.favoritesTableView.userList = self.userList
        
        let moreBarButtonItem: UIBarButtonItem = UIBarButtonItem(image: UIImage(named: "ic_dropdown"), style: UIBarButtonItemStyle.done, target: self, action: #selector(didMoreButtonPressed(_:)))
        
        let locationBarButtonItem: UIBarButtonItem = UIBarButtonItem(image: UIImage(named: "ic_discover"), style: UIBarButtonItemStyle.done, target: self, action: #selector(didLocationButtonPressed(_:)))
        
        let locationImageInset = UIEdgeInsets(top: 0, left: 30, bottom: 0, right: 0);
        
        locationBarButtonItem.imageInsets = locationImageInset;
        
//        let negativeSpace:UIBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.fixedSpace, target: nil, action: nil)
////        negativeSpace.width = -10.0
        self.navigationItem.rightBarButtonItems = [moreBarButtonItem, locationBarButtonItem]
    }
    
    // MARK: -  Web Services
    
    private func sendRequestForFavorites() {
        
        ApiServices.shared.requestForUserFavorites(onTarget: self, successfull: { (userProfileList, success) in
            
            
            self.userList = userProfileList
            
            self.favoritesTableView.userList = self.userList
            
            if self.userList.count > 0 {
                
                self.placeholderView.isHidden = true
            }
            else {
                
                self.placeholderView.isHidden = false
            }
            
            
        }) { (failure) in
            
        }
    }
    
    func sendRequestForDeleteFavorite(_ favoriteId: String) {
        
        ApiServices.shared.requestForDeleteFavorite(onTarget: self, favoriteId, successfull: { (success) in
            
            self.sendRequestForFavorites()
            
        }) { (failure) in
        
        }
    }
    
    // MARK: - Buttons Action
    
    @objc func didMoreButtonPressed(_ sender: UIBarButtonItem) {
        
    }
    
    @objc func didLocationButtonPressed(_ sender: UIBarButtonItem) {
        
        let mapViewController: MapViewController = self.storyboard?.instantiateViewController(withIdentifier: "MapViewController") as! MapViewController
        
        self.navigationController?.pushViewController(mapViewController, animated: true)
        
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

extension FavoritesViewController: MembersTableViewDelegate {
    
    func membersTableView(_ tableView: MembersTableView, didDeleteRowAt indexPath: IndexPath) {
        
        let userProfile: UserProfile = tableView.userList[indexPath.row]
        
        tableView.userList.remove(at: indexPath.row)
        
        tableView.beginUpdates()
        tableView.endUpdates()
        
        sendRequestForDeleteFavorite(userProfile.userId)
    }
    
    func membersTableView(_ tableView: MembersTableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
    func membersTableView(_ tableView: MembersTableView, didChatButtonPressed sender: UIButton, atIndexPath: IndexPath) {
        
        let userProfile: UserProfile = self.userList[atIndexPath.row]
        
        self.subscribeToChannel(userProfile.channel)
        
        let chatViewController: ChatViewController = self.storyboard?.instantiateViewController(withIdentifier: "ChatViewController") as! ChatViewController
        
        chatViewController.userProfile = userProfile
        chatViewController.loginUserProfile = self.loginUserProfile
        self.navigationController?.pushViewController(chatViewController, animated: true)
    }
    
    func membersTableView(_ tableView: MembersTableView, didMoreButtonPressed sender: UIButton, atIndexPath: IndexPath) {
        
        
    }
}
