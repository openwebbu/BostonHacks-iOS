//
//  AnnouncementsTableViewController.swift
//  Boston Hacks
//
//  Created by Иван Уваров on 10/10/15.
//  Copyright © 2015 Ivan Uvarov. All rights reserved.
//

import UIKit
import Parse




class AnnouncementsTableViewController: UITableViewController {
    
    // Data for the table
    var tableData = []
    var refresh = UIRefreshControl()
    let activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: .White)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set up the activity indicator (loading spinner)
        let barButtonItem = UIBarButtonItem(customView: activityIndicator)
        navigationItem.rightBarButtonItem = barButtonItem
        activityIndicator.startAnimating()
        
        self.refreshControl = self.refresh
        self.refresh.addTarget(self, action: "didRefreshList", forControlEvents: .ValueChanged)
        
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 98.0
        tableView.tableFooterView = UIView.init(frame: CGRectZero)
        
        let announcementsQuery = PFQuery(className: "Announcements")
        announcementsQuery.orderByDescending("createdAt")
        announcementsQuery.findObjectsInBackgroundWithBlock { (objects: [PFObject]?, error: NSError?) -> Void in
            if error == nil {
                self.tableData = objects!
                self.tableView.reloadData()
                self.activityIndicator.stopAnimating()
            }
        }
        
    }
    
    func didRefreshList() {
        
        let announcementsQuery = PFQuery(className: "Announcements")
        announcementsQuery.orderByDescending("createdAt")
        announcementsQuery.findObjectsInBackgroundWithBlock { (objects: [PFObject]?, error: NSError?) -> Void in
            if error == nil {
                self.tableData = objects!
                self.tableView.reloadData()
                self.refresh.endRefreshing()
            }
        }
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return tableData.count
    }
    
    

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("AnnouncementCell", forIndexPath: indexPath) as! AnnouncementTableViewCell
        cell.userInteractionEnabled = false
        
        let announcement = self.tableData[indexPath.row]
        
        let title  = announcement["title"] as! String
        let description = announcement["description"] as! String
        let timePosted = announcement.createdAt
        
        
        let timeSincePosted = NSDate().offsetFrom(timePosted!!)
        
        cell.announcementTile.text = title
        cell.announcementDescription.text = description
        cell.announcementTime.text = timeSincePosted
        
        /*cell.textLabel!.text = title
        cell.detailTextLabel!.text = description*/
        

        return cell
    }
    

}
