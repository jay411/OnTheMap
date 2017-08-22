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
        parameters=[ParseClient.ParameterKeys.Where:[ParseClient.RequestKeys.UniqueKey:UserData.sharedInstance().userData.userID!] as AnyObject]
        self.taskForGettingALocation(parameters) { (success, data, error) in
            guard error == nil else{
                return completionHandlerForGet(false,nil,error)
            }
            if success {
               
                guard data?[ParseClient.ResponseKeys.ObjectID] != nil else {
                    print("no object id")
                    return completionHandlerForGet(true,nil,nil)
                    }
                print("\(data?[ParseClient.ResponseKeys.ObjectID])")
                self.objectID=data?[ParseClient.ResponseKeys.ObjectID] as! String
                print("object id for client\(self.objectID)")
                completionHandlerForGet(true,data,nil)
            }
        }
    }
    
    
    func postStudentLocation(_ mapString:String,_ longitude:CLLocationDegrees,_ latitude:CLLocationDegrees,_ url:String?,_ completionHandlerForPost:@escaping(_ success:Bool,_ data:AnyObject?,_ error:Error?)->Void)
    {
        var queryItems=[String:AnyObject]()
//        "{\"uniqueKey\": \"1234\", \"firstName\": \"John\", \"lastName\": \"Doe\",\"mapString\": \"Mountain View, CA\", \"mediaURL\": \"https://udacity.com\",\"latitude\": 37.386052, \"longitude\": -122.083851}"
//        print("userID:\(UserData.sharedInstance().userData.userID)")
//        print("\(UserData.sharedInstance().userData.firstName)")
        queryItems=[ParseClient.RequestKeys.UniqueKey:UserData.sharedInstance().userData.userID as AnyObject,ParseClient.RequestKeys.FirstName:UserData.sharedInstance().userData.firstName as AnyObject, ParseClient.RequestKeys.LastName:UserData.sharedInstance().userData.lastName as AnyObject,ParseClient.RequestKeys.MapString:mapString as AnyObject,ParseClient.RequestKeys.Longitude:longitude as AnyObject,ParseClient.RequestKeys.Latitude:latitude as AnyObject,ParseClient.RequestKeys.MediaURL:url as AnyObject]
        print("\(queryItems)")
        self.taskForPostToParse(queryItems) { (success, data, error) in
            guard error == nil else {
                return completionHandlerForPost(false, nil, error)
            }
            if success{
                completionHandlerForPost(true,data,nil)
            }
        }
        
    }
    func putStudentLocation(_ mapString:String,_ longitude:CLLocationDegrees,_ latitude:CLLocationDegrees,_ url:String?,_ completionHandlerForPut:@escaping(_ success:Bool,_ error:Error?)->Void)
    {
        var queryItems=[String:AnyObject]()

        queryItems=[ParseClient.RequestKeys.UniqueKey:UserData.sharedInstance().userData.userID as AnyObject,ParseClient.RequestKeys.FirstName:UserData.sharedInstance().userData.firstName as AnyObject, ParseClient.RequestKeys.LastName:UserData.sharedInstance().userData.lastName as AnyObject,ParseClient.RequestKeys.MapString:mapString as AnyObject,ParseClient.RequestKeys.Longitude:longitude as AnyObject,ParseClient.RequestKeys.Latitude:latitude as AnyObject,ParseClient.RequestKeys.MediaURL:url as AnyObject]

        self.taskForPut(queryItems) { (success, error) in
            guard error == nil else{
                completionHandlerForPut(false, error)
                return
            }
            if success{
                print("put success")
                return completionHandlerForPut(true,nil)
            }
        }
    }
}
