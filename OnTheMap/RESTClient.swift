//
//  RESTClient.swift
//  OnTheMap
//
//  Created by Wouter de Vos on 2015/12/13.
//  Copyright © 2015 Wouter. All rights reserved.
//

import Foundation

class RESTClient: NSObject {

    var session : NSURLSession
    
    var sessionID : String?
    var userID : String?
    
    override init() {
        session = NSURLSession.sharedSession()
        super.init()
    }
    
    func taskForGETMethod(var urlString: String, queryParameters: [String:AnyObject]?, completionHandler: (result: AnyObject!, error: NSError?)-> Void) -> NSURLSessionDataTask {
        
        // Build the URL and configure the request
        urlString += RESTClient.escapedParameters(queryParameters)
        let url = NSURL(string: urlString)!
        let request = NSMutableURLRequest(URL: url)
        request.HTTPMethod = RESTClient.HTTPMethods.GET
        
        let task = session.dataTaskWithRequest(request) { (data, response, error) in
            
            if self.isSuccess(data, response: response, error: error) {
                RESTClient.parseJSONWithCompletionHandler(data!, completionHandler: completionHandler)
            }
        }
        
        task.resume()
        
        return task
    }
    
    func taskForPOSTMethod(urlString: String, bodyParameters: [String:AnyObject], completionHandler: (result: AnyObject!, error: NSError?)-> Void) -> NSURLSessionDataTask {
        
        // Build the URL and configure the request
        let url = NSURL(string: urlString)!
        let request = NSMutableURLRequest(URL: url)
        request.HTTPMethod = RESTClient.HTTPMethods.POST
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let task = session.dataTaskWithRequest(request) { (data, response, error) in
            
            if self.isSuccess(data, response: response, error: error) {
                RESTClient.parseJSONWithCompletionHandler(data!, completionHandler: completionHandler)
            }
        }
        
        task.resume()
        
        return task
    }
    
    func taskForPUTMethod(scheme: String, host: String, path: String, completionHandler: (result: AnyObject!, error: NSError?)-> Void) -> NSURLSessionDataTask {
        
        return NSURLSessionDataTask()
    }
    
    func taskForDELETEMethod(scheme: String, host: String, path: String, completionHandler: (result: AnyObject!, error: NSError?)-> Void) -> NSURLSessionDataTask {
        
        return NSURLSessionDataTask()
    }
    
    func isSuccess(data: NSData?, response: NSURLResponse?, error: NSError?) -> Bool {
        
        guard error == nil else {
            print("There was an error with your request: \(error)")
            return false
        }
        
        guard let statusCode = (response as? NSHTTPURLResponse)?.statusCode where statusCode >= 200 && statusCode <= 299 else {
            if let response = response as? NSHTTPURLResponse {
                print("Your request returned an invalid response! Status code \(response.statusCode)!")
            } else if let response = response {
                print("Your request returned an invalid response! Response \(response)!")
            } else {
                print("Your request returned an invalid response!")
            }
            
            return false
        }
        
        guard let _ = data else {
            print("No data was returned by the request!")
            return false
        }
        
        return true
    }
    
    /* Helper: Given raw JSON, return a usable Foundation object */
    class func parseJSONWithCompletionHandler(data: NSData, completionHandler: (result: AnyObject!, error: NSError?) -> Void) {
        
        var parsedResult: AnyObject!
        do {
            parsedResult = try NSJSONSerialization.JSONObjectWithData(data, options: .AllowFragments)
        } catch {
            let userInfo = [NSLocalizedDescriptionKey : "Could not parse the data as JSON: '\(data)'"]
            completionHandler(result: nil, error: NSError(domain: "parseJSONWithCompletionHandler", code: 1, userInfo: userInfo))
        }
        
        completionHandler(result: parsedResult, error: nil)
    }
    
    /* Helper function: Given a dictionary of parameters, convert to a string for a url */
    class func escapedParameters(parameters: [String : AnyObject]?) -> String {
        
        guard let parameters = parameters else {
            return ""
        }
        
        var urlVars = [String]()
        
        for (key, value) in parameters {
            
            /* Make sure that it is a string value */
            let stringValue = "\(value)"
            
            /* Escape it */
            let escapedValue = stringValue.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLQueryAllowedCharacterSet())
            
            /* Append it */
            urlVars += [key + "=" + "\(escapedValue!)"]
            
        }
        
        return (!urlVars.isEmpty ? "?" : "") + urlVars.joinWithSeparator("&")
    }
}
