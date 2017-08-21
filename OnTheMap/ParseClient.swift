//
//  ParseClient.swift
//  OnTheMap
//
//  Created by jay raval on 8/13/17.
//  Copyright © 2017 jay raval. All rights reserved.
//

import Foundation
import CoreLocation

class ParseClient{
    
    var allStudents=[StudentInfo]()
    var objectID:String?
    
    func taskForGettingAllLocations(_ parameters:[String:AnyObject], _ completionHandlerForAllLocations: @escaping(_ success:Bool,_ data:AnyObject?,_ error:Error?)->Void){
        
           let urlParameters=parameters
           let request = NSMutableURLRequest(url: parseURLFromParameters(urlParameters, withPathExtension: ParseClient.Methods.method))
            allStudents = []
    
        
       
        request.addValue("QrX47CA9cyuGewLdsL7o5Eb8iug6Em8ye0dnAbIr", forHTTPHeaderField: "X-Parse-Application-Id")
            request.addValue("QuWThTdiRmTux3YaDseUSEpUKo7aBYM737yKd4gY", forHTTPHeaderField: "X-Parse-REST-API-Key")
            let session = URLSession.shared
            let task = session.dataTask(with: request as URLRequest) { data, response, error in
            if error != nil { // Handle error...
                return
            }
//            print(NSString(data: data!, encoding: String.Encoding.utf8.rawValue)!)
                var parsedResult: AnyObject! = nil
                do {
                    parsedResult = try JSONSerialization.jsonObject(with: data!, options: .allowFragments) as AnyObject
                    
                }catch{
                    print("Error")
                    
                }
                guard let replyDictionary = parsedResult[ParseClient.ResponseKeys.Results] as? [[String:AnyObject]] else{
                    print("couldnt create response dictionary")
                    return
                }
                for item in replyDictionary {
//                    print("\n item:\(item)")
                    let student=StudentInfo(firstName: item[ParseClient.ResponseKeys.FirstName] as? String, lastName: item[ParseClient.ResponseKeys.LastName] as? String, longitude: item[ParseClient.ResponseKeys.Longitude] as? CLLocationDegrees, latitude: item[ParseClient.ResponseKeys.Latitude] as? CLLocationDegrees, mediaURL: item[ParseClient.ResponseKeys.MediaURL] as? String, location: item[ParseClient.ResponseKeys.MapString] as? String,objectID: item[ParseClient.ResponseKeys.ObjectId] as! String)
                    self.allStudents.append(student)
                }
                completionHandlerForAllLocations(true, self.allStudents as AnyObject, nil)
                
        }
        task.resume()
    }
    
    
    
    
    
    
    
    
//MARK: Getting a students location
    
    func taskForGettingALocation(_ parameters:[String:AnyObject],_ completionHandlerForALocation: @escaping(_ success:Bool,_ data:AnyObject?, _ error:Error?)->Void){
        
        let urlParameters=parameters
//        let request = NSMutableURLRequest(url: parseURLFromParameters(urlParameters, withPathExtension: ParseClient.Methods.method))
        
        let request=NSMutableURLRequest(url: URL(string: "https://parse.udacity.com/parse/classes/StudentLocation?where=%7B%22uniqueKey%22%3A%22\(UserData.sharedInstance().userData.userID!)%22%7D&order=-updatedAt")!)
//        let request=NSMutableURLRequest(url: URL(string: "https://parse.udacity.com/parse/classes/StudentLocation?where=%7B%22uniqueKey%22%3A%221234%22%7D")!)
//        https://parse.udacity.com/parse/classes/StudentLocation?where=%7B%22uniqueKey%22%3A%221234%22%7D
        print(request)
        
        request.addValue("QrX47CA9cyuGewLdsL7o5Eb8iug6Em8ye0dnAbIr", forHTTPHeaderField: "X-Parse-Application-Id")
        request.addValue("QuWThTdiRmTux3YaDseUSEpUKo7aBYM737yKd4gY", forHTTPHeaderField: "X-Parse-REST-API-Key")
        let session = URLSession.shared
        let task = session.dataTask(with: request as URLRequest) { data, response, error in
            if error != nil { // Handle error...
                return completionHandlerForALocation(false, nil, error)
            }
            //            print(NSString(data: data!, encoding: String.Encoding.utf8.rawValue)!)
            var parsedResult: AnyObject! = nil
            do {
                parsedResult = try JSONSerialization.jsonObject(with: data!, options: .allowFragments) as AnyObject
                
            }catch{
                print("Error")
                
            }

            guard let replyDictionary = parsedResult[ParseClient.ResponseKeys.Results] as? [[String:AnyObject]] else{
                print("couldnt create response dictionary")
                return
            }
            if replyDictionary.count == 0 {
                return completionHandlerForALocation(true, nil, nil)

            }
            let item = replyDictionary[0]
            
            UserData.sharedInstance().userData.objectID=item[ParseClient.ResponseKeys.ObjectID] as! String

            
            
            completionHandlerForALocation(true, replyDictionary[0] as AnyObject, nil)
        
    }
        task.resume()
    }
    
