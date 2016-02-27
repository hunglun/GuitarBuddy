//
//  RecordViewController.swift
//  p5
//
//  Created by hunglun on 2/27/16.
//  Copyright © 2016 hunglun. All rights reserved.
//

import UIKit

class RecordViewController : UIViewController {
    
    @IBOutlet var metronomeStartStopButton: UIButton!
    @IBOutlet weak var tempoTextField: UITextField!
    @IBOutlet weak var tempoStepper: UIStepper!
    var metronomeStartStopState: Bool!
    var metronome : Metronome!
    var tempo: NSTimeInterval = 40 {
        didSet {
            tempoTextField.text = String(format: "%.0f", tempo)
            tempoStepper.value = Double(tempo)
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        metronomeStartStopState = false
        metronome = Metronome()
        tempo = 40
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

