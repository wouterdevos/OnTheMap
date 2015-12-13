//
//  RESTClientConstants.swift
//  OnTheMap
//
//  Created by Wouter de Vos on 2015/12/13.
//  Copyright © 2015 Wouter. All rights reserved.
//

extension RESTClient {
    
    struct HTTPMethods {
        
        static let POST = "POST"
        static let GET = "GET"
        static let PUT = "PUT"
        static let DELETE = "DELETE"
    }
    
    struct HeaderFields {
        
        static let Accept = "Accept"
        static let ContentType = "Content-Type"
        static let ParseApplicationID = "X-Parse-Application-Id"
        static let ParseRESTAPIKey = "X-Parse-REST-API-Key"
    }
    
    struct Constants {
        
        static let ParseAppID = "QrX47CA9cyuGewLdsL7o5Eb8iug6Em8ye0dnAbIr"
        static let ParseRESTAPIKey = "QuWThTdiRmTux3YaDseUSEpUKo7aBYM737yKd4gY"
        
        static let FacebookAppID = "365362206864879"
        
        static let UdacityURL = "https://www.udacity.com/"
        static let ParseURL = "https://api.parse.com/"
    }
    
    struct Methods {
        
        // MARK: Udacity
        static let Session = "api/session"
        static let PublicUserData = "api/users/"
        
        // MARK: Parse
        static let StudentLocation = "1/classes/StudentLocation"
    }
    
    struct JSONBodyKeys {
        
        // MARK: Udacity
        static let Udacity = "udacity"
        static let Username = "username"
        static let Password = "password"
        
        // MARK: Parse body keys
        static let UniqueKey = "uniqueKey"
        static let FirstName = "firstName"
        static let LastName = "lastName"
        static let MapString = "mapString"
        static let MediaURL = "mediaURL"
        static let Latitude = "latitude"
        static let Longitude = "longitude"
        
        // MARK: Facebook
        static let FacebookMobiel = "facebook_mobile"
        static let AccessToken = "access_token"
    }
    
    struct JSONResponseKeys {
        
        // MARK: Udacity session
        static let CurrentTime = "current_time"
        static let Account = "account"
        static let Registered = "registered"
        static let Key = "key"
        static let Session = "session"
        static let ID = "id"
        static let Expiration = "expiration"
        static let CurrentSecondsSinceEpoch = "current_seconds_since_epoch"
        
        // MARK: Parse student locations
        static let Results = "results"
        static let CreatedAt = "createdAt"
        static let FirstName = "firstName"
        static let LastName = "lastName"
        static let Latitude = "latitude"
        static let Longitude = "longitude"
        static let MapString = "mapString"
        static let MediaURL = "mediaURL"
        static let ObjectID = "objectId"
        static let UniqueKey = "uniqueKey"
        static let UpdatedAt = "updatedAt"
    }
}
