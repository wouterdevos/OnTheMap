//
//  StudentLocationViewController.swift
//  OnTheMap
//
//  Created by Wouter de Vos on 2015/12/22.
//  Copyright © 2015 Wouter. All rights reserved.
//

import UIKit
import MapKit

class StudentLocationViewController: UIViewController, MKMapViewDelegate, UITextViewDelegate {
    
    let whereAreYouStudyingToday = "Where are you\nstudying\ntoday?"
    let enterYourLocationHere = "Enter Your Location Here"
    let enterALinkToShareHere = "Enter a Link to Share Here"
    
    let greyBackground = UIColor(colorLiteralRed: 224.0/255.0, green: 224.0/255.0, blue: 221.0/255.0, alpha: 1.0)
    let transparentGreyBackground = UIColor(colorLiteralRed: 224.0/255.0, green: 224.0/255.0, blue: 221.0/255.0, alpha: 0.2)
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
    
    var tapRecognizer: UITapGestureRecognizer? = nil
    var activityIndicator = UIActivityIndicatorView()
    
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
    
    @IBAction func findOnMapTouchUp(sender: AnyObject) {
        let location = locationTextView.text
        let geocoder = CLGeocoder()
        showActivityIndicator()
        geocoder.geocodeAddressString(location) { (placemarks, error) in
            dispatch_async(dispatch_get_main_queue(), {
                self.handleGeocodeResult(placemarks)
            })
        }
    }
    
    @IBAction func submitTouchUp(sender: AnyObject) {
        
    }
    
    @IBAction func cancelTouchUp(sender: AnyObject) {
        
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
    
    func handleSingleTap(recognizer: UITapGestureRecognizer) {
        self.view.endEditing(true)
    }
    
    func showActivityIndicator() {
        activityIndicator.frame = CGRectMake(0.0, 0.0, 40.0, 40.0);
        activityIndicator.center = view.center
        activityIndicator.hidesWhenStopped = true
        activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.WhiteLarge
        view.addSubview(activityIndicator)
        activityIndicator.startAnimating()
    }
    
    func hideActivityIndictor() {
        activityIndicator.stopAnimating()
    }
    
    func handleGeocodeResult(placemarks: [CLPlacemark]?) {
        hideActivityIndictor()
        if let placemark = placemarks![0] as? CLPlacemark {
            // Hide/show the title/link text view.
            titleTextView.hidden = true
            linkTextView.hidden = false
            
            // Hide/show the 'find on map'/submit button.
            findOnMapButton.hidden = true
            submitButton.hidden = false
            
            topView.backgroundColor = blueBackground
            middleView.hidden = true
            bottomView.backgroundColor = transparentGreyBackground
            
            // Configure the map view.
            mapView.zoomEnabled = false
            mapView.scrollEnabled = false
            mapView.userInteractionEnabled = false
            let annotations = [MKPlacemark(placemark: placemark)]
            mapView.showAnnotations(annotations, animated: true)
        }
    }
}