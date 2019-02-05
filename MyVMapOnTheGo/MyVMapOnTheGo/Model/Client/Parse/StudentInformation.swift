//
//  StudentInformation.swift
//  MyVMapOnTheGo
//
//  Created by Vedarth Solutions on 12/1/18.
//  Copyright © 2018 Vedarth Solutions. All rights reserved.
//
struct StudentInformation {
    var objectId: String
    var uniqueKey: String
    var firstName: String
    var lastName: String
    var mapString: String
    var mediaURL: String
    var latitude: Double
    var longitude: Double
    var createdAt: String
    var updatedAt: String
    
    // construct a Result from a dictionary
    init(dictionary: [String:Any]) {
        if let objectIdValue = dictionary[ParseClient.JSONResponseKeys.ObjectId] as! String?,
            objectIdValue.isEmpty == false {
            objectId = objectIdValue
        } else {
            objectId = ""
        }
        if let uniqueKeyValue = dictionary[ParseClient.JSONResponseKeys.UniqueKey] as? String,
            uniqueKeyValue.isEmpty == false {
            uniqueKey = uniqueKeyValue
        } else {
            uniqueKey = ""
        }
        if let firstNameValue = dictionary[ParseClient.JSONResponseKeys.FirstName] as? String,
            firstNameValue.isEmpty == false {
            firstName = firstNameValue
        } else {
            firstName = ""
        }
        if let lastNameValue = dictionary[ParseClient.JSONResponseKeys.LastName] as? String,
            lastNameValue.isEmpty == false {
            lastName = lastNameValue
        } else {
            lastName = ""
        }
        if let mapStringValue = dictionary[ParseClient.JSONResponseKeys.MapString] as? String,
            mapStringValue.isEmpty == false {
            mapString = mapStringValue
        } else {
            mapString = ""
        }
        if let mediaUrlValue = dictionary[ParseClient.JSONResponseKeys.MediaURL] as? String,
            mediaUrlValue.isEmpty == false {
            mediaURL = mediaUrlValue
        } else {
            mediaURL = ""
        }
        if let latitudeValue = dictionary[ParseClient.JSONResponseKeys.Latitude] as? Double,
            latitudeValue.isNaN == false {
            latitude = latitudeValue
        } else {
            latitude = Double(bitPattern: 0)
        }
        if let longitudeValue = dictionary[ParseClient.JSONResponseKeys.Longitude] as? Double,
            longitudeValue.isNaN == false {
              longitude = longitudeValue
        } else {
            longitude = Double(0)
        }
        if let createdAtValue = dictionary[ParseClient.JSONResponseKeys.CreatedAt] as? String, createdAtValue.isEmpty == false {
            createdAt = createdAtValue
        } else {
            createdAt = ""
        }
        if let updatedAtValue = dictionary[ParseClient.JSONResponseKeys.UpdatedAt] as? String, updatedAtValue.isEmpty == false {
            updatedAt = updatedAtValue
        } else {
            updatedAt = ""
        }
    }
    
    static func LocationsFromResults(_ results: [[String:Any]]) -> [StudentInformation] {
        
        var locations = [StudentInformation]()
        
        // iterate through array of dictionaries, each Movie is a dictionary
        for result in results {
            locations.append(StudentInformation(dictionary: result))
           
        }
        return locations
    }
}

// MARK: - Location: Equatable

extension StudentInformation: Equatable {}

func ==(lhs: StudentInformation, rhs: StudentInformation) -> Bool {
    return lhs.objectId == rhs.objectId
}



