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
    var practiceItem : PracticeItem!
    
    @IBOutlet var progressBar: UIProgressView!
    @IBOutlet var songInfoLabel: UILabel!
    
    @IBOutlet var statsInfoLabel: UILabel!
    //recorder
    @IBOutlet weak var stopRecordingButton: UIButton!
    @IBOutlet weak var recordButton: UIButton!
    @IBOutlet var playAudioButton: UIButton!
    var audioPlayer: AVAudioPlayer!
    var audioRecorder:AVAudioRecorder!
    var filePath : NSURL?
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
    
    override func viewWillAppear(animated: Bool) {
      //REMARK : don't use self.practiceItem
        if let item = RecordViewController.sharedInstance().practiceItem {
            songInfoLabel.text = "Target bpm: \(item.song.targetBpm)|Beats/Measure: \(item.song.beatsPerMeasure)|Total Measures: \(item.song.numberOfMeasures) Song Length : \(item.song.expectedRecordingLength) secs"
            statsInfoLabel.text = "In Practice Tab Time: \(item.stats.practiceTabForegroundTime) min | Metronome Usage Time : \(item.stats.metronomeUsageTime) min | Recorder Usage Time : \(item.stats.recorderUsageTime) min"
            progressBar.setProgress( Float(item.progress), animated: true)
            songInfoLabel.sizeToFit()
            statsInfoLabel.sizeToFit()
            print(item)
            print("Progress: \(item.progress)")
        }else{
            progressBar.setProgress(0,animated : false)
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
    
    @IBAction func publishButtonTouchUpInside(sender: UIButton) {
        let userId = Soundcloud.sharedInstance().userId //?? "4793009"
        let accessToken = Soundcloud.sharedInstance().accessToken //?? "1-182209-4793009-f9e477d058e6b69"
        if userId == nil || accessToken == nil {
            Soundcloud.sharedInstance().connect()
            return
        }
        if let filePath = filePath {
            Soundcloud.sharedInstance().upload(filePath, title: "TestWav")
        }
    }
    class func sharedInstance() -> RecordViewController {
        
        struct Singleton {
            static var sharedInstance = RecordViewController()
        }
        
        return Singleton.sharedInstance
    }

}

