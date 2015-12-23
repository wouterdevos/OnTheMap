//
//  ViewController.swift
//  OnTheMap
//
//  Created by Wouter de Vos on 2015/12/12.
//  Copyright © 2015 Wouter. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {

    let gradientLayer = CAGradientLayer()
    
    @IBOutlet weak var emailTextView: UILoginTextField!
    @IBOutlet weak var passwordTextField: UILoginTextField!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var activityIndicatorView: UIActivityIndicatorView!
    
    var tapRecognizer: UITapGestureRecognizer? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        activityIndicatorView.hidesWhenStopped = true
        activityIndicatorView.stopAnimating()
        
        // Create the top and bottom colors
        let topColor = UIColor(red: 255/255, green: 153/255, blue: 10/255, alpha: 1)
        let bottomColor = UIColor(red: 255/255, green: 111/255, blue: 0, alpha: 1)
        
        // Define the gradient colors and the gradient locations
        let gradientColors : [CGColor] = [topColor.CGColor, bottomColor.CGColor]
        let gradientLocations = [0.0, 1.0]
        
        // Set the colors and locations in the gradient layer
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = gradientColors
        gradientLayer.locations = gradientLocations
        
        gradientLayer.frame = view.bounds
        view.layer.insertSublayer(gradientLayer, atIndex: 0)
        
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

    @IBAction func loginButtonTouchUp(sender: AnyObject) {
        guard let username = emailTextView.text where !username.isEmpty else {
            Utilities.createAlertController(self, message: "Please enter a username")
            return
        }
        
        guard let password = passwordTextField.text where !password.isEmpty else {
            Utilities.createAlertController(self, message: "Please enter a password")
            return
        }
        
        toggleUserInterface(false)
        OnTheMapClient.sharedInstance().createSession(username, password: password) { (success, errorString) in
            dispatch_async(dispatch_get_main_queue(), {
                self.toggleUserInterface(true)
                if success {
                    // Go to next screen
                    print("Successfully logged in")
                    let tabBarController = self.storyboard!.instantiateViewControllerWithIdentifier("TabBarController")
                    self.presentViewController(tabBarController, animated: true, completion: nil)
                } else {
                    print(errorString!)
                    Utilities.createAlertController(self, message: errorString!)
                }
            })
        }
    }

    @IBAction func signUpButtonTouchUp(sender: AnyObject) {
        UIApplication.sharedApplication().openURL(NSURL(string: "https://www.udacity.com/account/auth#!/signup")!)
    }
    
    func toggleUserInterface(enabled: Bool) {
        emailTextView.enabled = enabled
        passwordTextField.enabled = enabled
        loginButton.enabled = enabled
        if enabled {
            activityIndicatorView.stopAnimating()
        } else {
            activityIndicatorView.startAnimating()
        }
    }
}

