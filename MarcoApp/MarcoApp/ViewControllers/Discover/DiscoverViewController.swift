//
//  DiscoverViewController.swift
//  MarcoApp
//
//  Created by Nabeel Hayat on 28/10/2017.
//  Copyright © 2017 GrayScaleLogic. All rights reserved.
//

import UIKit
import SDWebImage

class DiscoverViewController: BaseViewController {
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var mainContainerView: UIView!
    @IBOutlet weak var tabContainerView: UIView!
    @IBOutlet weak var groupsCollectionView: UICollectionView!
    @IBOutlet weak var peopleTableView: MembersTableView!
    
    @IBOutlet weak var mainContainerLConstraint: NSLayoutConstraint!

    var userList: [UserProfile] = [UserProfile]()
    
    var groupListTemp: [GroupObject] = [GroupObject]()
    
    var groupList: [GroupObject] = [GroupObject]() {
        
        didSet {
            
            if groupList.count > 0 {
                
            }
            else {
                
            }
        }
    }
    
    private var tabView: TabView!
    
    var isSearchGroup: Bool = false
    var isSearching: Bool = false
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.hideNavigationMenuButtonItem = false
        self.showBackButtonItem = false
        // Do any additional setup after loading the view.
        
        self.fetchGroupsFromDB()
        
        if self.groupList.count == 0 {

            self.getAllPublicGroups()
        }
        
        self.setupViews()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationItem.title = "Discover"
        
//        if self.groupList.count == 0 {
        
            self.getAllPublicGroups(true)
//        }
        
