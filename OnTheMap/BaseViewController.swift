//
//  BaseViewController.swift
//  OnTheMap
//
//  Created by Wouter de Vos on 2015/12/20.
//  Copyright © 2015 Wouter. All rights reserved.
//

import UIKit

class BaseViewController: UIViewController {
    
    func logout() {
        OnTheMapClient.sharedInstance().deleteSession() { (success, errorString) in
            dispatch_async(dispatch_get_main_queue(), {
                if success {
                    self.navigationController?.dismissViewControllerAnimated(true, completion: nil)
                } else {
                    Utilities.createAlertController(self, message: errorString!)
                }
            })
        }
    }
    
    func addPin() {
        
    }
    
    func getStudentLocations() {
        OnTheMapClient.sharedInstance().getStudentLocations() { (success, errorString) in
            dispatch_async(dispatch_get_main_queue(), {
                if success {
                    self.updateStudentLocations()
                }
            })
        }
    }
    
    func updateStudentLocations() {
        // Implement method in child class
    }
    
    func getPublicUserData() {
        OnTheMapClient.sharedInstance().getPublicUserData() { (success, errorString) in
            dispatch_async(dispatch_get_main_queue(), {
                if success {
                    if let _ = OnTheMapClient.sharedInstance().location {
                        self.createOverwriteAlertController()
                    } else {
                        Utilities.createAlertController(self, message: "Unable to Post a Student Location. Please try again later.")
                    }
                }
            })
        }
    }
    
    func createOverwriteAlertController() {
        let name = "\(OnTheMapClient.sharedInstance().firstName) \(OnTheMapClient.sharedInstance().lastName)"
        let message = "User \"\(name)\" Has Already Posted a Student Location. Would You Like to Overwrite Their Location?"
        let alertController = UIAlertController(title: "", message: message, preferredStyle: .Alert)
        let overwriteAction = UIAlertAction(title: "Overwrite", style: .Default) { (action) in
            let studentLocationViewController = self.storyboard!.instantiateViewControllerWithIdentifier("StudentLocationViewController")
            self.presentViewController(studentLocationViewController, animated: true, completion: nil)
        }
        alertController.addAction(overwriteAction)
        alertController.addAction(UIAlertAction(title: "Cancel", style: .Cancel, handler: nil))
        
        presentViewController(alertController, animated: true, completion: nil)
    }
}