//
//  UserData.swift
//  OnTheMap
//
//  Created by jay raval on 8/13/17.
//  Copyright © 2017 jay raval. All rights reserved.
//

import Foundation


struct UserInfo {
    var firstName: String?
    var lastName: String?
    var userID: String?
    var longitude: String?
    var latitue: String?
    var objectID: String?
    
}

class UserData{
    var userData=UserInfo()
    class func sharedInstance() -> UserData {
        struct Singleton {
            static var sharedInstance = UserData()
        }
        return Singleton.sharedInstance
    }
}