        self.getAllMarcoUsers()
        self.getUpdatedProfile()
    }
    
    override func didBackButtonPressed(_ sender: UIBarButtonItem) {
        super.didBackButtonPressed(sender)
        
    }
    
    override func didMenuButtonPressed(_ sender: UIBarButtonItem) {
        super.didMenuButtonPressed(sender)
        
    }
    
    // MARK: - Helper Functions
    
    private func fetchGroupsFromDB() {
        
        self.groupList = AppFunctions.fetchGroupsFromDB(.DiscoverGroups)
        
        self.sortedBy()
        
        self.groupsCollectionView.reloadData()
    }
    
    func setupViews() {
        
//        self.groupList.append(UserGroup(index: 1))
//        self.groupList.append(UserGroup(index: 2))
//        self.groupList.append(UserGroup(index: 3))
//        self.groupList.append(UserGroup(index: 0))
//        self.groupList.append(UserGroup(index: 3))
//        self.groupList.append(UserGroup(index: 2))
//        self.groupList.append(UserGroup(index: 0))
//
//        self.userList = TempDataModel.getList(with: 19)
        
        self.searchBar.placeholder = "Search groups..."
        self.searchBar.searchBarStyle = .prominent
        self.searchBar.delegate = self
        self.searchBar.barTintColor = AppTheme.whiteColor
        self.searchBar.tintColor = AppTheme.blackColor
        self.searchBar.backgroundColor = AppTheme.whiteColor
        self.searchBar.setBackgroundImage(UIImage(), for: .any, barMetrics: UIBarMetrics.default)
        
        let textField: UITextField = self.searchBar.value(forKey: "_searchField") as! UITextField
        textField.clearButtonMode = .never;
        
        
        let frame: CGRect = CGRect(x: 0, y: 0, width: self.tabContainerView.frame.size.width, height: self.tabContainerView.frame.size.height)
        self.tabView = TabView(frame: frame)
        self.tabView.delegate = self
        self.tabView.setupTabButtons(tabs:["GROUPS", "PEOPLE"])
        self.tabContainerView.addSubview(self.tabView);
        
        self.peopleTableView.membersDelegate = self
        self.peopleTableView.isDiscoverView = true
        self.peopleTableView.isChatButtonHidden = true
        self.peopleTableView.parentViewController = self
        self.peopleTableView.userList = self.userList
        
        
        self.groupsCollectionView.register(UINib(nibName: "DiscoverCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "DiscoverCollectionViewCell")
        
        self.groupsCollectionView.delegate = self
        self.groupsCollectionView.dataSource = self
        
        
        let edgeInsets = UIEdgeInsets(top: 10, left: 0, bottom: 50, right: 0)
        self.peopleTableView.contentInset = edgeInsets
        self.groupsCollectionView.contentInset = edgeInsets
        self.automaticallyAdjustsScrollViewInsets = false
        
    }
    
    private func sortedBy() {
        
        let sortedResultList = self.groupList.sorted { $0.groupCreatedDate < $1.groupCreatedDate }
        
        self.groupList = sortedResultList
    }

    // MARK: - Web Services
    
    private func getAllMarcoUsers() {
        
        ApiServices.shared.requestForAllUsers(onTarget: self, successfull: { (success, userProfileList) in
            
            self.userList = userProfileList
            
            for userProfile: UserProfile in self.userList {
             
                if userProfile.userId == self.loginUserProfile.userId {
                    
                    self.userList.removeAll(userProfile)
                }
            }
            
            self.peopleTableView.userList = self.userList
//            self.peopleTableView.reloadData()
            
        }) { (failure) in
            
        }
    }
    
    private func getAllPublicGroups(_ isBackground: Bool = false) {
        
        if !isBackground {
        
            self.showPKHUD(WithMessage: "Getting groups...")
        }
        
        let parameters: [String : Any] = ["Date":""]
        
        ApiServices.shared.requestForPublicGroups(onTarget: self, parameters, successfull: { (success, groupsList) in
            
            self.hidePKHUD()
            
            self.groupList = groupsList
            
            self.sortedBy()
            
            self.groupsCollectionView.reloadData()
            
        }) { (failure) in
            
            self.hidePKHUD()
        }
    }
    
    private func getUpdatedProfile() {
        
        ApiServices.shared.requestForMyProfile(onTarget: self, successfull: { (success, isProfileFound) in
            
            
        }) { (failure) in
            
            self.hidePKHUD()
        }
    }
    
    private func sendRequestForSearchGroup(_ searchText: String) {
        
        ApiServices.shared.requestForSearchPublicGroups(onTarget: self, searchText, successfull: { (success, groupList) in
            
            print(groupList)
            
            self.isSearchGroup = true
            
            self.groupListTemp = self.groupList
            
            self.groupList = groupList
            
            self.groupsCollectionView.reloadData()
            
            
        }) { (failure) in
            
            self.dismissSearch()
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

// MARK: - MembersTableViewDelegate

extension DiscoverViewController: MembersTableViewDelegate {
    
    func membersTableView(_ tableView: MembersTableView, didDeleteRowAt indexPath: IndexPath) {
        
    }
    
    func membersTableView(_ tableView: MembersTableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
    func membersTableView(_ tableView: MembersTableView, didChatButtonPressed sender: UIButton, atIndexPath: IndexPath) {
        
    }
    
    func membersTableView(_ tableView: MembersTableView, didMoreButtonPressed sender: UIButton, atIndexPath: IndexPath) {
        
        let favortiteUser: UserProfile = self.userList[atIndexPath.row]
        
        let alertController = UIAlertController(title: "Marco", message: "Are you sure you want to add \(favortiteUser.firstName ?? "User") into your favorites?", preferredStyle: .alert)
        
        let okAction: UIAlertAction = UIAlertAction(title: "YES", style: .default) { (okAction) in
        
            let parameters: [String: Any] = ["Idol": favortiteUser.userId]
            
            ApiServices.shared.requestForAddToFavorite(onTarget: self, parameters, successfull: { (success, serverMessage) in
                
                var messageString: String = ""
                
                if serverMessage == "" {
                    
                    messageString = "Successfully Added to your favorites."
                }
                else {
                    
                    messageString = "This user is already in your favorites."
                }
                
                let alertController = UIAlertController(title: "Marco", message: messageString, preferredStyle: .alert)
                
                let okAction: UIAlertAction = UIAlertAction(title: "OK", style: .default) { (okAction) in
                    
                }
                
                alertController.addAction(okAction)
                
                self.present(alertController, animated: true, completion: nil)
                
            }) { (failture) in
                
                
            }
        }
        
        let cancelAction: UIAlertAction = UIAlertAction(title: "Cancel", style: .cancel) { (cancelAction) in
            
            
        }
        
        alertController.addAction(okAction)
        alertController.addAction(cancelAction)
        
        self.present(alertController, animated: true, completion: nil)
    }
}

// MARK: - UISearchBarDelegate

extension DiscoverViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        if !self.isSearching {
         
            if !(self.searchBar.text?.isEmpty)! {
                
                self.isSearching = true
                
                let searchText: String = searchBar.text!
                
                if self.tabView.indexSelected == 0 {
                    
                    self.sendRequestForSearchGroup(searchText)
                    
                }
                else if self.tabView.indexSelected == 1 {
                    
                    self.peopleTableView.searchUsers(by: searchText)
                }
            }
        }
    }
    
    fileprivate func dismissSearch() {
        
        self.isSearchGroup = false
        
        self.searchBar.text = ""
        
        if self.isSearching {
            
            self.isSearching = false
            
            if self.tabView.indexSelected == 0 {
                
                self.groupList = self.groupListTemp
                
                self.groupsCollectionView.reloadData()
                
            }
            else if self.tabView.indexSelected == 1 {
                
                self.peopleTableView.didEndSearch()
            }
        }
        
        self.searchBar.resignFirstResponder()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
     
        self.dismissSearch()
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        
        self.searchBar.showsCancelButton = false
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        
        self.searchBar.showsCancelButton = true
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        if self.searchBar.text == "" {
            
            self.dismissSearch()
        }
        
        self.searchBar.resignFirstResponder()
        
    }
    
}

extension DiscoverViewController: TabViewDelegate {

    func tabView(_ tabView: TabView, selectionChanged: Int) {
        
        self.dismissSearch()
        
        switch selectionChanged {
        case 0:
            self.mainContainerLConstraint.constant = 0.0
            self.searchBar.placeholder = "Search groups..."
//            self.peopleTableView.isHidden = true
//            self.groupsCollectionView.isHidden = false
            
            self.getAllPublicGroups(true)
            
            break
        case 1:
            self.mainContainerLConstraint.constant = -self.view.frame.size.width
            self.searchBar.placeholder = "Search peoples..."
//            self.peopleTableView.isHidden = false
//            self.groupsCollectionView.isHidden = true
            
            self.getAllMarcoUsers()
            
            break
        default:
            break
        }
        
        UIView.animate(withDuration: 0.3) { 
            self.view.layoutIfNeeded()
        }
    }
}

extension DiscoverViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, DiscoverCollectionDelegate {

    // MARK: - DiscoverCollectionDelegate
    
    func discoverCollectionViewCell(_ cell: DiscoverCollectionViewCell, didJoinGroupPressed sender: UIButton, at indexPath: IndexPath) {
        
        
        
        let groupDetailViewController: GroupDetailViewController = self.storyboard?.instantiateViewController(withIdentifier: "GroupDetailViewController") as! GroupDetailViewController
        
        let group: GroupObject = self.groupList[indexPath.row]
        
        groupDetailViewController.group = group
        
        self.navigationController?.pushViewController(groupDetailViewController, animated: true)
    }
    
    func discoverCollectionViewCell(_ cell: DiscoverCollectionViewCell, didMoreOptionPressed sender: UIButton, at indexPath: IndexPath) {
        
    }
    
    // MARK: UICollectionViewDataSource
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        
        return 1
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return self.groupList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: DiscoverCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: "DiscoverCollectionViewCell", for: indexPath) as! DiscoverCollectionViewCell
        
        cell.delegate = self
        cell.indexPath = indexPath
        
        cell.coverPhotoImageView.layer.cornerRadius = 8;
        cell.ContainerView.layer.cornerRadius = 8;
        
        let group: GroupObject = self.groupList[indexPath.row]
        
//        cell.coverPhotoImageView.image = UIImage(named: group.groupCoverPhoto)
//        cell.profileImageView.image = UIImage(named: group.userProfile.avatar)
        // Configure the cell
        cell.profileImageView.imageBorderWidth = 4
        
        let privateGroupString: String = group.groupCreator.fullName
        
        let text = NSMutableAttributedString(string: privateGroupString)
        
        cell.groupDetail.attributedText = text.setFont(font: AppTheme.semiBoldFont(withSize: 15), kerningValue: -20)
        
        cell.membersLabel.text = "\(group.totalMembers.intValue)"
        
        
        if let totalPosts = group.totalPosts {
            
            if totalPosts.intValue == 0 {
                
                cell.commentLabel.isHidden = true
                cell.commentImageView.isHidden = true
            }
            else {
                
                cell.commentLabel.isHidden = false
                cell.commentImageView.isHidden = false
                
                cell.commentLabel.text = "\(totalPosts.intValue)"
            }
        }
        else {
         
            cell.commentLabel.isHidden = true
            cell.commentImageView.isHidden = true
        }
        
        cell.groupName.text = group.groupTitle
        cell.joinButton.isHidden = !group.isUserCanJoin
        cell.joinedLabel.isHidden = group.isUserCanJoin
        cell.commentView.isHidden = false
        
        cell.dimsView.isHidden = true
        
        if group.groupProfilePicture != nil && group.groupProfilePicture != "" {
            
            let urlString: URL = URL(string: group.groupProfilePicture)!
            
            
            cell.profileImageView.sd_setImage(with: urlString, placeholderImage: UIImage.getImage(withName: "group-default", imageColor: UIColor(hexString: "#cccccc"))) { (image, error, imageCacheType, url) in
                
            }
        }
        else {
            
            cell.profileImageView.image = UIImage.getImage(withName: "group-default", imageColor: UIColor(hexString: "#cccccc"))
        }
        
        if group.groupCoverPicture != nil && group.groupCoverPicture != "" {
            
            let urlString: URL = URL(string: group.groupCoverPicture)!
            
            cell.coverPhotoImageView.sd_setImage(with: urlString, placeholderImage: UIImage(named: "cover_default")) { (image, error, imageCacheType, url) in
                
            }
        }
        else {
            
            cell.coverPhotoImageView.image = UIImage(named: "cover_default")
        }
        
        return cell
    }
    
    // MARK: UICollectionViewDelegateFlowLayout
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: self.view.frame.size.width, height: 230);
    }
    
    // MARK: UICollectionViewDelegate
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let group: GroupObject = self.groupList[indexPath.row]
        
        if !group.isUserCanJoin {
         
            let feedViewController: FeedsViewController = AppUI.mainStoryboard.instantiateViewController(withIdentifier: "FeedsViewController") as! FeedsViewController
            feedViewController.isGroupFeeds = true
            feedViewController.groupObject = group
            
            self.navController?.pushViewController(feedViewController, animated: true)
        }
    }
    
    /*
     // Uncomment this method to specify if the specified item should be highlighted during tracking
     func collectionView(_ collectionView: UICollectionView, shouldHighlightItemAt indexPath: IndexPath) -> Bool {
     return true
     }
     */
    
    /*
     // Uncomment this method to specify if the specified item should be selected
     func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
     return true
     }
     */
    
    /*
     // Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
     func collectionView(_ collectionView: UICollectionView, shouldShowMenuForItemAt indexPath: IndexPath) -> Bool {
     return false
     }
     
     func collectionView(_ collectionView: UICollectionView, canPerformAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) -> Bool {
     return false
     }
     
     func collectionView(_ collectionView: UICollectionView, performAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) {
     
     }
     */
}
