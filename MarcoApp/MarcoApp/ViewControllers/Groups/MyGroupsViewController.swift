//
//  MyGroupsViewController.swift
//  MarcoApp
//
//  Created by Nabeel Hayat on 09/11/2017.
//  Copyright © 2017 GrayScaleLogic. All rights reserved.
//

import UIKit
import SDWebImage

class MyGroupsViewController: BaseViewController {
    
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    @IBOutlet weak var mainTabView: TabView!
    
    @IBOutlet weak var mainContainerView: UIView!
    @IBOutlet weak var myGroupsCollectionView: UICollectionView!
    
    @IBOutlet weak var placeholderView: UIView!
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var detailLabel: UILabel!
    
    @IBOutlet weak var discoverButton: UIButton!
    @IBOutlet weak var createButton: UIButton!
    
    @IBOutlet weak var createButtonTopConstraint: NSLayoutConstraint!
    
    var createGroupList: [GroupCreateObject] = [GroupCreateObject]()
    
    var allGroupListTemp: [GroupObject] = [GroupObject]()
    
    var memberGroupList: [GroupObject] = [GroupObject]()
    var adminGroupList: [GroupObject] = [GroupObject]()
    
    var allGroupList: [GroupObject] = [GroupObject]() {
        
        didSet {
            
            if allGroupList.count > 0 {
                
                placeholderView.isHidden = true
            }
            else {
                if allGroupListTemp.count > 0 || self.isSearching {
                    
                    placeholderView.isHidden = true
                }
                else {
                
                    placeholderView.isHidden = false
                }
            }
            
//            self.setGroupLists()
        }
    }
    
    var isShowingFeed: Bool = false
    var isSearchGroup: Bool = false
    
    var isSearching: Bool = false
    
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.hideNavigationMenuButtonItem = false
        self.showBackButtonItem = false

        // Do any additional setup after loading the view.
        
        self.fetchGroupsFromDB()
        
        self.setupViews()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        
        if AppDefaults.getDLJoinGroupId() != "" {
            
            self.populateJoinGroupController()
        }
        
        
        self.isShowingFeed = false
        
