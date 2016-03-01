//
//  Convenience.swift
//  OnTheMap
//
//  Created by hunglun on 1/15/16.
//  Copyright © 2016 hunglun. All rights reserved.
//

import UIKit
import SystemConfiguration

let SoundcloudSecureBaseUrl = "https://api.soundcloud.com"
let clientId = "fdf75eddcd987c3e6beb9b3a47925633"
let clientSecret = "dfd72e17039500100a3b5bd0be3cb9b0"
/*
client_id	string	The client id belonging to your application
redirect_uri	string	The redirect uri you have configured for your application
response_type	enumeration	(code, token)
scope	string	'*'
display	string	Can specify a value of 'popup' for mobile optimized screen
state	string	Any value included here will be appended to the redirect URI
*/
extension Soundcloud {

    class func escapedParameters(parameters: [String : AnyObject]) -> String {
        
        var urlVars = [String]()
        
        for (key, value) in parameters {
            
            /* Make sure that it is a string value */
            let stringValue = "\(value)"
            
            /* Escape it */
            let escapedValue = stringValue.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLQueryAllowedCharacterSet())
            
            /* Append it */
            urlVars += [key + "=" + "\(escapedValue!)"]
            
        }
        
        return (!urlVars.isEmpty ? "?" : "") + urlVars.joinWithSeparator("&")
    }

    
    func httpGetUdacityUserInfo(userId : String , errorHandler: (errroString : String) -> Void,
        getUserInfoComplete : () -> Void ){
            let request = NSMutableURLRequest(URL: NSURL(string: "https://www.udacity.com/api/users/\(userId)")!)
            let session = NSURLSession.sharedSession()
            let task = session.dataTaskWithRequest(request) { data, response, error in
                if error != nil { // Handle error...
                    errorHandler(errroString: "Bad Connection")
                    return
                }
                let newData = data!.subdataWithRange(NSMakeRange(5, data!.length - 5))  /* subset response data! */
                do {
                    if let parsedResult = try NSJSONSerialization.JSONObjectWithData(newData, options: .AllowFragments) as? NSDictionary,
                        userInfo = parsedResult["user"] as? NSDictionary,
                        firstName = userInfo["first_name"] as? String,
                        lastName = userInfo["last_name"] as? String{
                            Soundcloud.sharedInstance().firstName = firstName
                            Soundcloud.sharedInstance().lastName = lastName
                            getUserInfoComplete()
                            
                    }else{
                        errorHandler(errroString: "Invalid JSON Object")
                    }
                }catch {
                    errorHandler(errroString: "Error parsing JSON object")
                }
            }
            task.resume()
    }

    
    func httpQueryStudent(controller : UIViewController, userId: String, errorString: String, completeHandler : (userExists : Bool, objectId : String?)-> Void){
        let urlString = "https://api.parse.com/1/classes/StudentLocation?where=%7B%22uniqueKey%22%3A%22\(userId)%22%7D"
        let url = NSURL(string: urlString)
        let request = NSMutableURLRequest(URL: url!)
        request.addValue("QrX47CA9cyuGewLdsL7o5Eb8iug6Em8ye0dnAbIr", forHTTPHeaderField: "X-Parse-Application-Id")
        request.addValue("QuWThTdiRmTux3YaDseUSEpUKo7aBYM737yKd4gY", forHTTPHeaderField: "X-Parse-REST-API-Key")
        let session = NSURLSession.sharedSession()
        let task = session.dataTaskWithRequest(request) { data, response, error in
            if error != nil { /* Handle error */
                let alert = Soundcloud.sharedInstance().warningAlertView(controller,messageString: errorString)
                dispatch_async(dispatch_get_main_queue()) {
                    controller.presentViewController(alert, animated: true, completion: nil)
                }
                return
            }
            
            do {
                if let parsedResult = try NSJSONSerialization.JSONObjectWithData(data!, options: .AllowFragments) as? NSDictionary,
                    objectId = parsedResult["results"]?[0]?["objectId"] as? String{
                        print("Updating...")
                        //self.update(objectId)
                        completeHandler(userExists: true, objectId: objectId)
                }else{
                    print("Posting...")
                    completeHandler(userExists: false, objectId: nil)
                }
            }catch{
                
                let alert = Soundcloud.sharedInstance().warningAlertView(controller,messageString: "Fail to parse JSON response from query")
                dispatch_async(dispatch_get_main_queue()) {
                    controller.presentViewController(alert, animated: true, completion: nil)
                }
            }
            
        }
        task.resume()
        
        
    }
    
    func httpPutStudentLocation(controller : UIViewController,objectId : String,requestBody: String, errorString: String,
                                submitComplete : () -> Void){
        
        let urlString = "https://api.parse.com/1/classes/StudentLocation/\(objectId)"
        let url = NSURL(string: urlString)
        let request = NSMutableURLRequest(URL: url!)
        request.HTTPMethod = "PUT"
        request.addValue("QrX47CA9cyuGewLdsL7o5Eb8iug6Em8ye0dnAbIr", forHTTPHeaderField: "X-Parse-Application-Id")
        request.addValue("QuWThTdiRmTux3YaDseUSEpUKo7aBYM737yKd4gY", forHTTPHeaderField: "X-Parse-REST-API-Key")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.HTTPBody = requestBody.dataUsingEncoding(NSUTF8StringEncoding)
        let session = NSURLSession.sharedSession()
        let task = session.dataTaskWithRequest(request) { data, response, error in
            if error != nil {
                let alert = Soundcloud.sharedInstance().warningAlertView(controller,messageString: errorString)
                dispatch_async(dispatch_get_main_queue()) {
                    controller.presentViewController(alert, animated: true, completion: nil)
                }
            }else{
                submitComplete()
            }
            
        }
        task.resume()

    
    }
    
    func httpPostStudentLocation(controller : UIViewController,requestBody : String, errorString : String,
                  submitComplete : ()-> Void){
        
        let request = NSMutableURLRequest(URL: NSURL(string: "https://api.parse.com/1/classes/StudentLocation")!)
        request.HTTPMethod = "POST"
        request.addValue("QrX47CA9cyuGewLdsL7o5Eb8iug6Em8ye0dnAbIr", forHTTPHeaderField: "X-Parse-Application-Id")
        request.addValue("QuWThTdiRmTux3YaDseUSEpUKo7aBYM737yKd4gY", forHTTPHeaderField: "X-Parse-REST-API-Key")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.HTTPBody = requestBody.dataUsingEncoding(NSUTF8StringEncoding)
        let session = NSURLSession.sharedSession()
        let task = session.dataTaskWithRequest(request) { data, response, error in
            if error != nil { // Handle error…
                let alert = Soundcloud.sharedInstance().warningAlertView(controller,messageString: errorString)
                dispatch_async(dispatch_get_main_queue()) {
                    controller.presentViewController(alert, animated: true, completion: nil)
                }
                
            }else{
                submitComplete()
            }
            
        }
        task.resume()


    }
    
    
    func isNetworkAvailable() -> Bool    {
        var flags:SCNetworkReachabilityFlags = .TransientConnection
        let  address: SCNetworkReachabilityRef
        address = SCNetworkReachabilityCreateWithName( nil,"www.apple.com" )!
        let success = SCNetworkReachabilityGetFlags(address, &flags)
        
        let canReach = success && ((flags.rawValue & SCNetworkReachabilityFlags.Reachable.rawValue) != 0)
        
        return canReach;
    }
    class func authenticateCallbackHandler(success: Bool, errorString: String?)-> Void{
        if success {
            print("Authentication successful!")
        }else{
            print(errorString)
        }
    }
    class func connect(){
        // connect
        var parameters = [String:String]()
        parameters["client_id"] = clientId
        parameters["redirect_uri"] = "guitarbuddy://soundcloud/connectCallback"
        parameters["response_type"] = "code"
        parameters["display"] = "popup"
        parameters["state"] = ""
        parameters["scope"] = "non-expiring"
        
        let urlString = "https://soundcloud.com/connect" + Soundcloud.escapedParameters(parameters)
        print (urlString)
        let url = NSURL(string: urlString)!
        UIApplication.sharedApplication().openURL(url)
        
        
    }
    class func authenticate(){

            var parameters = [String:String]()
            parameters["client_id"] = clientId
            parameters["client_secret"] = clientSecret
            parameters["redirect_uri"] = "guitarbuddy://soundcloud/connectCallback"
            parameters["grant_type"] = "authorization_code"
            parameters["code"] = Soundcloud.sharedInstance().code

            let urlString = "https://api.soundcloud.com/oauth2/token"
            print(urlString)
            let request = NSMutableURLRequest(URL: NSURL(string: urlString)!)

            var post: String = escapedParameters(parameters)
            // Remark : THIS STEP IS THE KEY, drop the ? character.
            post = String(post.characters.dropFirst())
            let postData: NSData = post.dataUsingEncoding(NSASCIIStringEncoding, allowLossyConversion: true)!
//            let postLength: String = "\(postData.length)"
//            request.setValue(postLength, forHTTPHeaderField: "Content-Length")
            request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
            request.addValue("application/json", forHTTPHeaderField: "Accept")
            request.HTTPMethod = "POST"
            request.HTTPBody = postData
//            print(post)
//            print(request)
            let session = NSURLSession.sharedSession()
            let task = session.dataTaskWithRequest(request) { data, response, error in
                if error != nil { // Handle error…
                    authenticateCallbackHandler(false,errorString: "Bad Connection")
                    return
                }
//                print(response)
//                print(error)
                
                var newData = data!.subdataWithRange(NSMakeRange(0, data!.length)) /* subset response data! */
                print(NSString(data: newData, encoding: NSUTF8StringEncoding))

            }
            task.resume()

        }
    
    func logout(controller: UIViewController){
    
        let request = NSMutableURLRequest(URL: NSURL(string: "https://www.udacity.com/api/session")!)
        request.HTTPMethod = "DELETE"
        var xsrfCookie: NSHTTPCookie? = nil
        let sharedCookieStorage = NSHTTPCookieStorage.sharedHTTPCookieStorage()
        for cookie in sharedCookieStorage.cookies! {
            if cookie.name == "XSRF-TOKEN" { xsrfCookie = cookie }
        }
        if let xsrfCookie = xsrfCookie {
            request.setValue(xsrfCookie.value, forHTTPHeaderField: "X-XSRF-TOKEN")
        }
        let session = NSURLSession.sharedSession()
        let task = session.dataTaskWithRequest(request) { data, response, error in
            if error != nil { // Handle error…
                return
            }
            let newData = data!.subdataWithRange(NSMakeRange(5, data!.length - 5)) /* subset response data! */
            print(NSString(data: newData, encoding: NSUTF8StringEncoding))
            
            controller.dismissViewControllerAnimated(true, completion: nil)
        }
        task.resume()

    }


}
