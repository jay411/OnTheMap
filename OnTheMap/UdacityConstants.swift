//
//  UdacityConstants.swift
//  OnTheMap
//
//  Created by jay raval on 8/10/17.
//  Copyright © 2017 jay raval. All rights reserved.
//

import Foundation

extension UdacityClient{
    
    struct UdacityURL{
        static let baseURL: String="https://www.udacity.com/api"
        
    }
    
    struct UdacityMethods{
        static let session = "/session"
        static let user =  "/users"
    }
    struct UdacityRequestJSON{
        var requestJSON: [String:AnyObject]?
        static let username="username"
        static let password="password"
        
    }
    
    struct UdacityResponse {
        static let account="account"
        static let registered="registered"
        static let userId="key"
        static let session="sessions"
        static let sessionID="id"
        static let expiration="expiration"
    }
    
}
