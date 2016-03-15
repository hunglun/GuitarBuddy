//
//  Model.swift
//
//
//  Created by hunglun on 1/10/16.
//  Copyright © 2016 hunglun. All rights reserved.
//

import Foundation
import UIKit


class Soundcloud : NSObject {
    static var userId : String?
    static var code : String?
    static var accessToken: String?
    static var lastPracticeItemIndex : Int?  {
        didSet {
            saveUserAccessInfo()
        }
    }


    static var archiveFilePath : String {
        let manager = NSFileManager.defaultManager()
        let url = manager.URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask).first! as NSURL
        return url.URLByAppendingPathComponent("p5SoundcloudArchive").path!
    }
    
    override init() {
        super.init()
        Soundcloud.retrieveArchivedItems()
    }
    static func retrieveArchivedItems() {
        
        // if we can unarchive a dictionary, we will use it to set the map back to its
        // previous center and span
        if let dict = NSKeyedUnarchiver.unarchiveObjectWithFile(archiveFilePath) as? [String : AnyObject] {
            
            accessToken = dict["access_token"] as? String
            userId = dict["userId"] as? String
            lastPracticeItemIndex = dict["lastPracticeItemIndex"] as? Int
        }
    }
    static func saveUserAccessInfo() {
        
        // Place the "center" and "span" of the map into a dictionary
        // The "span" is the width and height of the map in degrees.
        // It represents the zoom level of the map.
        
        let dictionary = [
            "access_token" : accessToken ?? "",
            "userId" : userId ?? "",
            "lastPracticeItemIndex" :lastPracticeItemIndex ?? 0
        ]
        
        // Archive the dictionary into the filePath
        NSKeyedArchiver.archiveRootObject(dictionary, toFile: archiveFilePath)
    }

    static func authenticateCallbackHandler(success: Bool, errorString: String?)-> Void{
        if success {
            print("Authentication successful!")
        }else{
            if var topController = UIApplication.sharedApplication().keyWindow?.rootViewController {
                while let presentedViewController = topController.presentedViewController {
                    topController = presentedViewController
                }
                let alert = Soundcloud.warningAlertView(topController, messageString: errorString ?? "Authentication Fails")
                dispatch_async(dispatch_get_main_queue()) {
                    topController.presentViewController(alert, animated: true, completion: nil)
                }

                // topController should now be your topmost view controller
            }

            print(errorString)
        }
    }
    static func connect(){
        // connect
        var parameters = [String:String]()
        parameters["client_id"] = Soundcloud.Constants.clientId
        parameters["redirect_uri"] = "guitarbuddy://soundcloud/connectCallback"
        parameters["response_type"] = "code"
        parameters["display"] = "popup"
        parameters["state"] = ""
        parameters["scope"] = "non-expiring"
        
        let urlString = "https://soundcloud.com/connect" + self.escapedParameters(parameters)
        print (urlString)
        let url = NSURL(string: urlString)!
        UIApplication.sharedApplication().openURL(url)
        
        
    }
    static func authenticate(){
        
        var parameters = [String:String]()
        parameters["client_id"] = Soundcloud.Constants.clientId
        parameters["client_secret"] = Soundcloud.Constants.clientSecret
        parameters["redirect_uri"] = "guitarbuddy://soundcloud/connectCallback"
        parameters["grant_type"] = "authorization_code"
        parameters["code"] = Soundcloud.code!
        
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
                authenticateCallbackHandler(false,errorString: "Authentication Fails: Bad Connection")

                return
            }
            print(NSString(data: data!, encoding: NSUTF8StringEncoding))
            do {
                if let parsedResult = try NSJSONSerialization.JSONObjectWithData(data!, options: .AllowFragments) as? NSDictionary,
                    accessToken = parsedResult["access_token"] as? String{
                        Soundcloud.accessToken = accessToken
                        Soundcloud.getUserId(accessToken){_,_ in }
                }else{
                    print("Invalid JSON Object")
                }
            }catch {
                print("Error parsing JSON object")
            }

        }
        task.resume()
        
    }
    
    static func escapedParameters(parameters: [String : AnyObject]) -> String {
        
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

    static func upload(file : NSURL, title: String, controller : UIViewController){
        
        let accessToken = Soundcloud.accessToken
        let parameters = [Soundcloud.ParameterKeys.AccessToken: accessToken!]
        let mutableMethod : String = Soundcloud.Methods.Track
        print(file.path!)
        let jsonBody : [String:String] = [
            Soundcloud.JSONBodyKeys.Title: title,
            Soundcloud.JSONBodyKeys.Sharing: Soundcloud.JSONResponseKeys.Private
        ]
        let assetDataPaths = [file.path!]
        taskForPOSTMethodForFileUpload(mutableMethod, parameters: parameters, jsonBody: jsonBody, filePaths: assetDataPaths) { JSONResult, error in
            
            /* 3. Send the desired value(s) to completion handler */
            if let error = error {
                print("error upload")
                print(error)
                //              completionHandler(result: nil, error: error)
                dispatch_async(dispatch_get_main_queue()) {

                    let alert = Soundcloud.warningAlertView(controller, messageString: "Upload Fails")
                    dispatch_async(dispatch_get_main_queue()) {
                        controller.presentViewController(alert, animated: true, completion: nil)
                    }
                    
                }

            } else {
                print(JSONResult)
                print("success upload")
                if let _ = JSONResult[Soundcloud.JSONBodyKeys.TrackID] as? Int {
                    
                    dispatch_async(dispatch_get_main_queue()) {
                        
                        let alert = Soundcloud.warningAlertView(controller, messageString: "Upload Successful.")
                        dispatch_async(dispatch_get_main_queue()) {
                            controller.presentViewController(alert, animated: true, completion: nil)
                        }
                    }
                }else{
                
                    let alert = Soundcloud.warningAlertView(controller, messageString: "Upload Fails")
                    dispatch_async(dispatch_get_main_queue()) {
                        controller.presentViewController(alert, animated: true, completion: nil)
                    }

                }
           }
        }

        
    }

    static func getUserId(accessToken : String, completionHandler: (result: String?, error: NSError?) -> Void) {

        
        /* 1. Specify parameters, method (if has {key}), and HTTP body (if POST) */
        let parameters = [Soundcloud.ParameterKeys.AccessToken: accessToken]
        let mutableMethod : String = Soundcloud.Methods.UserProfile
        
        /* 2. Make the request */
        taskForGETMethod(mutableMethod, parameters: parameters) { JSONResult, error in
            
            /* 3. Send the desired value(s) to completion handler */
            if let error = error {
                completionHandler(result: nil, error: error)
            } else {
                
                if let result = JSONResult[JSONResponseKeys.UserID] as? Int {
                    Soundcloud.userId = "\(result)"
                    saveUserAccessInfo()
                    completionHandler(result: Soundcloud.userId, error: nil)
                } else {
                    completionHandler(result: nil, error: NSError(domain: "get tracks parsing", code: 0, userInfo: [NSLocalizedDescriptionKey: "Could not parse getTracks"]))
                }
            }
        }
        
    }
    static func getTracks(completionHandler: (result: [SCTrack]?, error: NSError?) -> Void) {
        
        userId = Soundcloud.userId //?? "4793009"
        accessToken = Soundcloud.accessToken //?? "1-182209-4793009-f9e477d058e6b69"
        if userId == "" || accessToken == "" {
            Soundcloud.connect()
            return
        }
        
        /* 1. Specify parameters, method (if has {key}), and HTTP body (if POST) */
        let parameters = [Soundcloud.ParameterKeys.AccessToken: accessToken!]
        var mutableMethod : String = Soundcloud.Methods.UserIdTracks
        mutableMethod = Soundcloud.subtituteKeyInMethod(mutableMethod, key: Soundcloud.URLKeys.UserID, value: String(userId!))!
        
        /* 2. Make the request */
        taskForGETMethod(mutableMethod, parameters: parameters) { JSONResult, error in
            
            /* 3. Send the desired value(s) to completion handler */
            if let error = error {
                completionHandler(result: nil, error: error)
            } else {
                
                if let results = JSONResult as? [[String : AnyObject]] {
                    
                    let tracks = SCTrack.tracksFromResults(results)
                    completionHandler(result: tracks, error: nil)
                } else {
                    completionHandler(result: nil, error: NSError(domain: "get tracks parsing", code: 0, userInfo: [NSLocalizedDescriptionKey: "Could not parse getTracks"]))
                }
            }
        }

    }
    /* Helper: Substitute the key for the value that is contained within the method name */
    static func subtituteKeyInMethod(method: String, key: String, value: String) -> String? {
        if method.rangeOfString("{\(key)}") != nil {
            return method.stringByReplacingOccurrencesOfString("{\(key)}", withString: value)
        } else {
            return nil
        }
    }


    static func warningAlertView(parent : UIViewController, messageString : String) -> UIAlertController{
        let alert = UIAlertController(title: "", message: messageString, preferredStyle: .Alert)
        let dismissAction = UIAlertAction(title: "Dismiss",
                                          style: .Cancel,
                                        handler: nil)
        alert.addAction(dismissAction)
        
        return alert
    }

    
    

}