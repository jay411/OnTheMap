//
//  ParseConvenience.swift
//  OnTheMap
//
//  Created by jay raval on 8/13/17.
//  Copyright © 2017 jay raval. All rights reserved.
//

import Foundation

import CoreLocation
extension ParseClient{
    
    func getAllLocations(_ latest:Bool,_ completionHandlerForGetAll: @escaping(_ success:Bool,_ data:AnyObject?, _ error:Error?)->Void){
        var queryItems=[String:AnyObject]()
        if latest == true{
            queryItems=[ParameterKeys.Order:"-updatedAt" as AnyObject,ParameterKeys.Limit:100 as AnyObject]
        }
        else{
            queryItems=[ParameterKeys.Limit:"100" as AnyObject]
        }
        self.taskForGettingAllLocations(queryItems){ success,data,error in
            if success{
                print("/n/n/n/nGot it")
                
                completionHandlerForGetAll(true,data,nil)
            }
            else{
                completionHandlerForGetAll(false,nil,error)
            }
            
            
        }
        
    }
    
    
    
    
    
    
    
    
    
    func getStudentLocation(_ completionHandlerForGet: @escaping(_ success:Bool,_ data:AnyObject?,_ error:Error?)->Void){
        var parameters=[String:AnyObject]()
        parameters=[ParseClient.ParameterKeys.Where:[ParseClient.RequestKeys.UniqueKey:UdacityClient.sharedInstance().userInfo.userID!] as AnyObject]
        self.taskForGettingALocation(parameters) { (success, data, error) in
            if success {
               
                guard let objectID=data?[ParseClient.ResponseKeys.ObjectId] else {
                    return completionHandlerForGet(true,nil,nil)
                    }
                

                completionHandlerForGet(true,data,nil)
            }
        }
    }
    func postStudentLocation(_ mapString:String,_ longitude:CLLocationDegrees,_ latitude:CLLocationDegrees,_ completionHandlerForPost:@escaping(_ success:Bool,_ data:AnyObject?,_ error:Error?)->Void)
    {
        var queryItems=[String:AnyObject]()
        "{\"uniqueKey\": \"1234\", \"firstName\": \"John\", \"lastName\": \"Doe\",\"mapString\": \"Mountain View, CA\", \"mediaURL\": \"https://udacity.com\",\"latitude\": 37.386052, \"longitude\": -122.083851}"
        queryItems=[ParseClient.RequestKeys.UniqueKey:UdacityClient.sharedInstance().userInfo.userID as AnyObject,ParseClient.RequestKeys.FirstName:UdacityClient.sharedInstance().userInfo.firstName as AnyObject, ParseClient.RequestKeys.LastName:UdacityClient.sharedInstance().userInfo.lastName as AnyObject,ParseClient.RequestKeys.MapString:mapString as AnyObject,ParseClient.RequestKeys.Longitude:longitude as AnyObject,ParseClient.RequestKeys.Latitude:latitude as AnyObject]
        
    }
}
