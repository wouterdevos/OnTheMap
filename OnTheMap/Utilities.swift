//
//  Utilities.swift
//  OnTheMap
//
//  Created by Wouter de Vos on 2015/12/20.
//  Copyright © 2015 Wouter. All rights reserved.
//

import UIKit

class Utilities {
    
    static func createAlertController(viewController: UIViewController, message: String) {
        let alertController = UIAlertController(title: "", message: message, preferredStyle: UIAlertControllerStyle.Alert)
        alertController.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
        viewController.presentViewController(alertController, animated: true, completion: nil)
    }
}