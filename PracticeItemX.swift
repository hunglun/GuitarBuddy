//
//  PracticeItemX.swift
//  p5
//
//  Created by hunglun on 3/8/16.
//  Copyright © 2016 hunglun. All rights reserved.
//


import CoreData


class PracticeItemX : NSManagedObject {
    struct Keys {
        static let practiceTabForegroundTime = "practiceTabForegroundTime"
        static let metronomeUsageTime = "metronomeUsageTime"
        static let recorderUsageTime = "recorderUsageTime"
        static let title = "title"
        static let lastPracticeDate = "lastPracticeDate"
        static let targetBpm = "targetBpm"
        static let beatsPerMeasure = "beatsPerMeasure"
        static let numberOfMeasures = "numberOfMeasures"
        static let currentBpm = "currentBpm"
        static let lastRecordingLength = "lastRecordingLength"
    }

    @NSManaged var practiceTabForegroundTime: NSNumber
    @NSManaged var metronomeUsageTime: NSNumber
    @NSManaged var recorderUsageTime: NSNumber
    @NSManaged var title: NSString
    @NSManaged var lastPracticeDate: NSDate
    @NSManaged var targetBpm: NSNumber
    @NSManaged var beatsPerMeasure: NSNumber
    @NSManaged var numberOfMeasures: NSNumber
    @NSManaged var currentBpm: NSNumber
    @NSManaged var lastRecordingLength: NSNumber
    var expectedRecordingLength : Int { //seconds
        get {
            return (Int(numberOfMeasures) * Int(beatsPerMeasure) * 60 ) / Int(targetBpm)
        }
    }

    var progress : Float {
        get {
            let bpmRatio =  Float(currentBpm) / Float(targetBpm)
            let lengthRatio = Float(Int(lastRecordingLength) - Int(expectedRecordingLength)) / Float(expectedRecordingLength)
            return  (1 - abs(lengthRatio)) * bpmRatio
        }
    }

    override init(entity: NSEntityDescription, insertIntoManagedObjectContext context: NSManagedObjectContext?) {
        super.init(entity: entity, insertIntoManagedObjectContext: context)
    }

    /*
    func practiceItemToDict(item : PracticeItem) -> [String: AnyObject]{
        let dictionary = [PracticeItemX.Keys.practiceTabForegroundTime  : item.stats.practiceTabForegroundTime ,
            PracticeItemX.Keys.metronomeUsageTime  : item.stats.metronomeUsageTime ,
            PracticeItemX.Keys.recorderUsageTime  : item.stats.recorderUsageTime ,
            PracticeItemX.Keys.title  : item.song.title ,
            PracticeItemX.Keys.lastPracticeDate  : NSDate() ,
            PracticeItemX.Keys.targetBpm  : item.song.targetBpm ,
            PracticeItemX.Keys.beatsPerMeasure  : item.song.beatsPerMeasure ,
            PracticeItemX.Keys.numberOfMeasures  : item.song.numberOfMeasures ,
            PracticeItemX.Keys.currentBpm  : item.practice.currentBpm ,
            PracticeItemX.Keys.lastRecordingLength  : item.practice.lastRecordingLength ]
        return dictionary
    }
*/
    init(dictionary: [String : AnyObject], context: NSManagedObjectContext) {
        let entity =  NSEntityDescription.entityForName("PracticeItemX", inManagedObjectContext: context)!
        super.init(entity: entity,insertIntoManagedObjectContext: context)
        practiceTabForegroundTime = dictionary[Keys.practiceTabForegroundTime] as! NSNumber
        metronomeUsageTime = dictionary[Keys.metronomeUsageTime] as! NSNumber
        recorderUsageTime = dictionary[Keys.recorderUsageTime] as! NSNumber
        title = dictionary[Keys.title] as! NSString
        lastPracticeDate = dictionary[Keys.lastPracticeDate] as! NSDate
        targetBpm = dictionary[Keys.targetBpm] as! NSNumber
        beatsPerMeasure = dictionary[Keys.beatsPerMeasure] as! NSNumber
        numberOfMeasures = dictionary[Keys.numberOfMeasures] as! NSNumber
        currentBpm = dictionary[Keys.currentBpm] as! NSNumber
        lastRecordingLength = dictionary[Keys.lastRecordingLength] as! NSNumber
        
    }
    
}


