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
        stopRecordPlayButton.enabled = false
        playAudioButton.enabled = true
    }
    
    func configureButtonsWhenProcessingAudio (){
        recordButton.enabled = false
        stopRecordPlayButton.enabled = true
        playAudioButton.enabled = false
    }

    func setupAudioPlayer(url : NSURL){
        audioPlayer = try? AVAudioPlayer(contentsOfURL: url)
        audioPlayer.delegate = self
        audioPlayer.prepareToPlay()
    }
    func resetAudioPlayer(){
        if let url = audioPlayer?.url {
            audioPlayer = try? AVAudioPlayer(contentsOfURL: url)
            audioPlayer.delegate = self
            audioPlayer.prepareToPlay()
        }
    }
    
    func audioRecorderDidFinishRecording(recorder: AVAudioRecorder, successfully flag: Bool) {
        if flag {
            do {
                try AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayAndRecord, withOptions: .DefaultToSpeaker)
            } catch let error as NSError {
                print(error.localizedDescription)
            }

            setupAudioPlayer(recorder.url)
            configureButtonsWhenReady()
            RecordViewController.practiceItemX.lastRecordingLength = Int(audioPlayer.duration)

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
        filePath = NSURL.fileURLWithPathComponents(pathArray)
        
        print(filePath)
        
        try! audioRecorder = AVAudioRecorder(URL: filePath!, settings: [:])
        
        audioRecorder.delegate = self
        audioRecorder.meteringEnabled = true
        audioRecorder.prepareToRecord()
        audioRecorder.record()

        
        
    }
    
    @IBAction func stopRecordPlay(sender: AnyObject) {
        configureButtonsWhenReady()
        audioRecorder.stop()
        audioPlayer?.stop()
        resetAudioPlayer()
        
    }
    

    
    
}

