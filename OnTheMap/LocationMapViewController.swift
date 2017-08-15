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
    var studentArray=[StudentData]()


    @IBOutlet weak var studentsMapView: MKMapView!

    override func viewDidLoad() {
        super.viewDidLoad()
        let appDelegate = object as! AppDelegate
        
        self.studentArray = appDelegate.studentsArray as! [StudentData]
        self.createAnnotations()
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
            let lat = student.latitude
            let long = student.longitude
            
            // The lat and long are used to create a CLLocationCoordinates2D instance.
            let coordinate = CLLocationCoordinate2D(latitude: lat!, longitude: long!)
            
            let first = student.firstName
            let last = student.lastName
           
            
            
            // Here we create the annotation and set its coordiate, title, and subtitle properties
            let annotation = MKPointAnnotation()
            annotation.coordinate = coordinate
            annotation.title = "\(first) \(last)"
            if let mediaURL = student.mediaURL             {
                annotation.subtitle = mediaURL as! String

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
            pinView!.pinColor = .red
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
  

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
