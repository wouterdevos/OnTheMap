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

class StudentLocationViewController: BaseViewController, MKMapViewDelegate, UITextViewDelegate {
    
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
    @IBOutlet weak var linkTextView: UITextView!
    @IBOutlet weak var locationTextView: UITextView!
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
        linkTextView.tag = linkTextViewTag
        locationTextView.tag = locationTextViewTag
        
        // Set the delegates for the text views.
        linkTextView.delegate = self
        locationTextView.delegate = self
        
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
        let location = locationTextView.text
        let geocoder = CLGeocoder()
        toggleUserInterface(false)
        geocoder.geocodeAddressString(location) { (placemarks, error) in
            dispatch_async(dispatch_get_main_queue(), {
                self.handleGeocodeResult(placemarks)
            })
        }
    }
    
    @IBAction func submitTouchUp(sender: AnyObject) {
        let mapString = locationTextView.text
        guard let link = linkTextView.text where link.characters.count > 0 && link != enterALinkToShareHere else {
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
    
    func textViewDidBeginEditing(textView: UITextView) {
        textView.textAlignment = NSTextAlignment.Left
        if textView.text == enterALinkToShareHere || textView.text == enterYourLocationHere {
            textView.text = ""
        }
    }
    
    func textViewDidEndEditing(textView: UITextView) {
        textView.textAlignment = NSTextAlignment.Center
        if textView.text.isEmpty {
            textView.text = textView.tag == linkTextViewTag ? enterALinkToShareHere : enterYourLocationHere
        }
    }
    
//    func showActivityIndicator() {
//        activityIndicator.frame = CGRectMake(0.0, 0.0, 40.0, 40.0);
//        activityIndicator.center = view.center
//        activityIndicator.hidesWhenStopped = true
//        activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.WhiteLarge
//        view.addSubview(activityIndicator)
//        activityIndicator.startAnimating()
//    }
//    
//    func hideActivityIndictor() {
//        activityIndicator.stopAnimating()
//    }
    
    func toggleUserInterface(editable: Bool) {
        linkTextView.editable = editable
        locationTextView.editable = editable
        findOnMapButton.enabled = editable
        submitButton.enabled = editable
        if editable {
            activityIndicatorView.stopAnimating()
        } else {
            activityIndicatorView.startAnimating()
        }
    }
    
    func handleGeocodeResult(placemarks: [CLPlacemark]?) {
        toggleUserInterface(true)
        if let placemark = placemarks![0] as? CLPlacemark {
            // Hide the title and location text view and show the link text view.
            titleTextView.hidden = true
            locationTextView.hidden = true
            linkTextView.hidden = false
            
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