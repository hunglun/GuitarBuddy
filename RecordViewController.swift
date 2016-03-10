//
//  RecordViewController.swift
//  p5
//
//  Created by hunglun on 2/27/16.
//  Copyright © 2016 hunglun. All rights reserved.
//

import UIKit
import CoreData
import AVFoundation
class RecordViewController : UIViewController,UITextFieldDelegate {
    static var practiceItemX : PracticeItemX!
    @IBOutlet var beatsPerMinuteTextField: UITextField!
    @IBOutlet var beatsPerMeasureTextField: UITextField!
    @IBOutlet var totalNumOfMeasuresTextField: UITextField!
    
    @IBOutlet var beatsPerMinuteStepper: UIStepper!
    @IBOutlet var beatsPerMeasureStepper: UIStepper!
    @IBOutlet var totalNumOfMeasuresStepper: UIStepper!
    
    @IBOutlet var musicPieceTitle: UITextField!

    @IBOutlet var progressBar: UIProgressView!
    @IBOutlet var songInfoLabel: UILabel!
    
    @IBOutlet var statsInfoLabel: UILabel!
    //recorder
    @IBOutlet weak var stopRecordPlayButton: UIButton!
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
            if let _ = RecordViewController.practiceItemX {
                RecordViewController.practiceItemX.currentBpm = Int(tempo)

            }
            tempoLabel.text = String(format: "%.0f", tempo)
            tempoStepper.value = Double(tempo)
        }
    }
    func updateStats(item : PracticeItem){
      statsInfoLabel.text = "In Practice Tab Time: \(item.stats.practiceTabForegroundTime) min | Metronome Usage Time : \(item.stats.metronomeUsageTime) min | Recorder Usage Time : \(item.stats.recorderUsageTime) min "
//        print("| Last Record: \(item.practice.lastRecordingLength) secs| Progress: \(item.progress * 100)%"
    }
    
    func save(){
        RecordViewController.practiceItemX.title = NSString(string: musicPieceTitle.text!)
        RecordViewController.practiceItemX.targetBpm = beatsPerMinuteStepper.value
        RecordViewController.practiceItemX.beatsPerMeasure = beatsPerMeasureStepper.value
        RecordViewController.practiceItemX.numberOfMeasures = totalNumOfMeasuresStepper.value
        CoreDataStackManager.sharedInstance().saveContext()
    }
    

    override func viewWillAppear(animated: Bool) {
      //REMARK : don't use self.practiceItem
        let item : PracticeItemX?
        if RecordViewController.practiceItemX != nil {
            item = RecordViewController.practiceItemX
        }else{
            item = fetchLastPracticeItem()
        }
        if let item = item {
            RecordViewController.practiceItemX = item
            beatsPerMinuteTextField.text = String(item.targetBpm)
            beatsPerMeasureTextField.text = String(item.beatsPerMeasure)
            totalNumOfMeasuresTextField.text = String(item.numberOfMeasures)
            beatsPerMinuteStepper.value = Double(item.targetBpm)
            beatsPerMeasureStepper.value = Double(item.beatsPerMeasure)
            totalNumOfMeasuresStepper.value = Double(item.numberOfMeasures)
            tempoLabel.text = String(item.currentBpm)

            musicPieceTitle.text = String(item.title)
            songInfoLabel.text = "Expected Song Length: \(item.expectedRecordingLength) secs"
    //        updateStats(item)
            progressBar.setProgress( Float(item.progress), animated: true)
        }
        do {
            try AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayAndRecord, withOptions: .DefaultToSpeaker)
        } catch let error as NSError {
            print(error.localizedDescription)
        }

    }
    
    
    
    func fetchLastPracticeItem() -> PracticeItemX?{
        // Create the Fetch Request
        let fetchRequest = NSFetchRequest(entityName: "PracticeItemX")
        
        // Execute the Fetch Request
        do {
            if let items = try sharedContext.executeFetchRequest(fetchRequest) as? [PracticeItemX] {
            //TODO: search for the last practice item.
                if items.count > 0 {
                    return items[0]
                }
            }
        } catch _ {
            //TODO: understand what it means
            return nil
        }
        return nil
    }
    var sharedContext : NSManagedObjectContext {
        return CoreDataStackManager.sharedInstance().managedObjectContext
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .Save, target: self, action: "save")
        musicPieceTitle.delegate = self
        //metronome
        metronomeStartStopState = false
        metronome = Metronome()
        tempo = 40

        //recorder
        stopRecordPlayButton.enabled = false
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
            Soundcloud.sharedInstance().upload(filePath, title: String(RecordViewController.practiceItemX.title), controller: self)
        }
    }
    

}

