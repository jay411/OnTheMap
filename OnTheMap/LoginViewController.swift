//
//  ViewController.swift
//  OnTheMap
//
//  Created by jay raval on 8/10/17.
//  Copyright © 2017 jay raval. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {

    @IBOutlet weak var signUp: UIButton!
    @IBOutlet weak var username: UITextField!
    @IBOutlet weak var password: UITextField!
    //https://www.udacity.com/account/auth#!/signup
//    var dataArray=[StudentInfo]()

    @IBOutlet weak var activityView: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.activityView.hidesWhenStopped=true


        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
    }
    @IBAction func signUpPressed(_ sender: Any) {
        
        UIApplication.shared.open((NSURL(string:"https://www.udacity.com/account/auth#!/signup")! as URL), options: [:], completionHandler: nil)
    }

    @IBAction func loginPressed(_ sender: Any) {
        self.activityView.startAnimating()
        self.activityView.isHidden=false
        
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
                    self.activityView.stopAnimating()
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
                self.activityView.stopAnimating()
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
    
        override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if(self.username.isFirstResponder){
            print("username field resigning")
            self.username.resignFirstResponder()
        }
        if (self.password.isFirstResponder) {
            print("password field resigning")

            self.password.resignFirstResponder()
        }
//        view.frame.origin.y=0
        
    }
    



}

