//
//  RESTClientConvenience.swift
//  OnTheMap
//
//  Created by Wouter de Vos on 2015/12/17.
//  Copyright © 2015 Wouter. All rights reserved.
//

import Foundation
import MapKit

class OnTheMapClient : NSObject {
    
    // MARK: Udacity API calls
    
    // Create Session
    func createSession(username: String, password: String, completionHandler: (success: Bool, errorString: String?) -> Void) {
        
        // Specify header fields and the HTTP body.
        let headerFields = getHeaderFields()
        let bodyParameters: [String:AnyObject] = [
            OnTheMapClient.JSONBodyKeys.Udacity: [
                OnTheMapClient.JSONBodyKeys.Username: username,
                OnTheMapClient.JSONBodyKeys.Password: password
            ]
        ]
        
        // Create url and specifiy method.
        let urlString = OnTheMapClient.Constants.UdacityURL + OnTheMapClient.Methods.Session
        
        let restClient = RESTClient.sharedInstance()
        restClient.taskForPOSTMethod(urlString, headerFields: headerFields, bodyParameters: bodyParameters) { (data, error) in
            
            if let error = error {
                self.handleCreateSessionResponseError(data, error: error, completionHandler: completionHandler)
            } else {
                self.handleCreateSessionResponse(data, completionHandler: completionHandler)
            }
        }
    }
    
    func handleCreateSessionResponse(data: NSData?, completionHandler: (success: Bool, errorString: String?) -> Void) {
        let skipData = RESTClient.skipResponseCharacters(data!)
        guard let JSONResult = RESTClient.parseJSONWithCompletionHandler(skipData) else {
            completionHandler(success: false, errorString: "Cannot parse data as JSON!")
            return
        }
        
        guard let session = JSONResult[OnTheMapClient.JSONResponseKeys.Session] as? [String:AnyObject] else {
            completionHandler(success: false, errorString: "Cannot find key 'session' in JSON")
            return
        }
        
        guard let sessionID = session[OnTheMapClient.JSONResponseKeys.ID] as? String else {
            completionHandler(success: false, errorString: "Cannot find key 'id' in JSON")
            return
        }
        
        guard let account = JSONResult[OnTheMapClient.JSONResponseKeys.Account] as? [String:AnyObject] else {
            completionHandler(success: false, errorString: "Cannot find key 'account' in JSON")
            return
        }
        
        guard let key = account[OnTheMapClient.JSONResponseKeys.Key] as? String else {
            completionHandler(success: false, errorString: "Cannot find key 'key' in JSON")
            return
        }
        
        DataModel.sharedInstance().sessionID = sessionID
        DataModel.sharedInstance().key = key
        completionHandler(success: true, errorString: nil)
    }
    
    func handleCreateSessionResponseError(data: NSData?, error: NSError, completionHandler: (success: Bool, errorString: String?) -> Void) {
        var errorString = error.localizedDescription
        if data != nil {
            let skipData = RESTClient.skipResponseCharacters(data!)
            let JSONResult = RESTClient.parseJSONWithCompletionHandler(skipData)!
            if let errorMessage = JSONResult[OnTheMapClient.JSONResponseKeys.Error] as? String {
                errorString = errorMessage
            }
        }
        print(errorString)
        completionHandler(success: false, errorString: errorString)
    }
    
    // Delete Session
    func deleteSession(completionHandler: (success: Bool, errorString: String?) -> Void) {
        
        // Specify header fields.
        var headerFields = [String:String]()
        var xsrfCookie: NSHTTPCookie? = nil
        let sharedCookieStorage = NSHTTPCookieStorage.sharedHTTPCookieStorage()
        for cookie in sharedCookieStorage.cookies! {
            if cookie.name == OnTheMapClient.Constants.CookieValue {
                xsrfCookie = cookie
            }
        }
        if let xsrfCookie = xsrfCookie {
            headerFields[OnTheMapClient.Constants.CookieField] = xsrfCookie.value
        }
        
        // Create url and specifiy method.
        let urlString = OnTheMapClient.Constants.UdacityURL + OnTheMapClient.Methods.Session
        
        let restClient = RESTClient.sharedInstance()
        restClient.taskForDELETEMethod(urlString, headerFields: headerFields) { (data, error) in
            
            if let _ = error {
                completionHandler(success: false, errorString: "Failed to logout!")
            } else {
                completionHandler(success: true, errorString: nil)
            }
        }
    }
    
    // Get Public User Data
    func getPublicUserData(completionHandler: (success: Bool, errorString: String?) -> Void) {
        
        // Specify header fields.
        let headerFields = getParseHeaderFields()
        
        // Create url.
        let urlString = OnTheMapClient.Constants.UdacityURL + OnTheMapClient.Methods.PublicUserData + DataModel.sharedInstance().key!
        
        let restClient = RESTClient.sharedInstance()
        restClient.taskForGETMethod(urlString, headerFields: headerFields, queryParameters: nil) { (data, error) in
            
            if let _ = error {
                completionHandler(success: false, errorString: "Failed to retrieve public user data")
            } else {
                let skipData = RESTClient.skipResponseCharacters(data!)
                guard let JSONResult = RESTClient.parseJSONWithCompletionHandler(skipData) else {
                    completionHandler(success: false, errorString: "Cannot parse data as JSON!")
                    return
                }
                
                guard let user = JSONResult[OnTheMapClient.JSONResponseKeys.User] as? [String:AnyObject] else {
                    completionHandler(success: false, errorString: "Cannot find key 'user' in JSON")
                    return
                }
                
                guard let firstName = user[OnTheMapClient.JSONResponseKeys.UserFirstName] as? String else {
                    completionHandler(success: false, errorString: "Cannot find key 'first_name' in JSON")
                    return
                }
                
                guard let lastName = user[OnTheMapClient.JSONResponseKeys.UserLastName] as? String else {
                    completionHandler(success: false, errorString: "Cannot find key 'last_name' in JSON")
                    return
                }
                
                DataModel.sharedInstance().firstName = firstName
                DataModel.sharedInstance().lastName = lastName
                completionHandler(success: true, errorString: nil)
            }
        }
    }
    
