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
    var firstName : String!
    var lastName : String!
    var userId : String?
    var code : String?
    var accessToken : String?
    let SoundcloudSecureBaseUrl = "https://api.soundcloud.com"
    let clientId = "fdf75eddcd987c3e6beb9b3a47925633"
    let clientSecret = "dfd72e17039500100a3b5bd0be3cb9b0"

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
        parameters["client_id"] = Soundcloud.sharedInstance().clientId
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
        parameters["client_id"] = Soundcloud.sharedInstance().clientId
        parameters["client_secret"] = Soundcloud.sharedInstance().clientSecret
        parameters["redirect_uri"] = "guitarbuddy://soundcloud/connectCallback"
        parameters["grant_type"] = "authorization_code"
        parameters["code"] = Soundcloud.sharedInstance().code!
        
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
            print(NSString(data: data!, encoding: NSUTF8StringEncoding))
            do {
                if let parsedResult = try NSJSONSerialization.JSONObjectWithData(data!, options: .AllowFragments) as? NSDictionary,
                    accessToken = parsedResult["access_token"] as? String{
                        Soundcloud.sharedInstance().accessToken = accessToken
                        Soundcloud.sharedInstance().getUserId(accessToken){_,_ in }
                }else{
                    print("Invalid JSON Object")
                }
            }catch {
                print("Error parsing JSON object")
            }

        }
        task.resume()
        
    }
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

    func upload(file : NSURL, title: String){
        /*
        import soundcloud
        
        # create a client object with access token
        client = soundcloud.Client(access_token='YOUR_ACCESS_TOKEN')
        
        # upload audio file
        track = client.post('/tracks', track={
        'title': 'This is my sound',
        'asset_data': open('file.mp3', 'rb')
        })
        
        # print track link
        print track.permalink_url
        */
        let accessToken = Soundcloud.sharedInstance().accessToken
/*
        track = client.post('/tracks', track={
            'title': 'This is a sample track',
            'sharing': 'private',
            'asset_data': open('5littlemonkeys.mp3', 'rb')
            })
*/
        let parameters = [Soundcloud.ParameterKeys.AccessToken: accessToken!]
        let mutableMethod : String = Soundcloud.Methods.Track
        print(file.path!)
  //      let check = NSData(contentsOfFile: file.path!)!
        let jsonBody : [String:AnyObject] = [
            Soundcloud.JSONBodyKeys.Title: title,
            Soundcloud.JSONBodyKeys.Sharing: "private",
//            Soundcloud.JSONBodyKeys.AssetData: NSData(contentsOfFile: file.path!)!
            Soundcloud.JSONBodyKeys.AssetData: file.path!
        ]
        
        taskForPOSTMethod(mutableMethod, parameters: parameters, jsonBody: jsonBody) { JSONResult, error in
            
            /* 3. Send the desired value(s) to completion handler */
            if let error = error {
                print("error upload")
                print(error)
                //              completionHandler(result: nil, error: error)
            } else {
                print(JSONResult)
                print("success upload")
    //            completionHandler(result: results, error: nil)
                
                /*                if let results = JSONResult[Soundcloud.JSONResponseKeys.StatusCode] as? Int {
                    completionHandler(result: results, error: nil)
                } else {
                    completionHandler(result: nil, error: NSError(domain: "postToFavoritesList parsing", code: 0, userInfo: [NSLocalizedDescriptionKey: "Could not parse postToFavoritesList"]))
                }
 */           }
        }

        
    }

    func getUserId(accessToken : String, completionHandler: (result: String?, error: NSError?) -> Void) {
//        accessToken = Soundcloud.sharedInstance().accessToken ?? "1-182209-4793009-f9e477d058e6b69"
        
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
                    Soundcloud.sharedInstance().userId = "\(result)"
                    completionHandler(result: Soundcloud.sharedInstance().userId, error: nil)
                } else {
                    completionHandler(result: nil, error: NSError(domain: "get tracks parsing", code: 0, userInfo: [NSLocalizedDescriptionKey: "Could not parse getTracks"]))
                }
            }
        }
        
    }
    func getTracks(completionHandler: (result: [SCTrack]?, error: NSError?) -> Void) {
        
        userId = Soundcloud.sharedInstance().userId //?? "4793009"
        accessToken = Soundcloud.sharedInstance().accessToken //?? "1-182209-4793009-f9e477d058e6b69"
        if userId == nil || accessToken == nil {
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
    class func subtituteKeyInMethod(method: String, key: String, value: String) -> String? {
        if method.rangeOfString("{\(key)}") != nil {
            return method.stringByReplacingOccurrencesOfString("{\(key)}", withString: value)
        } else {
            return nil
        }
    }


    func warningAlertView(parent : UIViewController, messageString : String) -> UIAlertController{
        let alert = UIAlertController(title: "", message: messageString, preferredStyle: .Alert)
        let dismissAction = UIAlertAction(title: "Dismiss",
                                          style: .Cancel,
                                        handler: nil)
        alert.addAction(dismissAction)
        
        return alert
    }

    
    
    class func sharedInstance() -> Soundcloud {
        
        struct Singleton {
            static var sharedInstance = Soundcloud()
        }
        
        return Singleton.sharedInstance
    }

}