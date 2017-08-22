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
        guard verifyUrl(urlString: self.mediaURL.text!) else{
            performUIUpdatesOnMain {
                self.displayAlert("invalid URL", "please enter a valid url (https://...)")
            }
            return
        }
        
        performUIUpdatesOnMain {
            self.performSegue(withIdentifier: "addLocation", sender: self)
        }
        
        
        }
    
        

        

        


    @IBAction func cancelPressed(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let submitVC=segue.destination as! SubmitLocationViewController
        submitVC.locationString=self.locationTextInput.text
        submitVC.userURL=self.mediaURL.text
      
        print("segue called")
    }
    
    func verifyUrl (urlString: String?) -> Bool {
    if let url  = NSURL(string: urlString!) {
    return UIApplication.shared.canOpenURL(url as URL)
    }
    
    return false
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


