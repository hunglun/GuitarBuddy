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

    func addPracticeItem(){
        let controller = self.storyboard!.instantiateViewControllerWithIdentifier("TabBarController") as! UITabBarController
        let dictionary = [PracticeItemX.Keys.practiceTabForegroundTime  : 0,
            PracticeItemX.Keys.metronomeUsageTime  : 0,
            PracticeItemX.Keys.recorderUsageTime  : 0,
            PracticeItemX.Keys.title  : "Untitled",
            PracticeItemX.Keys.lastPracticeDate  : NSDate() ,
            PracticeItemX.Keys.targetBpm  : 60,
            PracticeItemX.Keys.beatsPerMeasure  : 4,
            PracticeItemX.Keys.numberOfMeasures  : 16,
            PracticeItemX.Keys.currentBpm  : 40,
            PracticeItemX.Keys.lastRecordingLength  : 0]
        
        let itemX = PracticeItemX(dictionary : dictionary,context: self.sharedContext)
        CoreDataStackManager.sharedInstance().saveContext()
        PracticeItemTableViewController.practiceItems.append(itemX)
        RecordViewController.practiceItemX = itemX
        Soundcloud.lastPracticeItemIndex = PracticeItemTableViewController.practiceItems.count - 1
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
        Soundcloud.taskForGETImage(TMDBClient.PosterSizes.RowPoster, filePath: posterPath, completionHandler: { (imageData, error) in
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
        Soundcloud.lastPracticeItemIndex = indexPath.row
        Soundcloud.saveUserAccessInfo()
        presentViewController(controller, animated: false, completion: nil)
    
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 100
    }

  
}