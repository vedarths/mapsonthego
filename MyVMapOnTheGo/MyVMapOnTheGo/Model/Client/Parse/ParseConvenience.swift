//
//  ParseConvenience.swift
//  MyVMapOnTheGo
//
//  Created by Vedarth Solutions on 12/1/18.
//  Copyright © 2018 Vedarth Solutions. All rights reserved.
//

import UIKit
import Foundation

extension ParseClient {
    
    func getAllLocations(completionHandlerForLocations: @escaping (_ success: Bool, _ result: [Location]?, _ errorString: String?) -> Void) {
        
        /* 1. Specify parameters */
        let parameters = [URLArgumentKeys.Limit: URLArgumentValues.limit]
                
        let _ = taskForGETMethod(Methods.Location, parameters: parameters as [String:AnyObject]) { (results, error) in
            
            /* 2. Send the desired value(s) to completion handler */
            if let error = error {
                print(error)
                completionHandlerForLocations(false, nil, "Could not get data from Parse for getStudentLocations")
            } else {
                print("retrieved locations successfully!")
                if let results = results?["results"] as? [[String: Any]] {
                    
                    let locations = Location.LocationsFromResults(results)
                    completionHandlerForLocations(true, locations, nil)
                } else {
                    completionHandlerForLocations(true, nil, nil)
                }
            }
        }
     }
    
    func getLocationsForAStudent(key: String?, completionHandlerForLocations: @escaping (_ success: Bool, _ result: [Location]?, _ errorString: String?) -> Void) {
        
        /* 1. Specify parameters */
        let parameters = [URLArgumentKeys.Where: "{\"uniqueKey\":\"\(key!)\"}"]
        
        let _ = taskForGETMethod(Methods.Location, parameters: parameters as [String:AnyObject]) { (results, error) in
            
            /* 2. Send the desired value(s) to completion handler */
            if let error = error {
                print(error)
                completionHandlerForLocations(false, nil, "Could not get data from Parse for getLocationsForStudent")
            } else {
                print("retrieved locations for student successfully!")
                if let results = results?["results"] as? [[String: Any]] {
                    
                    let locations = Location.LocationsFromResults(results)
                    completionHandlerForLocations(true, locations, nil)
                } else {
                    completionHandlerForLocations(true, nil, nil)
                }
            }
        }
    }
    
    func postStudentLocation(location: Location, completionHandlerForLocations: @escaping (_ success: Bool, _ errorString: NSError?) -> Void) {
        
        let jsonBody = try! JSONSerialization.data(withJSONObject: location, options: []) as AnyObject?
        
        let _ = taskForPOSTMethod(Methods.Location, jsonBody: jsonBody as! String) { (success, errorString) in
            
            if let error = errorString {
                completionHandlerForLocations(false,  error)
            } else {
                completionHandlerForLocations(true, nil)
            }
        }
    }
}
