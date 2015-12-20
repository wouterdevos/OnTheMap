//
//  MapViewController.swift
//  OnTheMap
//
//  Created by Wouter de Vos on 2015/12/20.
//  Copyright © 2015 Wouter. All rights reserved.
//

import UIKit
import MapKit

class PinMapViewController: BaseViewController, MKMapViewDelegate {

    @IBOutlet weak var mapView: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
    }
    
    @IBAction func logoutTouchUp(sender: AnyObject) {
        logout()
    }
    
    @IBAction func addPinTouchUp(sender: AnyObject) {
    }
    
    @IBAction func refreshMapTouchUp(sender: AnyObject) {
    }
}
