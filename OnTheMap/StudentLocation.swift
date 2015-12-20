//
//  StudentLocation.swift
//  OnTheMap
//
//  Created by Wouter de Vos on 2015/12/20.
//  Copyright © 2015 Wouter. All rights reserved.
//

struct StudentLocation {
    
    var objectID: String = ""
    var uniqueKey: String = ""
    var firstName: String = ""
    var lastName: String = ""
    var mapString: String = ""
    var mediaURL: String = ""
    var latitude: Double = 0
    var longitude: Double =  0
    
    init(dictionary: [String:AnyObject]) {
        
        objectID = dictionary[OnTheMapClient.JSONResponseKeys.ObjectID] as! String
        uniqueKey = dictionary[OnTheMapClient.JSONResponseKeys.UniqueKey] as! String
        firstName = dictionary[OnTheMapClient.JSONResponseKeys.FirstName] as! String
        lastName = dictionary[OnTheMapClient.JSONResponseKeys.LastName] as! String
        mapString = dictionary[OnTheMapClient.JSONResponseKeys.MapString] as! String
        mediaURL = dictionary[OnTheMapClient.JSONResponseKeys.MediaURL] as! String
        latitude = dictionary[OnTheMapClient.JSONResponseKeys.Latitude] as! Double
        longitude = dictionary[OnTheMapClient.JSONResponseKeys.Longitude] as! Double
    }
    
    static func studentLocationsFromResults(results: [[String:AnyObject]]) -> [StudentLocation] {
        var studentLocations = [StudentLocation]()
        
        for result in results {
            studentLocations.append(StudentLocation(dictionary: result))
        }
        
        return studentLocations
    }
}