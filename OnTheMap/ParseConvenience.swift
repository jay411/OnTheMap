//
//  ParseConvenience.swift
//  OnTheMap
//
//  Created by jay raval on 8/13/17.
//  Copyright © 2017 jay raval. All rights reserved.
//

import Foundation


extension ParseClient{
    func getAllLocations(_ latest:Bool,_ completionHandlerForGetAll: @escaping(_ success:Bool,_ error:Error?)->Void){
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
                completionHandlerForGetAll(true,nil)
            }
            else{
                completionHandlerForGetAll(false,error)
            }
            
            
        }
        
    }
}
