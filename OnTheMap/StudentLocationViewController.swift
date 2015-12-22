//
//  StudentLocationViewController.swift
//  OnTheMap
//
//  Created by Wouter de Vos on 2015/12/22.
//  Copyright © 2015 Wouter. All rights reserved.
//

import UIKit
import MapKit

class StudentLocationViewController: UIViewController, MKMapViewDelegate {
    
    
    @IBOutlet weak var titleTextView: UITextView!
    @IBOutlet weak var locationTextView: UITextView!
    @IBOutlet weak var findOnMapButton: UIButton!
    @IBOutlet weak var submitButton: UIButton!
    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var middleView: UIView!
    @IBOutlet weak var bottomView: UIView!
    @IBOutlet weak var mapView: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
    }
    
    @IBAction func findOnMapTouchUp(sender: AnyObject) {
        
    }
    
    @IBAction func submitTouchUp(sender: AnyObject) {
        
    }
}