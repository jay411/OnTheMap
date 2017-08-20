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

        // Do any additional setup after loading the view.
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
        ParseClient.sharedInstance().postStudentLocation(mapString, longitudeForSubmit!, latitudeForSubmit!) { (success, data, error) in
            guard error == nil else{
                performUIUpdatesOnMain {
                    
                
                self.displayAlert("could not post data to parse", "\(error?.localizedDescription)")
                
                }
                return
                
            }
            if success{
                print("data posted")
//                ParseClient.sharedInstance().getStudentLocation({ (success, data, error) in
//                    guard error == nil else{
//                        performUIUpdatesOnMain {
//                            self.displayAlert("couldnt get user data", "\(error?.localizedDescription)")
//                        }
//                        return
//                    }
//                    if success{
//                        guard data != nil else{
//                            print("data is nil")
//                            return
//                        }
//                    }
//                })
                
            
            }
        }
        ParseClient.sharedInstance().getStudentLocation { (success, data, error) in
            guard error == nil else {
                print("\(error?.localizedDescription)")
                return
            }
            if success{
                print("user data:\(data)")
                performUIUpdatesOnMain {
                    self.dismiss(animated: true, completion: nil)

                }
                //                print("data:\(data)")
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
  
    
}


