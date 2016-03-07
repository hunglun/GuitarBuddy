//
//  ViewController.swift
//  p5
//
//  Created by Nikolas Gelo on 10/8/14.
//  Integrated by hunglun on 2/25/16.
//  Copyright © 2016 hunglun. All rights reserved.
//

import UIKit
import AVFoundation

class Metronome : NSObject {

    var metronomeTimer: NSTimer!
    
    var metronomeSoundPlayer: AVAudioPlayer!
    
    //skip the first few ticks.
    var skipCounter : Int!

    func playMetronomeSound() {
        let currentTime = CFAbsoluteTimeGetCurrent()
        if (skipCounter == 0) {
            metronomeSoundPlayer.play()
            print("Play metronome sound @ \(currentTime)")
        }else{
            skipCounter = skipCounter - 1
        }
    }

    func start(tempo : NSTimeInterval){
        // Start the metronome.
        skipCounter = 2
        let metronomeTimeInterval:NSTimeInterval = 60.0 / tempo
        
        metronomeTimer = NSTimer.scheduledTimerWithTimeInterval(metronomeTimeInterval, target: self, selector: Selector("playMetronomeSound"), userInfo: nil, repeats: true)
        metronomeTimer?.fire()
    }

    func stop(){
        // Stop the metronome.
        metronomeTimer?.invalidate()
    }
    

    
    override init() {
        // Initialize the sound player
     
        let metronomeSoundURL = NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource("metronomeClick", ofType: "mp3")!)
        metronomeSoundPlayer = try? AVAudioPlayer(contentsOfURL: metronomeSoundURL)
        metronomeSoundPlayer.prepareToPlay()
      
    }
    
    
}

