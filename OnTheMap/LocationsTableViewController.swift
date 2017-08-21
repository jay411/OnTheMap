//
//  LocationsTableViewController.swift
//  OnTheMap
//
//  Created by jay raval on 8/13/17.
//  Copyright © 2017 jay raval. All rights reserved.
//

import UIKit
import CoreLocation

class LocationsTableViewController: UITableViewController {

    var studentArray=[StudentInfo]()

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate=self

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        ParseClient.sharedInstance().getAllLocations(false, { (success,data, error) in
            if success{
                print("worked")
                //                                print("student array: \(data)")
                self.studentArray=data! as! [StudentInfo]
                print("parse client array:\(ParseClient.sharedInstance().allStudents[0])")
                performUIUpdatesOnMain {
                    self.tableView.reloadData()
                }
                
            }
            else{
                print(error.debugDescription)
            }
        })
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        print("\n number of cells: \(ParseClient.sharedInstance().allStudents.count)")
        return ParseClient.sharedInstance().allStudents.count

//        return self.studentArray.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        super.tableView(tableView, cellForRowAt: indexPath)
        print("creating cells")
        let cell = tableView.dequeueReusableCell(withIdentifier: "locationsCell") as! LocationsTableCell
        let student=self.studentArray[(indexPath as NSIndexPath).row]
        if let firstName=student.firstName {
            cell.name.text=firstName
        }
        if let lastName=student.lastName {
            cell.name.text?.append(" ")
            cell.name.text?.append(lastName)
        }
        
        if let location=student.location{
            cell.locationName.text=location
        }
        if let url=student.mediaURL{
            cell.urlLabel.text=url
            
        }
        
        



        return cell
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let url=self.studentArray[(indexPath as NSIndexPath).row].mediaURL else{
            return
        }
        if NSURL(string: url) != nil {
            UIApplication.shared.open((NSURL(string: url)! as URL), options: [:], completionHandler: nil)

            
        }
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    @IBAction func postPressed(_ sender: Any) {
        self.performSegue(withIdentifier: "postInfoSegue", sender: self)
    }

}
