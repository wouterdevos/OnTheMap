//
//  BaseViewController.swift
//  OnTheMap
//
//  Created by Wouter de Vos on 2015/12/20.
//  Copyright © 2015 Wouter. All rights reserved.
//

import UIKit

class BaseViewController: UIViewController {
    
    var tapRecognizer: UITapGestureRecognizer? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Initialise the tap recogniser
        tapRecognizer = UITapGestureRecognizer(target: self, action: "handleSingleTap:")
        tapRecognizer?.numberOfTapsRequired = 1
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        // Add tap recognizer to dismiss keyboard
        view.addGestureRecognizer(tapRecognizer!)
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Remove tap recognizer
        view.removeGestureRecognizer(tapRecognizer!)
    }
    
    func handleSingleTap(recognizer: UITapGestureRecognizer) {
        self.view.endEditing(true)
    }
    
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
    
    func getStudentLocation() {
        OnTheMapClient.sharedInstance().getStudentLocation() { (success, results, errorString) in
            dispatch_async(dispatch_get_main_queue(), {
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
        alertController.addAction(UIAlertAction(title: "Cancel", style: .Cancel, handler: nil))
        
        presentViewController(alertController, animated: true, completion: nil)
    }
    
    func presentStudentLocationViewController() {
        let studentLocationViewController = self.storyboard!.instantiateViewControllerWithIdentifier("StudentLocationViewController")
        self.presentViewController(studentLocationViewController, animated: true, completion: nil)
    }
}