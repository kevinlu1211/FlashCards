//
//  DetailDeckViewController.swift
//  FlashCards
//
//  Created by Kevin Lu on 2/01/2016.
//  Copyright © 2016 Kevin Lu. All rights reserved.
//

import UIKit
import CoreData
private let reuseIdentifier = "userActionCell"

class DetailDeckViewController: UICollectionViewController {
    
    var deck : Deck!
    
    lazy var sharedContext : NSManagedObjectContext = {
        return CoreDataStackManager.sharedInstance().managedObjectContext
    }()
    
    // MARK: - Constants
    let userActions = [0 : "Test", 1 : "View Deck", 2 : "Delete Deck"]
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.collectionView?.reloadData()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func configureUI() {
        self.collectionView!.configureCollectionView()
        configureNavigationBar()
       
    }
    
    func configureNavigationBar() {
       self.navigationController?.navigationBar.blackTransparentWithWhiteTint()
        
        // Configure the items
        self.navigationItem.title = deck.name
    }
    
    
    func deleteDeck() {
        let alertController = UIAlertController(title: "", message: "Confirmation to delete deck?", preferredStyle: .ActionSheet)
        let yesAction = UIAlertAction(title: "Yes", style: .Default) {
            (action) -> Void in
            self.sharedContext.deleteObject(self.deck!)
            CoreDataStackManager.sharedInstance().saveContext()
            self.navigationController?.popViewControllerAnimated(true)
        }
        let noAction = UIAlertAction(title: "No", style: .Default) {
            (action) -> Void in
        }
        alertController.addAction(yesAction)
        alertController.addAction(noAction)
        self.presentViewController(alertController, animated: true, completion: nil)
        
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
        return userActions.count
    }

    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(reuseIdentifier, forIndexPath: indexPath) as! UserActionCollectionViewCell
        let userAction = userActions[indexPath.row]

        cell.userActionLabel.configureCollectionViewCellLabel(userAction!)

        // Set the color
        cell.backgroundColor = UIColor.whiteColor()
        cell.alpha = 0.7
        
        if userAction == "Test" && deck?.flashCards!.count == 0 {
            cell.userActionLabel.configureCollectionViewCellLabel("Add cards before testing")
            cell.alpha = 0.5
        }

        return cell
    }

    // MARK: UICollectionViewDelegate

    override func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(reuseIdentifier, forIndexPath: indexPath) as! UserActionCollectionViewCell
        print(cell.userActionLabel.text)
        print(indexPath.row)
        
//        if cell.userActionLabel.text == "Add cards before testing" {
//            let addCardViewController = self.storyboard?.instantiateViewControllerWithIdentifier("addCardViewController") as! AddCardViewController
//            addCardViewController.deck = self.deck
//            let addCardNavigationController = UINavigationController(rootViewController: addCardViewController)
//            self.presentViewController(addCardNavigationController, animated: true, completion: nil)
//        }

        if userActions[indexPath.row] == "View Deck" {
            print("here")
            let cardCollectionViewController = self.storyboard?.instantiateViewControllerWithIdentifier("cardCollectionViewController") as! CardCollectionViewController
            cardCollectionViewController.deck = self.deck
            self.navigationController?.pushViewController(cardCollectionViewController, animated: true)
        }
        else if userActions[indexPath.row] == "Test" {
            if deck.flashCards?.count == 0 {
                let cardCollectionViewController = self.storyboard?.instantiateViewControllerWithIdentifier("cardCollectionViewController") as! CardCollectionViewController
                cardCollectionViewController.deck = self.deck
                self.navigationController?.pushViewController(cardCollectionViewController, animated: true)
            }
            else {
                let testCollectionViewController = self.storyboard?.instantiateViewControllerWithIdentifier("testCollectionViewController") as! TestCollectionViewController
                testCollectionViewController.deck = self.deck
                self.navigationController?.pushViewController(testCollectionViewController, animated: true)
            }
            
        }
        else if userActions[indexPath.row] == "Delete Deck" {
            deleteDeck()
        }
    }
}
