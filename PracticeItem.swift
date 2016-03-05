//
//  PracticeItem.swift
//  p5
//
//  Created by hunglun on 3/5/16.
//  Copyright © 2016 hunglun. All rights reserved.
//

import Foundation

struct Stats {
    var practiceTabForegroundTime : Int  // minutes
    var metronomeUsageTime : Int // minutes
    var recorderUsageTime : Int  // minutes
    init(practiceTabForegroundTime : Int, metronomeUsageTime : Int, recorderUsageTime: Int){
        self.practiceTabForegroundTime = practiceTabForegroundTime
        self.metronomeUsageTime = metronomeUsageTime
        self.recorderUsageTime = recorderUsageTime
    }
    
}
struct Song {
    var title : String
    var targetBpm : Int
    var beatsPerMeasure : Int
    var numberOfMeasures : Int
    var expectedRecordingLength : Int { //seconds
        get {
            return (numberOfMeasures * beatsPerMeasure * 60 / targetBpm)
        }
    }
    init(title : String, targetBpm : Int, beatsPerMeasure : Int, numberOfMeasures : Int){
        self.title = title
        self.targetBpm = targetBpm
        self.beatsPerMeasure = beatsPerMeasure
        self.numberOfMeasures = numberOfMeasures
    }
}
struct Practice {
    var currentBpm : Int
    var lastRecordingLength : Int // seconds
    init(currentBpm : Int, lastRecordingLength : Int){
        self.currentBpm = currentBpm
        self.lastRecordingLength = lastRecordingLength
    }
}

struct PracticeItem {

    var stats : Stats
    var song : Song
    var practice: Practice
    var progress : Int {
        get {
            return
                (100 * (1 - abs( practice.lastRecordingLength - song.expectedRecordingLength))
                     * practice.currentBpm )
                / (song.targetBpm * song.expectedRecordingLength)
        }
    }
    init(stats: Stats, song: Song, practice: Practice){
        self.stats = stats
        self.song = song
        self.practice = practice
    }
}

