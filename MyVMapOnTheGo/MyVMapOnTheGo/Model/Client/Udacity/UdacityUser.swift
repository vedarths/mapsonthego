//
//  UdacityUser.swift
//  MyVMapOnTheGo
//
//  Created by Vedarth Solutions on 1/12/19.
//  Copyright © 2019 Vedarth Solutions. All rights reserved.
//

struct UdacityUser {
    
    var id: String = ""
    var firstName: String = ""
    var lastName: String = ""
    
    var fullName: String {
        return "\(firstName) \(lastName)"
    }
    
    /*
     * Construct a user from a dictionary
     */
    init(dictionary: [String : AnyObject]) {
        id = dictionary["id"] as! String
        firstName = dictionary["firstName"] as! String
        lastName = dictionary["lastName"] as! String
    }
}