        NotificationCenter.default.addObserver(self, selector: #selector(didGotoFeedViewController(_:)), name: .GOTOFeedNotification, object: nil)
        
        if !self.isSearchGroup {
            
            self.getMyGroups()
            self.sendRequestForGetGroupCategories()
            self.sendRequestForGetGroupPrices()
            
        }
        
        if self.allGroupList.count > 0 {
            
            self.setGroupLists()
            
            self.myGroupsCollectionView.reloadData()
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
    }

    override func didBackButtonPressed(_ sender: UIBarButtonItem) {
        super.didBackButtonPressed(sender)
        
    }
    
    override func didMenuButtonPressed(_ sender: UIBarButtonItem) {
        super.didMenuButtonPressed(sender)
        
    }
    
    // MARK: - Helper Functions
    
    fileprivate func populateJoinGroupController() {
        
        let groupId: Int = AppDefaults.getDLJoinGroupId().intValue
        
        AppDefaults.setDLJoinGroupId("")
        
        let groupDetailViewController: GroupDetailViewController = self.storyboard?.instantiateViewController(withIdentifier: "GroupDetailViewController") as! GroupDetailViewController
        
        let group: GroupObject = GroupObject()
        
        group.groupId = groupId
        
        groupDetailViewController.group = group
        groupDetailViewController.isDeeplinking = true
        
        self.navigationController?.pushViewController(groupDetailViewController, animated: true)
    }
    
    @objc func didGotoFeedViewController(_ notification: Notification) {
        
        if self.isShowingFeed == false {
            
            self.isShowingFeed = true
        
            self.navigationController?.popToRootViewController(animated: true)
            
            if let groupObject: GroupObject = notification.object as? GroupObject {
                
                let feedViewController: FeedsViewController = AppUI.mainStoryboard.instantiateViewController(withIdentifier: "FeedsViewController") as! FeedsViewController
                feedViewController.isGroupFeeds = true
                feedViewController.groupObject = groupObject
                
                self.navController?.pushViewController(feedViewController, animated: true)
            }
        }
    }
    
    private func fetchGroupsFromDB() {
        
        self.allGroupList = AppFunctions.fetchGroupsFromDB(.MyGroups)
        
        self.setGroupLists()
        
        self.myGroupsCollectionView.reloadData()
    }
    
    func setupViews() {
    
//        self.groupList.append(UserGroup(index: 0))
//        self.groupList.append(UserGroup(index: 2))
//        self.groupList.append(UserGroup(index: 1))
        
        self.searchBar.placeholder = "Search groups..."
        self.searchBar.searchBarStyle = .prominent
        self.searchBar.delegate = self
        self.searchBar.barTintColor = AppTheme.whiteColor
        self.searchBar.tintColor = AppTheme.blackColor
        self.searchBar.backgroundColor = AppTheme.whiteColor
        self.searchBar.setBackgroundImage(UIImage(), for: .any, barMetrics: UIBarMetrics.default)

        let textField: UITextField = self.searchBar.value(forKey: "_searchField") as! UITextField
        textField.clearButtonMode = .never;
        
        self.mainTabView.delegate = self
        
        self.mainTabView.setupTabButtons(tabs: ["ALL", "MEMBERS", "ADMIN"])
        
        self.myGroupsCollectionView.register(UINib(nibName: "DiscoverCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "DiscoverCollectionViewCell")
        
        self.myGroupsCollectionView.delegate = self
        self.myGroupsCollectionView.dataSource = self
    
        
        let createBarButtonItem: UIBarButtonItem = UIBarButtonItem(image: UIImage(named: "ic_nb_add"), style: UIBarButtonItemStyle.done, target: self, action: #selector(didCreateGroupButtonPressed(_:)))
        
//        let negativeSpace:UIBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.fixedSpace, target: nil, action: nil)
////        negativeSpace.width = -10.0
        self.navigationItem.rightBarButtonItems = [createBarButtonItem]
        
        let edgeInsets = UIEdgeInsets(top: 10, left: 0, bottom: 50, right: 0)
        self.myGroupsCollectionView.contentInset = edgeInsets
        self.automaticallyAdjustsScrollViewInsets = false
    }
    
    private func sortedBy() {
        
        let tempAllGroupList = self.allGroupList
        
        let sortedResultList = tempAllGroupList.sorted { $0.groupJoinDate > $1.groupJoinDate }
        
        self.allGroupList = sortedResultList
    }
    
    private func setGroupLists() {
        
        self.adminGroupList.removeAll()
        self.memberGroupList.removeAll()
        
        self.sortedBy()
        
        if self.allGroupList.count > 0 {
            
            for currentGroup: GroupObject in self.allGroupList {
                
                if currentGroup.groupCreator.userId == self.loginUserProfile.userId {
                    
                    self.adminGroupList.append(currentGroup)
                }
                else {
                    
                    self.memberGroupList.append(currentGroup)
                }
            }
        }
    }
    
    // MARK: - Web Services
    
    private func getMyGroups() {
        
        ApiServices.shared.requestForMyGroups(onTarget: self, successfull: { (success, groupsList) in
            
            self.allGroupList = groupsList
            
            self.setGroupLists()
            
            self.myGroupsCollectionView.reloadData()
            
        }) { (failure) in
            
            self.hidePKHUD()
        }
    }
    
    private func sendRequestForGetGroupCategories() {
     
        ApiServices.shared.requestForGroupDefaultCategories(onTarget: self, isBackground: true, successfull: { (success) in
            
            print("Categories Successful")
            
        }) { (failure) in
            
            
        }
    }
    
    private func sendRequestForGetGroupPrices() {
        
        ApiServices.shared.requestForGroupDefaultPrices(onTarget: self, isBackground: true, successfull: { (success) in
            
            print("Prices Successful")
            
        }) { (failure) in
            
            
        }
    }
    
    private func sendRequestForSearchGroup(_ searchText: String) {
        
        ApiServices.shared.requestForSearchMyGroups(onTarget: self, searchText, successfull: { (success, groupList) in
            
            print(groupList)
            
            self.isSearchGroup = true
            
            self.allGroupListTemp = self.allGroupList
            
            self.allGroupList = groupList
            
            self.setGroupLists()
            
            self.myGroupsCollectionView.reloadData()
            
            
        }) { (failure) in
            
            self.dismissSearch()
        }
    }
    
    // MARK: - Buttons Action
    
    @IBAction func didDiscoverButtonPressed(_ sender: UIButton) {
    
        if self.sideMenuViewController.contentViewController != nil {
            
            if self.sideMenuViewController.contentViewController.isKind(of: MainTabBarViewController.self) {
                
                let mainTabBarViewController: MainTabBarViewController = self.sideMenuViewController.contentViewController as! MainTabBarViewController
                
                mainTabBarViewController.selectedIndex = 1
            }
            else {
                
                self.sideMenuViewController.contentViewController = AppUI.mainStoryboard.instantiateViewController(withIdentifier: AppConstants.kDiscoverSegues)
            }
        }
    }
    
    @IBAction func didCreateButtonPressed(_ sender: UIButton) {
    
        let createGroupViewController: CreateGroupViewController = self.storyboard?.instantiateViewController(withIdentifier: "CreateGroupViewController") as! CreateGroupViewController
        
        self.navigationController?.pushViewController(createGroupViewController, animated: true)
    }
    
    @objc func didCreateGroupButtonPressed(_ sender: UIButton) {
    
        let createGroupViewController: CreateGroupViewController = self.storyboard?.instantiateViewController(withIdentifier: "CreateGroupViewController") as! CreateGroupViewController
        createGroupViewController.delegate = self
        
        self.navigationController?.pushViewController(createGroupViewController, animated: true)
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

extension MyGroupsViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        if !self.isSearching {
        
            if !(self.searchBar.text?.isEmpty)! {
                
                self.isSearching = true
                
                let searchText: String = searchBar.text!
                
                self.sendRequestForSearchGroup(searchText)
            }
        }
    }
    
    fileprivate func dismissSearch() {
        
        self.isSearchGroup = false
        
        self.searchBar.text = ""
        
        if self.isSearching {
            
            self.isSearching = false
            
            self.allGroupList = self.allGroupListTemp
        }
        
        self.setGroupLists()
        
        self.myGroupsCollectionView.reloadData()
        
        self.allGroupListTemp.removeAll()
        
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

extension MyGroupsViewController: TabViewDelegate {
    
    private func updateCollectioViewState(_ groupList: [GroupObject]) {
        
        if groupList.count > 0 {
            
            self.placeholderView.isHidden = true
            self.myGroupsCollectionView.isHidden = false
            
            self.myGroupsCollectionView.reloadData()
        }
        else {
            
            if self.allGroupListTemp.count > 0 || self.isSearching {
                
                self.placeholderView.isHidden = true
            
                self.myGroupsCollectionView.isHidden = false
                
                self.myGroupsCollectionView.reloadData()
            }
            else {
                
                self.placeholderView.isHidden = false
                self.myGroupsCollectionView.isHidden = true
            }
            
            
        }
    }
    
    func tabView(_ tabView: TabView, selectionChanged: Int) {
        
        self.dismissSearch()
        
        if selectionChanged == 0 {

            self.updateCollectioViewState(self.allGroupList)
            
            self.discoverButton.isHidden = false
            self.createButton.isHidden = false
            self.createButtonTopConstraint.constant = 10
            
            self.titleLabel.text = "You have not joined or created any groups"
            self.detailLabel.text = "All the groups that you join or have created will show up here. Go to Discover to search for Groups or create your own group now."
        }
        else if selectionChanged == 1 {

            self.updateCollectioViewState(self.memberGroupList)
            
            self.discoverButton.isHidden = false
            self.createButton.isHidden = true
            self.createButtonTopConstraint.constant = 10
            
            self.titleLabel.text = "You have not joined any groups"
            self.detailLabel.text = "Here all the members from the group you join will show up. Go to Discover to search for Groups."
        }
        else if selectionChanged == 2 {
            
            self.updateCollectioViewState(self.adminGroupList)
            
            self.discoverButton.isHidden = true
            self.createButton.isHidden = false
            self.createButtonTopConstraint.constant = -self.discoverButton.frame.size.height
            
            self.titleLabel.text = "You have not created any groups"
            self.detailLabel.text = "All the groups that you have created will show up here. Click the button below to create your Group now."
        }
    }
}

extension MyGroupsViewController: CreateGroupDelegate {
    
    func didCreateGroup(_ groupObject: GroupObject, _ profileImage: UIImage?, _ coverImage: UIImage?) {
        
        
        let createGroupObject: GroupCreateObject = GroupCreateObject(groupId: groupObject.groupId, indexPath: IndexPath(item: 0, section: 0))
        
        if let newProfileImage: UIImage = profileImage {
            
            groupObject.profileImage = newProfileImage
            createGroupObject.isAvatarPicture = true
        }
        else {
            
            createGroupObject.isAvatarPicture = false
        }
        
        if let newCoverImage: UIImage = coverImage {
            
            groupObject.coverImage = newCoverImage
            createGroupObject.isCoverPicture = true
        }
        else {
            
            createGroupObject.isCoverPicture = false
        }
        
        self.createGroupList.insert(createGroupObject, at: 0)
        
        self.insertNewGroupToDB(groupObject)
        
        self.allGroupList.insert(groupObject, at: 0)
        
        self.setGroupLists()
        
        self.myGroupsCollectionView.reloadData()
        
        
        if createGroupObject.isAvatarPicture {
            
            self.uploadProfileImage(profileImage!, with: groupObject, coverImage)
        }
        else if createGroupObject.isCoverPicture {
            
            self.uploadCoverImage(coverImage!, with: groupObject)
        }
        else {
            
            ResponseHandler.updateGroup(groupObject, completion: { (success) in
                
                
            })
            
            let createIndexPath: IndexPath = IndexPath(item: 0, section: 0)
            
            self.myGroupsCollectionView.reloadItems(at: [createIndexPath])
        }
        
    }
    
    private func insertNewGroupToDB(_ groupObject: GroupObject) {
        
        ResponseHandler.groupResponse(false, GroupDBState.Creating, groupObject) { (success) in
            
            
        }
    }
    
    private func updateGroupsList(_ fileUrl: String, isCoverPicture: Bool = false, _ groupId: Int) {
        
        var updatedGroup: GroupObject!
        
        for group: GroupObject in self.allGroupList {
            
            if group.groupId == groupId {
                
                if isCoverPicture {
                    
                    group.groupCoverPicture = fileUrl
                }
                else {
                    
                    group.groupProfilePicture = fileUrl
                }
                
                updatedGroup = group
                
                break
            }
        }
        
        if updatedGroup != nil {
            
            ResponseHandler.updateGroup(updatedGroup, completion: { (success) in
                
                
            })
        }
    }
    
    private func uploadCoverImage(_ coverImage: UIImage!, with groupObject: GroupObject) {
        
        guard let newCoverImage = coverImage else { return }
        
        let urlString: String = AppConstants.kGroups + AppConstants.kChangeGroupCoverPicture
        
        ApiServices.shared.requestForUploadFile(onTarget: self, stringURL: urlString, groupId: groupObject.groupId, fileImage: newCoverImage, uploadProgress: {(progress) in
            
            print("Fraction: \(progress.fractionCompleted)")
            
            var createIndexPath: IndexPath = IndexPath(item: 0, section: 0)
            
            for createGroup in self.createGroupList {
                
                if createGroup.groupId == groupObject.groupId {
                    
                    createIndexPath = createGroup.indexPath
                    
                    createGroup.coverProgress = CGFloat(progress.fractionCompleted)
                }
            }
            
            self.myGroupsCollectionView.reloadItems(at: [createIndexPath])
            
        }, successfull: { (fileUrl, success) in
            
            for createGroup in self.createGroupList {
                
                if createGroup.groupId == groupObject.groupId {
                    
                    createGroup.coverPictureChanged = true
                }
            }
            
            //{"URL":"https://marcoapp.blob.core.windows.net/marco/4984e8ef-b0f5-458c-8c6e-6addc8fe9167.jpg"}
            
            let fileValue:String = fileUrl.replacingOccurrences(of: "\"", with: "")
            
            self.updateGroupsList(fileValue, isCoverPicture: true, groupObject.groupId)
            
            if self.allGroupList.count > 0 {
                
                var i = 0
                
                for createGroup in self.allGroupList {
                    
                    if createGroup.groupId == groupObject.groupId {
                        
                        break
                    }
                    
                    i = i + 1
                }
                
                let createIndexPath: IndexPath = IndexPath(item: i, section: 0)
            
                self.myGroupsCollectionView.reloadItems(at: [createIndexPath])
                
                self.allGroupList.removeAll()
                
                self.allGroupList = AppFunctions.fetchGroupsFromDB(.MyGroups)
            }
            
            
        }) { (failure) in
            
            self.hidePKHUD()
        }
    }
    
    private func uploadProfileImage(_ profileImage: UIImage!, with groupObject: GroupObject, _ coverImage: UIImage!) {
        
        guard let newProfileImage = profileImage else { return }
        
        let urlString: String = AppConstants.kGroups + AppConstants.kChangeGroupProfilePicture
    
        ApiServices.shared.requestForUploadFile(onTarget: self, stringURL: urlString, groupId: groupObject.groupId, fileImage: newProfileImage, uploadProgress: {(progress) in
            
            print("Fraction: \(progress.fractionCompleted)")
            
            var createIndexPath: IndexPath = IndexPath(item: 0, section: 0)
            
            for createGroup in self.createGroupList {
                
                if createGroup.groupId == groupObject.groupId {
                    
                    createIndexPath = createGroup.indexPath
                    
                    createGroup.profileProgress = CGFloat(progress.fractionCompleted)
                }
            }
            
            self.myGroupsCollectionView.reloadItems(at: [createIndexPath])
            
        }, successfull: { (fileUrl, success) in
            
            for createGroup in self.createGroupList {
                
                if createGroup.groupId == groupObject.groupId {
                    
                    createGroup.avatarPictureChanged = true
                }
            }
            
            //{"URL":"https://marcoapp.blob.core.windows.net/marco/4984e8ef-b0f5-458c-8c6e-6addc8fe9167.jpg"}
            
            let fileValue:String = fileUrl.replacingOccurrences(of: "\"", with: "")
            
            self.updateGroupsList(fileValue, groupObject.groupId)
            
            if self.allGroupList.count > 0 {
                
                var i = 0
                
                for createGroup in self.allGroupList {
                    
                    if createGroup.groupId == groupObject.groupId {
                        
                        break
                    }
                    
                    i = i + 1
                }
                
                let createIndexPath: IndexPath = IndexPath(item: i, section: 0)
                
                self.myGroupsCollectionView.reloadItems(at: [createIndexPath])
            }
            
            if let newCoverImage: UIImage = coverImage {
                
                self.uploadCoverImage(newCoverImage, with: groupObject)
            }
            else {
                
                self.allGroupList.removeAll()
                
                self.allGroupList = AppFunctions.fetchGroupsFromDB(.MyGroups)
            }
            
        }) { (failure) in
            
            self.hidePKHUD()
        }
    }
}

extension MyGroupsViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, DiscoverCollectionDelegate {
    
    // MARK: - DiscoverCollectionDelegate
    
    func discoverCollectionViewCell(_ cell: DiscoverCollectionViewCell, didJoinGroupPressed sender: UIButton, at indexPath: IndexPath) {
        
//        let groupDetailViewController: GroupDetailViewController = self.storyboard?.instantiateViewController(withIdentifier: "GroupDetailViewController") as! GroupDetailViewController
//
//        let group: GroupObject = self.allGroupList[indexPath.row]
//        
//        groupDetailViewController.group = group
//
//        self.navigationController?.pushViewController(groupDetailViewController, animated: true)
    }
    
    func discoverCollectionViewCell(_ cell: DiscoverCollectionViewCell, didMoreOptionPressed sender: UIButton, at indexPath: IndexPath) {
        
    }
    
    // MARK: UICollectionViewDataSource
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        
        return 1
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        
        if self.mainTabView.indexSelected == 0 {
            
            return self.allGroupList.count
        }
        else if self.mainTabView.indexSelected == 1 {
            
            return self.memberGroupList.count
        }
        else /*if self.mainTabView.indexSelected == 2*/ {
            
            return self.adminGroupList.count
        }
        
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: DiscoverCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: "DiscoverCollectionViewCell", for: indexPath) as! DiscoverCollectionViewCell
        
        var group: GroupObject = GroupObject()
        
        if self.mainTabView.indexSelected == 0 {
            
            group = self.allGroupList[indexPath.row]
        }
        else if self.mainTabView.indexSelected == 1 {
            
            group = self.memberGroupList[indexPath.row]
        }
        else /*if self.mainTabView.indexSelected == 2*/ {
            
            group = self.adminGroupList[indexPath.row]
        }
        
        // Configure the cell
        
        cell.delegate = self
        cell.indexPath = indexPath
        
        cell.coverPhotoImageView.layer.cornerRadius = 8;
        cell.ContainerView.layer.cornerRadius = 8;
        
        if self.createGroupList.count > 0 {
            
            for createObject: GroupCreateObject in self.createGroupList {
                
                if createObject.groupId == group.groupId {
                    
//                    cell.profileProgressView.isHidden = (createObject.isAvatarPicture) ? false : true
//                    cell.coverProgressView.isHidden = (createObject.isCoverPicture) ? false : true
                    
                    createObject.indexPath = indexPath
                    cell.dimsView.isHidden = false
                    
                    if createObject.isAvatarPicture {
                    
                        if createObject.profileProgress > 0.0 {
                            
                            cell.profileProgressView.isHidden = false
                        }
                        else {
                            
                            cell.profileProgressView.isHidden = true
                        }
                        
                        cell.profileProgressView.setProgress(to: (createObject.profileProgress * 100), duration: 0.0)
                    }
                    else {
                        
                        cell.profileProgressView.isHidden = true
                    }
                    
                    if createObject.isCoverPicture {
                        
                        if createObject.coverProgress > 0.0 {
                            
                            cell.coverProgressView.isHidden = false
                        }
                        else {
                            
                            cell.coverProgressView.isHidden = true
                        }
                        
                        cell.coverProgressView.progressValue = (createObject.coverProgress * 100)
                    }
                    else {
                        
                        cell.coverProgressView.isHidden = true
                    }
                    
                    
                    if createObject.isAvatarPicture && createObject.isCoverPicture {
                        
                        if createObject.profileProgress == 1.0 || createObject.coverProgress == 1.0 {
                            
                            if createObject.avatarPictureChanged && createObject.coverPictureChanged {
                                
                                cell.dimsView.isHidden = true
                                
//                                self.createGroupList.removeAll(createObject)
                                
                                break
                            }
                        }
                    }
                    else if createObject.isAvatarPicture {
                        
                        if createObject.profileProgress == 1.0 {
                            
                            if createObject.avatarPictureChanged {
                                
                                cell.dimsView.isHidden = true
                                
//                                self.createGroupList.removeAll(createObject)
                                
                                break
                            }
                        }
                    }
                    else if createObject.isCoverPicture {
                        
                        if createObject.coverProgress == 1.0 {
                            
                            if createObject.coverPictureChanged {
                                
                                cell.dimsView.isHidden = true
                                
//                                self.createGroupList.removeAll(createObject)
                                
                                break
                            }
                        }
                    }
                    else {
                     
                        cell.dimsView.isHidden = true
                    }
                    
                    break
                }
                else {
                    
                    cell.dimsView.isHidden = true
                }
            }
        }
        else {
            
            cell.dimsView.isHidden = true
        }
        
//        if group.isCreatedGroup != nil {
//
//            if group.isCreatedGroup {
//
//                cell.dimsView.isHidden = false
//
//                cell.dimsProfileProgressView.setProgress(to: self.progress, duration: 0.3)
//            }
//            else {
//
//                cell.dimsView.isHidden = true
//            }
//        }
//        else {
//
//            cell.dimsView.isHidden = true
//        }
        
        
        
        cell.profileImageView.imageBorderWidth = 4
        
        if self.loginUserProfile.userId == group.groupCreator.userId {
            
            var privateGroupString: String = ""
            
            if group.isPrivateGroup {
                
                privateGroupString = "Private"
            }
            else {
                
                privateGroupString = "Public"
            }
            
            let text = NSMutableAttributedString(string: privateGroupString)
            
            cell.groupDetail.attributedText = text.setFont(font: AppTheme.semiBoldFont(withSize: 15), kerningValue: -20)
        }
        else {
            
            let privateGroupString: String = group.groupCreator.fullName
            
            let text = NSMutableAttributedString(string: privateGroupString)
            
            cell.groupDetail.attributedText = text.setFont(font: AppTheme.semiBoldFont(withSize: 15), kerningValue: -20)
        }
        
        cell.membersLabel.text = "\(group.totalMembers.intValue)"
        
        cell.groupName.text = group.groupTitle
        cell.commentLabel.text = ""
        
        cell.joinButton.isHidden = true
        cell.joinedLabel.isHidden = true
        cell.commentView.isHidden = false
        
        if group.groupProfilePicture != nil && group.groupProfilePicture != "" {
            
            let urlString: URL = URL(string: group.groupProfilePicture)!
            
            cell.profileImageView.sd_setImage(with: urlString, placeholderImage: UIImage.getImage(withName: "group-default", imageColor: UIColor(hexString: "#cccccc"))) { (image, error, imageCacheType, url) in
                
            }
        }
        else {
            
            let placeholder: UIImage = (group.profileImage != nil) ? group.profileImage : UIImage.getImage(withName: "group-default", imageColor: UIColor(hexString: "#cccccc"))
            
            cell.profileImageView.image = placeholder
        }
        
        if group.groupCoverPicture != nil && group.groupCoverPicture != "" {
            
            let urlString: URL = URL(string: group.groupCoverPicture)!
            
            cell.coverPhotoImageView.sd_setImage(with: urlString, placeholderImage: UIImage(named: "cover_default")) { (image, error, imageCacheType, url) in
                
            }
        }
        else {
            
            let placeholder: UIImage = UIImage(named: "cover_default")!
            
            cell.coverPhotoImageView.image = placeholder
        }
        
        return cell
    }
    
    // MARK: UICollectionViewDelegateFlowLayout
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: self.view.frame.size.width, height: 230);
    }
    
    // MARK: UICollectionViewDelegate
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        var groupObject: GroupObject = GroupObject()
        
        if self.mainTabView.indexSelected == 0 {
            
            groupObject = self.allGroupList[indexPath.row]
        }
        else if self.mainTabView.indexSelected == 1 {
            
            groupObject = self.memberGroupList[indexPath.row]
        }
        else /*if self.mainTabView.indexSelected == 2*/ {
            
            groupObject = self.adminGroupList[indexPath.row]
        }
        
        var isCreatedFound: Bool = false
        var index = 0
        
        for createObject: GroupCreateObject in self.createGroupList {
            
            if createObject.groupId == groupObject.groupId {
                
                isCreatedFound = true
                
                break
            }
            
            index = index + 1
        }
        
        
        if isCreatedFound {
        
            self.createGroupList.remove(at: index)
            
            let groupCreatedViewController: GroupCreatedViewController = self.storyboard?.instantiateViewController(withIdentifier: "GroupCreatedViewController") as! GroupCreatedViewController
            
            groupCreatedViewController.createdGroup = groupObject
            
            self.navigationController?.pushViewController(groupCreatedViewController, animated: true)
        }
        else {
        
            let feedViewController: FeedsViewController = AppUI.mainStoryboard.instantiateViewController(withIdentifier: "FeedsViewController") as! FeedsViewController
            feedViewController.isGroupFeeds = true
            feedViewController.groupObject = groupObject
            
            self.navController?.pushViewController(feedViewController, animated: true)
        }
        
//        var group: GroupObject = GroupObject()
//        
//        if self.mainTabView.indexSelected == 0 {
//
//            group = self.allGroupList[indexPath.row]
//        }
//        else if self.mainTabView.indexSelected == 1 {
//
//            group = self.memberGroupList[indexPath.row]
//        }
//        else /*if self.mainTabView.indexSelected == 2*/ {
//
//            group = self.adminGroupList[indexPath.row]
//        }
//
//        let groupDetailViewController: GroupDetailViewController = self.storyboard?.instantiateViewController(withIdentifier: "GroupDetailViewController") as! GroupDetailViewController
//
////        let group: GroupObject = self.groupList[indexPath.row]
//
//        groupDetailViewController.group = group
//
//        self.navigationController?.pushViewController(groupDetailViewController, animated: true)
    
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
