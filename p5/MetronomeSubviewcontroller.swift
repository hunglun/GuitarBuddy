//
//  MetronomeSubviewcontroller.swift
//  p5
//
//  Created by hunglun on 2/28/16.
//  Copyright © 2016 hunglun. All rights reserved.
//

import UIKit
import AVFoundation
extension RecordViewController{
    @IBAction func metronomeStartStopButtonAction(sender: UIButton) {
        metronomeStartStopState =  !metronomeStartStopState
        if metronomeStartStopState == true {
            metronome.start(tempo)
        }else {
            metronome.stop()
        }
        
    }
    
    @IBAction func tempoChanged(tempoStepper: UIStepper) {
        // Save the new tempo.
        tempo = tempoStepper.value
        progressBar.setProgress( RecordViewController.practiceItemX.progress, animated: true)
        RecordViewController.practiceItemX.currentBpm = tempo
        CoreDataStackManager.sharedInstance().saveContext()
    }

}

