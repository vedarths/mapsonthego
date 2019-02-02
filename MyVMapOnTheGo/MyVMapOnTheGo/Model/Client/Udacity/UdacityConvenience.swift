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
    
    
    func getUser(id: String, completionHandlerForGetUser: @escaping (_ success: Bool, _ user: UdacityUser?, _ errorString: String?) -> Void) {
        let method : String = Methods.Users + "/\(id)"
        let parameters = [String:AnyObject]()
        let _ = taskForGETMethod(method, parameters: parameters as [String:AnyObject]) { (results, error) in
            
            /* 2. Send the desired value(s) to completion handler */
            if let error = error {
                print(error)
                completionHandlerForGetUser(false, nil, "Could not get data from Udacity for getUser")
            } else {
                
                guard error == nil else {
                    completionHandlerForGetUser(false, nil, "Get User Failed.")
                    return
                }
                
                guard let firstName = results?["first_name"] as? String,
                    let lastName = results?["last_name"] as? String else {
                        print("Can't find [user]['first_name'] or [user]['last_name'] in response")
                        completionHandlerForGetUser(false, nil, "Connection error")
                        return
                }
                
                let user = UdacityUser(dictionary: [
                    "id": id as AnyObject,
                    "firstName": firstName as AnyObject,
                    "lastName": lastName as AnyObject,
                    ])
                completionHandlerForGetUser(true, user, nil)
            }
        }
    }
    
    func logout(_ completionHandlerForDelete: @escaping (_ success: Bool, _ errorString: String?) -> Void) {
        
        let method : String = Methods.Session
        let parameters = [String:AnyObject]()
        let _ = taskForDeleteMethod(method, parameters: parameters) {
            (error) in
            if let error = error {
                print(error)
                completionHandlerForDelete(false, "Could not logout user from Udacity")
            } else {
                guard error == nil else {
                    completionHandlerForDelete(false, "Logout User Failed.")
                    return
                }
                completionHandlerForDelete(true, nil)
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
                
                guard let accountDictionary = results?["account"] as? NSDictionary else {
                    print("Could not find dictionary account in \(results!)")
                    completionHandlerForSession(false, nil, "Login Failed (Account).")
                    return
                }
                
                guard let userId = accountDictionary["key"] as? String else {
                    print("Could not find key in \(results!)")
                    completionHandlerForSession(false, nil, "Login Failed (Key).")
                    return
                }
                self.userId = userId
                completionHandlerForSession(true, sessionId, nil)
            }
        }
    }
    
    
}
