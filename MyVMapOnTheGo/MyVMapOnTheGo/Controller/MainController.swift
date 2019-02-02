//
//  MainController.swift
//  MyVMapOnTheGo
//
//  Created by Vedarth Solutions on 1/29/19.
//  Copyright © 2019 Vedarth Solutions. All rights reserved.
//

import Foundation
import UIKit

class MainController: UITabBarController {
    
    var user: UdacityUser?
    var student: Location?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        refresh(nil)
    }
    
    @IBAction func addLocation(_ sender: Any) {
        let controller = storyboard!.instantiateViewController(withIdentifier: "AddLocationViewController") as! UINavigationController
        present(controller, animated: true, completion: nil)
    }
    
    @IBAction func doLogout(_ sender: Any) {
        let confirmationAlert = UIAlertController(title: "Logout", message: "Do you really want to logout?", preferredStyle: .alert)
        
        self.present(confirmationAlert, animated: true, completion: nil)
        
        let logoutAction = UIAlertAction(title: "Logout", style: .default, handler: { (action: UIAlertAction!) in
            // Try to delete API session for more security
            UdacityClient.sharedInstance().logout { (success, error) -> Void in
                // Go to login screen
                self.dismiss(animated: true, completion: nil)
           
            };
        })
        confirmationAlert.addAction(logoutAction)
    }
    
    @IBAction func refresh(_ sender: UIBarButtonItem?) {
        let viewManagers = [ViewManager(), ViewManager()]
        
        for i in 0 ... 1 {
            viewManagers[i].showView(view: viewControllers![i].view)
        }
        
        ParseClient.sharedInstance().getAllLocations { (success, locations, error) -> Void in
            DispatchQueue.main.async {
                // Hide all views
                for i in 0 ... 1 {
                    viewManagers[i].hideDefaultView()
                }
                
                guard error == nil else {
                    self.showError(message: error!)
                    return
                }
                (self.viewControllers![0] as! StudentLocationsViewController).getLocations()
                (self.viewControllers![1] as! MapTableViewController).doRefresh()
            };
        }
    }
    
    func showError(message: String, dismissButtonTitle: String = "OK") {
        let controller = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        
        controller.addAction(UIAlertAction(title: dismissButtonTitle, style: .default) { (action: UIAlertAction!) in
            controller.dismiss(animated: true, completion: nil)
        })
        
        self.present(controller, animated: true, completion: nil)
    }
}
