//
//  RecordedAudio.swift
//  pitchperfect
//
//  Created by hunglun on 18/12/15.
//  Copyright © 2015 hunglun. All rights reserved.
//

import Foundation

class RecordedAudio {
    var title : String!
    var filePathUrl : NSURL!
    init (title : String!, filePathUrl : NSURL!){
        self.title = title
        self.filePathUrl = filePathUrl
    }
}