//
//  TableViewController.swift
//  onthemap
//
//  Created by Peter Burgner on 8/29/19.
//  Copyright © 2019 Peter Burgner. All rights reserved.
//

import UIKit

class TableViewController: UIViewController, UITabBarDelegate, UITableViewDelegate, UITableViewDataSource {

    
    
    @IBOutlet weak var logoutButton: UIBarButtonItem!
    @IBOutlet weak var reloadButton: UIBarButtonItem!
    @IBOutlet weak var addButton: UIBarButtonItem!
    @IBOutlet weak var table: UITableView!
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return UdacityClient.studentLocation.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "studentInformation", for: indexPath)
        
        let currentStudent = UdacityClient.studentLocation[indexPath.row]
        
        cell.imageView?.image = UIImage(named: "icon_pin")
        cell.textLabel?.text = currentStudent.firstName + " " + currentStudent.lastName
        
        
        return cell
    }
    
 
    
    
}
