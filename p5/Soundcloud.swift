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
    var code : String!

    let signUpURL = "https://www.google.com/url?q=https://www.udacity.com/account/auth%23!/signin&sa=D&ust=1452592175802000&usg=AFQjCNF4P-G8QbOSHdZPa1TAOB4wnzzDVQ"

    func warningAlertView(parent : UIViewController, messageString : String) -> UIAlertController{
        let alert = UIAlertController(title: "", message: messageString, preferredStyle: .Alert)
        let dismissAction = UIAlertAction(title: "Dismiss",
                                          style: .Cancel,
                                        handler: nil)
        alert.addAction(dismissAction)
        
        return alert
    }

    // MARK: Shared Instance
    func getStudentLocations(controller : UIViewController, completeHandler : (()->Void)?) {
        let requestString = "https://api.parse.com/1/classes/StudentLocation?limit=100&order=-updatedAt"
        let request = NSMutableURLRequest(URL: NSURL(string: requestString)!)
        request.addValue("QrX47CA9cyuGewLdsL7o5Eb8iug6Em8ye0dnAbIr", forHTTPHeaderField: "X-Parse-Application-Id")
        request.addValue("QuWThTdiRmTux3YaDseUSEpUKo7aBYM737yKd4gY", forHTTPHeaderField: "X-Parse-REST-API-Key")

        
        let session = NSURLSession.sharedSession()
        let task = session.dataTaskWithRequest(request) { data, response, error in
            if error != nil { // Handle error...
                let alert = self.warningAlertView(controller,messageString: "Download fails")
                dispatch_async(dispatch_get_main_queue()) {
                    controller.presentViewController(alert, animated: true, completion: nil)
                }

                return
            }
            
            do {
                if let parsedResult = try NSJSONSerialization.JSONObjectWithData(data!, options: .AllowFragments) as? NSDictionary,
                    results = parsedResult["results"] as? [[String : AnyObject]]{
                        print("Students location:\(results)")
                        TrackModel.sharedInstance().studentLocations = []
                        for entry in results {
                            if let student = TrackModel.StudentLocation(studentInformation: entry) {
                                TrackModel.sharedInstance().studentLocations?.append(student)
                            }else {
                            
                                let alert = self.warningAlertView(controller,messageString: "Download fails")
                                dispatch_async(dispatch_get_main_queue()) {
                                    controller.presentViewController(alert, animated: true, completion: nil)
                                }

                            }
                        }
                        
                        if let completeHandler = completeHandler {
                            completeHandler()
                        }
                }else{
                    
                    let alert = self.warningAlertView(controller,messageString: "Download fails")
                    dispatch_async(dispatch_get_main_queue()) {
                        controller.presentViewController(alert, animated: true, completion: nil)
                    }

                
                }
            }
            catch {
                let alert = self.warningAlertView(controller,messageString: "Error parsing JSON data")
                dispatch_async(dispatch_get_main_queue()) {
                    controller.presentViewController(alert, animated: true, completion: nil)
                }

            }
            
        }
        task.resume()
        
    }

    class func sharedInstance() -> Soundcloud {
        
        struct Singleton {
            static var sharedInstance = Soundcloud()
        }
        
        return Singleton.sharedInstance
    }

}