//
//  MapViewController.swift
//  MarcoApp
//
//  Created by Nabeel Hayat on 01/12/2017.
//  Copyright © 2017 GrayScaleLogic. All rights reserved.
//

import UIKit

class MapViewController: BaseViewController {

    @IBOutlet weak var mapContainerView: MapContainerView!
    
    
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
        
        let moreBarButtonItem: UIBarButtonItem = UIBarButtonItem(image: UIImage(named: "ic_dropdown"), style: UIBarButtonItemStyle.done, target: self, action: #selector(didMoreButtonPressed(_:)))
        
        self.navigationItem.rightBarButtonItems = [moreBarButtonItem]
    }
    
    // MARK: - Buttons Action
    
    @objc func didMoreButtonPressed(_ sender: UIBarButtonItem) {
        
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
