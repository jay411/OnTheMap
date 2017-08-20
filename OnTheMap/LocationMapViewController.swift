//
//  LocationMapViewController.swift
//  OnTheMap
//
//  Created by jay raval on 8/11/17.
//  Copyright © 2017 jay raval. All rights reserved.
//

import UIKit
import MapKit


class LocationMapViewController: UIViewController,MKMapViewDelegate {
    let object = UIApplication.shared.delegate
    var studentArray=[StudentInfo]()


    @IBOutlet weak var studentsMapView: MKMapView!

    override func viewDidLoad() {
        super.viewDidLoad()
        subscribeToKeyboardNotifications()
//        self.studentArray = ParseClient.sharedInstance().allStudents
        ParseClient.sharedInstance().getAllLocations(false, { (success,data, error) in
            if success{
                print("worked")
                //                                print("student array: \(data)")
                self.studentArray=data! as! [StudentInfo]
                print("parse client array:\(ParseClient.sharedInstance().allStudents.count)")
                performUIUpdatesOnMain {
//                    self.studentsMapView.reloadData()
                    self.createAnnotations()

                }
                
            }
            else{
                print(error.debugDescription)
            }
        })

//        self.createAnnotations()
        print("map view loaded")
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        unsubscribeToKeyboardNotifications()
    }
    
    private func createAnnotations(){
        
        // We will create an MKPointAnnotation for each dictionary in "locations". The
        // point annotations will be stored in this array, and then provided to the map view.
        var annotations = [MKPointAnnotation]()
        
        // The "locations" array is loaded with the sample data below. We are using the dictionaries
        // to create map annotations. This would be more stylish if the dictionaries were being
        // used to create custom structs. Perhaps StudentLocation structs.
        
        for student in self.studentArray {
            
            // Notice that the float values are being used to create CLLocationDegree values.
            // This is a version of the Double type.
            guard let lat = student.latitude else{
                continue
            }
            guard let long = student.longitude else{
                continue
            }
            
            // The lat and long are used to create a CLLocationCoordinates2D instance.
            let coordinate = CLLocationCoordinate2D(latitude: lat, longitude: long)
            
            guard let first = student.firstName else {
                continue
            }
            guard let last = student.lastName else{
                continue
            }
           
            
            
            // Here we create the annotation and set its coordiate, title, and subtitle properties
            let annotation = MKPointAnnotation()
            annotation.coordinate = coordinate
            annotation.title = "\(first) \(last)"
            if let mediaURL = student.mediaURL             {
                annotation.subtitle = mediaURL 

            }
            
            // Finally we place the annotation in an array of annotations.
            annotations.append(annotation)
        }
        self.studentsMapView.addAnnotations(annotations)


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
    
    
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        if control == view.rightCalloutAccessoryView {
            let app = UIApplication.shared
            if let toOpen = view.annotation?.subtitle! {
                app.open(URL(string: toOpen)!,options: [:], completionHandler: nil)
            }
        }
    }
    func subscribeToKeyboardNotifications(){
        print("subscribing to keyboard inside subscribe func")
        
        NotificationCenter.default.addObserver(self, selector:#selector(keyboardWillShow(_:)), name: .UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: .UIKeyboardWillHide, object: nil)
    }
    func unsubscribeToKeyboardNotifications(){
        NotificationCenter.default.removeObserver(self, name: .UIKeyboardWillShow, object: nil)
        NotificationCenter.default.removeObserver(self, name: .UIKeyboardWillHide, object: nil)
    }
    
    
    func keyboardWillShow(_ notification:Notification){
        print("\n keyboardwillShow called")
        if (view.frame.origin.y == 0){
            view.frame.origin.y -= getKeyboardHeight(notification)
        }
        
        
    }
    func keyboardWillHide(_ notification:Notification){
        
        view.frame.origin.y=0
        
        
    }
    func getKeyboardHeight(_ notification:Notification) -> CGFloat {
        print("KEYBOARD height called")
        
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue
        return keyboardSize.cgRectValue.height
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        textField.resignFirstResponder()
        textField.borderStyle=UITextBorderStyle.none
        
        textField.backgroundColor=UIColor.clear
        
        
        return true
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
