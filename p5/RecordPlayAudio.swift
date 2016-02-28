//
//  RecordPlayAudio.swift
//  p5
//
//  Created by hunglun on 2/28/16.
//  Copyright © 2016 hunglun. All rights reserved.
//

import UIKit
import AVFoundation

//Declared Globally
var audioRecorder:AVAudioRecorder!


extension RecordViewController:  AVAudioRecorderDelegate {
    
    
    func audioRecorderDidFinishRecording(recorder: AVAudioRecorder, successfully flag: Bool) {
        if flag {
            audioPlayer = try? AVAudioPlayer(contentsOfURL: recorder.url)
            audioPlayer.prepareToPlay()
            
            recordButton.enabled = true
            stopRecordingButton.enabled = false
            playAudioButton.enabled = true
            
            
        }
    }
    
    @IBAction func playAudio(sender : UIButton){
        audioPlayer.play()
    }
    
    @IBAction func recordAudio(sender: AnyObject) {
        
        stopRecordingButton.enabled = true
        recordButton.enabled = false
        
        //Inside func recordAudio(sender: UIButton)
        let dirPath = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] as String
        let recordingName = "p5.wav"
        let pathArray = [dirPath, recordingName]
        let filePath = NSURL.fileURLWithPathComponents(pathArray)
        
        print(filePath)
        
        let session = AVAudioSession.sharedInstance()
        try! session.setCategory(AVAudioSessionCategoryPlayAndRecord)
        try! audioRecorder = AVAudioRecorder(URL: filePath!, settings: [:])
        
        audioRecorder.delegate = self
        audioRecorder.meteringEnabled = true
        audioRecorder.prepareToRecord()
        audioRecorder.record()
        
        
        
    }
    
    @IBAction func stopRecording(sender: AnyObject) {
        //Inside func stopAudio(sender: UIButton)
        recordButton.enabled = true
        audioRecorder.stop()
        let audioSession = AVAudioSession.sharedInstance()
        try! audioSession.setActive(false)
        
    }
    

/*
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "stopRecording" {
            // use force unwrapping of Optional, because the values are defined in audioRecorderDidFinishRecording.
            let  playSoundsVC: PlaySoundsViewController = segue.destinationViewController as! PlaySoundsViewController
            playSoundsVC.receivedAudio = sender as! RecordedAudio
        }
    }
  */

    
    
}

