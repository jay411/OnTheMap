//
//  UdacityConvenience.swift
//  OnTheMap
//
//  Created by jay raval on 8/12/17.
//  Copyright © 2017 jay raval. All rights reserved.
//

import Foundation

extension UdacityClient {

    
    // authenticate Udacity user
    func authenticateUdacityUser(email: String, password:String,  completionHandlerForAuthenticate: @escaping (_ success: Bool,_ data:AnyObject, _ error: String?) -> Void)  {
        // TBD
        // prep for Udacity taskForPostUdacity
        self.taskForPostUdacity(email, password: password){  success,data,error in
            
            if success{
                print("works")
                completionHandlerForAuthenticate(true,data!,nil)
            }
        }
    
    }
    func getUserData(_ userId:AnyObject)-> Void
    {
        self.taskForGetUdacity(userId) { success,data,error in
            if success{
                print("WORKS FROM HELPER")
            }
            
        }
        
    }

}
