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
    var userId : String!
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
            //                print(response)
            //                print(error)
            
            var newData = data!.subdataWithRange(NSMakeRange(0, data!.length)) /* subset response data! */
            print(NSString(data: newData, encoding: NSUTF8StringEncoding))
            print(NSString(data: data!, encoding: NSUTF8StringEncoding))
            do {
                if let parsedResult = try NSJSONSerialization.JSONObjectWithData(data!, options: .AllowFragments) as? NSDictionary,
                    accessToken = parsedResult["access_token"] as? String{
                        Soundcloud.sharedInstance().accessToken = accessToken
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