    // MARK: Parse API calls
    
    // Get Student Locations
    func getStudentLocations(completionHandler: (success: Bool, errorString: String?) -> Void) {
        
        // Specify header fields.
        let headerFields = getParseHeaderFields()
        
        // Specify query parameters.
        let queryParameters = [
            OnTheMapClient.QueryKeys.Order: "-updateAt"
        ]
        
        // Create url.
        let urlString = OnTheMapClient.Constants.ParseURL + OnTheMapClient.Methods.StudentLocation
        
        let restClient = RESTClient.sharedInstance()
        restClient.taskForGETMethod(urlString, headerFields: headerFields, queryParameters: queryParameters) { (data, error) in
            
            if let _ = error {
                completionHandler(success: false, errorString: "Failed to retrieve student locations")
            } else {
                guard let JSONResult = RESTClient.parseJSONWithCompletionHandler(data!) else {
                    completionHandler(success: false, errorString: "Cannot parse data as JSON!")
                    return
                }
                
                guard let results = JSONResult[OnTheMapClient.JSONResponseKeys.Results] as? [[String:AnyObject]] else {
                    completionHandler(success: false, errorString: "Cannot find key 'results' in JSON")
                    return
                }
                DataModel.sharedInstance().studentLocations = StudentLocation.studentLocationsFromResults(results)
                completionHandler(success: true, errorString: nil)
            }
        }
    }
    
    // Get a Student Location
    func getStudentLocation(completionHandler: (success: Bool, results: [[String:AnyObject]]?, errorString: String?) -> Void) {
        
        // Specify header fields.
        let headerFields = getParseHeaderFields()
        
        // Specify query parameters.
        let queryParameters = [
            OnTheMapClient.QueryKeys.Where: "{\"\(OnTheMapClient.JSONBodyKeys.UniqueKey)\":\"\(DataModel.sharedInstance().key!)\"}"
        ]
        
        // Create url.
        let urlString = OnTheMapClient.Constants.ParseURL + OnTheMapClient.Methods.StudentLocation
        
        let restClient = RESTClient.sharedInstance()
        restClient.taskForGETMethod(urlString, headerFields: headerFields, queryParameters: queryParameters) { (data, error) in
            
            if let _ = error {
                completionHandler(success: false, results: nil, errorString: "Failed to retrieve the student location")
            } else {
                guard let JSONResult = RESTClient.parseJSONWithCompletionHandler(data!) else {
                    completionHandler(success: false, results: nil, errorString: "Cannot parse data as JSON!")
                    return
                }
                
                guard let results = JSONResult[OnTheMapClient.JSONResponseKeys.Results] as? [[String:AnyObject]] else {
                    completionHandler(success: false, results: nil, errorString: "Cannot find key 'results' in JSON")
                    return
                }
                
                completionHandler(success: true, results: results, errorString: nil)
            }
        }
    }
    
    // Post Student Location
    func postStudentLocation(mapString: String, mediaURL: String, location: CLLocation, completionHandler: (success: Bool, errorString: String?) -> Void) {
        
        // Specify header fields and the HTTP body.
        var headerFields = getParseHeaderFields()
        headerFields[OnTheMapClient.HeaderFields.ContentType] = "application/json"
        let bodyParameters: [String:AnyObject] = [
            OnTheMapClient.JSONBodyKeys.UniqueKey: DataModel.sharedInstance().key!,
            OnTheMapClient.JSONBodyKeys.FirstName: DataModel.sharedInstance().firstName!,
            OnTheMapClient.JSONBodyKeys.LastName: DataModel.sharedInstance().lastName!,
            OnTheMapClient.JSONBodyKeys.MapString: mapString,
            OnTheMapClient.JSONBodyKeys.MediaURL: mediaURL,
            OnTheMapClient.JSONBodyKeys.Latitude: location.coordinate.latitude,
            OnTheMapClient.JSONBodyKeys.Longitude: location.coordinate.longitude
        ]
        
        // Create url.
        let urlString = OnTheMapClient.Constants.ParseURL + OnTheMapClient.Methods.StudentLocation
        
        let restClient = RESTClient.sharedInstance()
        restClient.taskForPOSTMethod(urlString, headerFields: headerFields, bodyParameters: bodyParameters) { (data, error) in
            
            if let _ = error {
                completionHandler(success: false, errorString: "Failed to post student location")
            } else {
                completionHandler(success: true, errorString: nil)
            }
        }
    }
    
    func getHeaderFields() -> [String:String] {
        
        let headerFields = [
            OnTheMapClient.HeaderFields.Accept: "application/json",
            OnTheMapClient.HeaderFields.ContentType: "application/json"
        ]
        
        return headerFields
    }
    
    func getParseHeaderFields() -> [String:String] {
        
        let parseHeaderFields = [
            OnTheMapClient.HeaderFields.ParseApplicationID: OnTheMapClient.Constants.ParseAppID,
            OnTheMapClient.HeaderFields.ParseRESTAPIKey: OnTheMapClient.Constants.ParseRESTAPIKey
        ]
        
        return parseHeaderFields
    }
    
    class func sharedInstance() -> OnTheMapClient {
        
        struct Singleton {
            static var sharedInstance = OnTheMapClient()
        }
        
        return Singleton.sharedInstance
    }
}