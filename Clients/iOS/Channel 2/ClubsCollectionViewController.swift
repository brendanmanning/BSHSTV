//
//  ClubsCollectionViewController.swift
//  Channel 2
//
//  Created by Brendan Manning on 11/1/16.
//  Copyright © 2016 BrendanManning. All rights reserved.
//

import UIKit
import Async
import SwiftyJSON
class ClubsCollectionViewController: UICollectionViewController {
    var clubs = [Club]();
    var downloader:ClubsDownloader!;
    override func viewDidLoad() {
        collectionView?.reloadData();
        Async.background {
            self.downloader = ClubsDownloader(vc: self as UIViewController);
            self.clubs = self.downloader.getClubs();
            if(self.downloader.errors) {
                Async.main {
                    Popup().show("Error Getting Clubs", message: "Please try again", button: "Dismiss", viewController: self as UIViewController)
                }
            } else {
                Async.main {
                    self.collectionView?.reloadData();
                }
            }
        }
    }
    
    override func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1;
    }
    
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return clubs.count;
    }
    
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("clubc", forIndexPath: indexPath) as! ClubsCollectionViewCell
        cell.imageView.image = UIImage(named: "Loading");
        cell.titleLabel.text = clubs[indexPath.row].title
        cell.moderatorLabel.text = clubs[indexPath.row].admin
        
        Async.background {
            if let url = self.clubs[indexPath.row].imageURL {
                if let data = NSData(contentsOfURL: url) {
                    Async.main {
                        cell.imageView.image = UIImage(data: data);
                    }
                } else {
                    Async.main {
                        cell.imageView.image = UIImage(named: "ImageNotFound");
                    }
                }
            } else {
                Async.main {
                    cell.imageView.image = UIImage(named: "ImageNotFound");
                }
            }
        }
        
        return cell;
    }
}
