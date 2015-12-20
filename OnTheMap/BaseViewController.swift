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
}