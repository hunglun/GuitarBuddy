//
//  SCTrack.swift
//  p5
//
//  Created by hunglun on 3/2/16.
//  Copyright © 2016 hunglun. All rights reserved.
//

struct SCTrack {
    var title = ""
    var id = 0
    var posterPath: String? = nil
    var releaseYear: String? = nil
    /* Construct a TMDBMovie from a dictionary */
    init(dictionary: [String : AnyObject]) {
        
        title = dictionary[Soundcloud.JSONResponseKeys.TrackTitle] as! String
//        id = dictionary[Soundcloud.JSONResponseKeys.TrackID] as! Int
//        posterPath = dictionary[Soundcloud.JSONResponseKeys.TrackPosterPath] as? String
        
        if let releaseDateString = dictionary[Soundcloud.JSONResponseKeys.TrackReleaseDate] as? String {
            
            if releaseDateString.isEmpty == false {
                releaseYear = releaseDateString.substringToIndex(releaseDateString.startIndex.advancedBy(4))
            } else {
                releaseYear = ""
            }
        }
    }
    
    /* Helper: Given an array of dictionaries, convert them to an array of TMDBMovie objects */
    static func tracksFromResults(results: [[String : AnyObject]]) -> [SCTrack] {
        var tracks = [SCTrack]()
        
        for result in results {
            tracks.append(SCTrack(dictionary: result))
        }
        
        return tracks
    }
}