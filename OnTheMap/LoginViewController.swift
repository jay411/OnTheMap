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
//    var dataArray=[StudentInfo]()

    
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
    
        UdacityClient.sharedInstance().authenticateUdacityUser(email: username, password: password){
            (succcess,error) in
            
            guard error == nil else {
                performUIUpdatesOnMain {
                    self.username.text=""
                    self.password.text=""
                    self.displayAlert("Login Failed", "Username/Password is incorrect")
                }
                return
            }
            
            if succcess{
                print("loginController:this works")
                UdacityClient.sharedInstance().getUserInfo{ succcess,error in
                    if succcess{
                        print("it works")
                    }
                    else{
                        print("\(error?.localizedDescription)")
                        
                    }
                                        }
             
            }
            
            performUIUpdatesOnMain {
                
                self.username.text=""
                self.password.text=""
                self.performSegue(withIdentifier: "segueToTable", sender: self)
                
                
            }
            
        
    
    
           
        
            }

    }
    

    
    
    private func invalidCredentials(){
        let alertController=UIAlertController(title: "Invalid credentials", message:"Please enter username/password", preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "Dismiss", style: .cancel, handler: nil))
        self.present(alertController, animated: true, completion: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        
    }

}

