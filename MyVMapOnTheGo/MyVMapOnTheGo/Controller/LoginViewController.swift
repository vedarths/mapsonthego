//
//  LogindViewController.swift
//  MyVMapOnTheGo
//
//  Created by Vedarth Solutions on 11/10/18.
//  Copyright © 2018 Vedarth Solutions. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {
    
    
    @IBOutlet weak var userName: UITextField!
    @IBOutlet weak var password: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.completeLogin()
    }
    @IBAction func doLogin(_ sender: Any) {
        UdacityClient.sharedInstance().authenticateWithViewController(self) { (success, errorString) in
            performUIUpdatesOnMain {
                if success {
                    self.completeLogin()
                } else {
                    self.displayError(errorString)
                }
            }
        }
    }
    
    
    func getUserName() -> String {
        return (self.userName?.text)!
    }
    
    func getPassword() -> String {
        return (self.password?.text)!
    }
    
    private func completeLogin() {
        let controller = storyboard!.instantiateViewController(withIdentifier: "PostLoginNavigationController") as! UINavigationController
        present(controller, animated: true, completion: nil)
    }
    
    func displayError(_ errorString: String?) {
        if let errorString = errorString {
            print(errorString)
        }
    }
}
