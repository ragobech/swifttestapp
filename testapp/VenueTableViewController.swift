//
//  VenueTableViewController.swift
//  testapp
//
//  Created by Chris Ragobeer on 2016-02-18.
//  Copyright © 2016 Chris Ragobeer. All rights reserved.
//

import UIKit

class VenueTableViewController : UITableViewController {
    
    var venues = [VenueModel]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
    }
 
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 3
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Section \(section)"
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("LabelCell", forIndexPath: indexPath)
        
        cell.textLabel?.text = "Section \(indexPath.section) Row \(indexPath.row)"
        
        return cell
    }
    
}