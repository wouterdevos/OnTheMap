//
//  StudentLocationsModel.swift
//  OnTheMap
//
//  Created by Wouter de Vos on 2015/12/27.
//  Copyright © 2015 Wouter. All rights reserved.
//

class DataModel {
    
    var sessionID : String?
    var key : String?
    var firstName : String?
    var lastName : String?
    var studentLocations = [StudentLocation]()
    
    class func sharedInstance() -> DataModel {
        
        struct Singleton {
            static var sharedInstance = DataModel()
        }
        
        return Singleton.sharedInstance
    }
}
