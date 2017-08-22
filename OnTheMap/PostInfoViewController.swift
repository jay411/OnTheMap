//
//  PostInfoViewController.swift
//  OnTheMap
//
//  Created by jay raval on 8/15/17.
//  Copyright © 2017 jay raval. All rights reserved.
//

import UIKit

class PostInfoViewController: UIViewController,UITextFieldDelegate {
    
    @IBOutlet weak var locationTextInput: UITextField!
    @IBOutlet weak var findOnMap: UIButton!
    
    
    @IBOutlet weak var mediaURL: UITextField!
   

    override func viewDidLoad() {
        super.viewDidLoad()
        mediaURL.delegate=self
        locationTextInput.delegate=self
                // Do any additional setup after loading the view.
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func findClicked(_ sender: Any) {
       
        print("find clicked")
        guard (self.locationTextInput.text)! != "" else{
            print("location text ")
            performUIUpdatesOnMain {
                self.displayAlert("No Location", "Please enter location")
            }
            return
        }
        guard self.mediaURL.text! != "" else {
            performUIUpdatesOnMain {
                self.displayAlert("no URL", "please enter url")
            }
            return
        }
        
        performUIUpdatesOnMain {
//            self.present(submitVC, animated: true, completion: nil)
            self.performSegue(withIdentifier: "addLocation", sender: self)
        }
        
        
        }
    
        

        

        

    

//    @IBAction func submitLocation(_ sender: Any) {
//        print("submit pressed")
//        guard let mapString = self.locationTextInput.text else{
//            print("could not create mapstring")
//            return
//        }
//
//        ParseClient.sharedInstance().getStudentLocation { (success, data, error) in
//            guard error == nil else {
//                print("\(error?.localizedDescription)")
//                return
//            }
//            if success{
//                guard (data == nil) else{
//                    performUIUpdatesOnMain {
//                        self.updateMessage("Location Found", "Would you like to update your existing location")
//                    }
//                    return
//                }
//                ParseClient.sharedInstance().postStudentLocation(mapString, self.longitudeForSubmit!, self.latitudeForSubmit!) { (success, data, error) in
//                                guard error == nil else{
//                                    performUIUpdatesOnMain {
//                    
//                    
//                                    self.displayAlert("could not post data to parse", "\(error?.localizedDescription)")
//                                    
//                                    }
//                                    return
//                                    
//                                }
//
//                
//                print("user data:\(data)")
//                
//                print("here")
//                //                print("data:\(data)")
//            }
//        }
//        
//    }
//        
//  }
    @IBAction func cancelPressed(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let submitVC=segue.destination as! SubmitLocationViewController
        submitVC.locationString=self.locationTextInput.text
        submitVC.userURL=self.mediaURL.text
      
        print("segue called")
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField.tag == 1{
            if (textField.text)! == ""{
            return }
            textField.text="https://"+textField.text!
        }
    }
}




extension PostInfoViewController{
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if(self.locationTextInput.isFirstResponder){
            self.locationTextInput.resignFirstResponder()
        }
        if (self.mediaURL.isFirstResponder) {
            self.mediaURL.resignFirstResponder()
        }
                view.frame.origin.y=0
        
    }
    
    }


