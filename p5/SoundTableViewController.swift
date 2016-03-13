//
//  SoundTableViewController.swift
//  p5
//
//  Created by hunglun on 3/2/16.
//  Copyright © 2016 hunglun. All rights reserved.
//


import UIKit

// MARK: - SoundTableViewController: UIViewController

class SoundTableViewController: UIViewController {
    
    // MARK: Properties
    var tracks: [SCTrack] = [SCTrack]()
    
    @IBOutlet weak var tracksTableView: UITableView!
    
    // MARK: Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()


        /* Create and set the logout button */
//        self.parentViewController!.navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .Reply, target: self, action: "logoutButtonTouchUp")
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        Soundcloud.getTracks { tracks, error in
            if let tracks = tracks {
                self.tracks = tracks
                dispatch_async(dispatch_get_main_queue()) {
                    self.tracksTableView.reloadData()
                }
            } else {
                print(error)
            }
        }
    }
    
    // MARK: Logout
    
    func logoutButtonTouchUp() {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
}

// MARK: - SoundTableViewController: UITableViewDelegate, UITableViewDataSource

extension SoundTableViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        /* Get cell type */
        let cellReuseIdentifier = "SoundTableViewCell"
        let track = tracks[indexPath.row]
        let cell = tableView.dequeueReusableCellWithIdentifier(cellReuseIdentifier) as UITableViewCell!
        
        /* Set cell defaults */
        cell.textLabel!.text = track.title
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
        return tracks.count
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        /* Push the movie detail view */
/*        let controller = self.storyboard!.instantiateViewControllerWithIdentifier("MovieDetailViewController") as! MovieDetailViewController
        controller.movie = movies[indexPath.row]
        self.navigationController!.pushViewController(controller, animated: true)
*/
    }

    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 100
    }
}