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
    @IBOutlet weak var loadingView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        loadingView.hidden = true
        activityIndicatorView.stopAnimating()
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
        return DataModel.sharedInstance().studentLocations.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("StudentLocationTableViewCell", forIndexPath: indexPath)
        let studentLocation = DataModel.sharedInstance().studentLocations[indexPath.row]
        
        // Set the name
        cell.textLabel?.text = "\(studentLocation.firstName) \(studentLocation.lastName)"
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        let studentLocation = DataModel.sharedInstance().studentLocations[indexPath.row]
        let urlString = studentLocation.mediaURL
        openURL(urlString)
    }
    
    override func showActivityIndicatorView() {
        loadingView.hidden = false
        activityIndicatorView.activityIndicatorViewStyle = .Gray
        activityIndicatorView.startAnimating()
    }
    
    override func hideActivityIndicatorView() {
        loadingView.hidden = true
        activityIndicatorView.stopAnimating()
    }
}