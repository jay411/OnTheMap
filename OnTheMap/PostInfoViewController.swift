//
//  PostInfoViewController.swift
//  OnTheMap
//
//  Created by jay raval on 8/15/17.
//  Copyright © 2017 jay raval. All rights reserved.
//

import UIKit
import MapKit

class PostInfoViewController: UIViewController {
    
    @IBOutlet weak var initialStackView: UIStackView!
    @IBOutlet weak var locationTextInput: UITextField!
    @IBOutlet weak var findOnMap: UIButton!
    var update:Bool?
    
    
    @IBOutlet weak var secondStackView: UIStackView!

    @IBOutlet weak var mediaURL: UITextField!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var submitButton: UIButton!
    lazy var geocoder = CLGeocoder()
    var longitudeForSubmit:CLLocationDegrees?
    var latitudeForSubmit:CLLocationDegrees?
    var location:CLLocation?

    override func viewDidLoad() {
        super.viewDidLoad()
        subscribeToKeyboardNotifications()

        // Do any additional setup after loading the view.
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        unsubscribeToKeyboardNotifications()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func findClicked(_ sender: Any) {
        self.initialStackView.isHidden=true
        self.secondStackView.isHidden=false
        print("find clicked")
        self.forwardGecode(self.locationTextInput.text!) { (success, location, error) in
            guard  error == nil else{
                print(error.debugDescription)
                performUIUpdatesOnMain {
                    self.displayAlert("Could not find location", (error?.localizedDescription)!)
                    self.initialStackView.isHidden=false
                    self.secondStackView.isHidden=true
                }
                return
            }
            if success{
                let coordinate=location?.coordinate
                self.latitudeForSubmit=coordinate?.latitude
                self.longitudeForSubmit=coordinate?.longitude
                let mapannotation = MKPointAnnotation()
                mapannotation.coordinate = (coordinate)!
                self.mapView.addAnnotation(mapannotation)
                self.mapView.setRegion(MKCoordinateRegion(center: (location!.coordinate),span: MKCoordinateSpan(latitudeDelta: 0.5,longitudeDelta: 0.5)), animated: true)
                
                performUIUpdatesOnMain {
                    self.submitButton.setTitle("Submit", for: .normal)
                    self.mapView.isHidden=false
                    
                    self.mapView.showAnnotations(self.mapView.annotations, animated: true)
                }
            }
        }

        

        
//        self.mapView.isHidden=false
//        
//        self.mapView.showAnnotations(self.mapView.annotations, animated: true)

    }

    @IBAction func submitLocation(_ sender: Any) {
        print("submit pressed")
        guard let mapString = self.locationTextInput.text else{
            print("could not create mapstring")
            return
        }

        ParseClient.sharedInstance().getStudentLocation { (success, data, error) in
            guard error == nil else {
                print("\(error?.localizedDescription)")
                return
            }
            if success{
                guard (data == nil) else{
                    performUIUpdatesOnMain {
                        self.updateMessage("Location Found", "Would you like to update your existing location")
                    }
                    return
                }
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
        }
        
    }
        
}
}




extension PostInfoViewController:MKMapViewDelegate{
    /*geocoding and mapview updates*/
    
    func forwardGecode(_ addressString:String,_ completionHandlerForGeocode: @escaping(_ success:Bool,_ location:CLLocation?,_ error:Error?)-> Void){
        geocoder.geocodeAddressString(addressString) { (placemarks, error) in
            if (error != nil) {
                
                return completionHandlerForGeocode(true, nil, error)
            }
            if let placemarksArray=placemarks, placemarksArray.count > 0{
                
                return completionHandlerForGeocode(true,(placemarksArray.first?.location)!,nil)
            }
        }

        
    }
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        let reuseId = "pin"
        
        var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId) as? MKPinAnnotationView
        
        if pinView == nil {
            pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            pinView!.canShowCallout = true
            pinView!.pinTintColor = .red
            pinView!.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
        }
        else {
            pinView!.annotation = annotation
        }
        
        return pinView
    }
    
    func subscribeToKeyboardNotifications(){
        print("subscribing to keyboard inside subscribe func")
        //
        NotificationCenter.default.addObserver(self, selector:#selector(keyboardWillShow(_:)), name: .UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: .UIKeyboardWillHide, object: nil)
    }
    func unsubscribeToKeyboardNotifications(){
        NotificationCenter.default.removeObserver(self, name: .UIKeyboardWillShow, object: nil)
        NotificationCenter.default.removeObserver(self, name: .UIKeyboardWillHide, object: nil)
    }
    
    
    func keyboardWillShow(_ notification:Notification){
        print("\n keyboardwillShow called")
        if ( self.locationTextInput.isFirstResponder){
//            self.initialStackView.frame.origin.y-=getKeyboardHeight(notification)
//            self.locationTextInput.frame.origin.y -= getKeyboardHeight(notification)
            if view.frame.origin.y == 0 {
                
//            view.frame.origin.y -= getKeyboardHeight(notification)
//                self.locationTextInput.frame.origin.y -= getKeyboardHeight(notification)
//                self.findOnMap.frame.origin.y -= getKeyboardHeight(notification)
            }
        }
        
        
    }
    func keyboardWillHide(_ notification:Notification){
//        self.locationTextInput.frame.origin.y += getKeyboardHeight(notification)
//        self.findOnMap.frame.origin.y += getKeyboardHeight(notification)


        
        
        view.frame.origin.y=0
        
        
    }
    func getKeyboardHeight(_ notification:Notification) -> CGFloat {
        print("KEYBOARD height called")
        
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue
        return keyboardSize.cgRectValue.height
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if(self.locationTextInput.isFirstResponder){
            self.locationTextInput.resignFirstResponder()
        }
        if (self.mediaURL.isFirstResponder) {
            self.mediaURL.resignFirstResponder()
        }
                view.frame.origin.y=0
        
    }
    func updateMessage(_ title:String,_ message:String){
        
        let alertController=UIAlertController(title:title, message:message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "Update", style: .destructive, handler: { (UIAlertAction) in
            self.update=true
            ParseClient.sharedInstance().putStudentLocation(self.locationTextInput.text!, self.longitudeForSubmit!, self.latitudeForSubmit!, { (success, error) in
                guard error == nil else{
                    performUIUpdatesOnMain {
                        self.displayAlert("could not update data", "\(error?.localizedDescription)")
                    }
                    return
                }
                if success{
                    print("updated")
                }
            })
         
        }))
        alertController.addAction(UIAlertAction(title: "No", style: .default, handler: { (UIAlertAction) in
            self.update=false
            ParseClient.sharedInstance().postStudentLocation(self.locationTextInput.text!, self.longitudeForSubmit!, self.latitudeForSubmit!) { (success, data, error) in
                guard error == nil else{
                    performUIUpdatesOnMain {
                        
                        
                        self.displayAlert("could not post data to parse", "\(error?.localizedDescription)")
                        
                    }
                    return
                    
                }
                
                
//                print("user data:\(data)")
                
                print("here")
                performUIUpdatesOnMain {
                    
                
                self.dismiss(animated: true, completion: nil)
                }
            }
        }))
        self.present(alertController, animated: true, completion: nil)
    }
  
    
}


