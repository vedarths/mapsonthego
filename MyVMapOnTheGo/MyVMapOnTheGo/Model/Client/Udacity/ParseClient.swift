//
//  ParseClient.swift
//  MyVMapOnTheGo
//
//  Created by Vedarth Solutions on 11/10/18.
//  Copyright © 2018 Vedarth Solutions. All rights reserved.
//

import Foundation

class ParseClient: NSObject {
    
    // MARK: Properties
    
    // shared session
    var session = URLSession.shared
    
    

class func sharedInstance() -> ParseClient {
    struct Singleton {
        static var sharedInstance = ParseClient()
    }
    return Singleton.sharedInstance
}
}
