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
        beatsPerMinuteTextField.text = String(Int(stepper.value))
        RecordViewController.practiceItemX.targetBpm = Int(stepper.value)
        CoreDataStackManager.sharedInstance().saveContext()
    }
    @IBAction func beatsPerMeasureChanged(stepper: UIStepper) {
        beatsPerMeasureTextField.text = String(Int(stepper.value))
        RecordViewController.practiceItemX.beatsPerMeasure = Int(stepper.value)
        CoreDataStackManager.sharedInstance().saveContext()
    }
    @IBAction func totalNumOfMeasuresChanged(stepper: UIStepper) {
        totalNumOfMeasuresTextField.text = String(Int(stepper.value))
        RecordViewController.practiceItemX.numberOfMeasures = Int(stepper.value)
        CoreDataStackManager.sharedInstance().saveContext()
    }
    
    @IBAction func musicPieceTitleEditEnd(sender: UITextField) {
        RecordViewController.practiceItemX.title = sender.text ?? "Untitled"
        CoreDataStackManager.sharedInstance().saveContext()
    }

    func textFieldShouldReturn(textField: UITextField) -> Bool {
        // dismiss keyboard
        musicPieceTitle.resignFirstResponder()
        
        return true
    }
    
    
}

