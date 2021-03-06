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

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate=self
        print("view did load called")
        
       
        
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print("view will appear called")
        ParseClient.sharedInstance().getAllLocations({ (success, error) in
            if success{
                print("worked view did load in table")
                //                                print("student array: \(data)")
                performUIUpdatesOnMain {
                    self.tableView.reloadData()
                }
                
            }
            else{
                self.displayAlert("error loading data", "\(error!.localizedDescription)")
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
        return Students.sharedInstance().studentArray.count

    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        super.tableView(tableView, cellForRowAt: indexPath)
        print("creating cells")
        let cell = tableView.dequeueReusableCell(withIdentifier: "locationsCell") as! LocationsTableCell
        let student=Students.sharedInstance().studentArray[(indexPath as NSIndexPath).row]
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
        guard let url=Students.sharedInstance().studentArray[(indexPath as NSIndexPath).row].mediaURL else{
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

    func refresh(_ completionForRefresh:@escaping(_ success:Bool,_ error:Error?)->Void){
        ParseClient.sharedInstance().didRefresh=true
        
        ParseClient.sharedInstance().getAllLocations({ (success, error) in
           
            if success{
                print("worked in refresh")
                //                                print("student array: \(data)")
                completionForRefresh(true,nil)

                performUIUpdatesOnMain {

                    self.tableView.reloadData()
                    
                }
                
            }
            else{
                completionForRefresh(false,error)

            }
            
            
        })
      return
    }

}
