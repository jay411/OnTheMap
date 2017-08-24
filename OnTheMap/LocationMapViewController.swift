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


    @IBOutlet weak var studentsMapView: MKMapView!
    var annotations = [MKPointAnnotation]()


    override func viewDidLoad() {
        super.viewDidLoad()
        studentsMapView.delegate=self

//        self.studentArray = ParseClient.sharedInstance().allStudents
//        self.createAnnotations()
        print("map view loaded")
        ParseClient.sharedInstance().getAllLocations({ (success, error) in
            guard error == nil else{
                self.displayAlert("error loading data", "\(error!.localizedDescription)")
                return
                
            }
            if success{
                print("worked in maps")
                //                                print("student array: \(data)")
                
                performUIUpdatesOnMain {
                    //                    self.studentsMapView.reloadData()
                    self.createAnnotations()
                    
                }
                
            }
            
        })
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func viewWillAppear(_ animated: Bool) {
        print("map view will appear called")
        super.viewWillAppear(animated)
//        ParseClient.sharedInstance().getAllLocations(false, { (success, error) in
//            guard error == nil else{
//                    self.displayAlert("error loading data", "\(error!.localizedDescription)")
//                return
//                
//            }
//            if success{
//                print("worked in maps")
//                //                                print("student array: \(data)")
//
//                performUIUpdatesOnMain {
//                    //                    self.studentsMapView.reloadData()
//                    self.createAnnotations()
//                    
//                }
//                
//            }
//            
//        })

        
    }
    private func createAnnotations(){
        
        // We will create an MKPointAnnotation for each dictionary in "locations". The
        // point annotations will be stored in this array, and then provided to the map view.
        
        // The "locations" array is loaded with the sample data below. We are using the dictionaries
        // to create map annotations. This would be more stylish if the dictionaries were being
        // used to create custom structs. Perhaps StudentLocation structs.
        self.annotations.removeAll()
        for student in Students.sharedInstance().studentArray {
            
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
            self.annotations.append(annotation)
        }
        print("number of annotations: \(self.annotations.count)")

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
    func refresh(){
        ParseClient.sharedInstance().didRefresh=true
        ParseClient.sharedInstance().getAllLocations({ (success, error) in
            guard error == nil else{
                self.displayAlert("error reloading data", "\(error!.localizedDescription)")
                return
                
            }
            if success{
                print("worked in maps")
                //                                print("student array: \(data)")
            
                performUIUpdatesOnMain {
                    self.studentsMapView.removeAnnotations(self.annotations)
        
                    
                    //                    self.studentsMapView.reloadData()
                    self.createAnnotations()
                    
                }
                
            }
            
        })
        
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
