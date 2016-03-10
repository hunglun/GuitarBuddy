//
//  PracticeItemTableViewController.swift
//  p5
//  Created by hunglun on 3/5/16.
//  Copyright © 2016 hunglun. All rights reserved.
//


import UIKit
import CoreData
// MARK: - PracticeItemTableViewController: UIViewController

class PracticeItemTableViewController: UIViewController {
    
    // MARK: Properties
    static var practiceItems: [PracticeItemX] = [PracticeItemX]()
    
    @IBOutlet weak var practiceItemTableView: UITableView!
    
    // MARK: Life Cycle
    func addPracticeItemToCoreData(item : PracticeItem)-> PracticeItemX{
        let dictionary = [PracticeItemX.Keys.practiceTabForegroundTime  : item.stats.practiceTabForegroundTime ,
            PracticeItemX.Keys.metronomeUsageTime  : item.stats.metronomeUsageTime ,
            PracticeItemX.Keys.recorderUsageTime  : item.stats.recorderUsageTime ,
            PracticeItemX.Keys.title  : item.song.title ,
            PracticeItemX.Keys.lastPracticeDate  : NSDate() ,
            PracticeItemX.Keys.targetBpm  : item.song.targetBpm ,
            PracticeItemX.Keys.beatsPerMeasure  : item.song.beatsPerMeasure ,
            PracticeItemX.Keys.numberOfMeasures  : item.song.numberOfMeasures ,
            PracticeItemX.Keys.currentBpm  : item.practice.currentBpm ,
            PracticeItemX.Keys.lastRecordingLength  : item.practice.lastRecordingLength ]
        
        let item = PracticeItemX(dictionary : dictionary,context: self.sharedContext)
        CoreDataStackManager.sharedInstance().saveContext()
        return item
    }

    func addPracticeItem(){
        let controller = self.storyboard!.instantiateViewControllerWithIdentifier("TabBarController") as! UITabBarController
        let stats = Stats(practiceTabForegroundTime: 0, metronomeUsageTime: 0, recorderUsageTime: 0)
        let song = Song(title: "Untitled", targetBpm: 60, beatsPerMeasure: 4, numberOfMeasures: 16)
        let practice = Practice(currentBpm: 40, lastRecordingLength: 0)
        let item = PracticeItem(stats: stats, song: song, practice: practice)
        let itemX = addPracticeItemToCoreData(item)
        PracticeItemTableViewController.practiceItems.append(itemX)
        //TODO: think about how to pass item to RecordViewController
        presentViewController(controller, animated: false, completion: nil)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .Add, target: self, action: "addPracticeItem")
        
        
        /* Create and set the logout button */
        //        self.parentViewController!.navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .Reply, target: self, action: "logoutButtonTouchUp")
    }

    var sharedContext : NSManagedObjectContext {
        return CoreDataStackManager.sharedInstance().managedObjectContext
    }
    
    func fetchAllPracticeItems() -> [PracticeItemX]{
        // Create the Fetch Request
        let fetchRequest = NSFetchRequest(entityName: "PracticeItemX")
        
        // Execute the Fetch Request
        do {
            let items = try sharedContext.executeFetchRequest(fetchRequest) as! [PracticeItemX]
            //TODO: search for the last practice item.
            return items
        } catch _ {
            //TODO: understand what it means
            return [PracticeItemX]()
        }
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        PracticeItemTableViewController.practiceItems = [PracticeItemX]()
        for item in fetchAllPracticeItems(){
            PracticeItemTableViewController.practiceItems.append(item)
        }
    }
    
}

// MARK: - PracticeItemTableViewController: UITableViewDelegate, UITableViewDataSource

extension PracticeItemTableViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        /* Get cell type */
        let cellReuseIdentifier = "PracticeItemTableViewCell"
        let practiceItem = PracticeItemTableViewController.practiceItems[indexPath.row]
        let cell = tableView.dequeueReusableCellWithIdentifier(cellReuseIdentifier) as UITableViewCell!
        
        /* Set cell defaults */
        cell.textLabel!.text = String(practiceItem.title)
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
        return PracticeItemTableViewController.practiceItems.count
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        /* Push the movie detail view */
        let controller = self.storyboard!.instantiateViewControllerWithIdentifier("TabBarController") as! UITabBarController
        RecordViewController.practiceItemX = PracticeItemTableViewController.practiceItems[indexPath.row]
        presentViewController(controller, animated: false, completion: nil)
    
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 100
    }

  
}