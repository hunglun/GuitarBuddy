//
//  PracticeItemTableViewController.swift
//  p5
//  Created by hunglun on 3/5/16.
//  Copyright © 2016 hunglun. All rights reserved.
//


import UIKit

// MARK: - PracticeItemTableViewController: UIViewController

class PracticeItemTableViewController: UIViewController {
    
    // MARK: Properties
    var practiceItems: [PracticeItem] = [PracticeItem]()
    
    @IBOutlet weak var practiceItemTableView: UITableView!
    
    // MARK: Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        /* Create and set the logout button */
        //        self.parentViewController!.navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .Reply, target: self, action: "logoutButtonTouchUp")
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
//        let stats = Stats(60 : practiceTabForegroundTime, 60 : metronomeUsageTime, 60 : recorderUsageTime)
        var stats = Stats(practiceTabForegroundTime: 60, metronomeUsageTime: 60, recorderUsageTime: 60)
        var song = Song(title: "Hello WIlson", targetBpm: 60, beatsPerMeasure: 4, numberOfMeasures: 16)
        var practice = Practice(currentBpm: 45, lastRecordingLength: 64)
        var item = PracticeItem(stats: stats, song: song, practice: practice)
        practiceItems.append(item)
        stats = Stats(practiceTabForegroundTime: 60, metronomeUsageTime: 60, recorderUsageTime: 60)
        song = Song(title: "Hello Ziyuan", targetBpm: 60, beatsPerMeasure: 4, numberOfMeasures: 16)
        practice = Practice(currentBpm: 60, lastRecordingLength: 32)
        item = PracticeItem(stats: stats, song: song, practice: practice)
        practiceItems.append(item)

    }
    
}

// MARK: - PracticeItemTableViewController: UITableViewDelegate, UITableViewDataSource

extension PracticeItemTableViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        /* Get cell type */
        let cellReuseIdentifier = "PracticeItemTableViewCell"
        let practiceItem = practiceItems[indexPath.row]
        let cell = tableView.dequeueReusableCellWithIdentifier(cellReuseIdentifier) as UITableViewCell!
        
        /* Set cell defaults */
        cell.textLabel!.text = practiceItem.song.title
        //        cell.imageView!.image = UIImage(named: "Film")
        cell.imageView!.contentMode = UIViewContentMode.ScaleAspectFit
        
        /*
        if let posterPath = track.posterPath {
        Soundcloud.sharedInstance().taskForGETImage(TMDBClient.PosterSizes.RowPoster, filePath: posterPath, completionHandler: { (imageData, error) in
        if let image = UIImage(data: imageData!) {
        dispatch_async(dispatch_get_main_queue()) {
        cell.imageView!.image = image
        }
        } else {
        print(error)
        }
        })
        }
        */
        return cell
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return practiceItems.count
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
            //TODO : select -> record view
        /* Push the movie detail view */
        let controller = self.storyboard!.instantiateViewControllerWithIdentifier("RecordViewController") as! RecordViewController
//        controller.practiceItem = practiceItems[indexPath.row]
        presentViewController(controller, animated: true, completion: nil)
//        self.navigationController!.pushViewController(controller, animated: true)
    
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 100
    }
}