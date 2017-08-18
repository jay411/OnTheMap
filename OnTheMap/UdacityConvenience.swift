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
    func authenticateUdacityUser(email: String, password:String,  completionHandlerForAuthenticate: @escaping (_ success: Bool, _ error: String?) -> Void)  {
        // TBD
        // prep for Udacity taskForPostUdacity
        self.taskForPostUdacity(email, password: password){  success,data,error in
            guard error == nil else {
                completionHandlerForAuthenticate(false,error?.localizedDescription)
                return
            }
            if success{
                print("works")
                completionHandlerForAuthenticate(true,nil)
            }
            
        }
    
    }
    func getUserData(_ completionHandlerForUserData: @escaping(_ success:Bool,_ error:Error?)->Void )
    {
        self.taskForGetUdacity(self.userInfo.userID as AnyObject) { success,data,error in
            if success{
                print("WORKS FROM HELPER")
                print("\n\n\n\n\(data)")
                completionHandlerForUserData(true,nil)
            }
            else{
                completionHandlerForUserData(false,error)
            }
            
        }
        
    }
    func logout(_ completionHandlerForLogout: @escaping(_ success:Bool)->Void){
        self.taskForDeletingUdacitySession { (success, data, error) in
            guard error == nil else {
                return completionHandlerForLogout(false)
            }
            if success{
                return completionHandlerForLogout(true)
            }
        }
    }

}
