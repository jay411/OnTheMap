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
    
    override func viewDidLoad() {
        super.viewDidLoad()
      
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
            (succcess,data,error) in
            if succcess{
                print("this works")
                UdacityClient.sharedInstance().getUserData(data)
            }
            else{
                self.invalidCredentials()
            }
            
            
        }

    }
    
//    private func getUserData(_ userId:AnyObject)-> Void
//    {
//        let request = NSMutableURLRequest(url: URL(string: "https://www.udacity.com/api/users/\(userId)")!)
//        let session = URLSession.shared
//        let task = session.dataTask(with: request as URLRequest) { data, response, error in
//            if error != nil { // Handle error...
//                return
//            }
//            let range = Range(5..<data!.count)
//            let newData = data?.subdata(in: range) /* subset response data! */
//            print(NSString(data: newData!, encoding: String.Encoding.utf8.rawValue)!)
//        }
//        task.resume()
//    
//    }
    
    
    private func invalidCredentials(){
        let alertController=UIAlertController(title: "Invalid credentials", message:"Please enter username/password", preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "Dismiss", style: .cancel, handler: nil))
        self.present(alertController, animated: true, completion: nil)
    }

}

