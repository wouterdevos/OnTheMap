//
//  MapViewController.swift
//  OnTheMap
//
//  Created by Wouter de Vos on 2015/12/20.
//  Copyright © 2015 Wouter. All rights reserved.
//

import UIKit
import MapKit

class PinMapViewController: BaseDataDisplayViewController, MKMapViewDelegate {

    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var loadingView: UIView!
    @IBOutlet weak var activityIndicatorView: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mapView.delegate = self
        getStudentLocations()
    }
    
    @IBAction func logoutTouchUp(sender: AnyObject) {
        logout()
    }
    
    @IBAction func addPinTouchUp(sender: AnyObject) {
        getStudentLocation()
    }
    
    @IBAction func refreshMapTouchUp(sender: AnyObject) {
        getStudentLocations()
    }
    
    override func updateStudentLocations() {
        let studentLocations = DataModel.sharedInstance().studentLocations
        
        guard studentLocations.count > 0 else {
            return
        }
        
        // We will create an MKPointAnnotation for each dictionary in "studentLocations". The
        // point annotations will be stored in this array, and then provided to the map view.
        var annotations = [MKPointAnnotation]()
        
        for studentLocation in studentLocations {
            
            // Retrieve the latitude and longitude values
            let lat = CLLocationDegrees(studentLocation.latitude)
            let long = CLLocationDegrees(studentLocation.longitude)
            
            // The lat and long are used to create a CLLocationCoordinates2D instance.
            let coordinate = CLLocationCoordinate2D(latitude: lat, longitude: long)
            
            // Create the annotation and set its coordiate, title, and subtitle properties
            let annotation = MKPointAnnotation()
            annotation.coordinate = coordinate
            annotation.title = "\(studentLocation.firstName) \(studentLocation.lastName)"
            annotation.subtitle = studentLocation.mediaURL
            
            // Place the annotation in an array of annotations.
            annotations.append(annotation)
        }
        
        // Add the annotations to the map.
        mapView.addAnnotations(annotations)
    }
    
    func mapView(mapView: MKMapView, viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView? {
        
        let reuseId = "pin"
        
        var pinView = mapView.dequeueReusableAnnotationViewWithIdentifier(reuseId) as? MKPinAnnotationView
        
        if pinView == nil {
            // Create a new pin view and initialise it.
            pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            pinView!.canShowCallout = true
            pinView!.pinTintColor = MKPinAnnotationView.redPinColor()
            pinView!.rightCalloutAccessoryView = UIButton(type: .DetailDisclosure)
        }
        else {
            // Reuse an existing pin view and set the annotation.
            pinView!.annotation = annotation
        }
        
        return pinView
    }
    
    func mapView(mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        if control == view.rightCalloutAccessoryView {
            let subtitle = view.annotation?.subtitle!
            openURL(subtitle)
        }
    }
    
    override func showActivityIndicatorView() {
        loadingView.hidden = false
        activityIndicatorView.startAnimating()
    }
    
    override func hideActivityIndicatorView() {
        loadingView.hidden = true
        activityIndicatorView.stopAnimating()
    }
}
