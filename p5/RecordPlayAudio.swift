//
//  RecordPlayAudio.swift
//  p5
//
//  Created by hunglun on 2/28/16.
//  Copyright © 2016 hunglun. All rights reserved.
//

import UIKit
import AVFoundation


extension RecordViewController:  AVAudioRecorderDelegate, AVAudioPlayerDelegate {

    func configureButtonsWhenReady (){
        recordButton.enabled = true
        stopRecordingButton.enabled = false
        playAudioButton.enabled = true
    }
    
    func configureButtonsWhenProcessingAudio (){
        recordButton.enabled = false
        stopRecordingButton.enabled = true
        playAudioButton.enabled = false
    }

    func audioRecorderDidFinishRecording(recorder: AVAudioRecorder, successfully flag: Bool) {
        if flag {
            audioPlayer = try? AVAudioPlayer(contentsOfURL: recorder.url)
            audioPlayer.delegate = self
            audioPlayer.prepareToPlay()
            configureButtonsWhenReady()
        }
    }
    func audioPlayerDidFinishPlaying(player: AVAudioPlayer, successfully flag: Bool) {
        if flag {
            configureButtonsWhenReady()
        }
    }

    @IBAction func playAudio(sender : UIButton){
        configureButtonsWhenProcessingAudio()
        audioPlayer.play()
    }
    
    @IBAction func recordAudio(sender: AnyObject) {
        
        configureButtonsWhenProcessingAudio()

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
        configureButtonsWhenReady()
        audioRecorder.stop()
        audioPlayer?.stop()
        let audioSession = AVAudioSession.sharedInstance()
        try! audioSession.setActive(false)
        
    }
    

    
    
}

