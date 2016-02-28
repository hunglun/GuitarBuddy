//
//  RecordViewController.swift
//  p5
//
//  Created by hunglun on 2/27/16.
//  Copyright © 2016 hunglun. All rights reserved.
//

import UIKit
import AVFoundation
class RecordViewController : UIViewController {

    //recorder
    @IBOutlet weak var stopRecordingButton: UIButton!
    @IBOutlet weak var recordButton: UIButton!
    @IBOutlet var playAudioButton: UIButton!
    var audioPlayer: AVAudioPlayer!

    //metronome
    @IBOutlet var metronomeStartStopButton: UIButton!
    @IBOutlet weak var tempoLabel: UILabel!
    @IBOutlet weak var tempoStepper: UIStepper!
    var metronomeStartStopState: Bool!
    var metronome : Metronome!
    var tempo: NSTimeInterval = 40 {
        didSet {
            tempoLabel.text = String(format: "%.0f", tempo)
            tempoStepper.value = Double(tempo)
        }
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()

        //metronome
        metronomeStartStopState = false
        metronome = Metronome()
        tempo = 40

        //recorder
        stopRecordingButton.enabled = false
        recordButton.enabled = true
        playAudioButton.enabled = false
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
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
    }
}

