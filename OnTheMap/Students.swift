//
//  Students.swift
//  OnTheMap
//
//  Created by jay raval on 8/13/17.
//  Copyright © 2017 jay raval. All rights reserved.
//

import Foundation
import CoreLocation

struct StudentInfo{
    var firstName:String?
    var lastName:String?
    var longitude:CLLocationDegrees?
    var latitude:CLLocationDegrees?
    var mediaURL:String?
    var location:String?
    var objectID:String?
    init(value:[String:AnyObject]){
        
        firstName = value[ParseClient.ResponseKeys.FirstName] as? String
        lastName = value[ParseClient.ResponseKeys.LastName] as? String
        mediaURL = value[ParseClient.ResponseKeys.MediaURL] as? String
        latitude = value[ParseClient.ResponseKeys.Latitude] as? CLLocationDegrees
        longitude = value[ParseClient.ResponseKeys.Longitude] as? CLLocationDegrees
        objectID = value[ParseClient.ResponseKeys.ObjectId] as? String
        location = value[ParseClient.ResponseKeys.MapString] as? String
        
        
    }
}

class Students{
    var studentArray=[StudentInfo]()
    class func sharedInstance() -> Students {
        struct Singleton {
            static var sharedInstance = Students()
        }
        return Singleton.sharedInstance
}
}


//firstName: item[ParseClient.ResponseKeys.FirstName] as? String, lastName: item[ParseClient.ResponseKeys.LastName] as? String, longitude: item[ParseClient.ResponseKeys.Longitude] as? CLLocationDegrees, latitude: item[ParseClient.ResponseKeys.Latitude] as? CLLocationDegrees, mediaURL: item[ParseClient.ResponseKeys.MediaURL] as? String, location: item[ParseClient.ResponseKeys.MapString] as? String,objectID: item[ParseClient.ResponseKeys.ObjectId] as! String)



