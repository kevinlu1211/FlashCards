//
//  TestCollectionViewController.swift
//  FlashCards
//
//  Created by Kevin Lu on 3/01/2016.
//  Copyright © 2016 Kevin Lu. All rights reserved.
//

import UIKit
import CoreData

private let reuseIdentifier = "testCell"

class TestCollectionViewController: UICollectionViewController {

    var deck : Deck!
    
    lazy var sharedContext : NSManagedObjectContext = {
        return CoreDataStackManager.sharedInstance().managedObjectContext
    }()
    
    // MARK: - Constants 
    let testActions = [0 : "Full Test"]
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - UI Configuration
    
    func configureUI() {
        self.collectionView!.configureCollectionView()
        configureNavigationBar()
        
    }
    
    func configureNavigationBar() {
        
        self.navigationController?.navigationBar.blackTransparentWithWhiteTint()
        
        // Configure the items
        self.navigationItem.title = "Test"

    }


    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

    // MARK: UICollectionViewDataSource

    override func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }


    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return testActions.count
    }

    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(reuseIdentifier, forIndexPath: indexPath) as! TestCollectionViewCell
        let testAction = testActions[indexPath.row]
        cell.testActionLabel.configureCollectionViewCellLabel(testAction!)
     
        cell.backgroundColor = UIColor.whiteColor()
        cell.alpha = 0.7
        return cell
    }

    // MARK: UICollectionViewDelegate

    override func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        if testActions[indexPath.row] == "Full Test" {
            let fullTestViewController = self.storyboard?.instantiateViewControllerWithIdentifier("fullTestViewController") as! FullTestViewController
            fullTestViewController.deck = self.deck
            let fullTestNavigationController = UINavigationController(rootViewController: fullTestViewController)
            self.presentViewController(fullTestNavigationController, animated: true, completion: nil)
        }
    }
}
