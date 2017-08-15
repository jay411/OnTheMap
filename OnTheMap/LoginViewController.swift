//
//  ViewController.swift
//  OnTheMap
//
//  Created by jay raval on 8/10/17.
//  Copyright © 2017 jay raval. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {

    @IBOutlet weak var username: UITextField!
    @IBOutlet weak var password: UITextField!
//    var dataArray=[StudentData]()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        ParseClient.sharedInstance().getAllLocations(false, { (success,data, error) in
            if success{
                print("worked")
                //                                print("student array: \(data)")
                let object = UIApplication.shared.delegate

                let appDelegate = object as! AppDelegate

                appDelegate.studentsArray=data! as! [AnyObject]
                print("appdelegate array:\(appDelegate.studentsArray.count)")
                
            }
            else{
                print(error.debugDescription)
            }
        })
      
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func loginPressed(_ sender: Any) {

        
        guard let username = self.username.text else{
          
            return
        }
        
        guard let password = self.password.text else{
            
            return
        }
        if username == "" || password == "" {
            self.invalidCredentials()
            
        }
        
        // Placeholder call the authenticateUdacityUser(email:password)
//        // 
//        UdacityClient.sharedInstance().authenticateUdacityUser(email: username, password: password) { (success, error) in
//            // 
//            
//            
//            //MARK: TODO - if success:
//            /*
//             1. store Udacity User ID -> Parse's uniqueKey
//             2. obtain from UDACITY: the user's first_name and last_name from the User public data; store
//             3. obtain from PARSE: the user location - option; order:-updateAt, if it exists
//             4. obtain from PARSE: the latest 100 student locatiosn
//             5. transition to the map view
//             */
//        }
        UdacityClient.sharedInstance().authenticateUdacityUser(email: username, password: password){
            (succcess,error) in
            DispatchQueue.global(qos: .userInitiated).async {
                
            
            if succcess{
                print("loginController:this works")
                UdacityClient.sharedInstance().getUserData{ succcess,error in
                    if succcess{
                        print("it works")
//                        ParseClient.sharedInstance().getStudentLocation({ (success, data, error) in
//                            print("called get studentlocation")
//                        })
//
//                        ParseClient.sharedInstance().getAllLocations(false, { (success,data, error) in
//                            if success{
//                                print("worked")
////                                print("student array: \(data)")
//
//                                appDelegate.studentsArray=data! as! [AnyObject]
//                                print("appdelegate array:\(appDelegate.studentsArray.count)")
//                                
//                            }
//                            else{
//                                print(error.debugDescription)
//                            }
//                        })
                    }
                    else{
                        print("\(error.debugDescription)")
                    }
                    
                }
            }
            
        
    
    
            else{
                self.invalidCredentials()
            }
                DispatchQueue.main.async(execute: { () -> Void in
                    self.performSegue(withIdentifier: "segueToTable", sender: self)
                })

            
        }
        
            }

    }
    

    
    
    private func invalidCredentials(){
        let alertController=UIAlertController(title: "Invalid credentials", message:"Please enter username/password", preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "Dismiss", style: .cancel, handler: nil))
        self.present(alertController, animated: true, completion: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let controller=segue.destination as! LocationsTableViewController
        
    }

}