    func taskForPostToParse(_ parameters:[String:AnyObject],_ completionHandlerForPost:@escaping(_ success:Bool,_ data:AnyObject?,_ error:Error?)->Void){
       
        let request = NSMutableURLRequest(url: URL(string: "https://parse.udacity.com/parse/classes/StudentLocation")!)

        request.httpMethod = "POST"
        request.addValue("QrX47CA9cyuGewLdsL7o5Eb8iug6Em8ye0dnAbIr", forHTTPHeaderField: "X-Parse-Application-Id")
        request.addValue("QuWThTdiRmTux3YaDseUSEpUKo7aBYM737yKd4gY", forHTTPHeaderField: "X-Parse-REST-API-Key")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        request.httpBody = "{\"uniqueKey\": \"\(parameters[ParseClient.RequestKeys.UniqueKey]!)\", \"firstName\": \"\(parameters[ParseClient.RequestKeys.FirstName] ?? "First Name" as AnyObject)\", \"lastName\": \"\(parameters[ParseClient.RequestKeys.LastName] ?? "LastName" as AnyObject)\",\"mapString\": \"\(parameters[ParseClient.RequestKeys.MapString] ?? "Mountain View" as AnyObject)\", \"mediaURL\": \"\(parameters[ParseClient.RequestKeys.MediaURL] ?? "udacity.com" as AnyObject)\",\"latitude\": \(parameters[ParseClient.RequestKeys.Latitude] ?? 0.0 as AnyObject), \"longitude\": \(parameters[ParseClient.ResponseKeys.Longitude] ?? 0.0 as AnyObject)}".data(using: String.Encoding.utf8)
        let session = URLSession.shared
        let task = session.dataTask(with: request as URLRequest) { data, response, error in
            if error != nil { // Handle error...
                return
            }
            //            print(NSString(data: data!, encoding: String.Encoding.utf8.rawValue)!)
            var parsedResult: AnyObject! = nil
            do {
                parsedResult = try JSONSerialization.jsonObject(with: data!, options: .allowFragments) as AnyObject
                
            }catch{
                print("Error")
                
            }
            guard let objectID = parsedResult[ParseClient.ResponseKeys.ObjectId] else{
                print("could not post and retrive object ID")
                return
            }
            print("Object ID after posting: \(String(describing: objectID))")
            UserData.sharedInstance().userData.objectID=objectID as? String
            completionHandlerForPost(true, objectID as AnyObject,nil)
        }
        task.resume()

        
    }
    
    
    func taskForPut(_ parameters:[String:AnyObject],_ completionHandlerForPut:@escaping(_ success:Bool,_ error:Error?)->Void){
        let urlString = "https://parse.udacity.com/parse/classes/StudentLocation/\(UserData.sharedInstance().userData.objectID!)"
        let url = URL(string: urlString)
        let request = NSMutableURLRequest(url: url!)
        request.httpMethod = "PUT"
        request.addValue("QrX47CA9cyuGewLdsL7o5Eb8iug6Em8ye0dnAbIr", forHTTPHeaderField: "X-Parse-Application-Id")
        request.addValue("QuWThTdiRmTux3YaDseUSEpUKo7aBYM737yKd4gY", forHTTPHeaderField: "X-Parse-REST-API-Key")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = "{\"uniqueKey\": \"\(parameters[ParseClient.RequestKeys.UniqueKey]!)\", \"firstName\": \"\(parameters[ParseClient.RequestKeys.FirstName] ?? "First Name" as AnyObject)\", \"lastName\": \"\(parameters[ParseClient.RequestKeys.LastName] ?? "LastName" as AnyObject)\",\"mapString\": \"\(parameters[ParseClient.RequestKeys.MapString] ?? "Mountain View" as AnyObject)\", \"mediaURL\": \"\(parameters[ParseClient.RequestKeys.MediaURL] ?? "udacity.com" as AnyObject)\",\"latitude\": \(parameters[ParseClient.RequestKeys.Latitude] ?? 0.0 as AnyObject), \"longitude\": \(parameters[ParseClient.ResponseKeys.Longitude] ?? 0.0 as AnyObject)}".data(using: String.Encoding.utf8)

        let session = URLSession.shared
        let task = session.dataTask(with: request as URLRequest) { data, response, error in
            if error != nil { // Handle error…
                return completionHandlerForPut(false,error)r
            }
            var parsedResult: AnyObject! = nil
            do {
                parsedResult = try JSONSerialization.jsonObject(with: data!, options: .allowFragments) as AnyObject
                
            }catch{
                print("Error")
                return completionHandlerForPut(false, error)
                
            }
            
            completionHandlerForPut(true, nil)
        }
        task.resume()
        
    }
    
private func parseURLFromParameters(_ parameters: [String:AnyObject], withPathExtension: String? = nil) -> URL {
    
    var components = URLComponents()
    components.scheme = ParseClient.Constants.ApiScheme
    components.host = ParseClient.Constants.ApiHost
    components.path = ParseClient.Constants.ApiPath + (withPathExtension ?? "")
    components.queryItems = [URLQueryItem]()
    
    for (key, value) in parameters {
        
        let queryItem = URLQueryItem(name: key, value: "\(value)")
        components.queryItems!.append(queryItem)
    }
    print("\nthe url : \(components.url!)\n")
    return components.url!
}
    
    class func sharedInstance() -> ParseClient {
        struct Singleton {
            static var sharedInstance = ParseClient()
        }
        return Singleton.sharedInstance
    }
}
