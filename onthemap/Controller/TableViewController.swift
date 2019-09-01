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
    
    var cell = UITableViewCell(style: .subtitle, reuseIdentifier: "studentInformation")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureRefreshControl()
    }
    
    
    // MARK: IBactions
    @IBAction func reload(_ sender: Any) {
        UdacityClient.getStudentLocations(completion: handleStudentLocationResponse(studentLocations:error:))    }
    
    
    // MARK: Functions
    func configureRefreshControl () {
        // Add the refresh control to your UIScrollView object.
        table.refreshControl = UIRefreshControl()
        table.refreshControl?.addTarget(self, action:
            #selector(handleRefreshControl),
                                                  for: .valueChanged)
    }
    
    @objc func handleRefreshControl() {
        reload(self)
        
        DispatchQueue.main.async {
            self.table.refreshControl?.endRefreshing()
        }
    }
    
    func handleStudentLocationResponse(studentLocations: [StudentLocations], error: Error?) {
        if error != nil {
            showStudentInformationFailure(message:error?.localizedDescription ?? "")
        } else
        {
            UdacityClient.studentLocation = studentLocations
            table.reloadData()
        }
    }
        
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return UdacityClient.studentLocation.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        cell = tableView.dequeueReusableCell(withIdentifier: "studentInformation", for: indexPath)
        
        let currentStudent = UdacityClient.studentLocation[indexPath.row]
        
        cell.imageView?.image = UIImage(named: "icon_pin")
        cell.textLabel?.text = currentStudent.firstName + " " + currentStudent.lastName
        
        if let detailTextLabel = cell.detailTextLabel {
            detailTextLabel.text = currentStudent.mediaURL
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let currentStudent = UdacityClient.studentLocation[indexPath.row]
            let app = UIApplication.shared
                app.open(URL(string:currentStudent.mediaURL)!, options: [:], completionHandler: nil)
    } 
    
    
}
