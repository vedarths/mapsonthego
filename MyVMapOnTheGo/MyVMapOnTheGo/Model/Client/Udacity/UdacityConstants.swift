//
//  UdacityConstants.swift
//  MyVMapOnTheGo
//
//  Created by Vedarth Solutions on 11/10/18.
//  Copyright © 2018 Vedarth Solutions. All rights reserved.
//

import Foundation

extension UdacityClient {
    
    
    struct Constants {
        
        static let AcceptKey = "Accept"
        static let ContentType = "Content-Type"
        
        static let ApiScheme = "https"
        static let ApiHost = "www.udacity.com"
        static let ApiPath = "/api"
    }
    
    struct Methods {
        static let Session = "/session"
    }
    struct JSONBodyKeys {
        static let UserName = "username"
        static let Password = "password"
    }
    
    struct JSONResponseKeys {
        static let SessionID = "sessionId"
        static let Expiration = "expiration"
        static let StatusMessage = "status_message"
        static let StatusCode = "status_code"
        static let Registered = "registered"
        static let Key = "key"
    }
    
    struct Session  {
        let id: String
        let expiration: String
        
        init(dictionary: [String:AnyObject]) {
            id = dictionary[UdacityClient.JSONResponseKeys.SessionID] as! String
            expiration = dictionary[UdacityClient.JSONResponseKeys.Expiration] as! String
        }
    }
    
    struct Account {
        let registered: String
        let key: String
        init(dictionary: [String:AnyObject]) {
            registered = dictionary[UdacityClient.JSONResponseKeys.Registered] as! String
            key = dictionary[UdacityClient.JSONResponseKeys.Key] as! String
        }
        
    }
}

