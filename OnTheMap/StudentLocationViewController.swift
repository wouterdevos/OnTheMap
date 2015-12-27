//
//  StudentLocationViewController.swift
//  OnTheMap
//
//  Created by Wouter de Vos on 2015/12/22.
//  Copyright © 2015 Wouter. All rights reserved.
//

import UIKit
import MapKit

protocol StudentLocationViewControllerDelegate {
    func update()
}

class StudentLocationViewController: BaseViewController, MKMapViewDelegate, UITextFieldDelegate {
    
    let whereAreYouStudyingToday = "Where are you\nstudying\ntoday?"
    let enterYourLocationHere = "Enter Your Location Here"
    let enterALinkToShareHere = "Enter a Link to Share Here"
    
    let greyBackground = UIColor(colorLiteralRed: 224.0/255.0, green: 224.0/255.0, blue: 221.0/255.0, alpha: 1.0)
    let transparentGreyBackground = UIColor(colorLiteralRed: 224.0/255.0, green: 224.0/255.0, blue: 221.0/255.0, alpha: 0.2)
    let transparentBackground = UIColor(colorLiteralRed: 1.0, green: 1.0, blue: 1.0, alpha: 0.0)
    let blueBackground = UIColor(colorLiteralRed: 79.0/255.0, green: 136.0/255.0, blue: 182.0/255.0, alpha: 1.0)
    let blueText = UIColor(colorLiteralRed: 13.0/255.0, green: 62.0/255.0, blue: 114.0/255.0, alpha: 1.0)
    
    let linkTextViewTag = 0
    let locationTextViewTag = 1
    
    
    @IBOutlet weak var titleTextView: UITextView!
    @IBOutlet weak var linkTextField: UITextField!
    @IBOutlet weak var locationTextField: UITextField!
    @IBOutlet weak var findOnMapButton: UIButton!
    @IBOutlet weak var submitButton: UIButton!
    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var middleView: UIView!
    @IBOutlet weak var bottomView: UIView!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var activityIndicatorView: UIActivityIndicatorView!
    
    var location : CLLocation? = nil
    var delegate : StudentLocationViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set the tags for the text views.
        linkTextField.tag = linkTextViewTag
        locationTextField.tag = locationTextViewTag
        
        // Set the delegates for the text views.
        linkTextField.delegate = self
        locationTextField.delegate = self
        
        // Configure the text for the titleTextView.
        let attributedText = NSMutableAttributedString(string: whereAreYouStudyingToday, attributes: [
            NSFontAttributeName : UIFont(name: "Roboto-Thin", size: 24.0)!,
            NSForegroundColorAttributeName : blueText])
        attributedText.addAttribute(NSFontAttributeName, value: UIFont(name: "Roboto-Regular", size: 24.0)!, range: NSRange(location: 13, length: 9))
        titleTextView.attributedText = attributedText
        titleTextView.textAlignment = NSTextAlignment.Center
        
        activityIndicatorView.stopAnimating()
    }
    
    @IBAction func findOnMapTouchUp(sender: AnyObject) {
        let location = locationTextField.text!
        let geocoder = CLGeocoder()
        toggleUserInterface(false)
        geocoder.geocodeAddressString(location) { (placemarks, error) in
            dispatch_async(dispatch_get_main_queue(), {
                self.handleGeocodeResult(placemarks)
            })
        }
    }
    
    @IBAction func submitTouchUp(sender: AnyObject) {
        let mapString = locationTextField.text!
        guard let link = linkTextField.text where link.characters.count > 0 && link != enterALinkToShareHere else {
            Utilities.createAlertController(self, message: "Please enter a link")
            return
        }
        
        toggleUserInterface(false)
        OnTheMapClient.sharedInstance().postStudentLocation(mapString, mediaURL: link, location: location!) { (success, errorString) in
            dispatch_async(dispatch_get_main_queue(), {
                self.toggleUserInterface(true)
                if success {
                    self.delegate?.update()
                    self.dismissViewControllerAnimated(true, completion: nil)
                } else {
                    Utilities.createAlertController(self, message: "Unable to submit a student location. Please try again later.")
                }
            })
        }
    }
    
    @IBAction func cancelTouchUp(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    func textFieldDidBeginEditing(textField: UITextField) {
        textField.textAlignment = NSTextAlignment.Left
        if textField.text == enterALinkToShareHere || textField.text == enterYourLocationHere {
            textField.text = ""
        }
    }
    
    func textFieldDidEndEditing(textField: UITextField) {
        textField.textAlignment = NSTextAlignment.Center
        if let text = textField.text where text.isEmpty {
            textField.text = textField.tag == linkTextViewTag ? enterALinkToShareHere : enterYourLocationHere
        }
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.endEditing(true)
        return false
    }
    
    func toggleUserInterface(enabled: Bool) {
        linkTextField.enabled = enabled
        locationTextField.enabled = enabled
        findOnMapButton.enabled = enabled
        submitButton.enabled = enabled
        if enabled {
            activityIndicatorView.stopAnimating()
        } else {
            activityIndicatorView.startAnimating()
        }
    }
    
    func handleGeocodeResult(placemarks: [CLPlacemark]?) {
        toggleUserInterface(true)
        guard let results = placemarks where results.count > 0 else {
            Utilities.createAlertController(self, message: "No geocoding results available. Please try again.")
            return
        }
        
        if let placemark = results[0] as? CLPlacemark {
            // Hide the title and location text view and show the link text view.
            titleTextView.hidden = true
            locationTextField.hidden = true
            linkTextField.hidden = false
            
            // Hide/show the 'find on map'/submit button.
            findOnMapButton.hidden = true
            submitButton.hidden = false
            
            // Set the backgrounds for the top, middle and bottom views.
            topView.backgroundColor = blueBackground
            middleView.backgroundColor = transparentBackground
            bottomView.backgroundColor = transparentGreyBackground
            
            // Configure the map view.
            mapView.zoomEnabled = false
            mapView.scrollEnabled = false
            mapView.userInteractionEnabled = false
            let annotations = [MKPlacemark(placemark: placemark)]
            mapView.showAnnotations(annotations, animated: true)
            
            // Change the style of the activity indicator view.
            activityIndicatorView.activityIndicatorViewStyle = .Gray
            
            location = placemark.location
        }
    }
}