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
    }
    
    @IBAction func addPinTouchUp(sender: AnyObject) {
    }
    
    @IBAction func refreshListTouchUp(sender: AnyObject) {
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0//self.allVillains.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
//        let cell = tableView.dequeueReusableCellWithIdentifier("VillainCell") as! UITableViewCell
//        let villain = self.allVillains[indexPath.row]
//        
//        // Set the name and image
//        cell.textLabel?.text = villain.name
//        cell.imageView?.image = UIImage(named: villain.imageName)
//        
//        // If the cell has a detail label, we will put the evil scheme in.
//        if let detailTextLabel = cell.detailTextLabel {
//            detailTextLabel.text = "Scheme: \(villain.evilScheme)"
//        }
        
        return UITableViewCell()
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
//        let detailController = self.storyboard!.instantiateViewControllerWithIdentifier("VillainDetailViewController") as! VillainDetailViewController
//        detailController.villain = self.allVillains[indexPath.row]
//        self.navigationController!.pushViewController(detailController, animated: true)
        
    }
}