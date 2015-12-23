//
//  PinListViewController.swift
//  OnTheMap
//
//  Created by Wouter de Vos on 2015/12/20.
//  Copyright © 2015 Wouter. All rights reserved.
//

import UIKit

class PinListTableViewController: BaseViewController, UITableViewDataSource, UITableViewDelegate {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
    }
    
    @IBAction func logoutTouchUp(sender: AnyObject) {
        logout()
    }
    
    @IBAction func addPinTouchUp(sender: AnyObject) {
        getPublicUserData()
    }
    
    @IBAction func refreshListTouchUp(sender: AnyObject) {
        getStudentLocations()
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return OnTheMapClient.sharedInstance().studentLocations.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("StudentLocationTableViewCell", forIndexPath: indexPath)
        let studentLocation = OnTheMapClient.sharedInstance().studentLocations[indexPath.row]
        
        // Set the name
        cell.textLabel?.text = "\(studentLocation.firstName) \(studentLocation.lastName)"
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        let studentLocation = OnTheMapClient.sharedInstance().studentLocations[indexPath.row]
        UIApplication.sharedApplication().openURL(NSURL(string: studentLocation.mediaURL)!)
    }
}