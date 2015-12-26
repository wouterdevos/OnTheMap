//
//  BaseDataDisplayViewController.swift
//  OnTheMap
//
//  Created by Wouter de Vos on 2015/12/26.
//  Copyright © 2015 Wouter. All rights reserved.
//

import UIKit

class BaseDataDisplayViewController: BaseViewController, StudentLocationViewControllerDelegate {
    
    func update() {
        getStudentLocations()
    }
    
    func logout() {
        showActivityIndicatorView()
        OnTheMapClient.sharedInstance().deleteSession() { (success, errorString) in
            dispatch_async(dispatch_get_main_queue(), {
                self.hideActivityIndicatorView()
                if success {
                    self.navigationController?.dismissViewControllerAnimated(true, completion: nil)
                } else {
                    Utilities.createAlertController(self, message: errorString!)
                }
            })
        }
    }
    
    func getStudentLocations() {
        showActivityIndicatorView()
        OnTheMapClient.sharedInstance().getStudentLocations() { (success, errorString) in
            dispatch_async(dispatch_get_main_queue(), {
                self.hideActivityIndicatorView()
                if success {
                    self.updateStudentLocations()
                }
            })
        }
    }
    
    func updateStudentLocations() {
        // Implement method in child class
    }
    
    func showActivityIndicatorView() {
        // Implement method in child class
    }
    
    func hideActivityIndicatorView() {
        // Implement method in child class
    }
    
    func getStudentLocation() {
        showActivityIndicatorView()
        OnTheMapClient.sharedInstance().getStudentLocation() { (success, results, errorString) in
            dispatch_async(dispatch_get_main_queue(), {
                self.hideActivityIndicatorView()
                if success {
                    if let results = results where results.count > 0 {
                        let studentLocations = StudentLocation.studentLocationsFromResults(results)
                        self.createOverwriteAlertController(studentLocations[0])
                    } else {
                        self.presentStudentLocationViewController()
                    }
                } else {
                    Utilities.createAlertController(self, message: "Unable to post a student location. Please try again later.")
                }
            })
        }
    }
    
    func createOverwriteAlertController(studentLocation: StudentLocation) {
        let name = "\(studentLocation.firstName) \(studentLocation.lastName)"
        let message = "User \"\(name)\" has already posted a student location. Would you like to overwrite their location?"
        let alertController = UIAlertController(title: "", message: message, preferredStyle: .Alert)
        let overwriteAction = UIAlertAction(title: "Overwrite", style: .Default) { (action) in
            self.presentStudentLocationViewController()
        }
        
        alertController.addAction(overwriteAction)
        alertController.addAction(UIAlertAction(title: "Cancel", style: .Default, handler: nil))
        
        presentViewController(alertController, animated: true, completion: nil)
    }
    
    func presentStudentLocationViewController() {
        let studentLocationViewController = self.storyboard!.instantiateViewControllerWithIdentifier("StudentLocationViewController") as? StudentLocationViewController
        studentLocationViewController?.delegate = self
        self.presentViewController(studentLocationViewController!, animated: true, completion: nil)
    }
}