//
//  RESTClientConvenience.swift
//  OnTheMap
//
//  Created by Wouter de Vos on 2015/12/17.
//  Copyright © 2015 Wouter. All rights reserved.
//

import Foundation

class OnTheMapClient : NSObject {
    
    var sessionID : String?
    var userID : String?
    
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
        
        self.sessionID = sessionID
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
    
    func getHeaderFields() -> [String:String] {
        
        let headerFields = [
            OnTheMapClient.HeaderFields.Accept: "application/json",
            OnTheMapClient.HeaderFields.ContentType: "application/json"
        ]
        
        return headerFields
    }
//    var xsrfCookie: NSHTTPCookie? = nil
//    let sharedCookieStorage = NSHTTPCookieStorage.sharedHTTPCookieStorage()
//    for cookie in sharedCookieStorage.cookies! {
//    if cookie.name == RESTClient.Constants.CookieKey {
//    xsrfCookie = cookie
//    }
//    }
//    if let xsrfCookie = xsrfCookie {
//        request.addValue(xsrfCookie.value, forHTTPHeaderField: RESTClient.Constants.CookieValue)
//    }
    
//    request.addValue("application/json", forHTTPHeaderField: "Accept")
//    request.addValue("application/json", forHTTPHeaderField: "Content-Type")
    
    class func sharedInstance() -> OnTheMapClient {
        
        struct Singleton {
            static var sharedInstance = OnTheMapClient()
        }
        
        return Singleton.sharedInstance
    }
}