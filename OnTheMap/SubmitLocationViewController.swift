//
//  SubmitLocationViewController.swift
//  OnTheMap
//
//  Created by jay raval on 8/21/17.
//  Copyright © 2017 jay raval. All rights reserved.
//

import UIKit
import MapKit

class SubmitLocationViewController: UIViewController {

    @IBOutlet weak var locationMapView: MKMapView!
    var locationString:String?
    lazy var geocoder = CLGeocoder()
    var longitudeForSubmit:CLLocationDegrees?
    var latitudeForSubmit:CLLocationDegrees?
    var userURL:String?
    @IBOutlet weak var submitButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.forwardGecode(self.locationString!) { (success, location, error) in
            guard  error == nil else{
                print(error.debugDescription)
                performUIUpdatesOnMain {
                    self.displayAlert("Could not find location", (error?.localizedDescription)!)
                    
                }
                return
            }
            if success{
                let coordinate=location?.coordinate
                self.latitudeForSubmit=coordinate?.latitude
                self.longitudeForSubmit=coordinate?.longitude
                let mapannotation = MKPointAnnotation()
                mapannotation.coordinate = (coordinate)!
                self.locationMapView.addAnnotation(mapannotation)
                self.locationMapView.setRegion(MKCoordinateRegion(center: (location!.coordinate),span: MKCoordinateSpan(latitudeDelta: 0.5,longitudeDelta: 0.5)), animated: true)
                
                performUIUpdatesOnMain {
                    self.locationMapView.isHidden=false
                    
                    self.locationMapView.showAnnotations(self.locationMapView.annotations, animated: true)
                }
            }
        }


        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func submitLocation(_ sender: Any) {
        print("submit pressed")
        guard let mapString = self.locationString else{
            performUIUpdatesOnMain {
                self.displayAlert("No Location", "please add location in previous screen")
            }
            return
        }
        
        ParseClient.sharedInstance().getStudentLocation { (success, data, error) in
            guard error == nil else {
                print("\(error!.localizedDescription)")
                performUIUpdatesOnMain {
                    self.displayAlert("Could not download student location", "\(error!.localizedDescription)")
                }
                return
            }
            if success{
                guard (data == nil) else{
                    performUIUpdatesOnMain {
                        self.updateMessage("Location Exists", "Would you like to update your existing location or add a new one")
                    }
                    return
                }
                ParseClient.sharedInstance().postStudentLocation(mapString, self.longitudeForSubmit!, self.latitudeForSubmit!,self.userURL) { (success, data, error) in
                    guard error == nil else{
                        performUIUpdatesOnMain {
                            
                            
                            self.displayAlert("could not post data to parse", "\(error!.localizedDescription)")
                            
                        }
                        return
                        
                    }
                    
                    
                    print("user data:\(data)")
                    
                    print("here")
                    //                print("data:\(data)")
                }
            }
            
        }
    }
        func updateMessage(_ title:String,_ message:String){
            
            let alertController=UIAlertController(title:title, message:message, preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "Update", style: .destructive, handler: { (UIAlertAction) in
                
                ParseClient.sharedInstance().putStudentLocation(self.locationString!, self.longitudeForSubmit!, self.latitudeForSubmit!,self.userURL, { (success, error) in
                    guard error == nil else{
                        performUIUpdatesOnMain {
                            self.displayAlert("could not update data", "\(error!.localizedDescription)")
                        }
                        return
                    }
                    if success{
                        
                        print("updated")
                        performUIUpdatesOnMain {
                            
                            
                            self.presentingViewController?.dismiss(animated: true, completion: nil)

                        }
                        
                    }
                })
                
            }))
            alertController.addAction(UIAlertAction(title: "Add", style: .default, handler: { (UIAlertAction) in
//                                        self.presentingViewController?.dismiss(animated: true, completion: nil)

                ParseClient.sharedInstance().postStudentLocation(self.locationString!, self.longitudeForSubmit!, self.latitudeForSubmit!,self.userURL) { (success, data, error) in
                    guard error == nil else{
                        performUIUpdatesOnMain {
                            
                            
                            self.displayAlert("could not post data to parse", "\(error!.localizedDescription)")
                            
                        }
                        return
                        
                    }
                    
                    
                    //                print("user data:\(data)")
                    
                    print("here")
                    performUIUpdatesOnMain {
                        
                       // self.navigationController?.popToRootViewController(animated: true)
//                        let navVC=self.storyboard?.instantiateViewController(withIdentifier: "PostNavigationController") as! UINavigationController
                        self.presentingViewController?.dismiss(animated: true, completion: nil)
//                        self.dismiss(animated: true, completion: nil)
//                        navVC.popToRootViewController(animated: true)
                        
                       
                        
                        
                        
                        
                    }
                }
            }))
            self.present(alertController, animated: true, completion: nil)
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

extension SubmitLocationViewController:MKMapViewDelegate{
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
