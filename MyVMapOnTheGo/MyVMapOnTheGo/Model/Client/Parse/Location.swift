//
//  Location.swift
//  MyVMapOnTheGo
//
//  Created by Vedarth Solutions on 12/1/18.
//  Copyright © 2018 Vedarth Solutions. All rights reserved.
//
struct Location {
    let objectId: String
    let uniqueKey: String
    let firstName: String
    let lastName: String
    let mapString: String
    let mediaURL: String
    let latitude: Double
    let longitude: Double
    let createdAt: String
    let updatedAt: String
    
    // construct a Result from a dictionary
    init(dictionary: [String:Any]) {
        objectId = dictionary[ParseClient.JSONResponseKeys.ObjectId] as! String
        uniqueKey = dictionary[ParseClient.JSONResponseKeys.UniqueKey] as! String
        firstName = dictionary[ParseClient.JSONResponseKeys.FirstName] as! String
        lastName = dictionary[ParseClient.JSONResponseKeys.LastName] as! String
        mapString = dictionary[ParseClient.JSONResponseKeys.MapString] as! String
        mediaURL = dictionary[ParseClient.JSONResponseKeys.MediaURL] as! String
        latitude = dictionary[ParseClient.JSONResponseKeys.Latitude] as! Double
        longitude = dictionary[ParseClient.JSONResponseKeys.Longitude] as! Double
        createdAt = dictionary[ParseClient.JSONResponseKeys.CreatedAt] as! String
        updatedAt = dictionary[ParseClient.JSONResponseKeys.UpdatedAt] as! String
    }
    
    static func LocationsFromResults(_ results: [[String:Any]]) -> [Location] {
        
        var locations = [Location]()
        
        // iterate through array of dictionaries, each Movie is a dictionary
        for result in results {
            locations.append(Location(dictionary: result))
        }
        return locations
    }
}

// MARK: - Location: Equatable

extension Location: Equatable {}

func ==(lhs: Location, rhs: Location) -> Bool {
    return lhs.objectId == rhs.objectId
}



