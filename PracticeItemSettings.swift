//
//  PracticeItemSettings.swift
//  p5
//
//  Created by hunglun on 3/6/16.
//  Copyright © 2016 hunglun. All rights reserved.
//


import UIKit
extension RecordViewController{
    @IBAction func beatsPerMinuteChanged(stepper: UIStepper) {
        beatsPerMinuteTextField.text = String(stepper.value)
        RecordViewController.sharedInstance().practiceItem.song.targetBpm = Int(stepper.value)
    }
    @IBAction func beatsPerMeasureChanged(stepper: UIStepper) {
        beatsPerMeasureTextField.text = String(stepper.value)
        RecordViewController.sharedInstance().practiceItem.song.beatsPerMeasure = Int(stepper.value)
    }
    @IBAction func totalNumOfMeasuresChanged(stepper: UIStepper) {
        totalNumOfMeasuresTextField.text = String(stepper.value)
        RecordViewController.sharedInstance().practiceItem.song.numberOfMeasures = Int(stepper.value)
    }
    
    @IBAction func musicPieceTitleEditEnd(sender: UITextField) {
        RecordViewController.sharedInstance().practiceItem.song.title = sender.text ?? "Untitled"
    }

    func textFieldShouldReturn(textField: UITextField) -> Bool {
        // dismiss keyboard
        musicPieceTitle.resignFirstResponder()
        
        return true
    }
    
    
}

