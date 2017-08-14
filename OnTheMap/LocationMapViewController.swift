//
//  LocationMapViewController.swift
//  OnTheMap
//
//  Created by jay raval on 8/11/17.
//  Copyright © 2017 jay raval. All rights reserved.
//

import UIKit


class LocationMapViewController: UIViewController {
    let object = UIApplication.shared.delegate


    override func viewDidLoad() {
        super.viewDidLoad()
        self.getStudentLocations()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    private func getStudentLocations(){
        let request = NSMutableURLRequest(url: URL(string: "https://parse.udacity.com/parse/classes/StudentLocation")!)
        request.addValue("QrX47CA9cyuGewLdsL7o5Eb8iug6Em8ye0dnAbIr", forHTTPHeaderField: "X-Parse-Application-Id")
        request.addValue("QuWThTdiRmTux3YaDseUSEpUKo7aBYM737yKd4gY", forHTTPHeaderField: "X-Parse-REST-API-Key")
        let session = URLSession.shared
        let task = session.dataTask(with: request as URLRequest) { data, response, error in
            if error != nil { // Handle error...
                return
            }
            print(NSString(data: data!, encoding: String.Encoding.utf8.rawValue)!)
            var parsedResult: AnyObject? = nil
            do {
                parsedResult=try JSONSerialization.jsonObject(with: data!, options: .allowFragments) as AnyObject
                
            }catch{
                print("error")
                
            }
            guard let dictionaries = parsedResult?["results"] as! [NSDictionary]? else{
                return
            }
            for dictionary in dictionaries{
                print("\(dictionary["firstName"])")
            }
        }
        
        task.resume()
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
