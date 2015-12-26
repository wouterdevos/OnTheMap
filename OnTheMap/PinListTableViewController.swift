//
//  PinListViewController.swift
//  OnTheMap
//
//  Created by Wouter de Vos on 2015/12/20.
//  Copyright © 2015 Wouter. All rights reserved.
//

import UIKit

class PinListTableViewController: BaseDataDisplayViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet var tableView: UITableView!
    @IBOutlet weak var activityIndicatorView: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    @IBAction func logoutTouchUp(sender: AnyObject) {
        logout()
    }
    
    @IBAction func addPinTouchUp(sender: AnyObject) {
        getStudentLocation()
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
    
    override func showActivityIndicatorView() {
        activityIndicatorView.frame = CGRectMake(0.0, 0.0, 40.0, 40.0);
        activityIndicatorView.center = tableView.center
        activityIndicatorView.hidesWhenStopped = true
        activityIndicatorView.activityIndicatorViewStyle = .Gray
        tableView.addSubview(activityIndicatorView)
        activityIndicatorView.startAnimating()
    }
    
    override func hideActivityIndicatorView() {
        activityIndicatorView.stopAnimating()
    }
}