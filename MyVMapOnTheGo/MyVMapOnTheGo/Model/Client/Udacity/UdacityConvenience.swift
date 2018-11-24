//
//  UdacityConvenience.swift
//  MyVMapOnTheGo
//
//  Created by Vedarth Solutions on 11/17/18.
//  Copyright © 2018 Vedarth Solutions. All rights reserved.
//
import UIKit
import Foundation

extension UdacityClient {
    
    func authenticateWithViewController(_ hostViewController: UIViewController, completionHandlerForSession: @escaping (_ success: Bool, _ errorString: String?) -> Void) {
        
        let loginViewController = hostViewController as! LoginViewController
        self.userName = loginViewController.getUserName()
        self.password = loginViewController.getPassword()
        getSessionId() { (success, sessionId, errorString) in
            
            if success {
                print("Login successful with session id: \(sessionId!)")
                self.sessionId = sessionId
                completionHandlerForSession(true, nil)
            }
        }
    }
    
    private func getSessionId(_ completionHandlerForSession: @escaping (_ success: Bool, _ sessionId: String?, _ errorString: String?) -> Void) {
        
        let jsonBody = "{\"udacity\": {\"\(JSONBodyKeys.UserName)\": \"\(self.userName!)\", \"password\": \"\(self.password!)\"}}"
        let method : String = Methods.Session
        let _ = taskForPOSTMethod(method, jsonBody: jsonBody) { (results, error) in
        
        /* 3. Send the desired value(s) to completion handler */
        if let error = error {
            print(error)
            completionHandlerForSession(false, nil, "Login Failed (Udacity Session).")
        } else {
            print("logged in successfully.. yaay!")

            guard let sessionDictionary = results?["session"] as? NSDictionary else {
                print("Could not find dictionary session in \(results!)")
                completionHandlerForSession(false, nil, "Login Failed (Session).")
                return
            }
            guard let sessionId = sessionDictionary["id"] as? String else {
                print("Could not find id in \(results!)")
                completionHandlerForSession(false, nil, "Login Failed (Session Id).")
                return
            }
            completionHandlerForSession(true, sessionId, nil)
            
           }
      }
    }
}
