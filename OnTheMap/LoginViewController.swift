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
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
    }

    @IBAction func loginButtonTouchUp(sender: AnyObject) {
        
    }

    
}

