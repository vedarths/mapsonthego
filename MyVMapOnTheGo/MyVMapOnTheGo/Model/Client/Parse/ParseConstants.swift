//
//  ParseConstants.swift
//  MyVMapOnTheGo
//
//  Created by Vedarth Solutions on 12/1/18.
//  Copyright © 2018 Vedarth Solutions. All rights reserved.
//

import Foundation

extension ParseClient {
    struct Constants {
        
        static let AcceptKey = "Accept"
        static let ContentType = "Content-Type"
        static let ApplicationId = "X-Parse-Application-Id"
        static let ApiKey = "X-Parse-REST-API-Key"
        
        static let ApiScheme = "https"
        static let ApiHost = "parse.udacity.com"
        static let ApiPath = "/parse/classes"
    }
    
    struct Methods {
        static let Location = "/StudentLocation"
    }
    
    struct URLArgumentKeys {
        static let Limit = "limit"
        static let Skip = "skip"
        static let Where = "where"
    }
    
    struct Result {
        let objectId: String
        let uniqueKey: String
        let firstName: String
        let lastName: String
        let mapString: String
        let mediaURL: String
        let latitude: CLong
        let longitude: CLong
        let createdAt: String
        let updatedAt: String
    }
    
    
    
    
}
