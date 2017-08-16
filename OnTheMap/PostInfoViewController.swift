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
        self.forwardGecode()
        
        self.mapView.isHidden=false
        
        self.mapView.showAnnotations(self.mapView.annotations, animated: true)

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


extension PostInfoViewController:MKMapViewDelegate{
    /*geocoding and mapview updates*/
    
    func forwardGecode(){
        geocoder.geocodeAddressString("Mountain View,CA") { (placemarks, error) in
            if (error != nil) {
                print("Didnt work")
                return
            }
            if let placemarksArray=placemarks, placemarksArray.count > 0{
                self.location=placemarksArray.first?.location
            }
            let coordinate=self.location?.coordinate
            let mapannotation = MKPointAnnotation()
            mapannotation.coordinate = coordinate!
            self.mapView.addAnnotation(mapannotation)
            self.mapView.setRegion(MKCoordinateRegion(center: (self.location?.coordinate)!,span: MKCoordinateSpan(latitudeDelta: 0.5,longitudeDelta: 0.5)), animated: true)

        }

        
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
  
    
}


