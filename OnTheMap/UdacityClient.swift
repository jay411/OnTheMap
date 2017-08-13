//
//  UdacityClient.swift
//  OnTheMap
//
//  Created by jay raval on 8/10/17.
//  Copyright © 2017 jay raval. All rights reserved.
//

import Foundation

class UdacityClient{
    
    var session = URLSession.shared
    
    
    class func sharedInstance() -> UdacityClient {
        struct Singleton {
            static var sharedInstance = UdacityClient()
        }
        return Singleton.sharedInstance
    }
    
    
    
    func taskForPostUdacity(_ username:String,password:String,completionHandlerForPost: @escaping (_ success:Bool, _ data: AnyObject?,_ error:Error?)->Void)  {
        let request = NSMutableURLRequest(url: URL(string: UdacityURL.baseURL+UdacityMethods.session)!)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = "{\"udacity\": {\"username\": \"\(username)\", \"password\": \"\(password)\"}}".data(using: String.Encoding.utf8)
        let session = URLSession.shared
//        print("the request \(request)")
        let task = session.dataTask(with: request as URLRequest) { data, response, error in
            if error != nil { // Handle error…
                completionHandlerForPost(false,nil,error!)
            }
            else{
                
                func sendError(error: String) {
                    print(error)
                    let userInfo = [NSLocalizedDescriptionKey: error]
                    completionHandlerForPost(false,nil, NSError(domain: "taskForPostUdacity", code: 1, userInfo: userInfo))
                }
//                guard let statusCode = (response as? HTTPURLResponse)?.statusCode, statusCode >= 200 && statusCode <= 299 else {
//                    sendError(error: "Your request returned \(String(describing: (response as? HTTPURLResponse)?.statusCode))!")
//                    return
//                }

                
            let range = Range(5..<data!.count)
            let newData = data?.subdata(in: range) /* subset response data! */
            print(NSString(data: newData!, encoding: String.Encoding.utf8.rawValue)!)
            var parsedResult: AnyObject! = nil
            do {
                parsedResult = try JSONSerialization.jsonObject(with: newData!, options: .allowFragments) as AnyObject
                
            }catch{
                print("Error")
                
            }
            guard let accountData = parsedResult[UdacityResponse.account] as AnyObject! else{
                print("Error")
                return
            }
            guard let userID=accountData[UdacityResponse.userId] as AnyObject! else {
                    print("error")
                    sendError(error: "could not get userID")
                    return
                    
                }
                completionHandlerForPost(true,userID,nil)
//                print("\(userID)")
            }
            //            print("\(accountData["key"])")
//            self.getUserData(accountData["key"] as AnyObject)
            
            
            //            self.getUserData()
        }
        task.resume()
    }
    
    
    func taskForGetUdacity(_ userID:AnyObject,completionHandlerForGet: @escaping (_ success:Bool,_ data:AnyObject?,_ error:Error?)->Void){
        let request = NSMutableURLRequest(url: URL(string: "https://www.udacity.com/api/users/\(userID)")!)
        let session = URLSession.shared
        let task = session.dataTask(with: request as URLRequest) { data, response, error in
            if error != nil { // Handle error...
                return
            }
            let range = Range(5..<data!.count)
            let newData = data?.subdata(in: range) /* subset response data! */
//            print(NSString(data: newData!, encoding: String.Encoding.utf8.rawValue)!)
            completionHandlerForGet(true,newData as AnyObject,nil)
        }
        task.resume()
        
        
    }
    
    
}

