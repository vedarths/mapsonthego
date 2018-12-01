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
    
    func getStudentLocations(completionHandlerForLocations: @escaping (_ success: Bool, _ result: [Location]?, _ errorString: String?) -> Void) {
        
        /* 1. Specify parameters */
//        let parameters = [URLArgumentKeys.Limit: URLArgumentValues.limit,
//                          URLArgumentKeys.Skip: URLArgumentValues.Skip]
        let parameters = [URLArgumentKeys.Limit: URLArgumentValues.limit]
                
        let _ = taskForGETMethod(Methods.Location, parameters: parameters as [String:AnyObject]) { (results, error) in
            /* 3. Send the desired value(s) to completion handler */
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
}
