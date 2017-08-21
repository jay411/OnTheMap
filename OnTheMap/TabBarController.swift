//
//  TabBarController.swift
//  OnTheMap
//
//  Created by jay raval on 8/17/17.
//  Copyright © 2017 jay raval. All rights reserved.
//

import UIKit

class TabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        print("tab bar view did load called")
               // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    
    

    }
    @IBAction func postLocation(_ sender: Any) {
        self.performSegue(withIdentifier: "postInfoSegue", sender: self)
    }

    @IBAction func refresh(_ sender: Any) {
        
        if self.selectedIndex == 0{
            print("locations tableVIew controller called")
             let storyboard = UIStoryboard (name: "Main", bundle: nil)
            let resultVC = storyboard.instantiateViewController(withIdentifier: "LocationsTableViewController") as! LocationsTableViewController
            performUIUpdatesOnMain {
                
            
            resultVC.tableView.reloadData()
            }
        }
        else if self.selectedIndex == 1{
            print("Locations Mapview controller called")
            let storyboard = UIStoryboard (name: "Main", bundle: nil)
            let resultVC = storyboard.instantiateViewController(withIdentifier: "LocationMapViewController") as! LocationMapViewController
            
            performUIUpdatesOnMain {
                
            
            resultVC.view.reloadInputViews()
            }

            
        }
    }
    @IBAction func logout(_ sender: Any) {
        UdacityClient.sharedInstance().logout { (success) in
            if success{
                performUIUpdatesOnMain {
                    self.dismiss(animated: true, completion: nil)
                }
            }
            else{
                performUIUpdatesOnMain {
                    self.displayAlert("logout unsuccessful", "please try again")
                }
            }
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
