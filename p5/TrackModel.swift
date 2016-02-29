//
//  TrackModel.swift
//  p5
//
//  Created by hunglun on 2/29/16.
//  Copyright © 2016 hunglun. All rights reserved.
//

import Foundation

class TrackModel {
    var studentLocations : [StudentLocation]?
    struct StudentLocation {
        let createdAt : String // "2015-12-15T08:35:29.521Z";
        let firstName : String // Benjamin;
        let lastName : String  // Johnston;
        let latitude : Double // "52.51888";
        let longitude : Double // "-7.859928";
        let mapString : String // "Ireland ";
        let mediaURL : String // "www.google.com";
        let objectId : String // 1LKX9Px8Jw;
        let uniqueKey : String // u1940027;
        let updatedAt : String // "2015-12-15T08:35:29.521Z";

        init?(studentInformation : [String: AnyObject])
        {
            if let createdAt = studentInformation["createdAt"] as? String,
                firstName = studentInformation["firstName"] as? String,
                lastName = studentInformation["lastName"] as? String,
                latitude = studentInformation["latitude"] as? Double,
                longitude = studentInformation["longitude"] as? Double,
                mapString = studentInformation["mapString"] as? String,
                mediaURL = studentInformation["mediaURL"] as? String,
                objectId = studentInformation["objectId"] as? String,
                uniqueKey = studentInformation["uniqueKey"] as? String,
                updatedAt = studentInformation["updatedAt"] as? String {
                    
                    
                    self.createdAt = createdAt
                    self.firstName = firstName
                    self.lastName = lastName
                    self.latitude = latitude
                    self.longitude = longitude
                    self.mapString = mapString
                    self.mediaURL = mediaURL
                    self.objectId = objectId
                    self.uniqueKey = uniqueKey
                    self.updatedAt = updatedAt
                    
                    
            }else{
                
                return nil
                
            }
        }
    }
    class func sharedInstance() -> TrackModel {
        
        struct Singleton {
            static var sharedInstance = TrackModel()
        }
        
        return Singleton.sharedInstance
    }

}