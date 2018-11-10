//
//  LoginViewController.swift
//  MyVMapOnTheGo
//
//  Created by Vedarth Solutions on 11/3/18.
//  Copyright © 2018 Vedarth Solutions. All rights reserved.
//

import Foundation
import GoogleSignIn
class LoginViewController: UIViewController, GIDSignInUIDelegate {
    
    @IBOutlet weak var GIDSignInButton: GIDSignInButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        GIDSignIn.sharedInstance()?.uiDelegate = self
        GIDSignIn.sharedInstance()?.signInSilently()
    }
    
    
}
