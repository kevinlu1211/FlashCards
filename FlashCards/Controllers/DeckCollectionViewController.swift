//
//  LibraryCollectionViewController.swift
//  FlashCards
//
//  Created by Kevin Lu on 29/12/2015.
//  Copyright © 2015 Kevin Lu. All rights reserved.
//

import UIKit
import CoreData
private let reuseIdentifier = "deckCell"

class DeckCollectionViewController: UICollectionViewController {

    
    // MARK: - Variables
    var subject : Subject!
    lazy var sharedContext : NSManagedObjectContext =  {
        return CoreDataStackManager.sharedInstance().managedObjectContext
    }()
    
    // MARK: - Lifecycle
    override func viewWillAppear(animated: Bool) {
        // If the view reappears then it may be that the user has added a new deck, hence we need to re-fetch the decks 
        super.viewWillAppear(animated)
        subject.createDecks()
        self.collectionView?.reloadData()

    }
    override func viewDidLoad() {
        super.viewDidLoad()
        print(subject.name)
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Do any additional setup after loading the view.
        configureUI()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    // MARK: - UI Configuration
    func configureUI() {
        configureNavigationBar()
        self.collectionView!.configureCollectionView()
        
        // Create the decks
        subject.createDecks()
    }
    
    func configureNavigationBar() {
        self.navigationController?.navigationBar.blackTransparentWithWhiteTint()
        self.navigationItem.title = "Decks"
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .Add, target: self, action: "addDeck")
    }
    
    
    func addDeck() {
        let addDeckViewController = self.storyboard?.instantiateViewControllerWithIdentifier("addDeckViewController") as! AddDeckViewController
        let addDeckNavigationController = UINavigationController(rootViewController: addDeckViewController)
        addDeckViewController.subject = self.subject
        self.presentViewController(addDeckNavigationController, animated: true, completion: nil)
        print("Adding deck")
    }
   
    // MARK: UICollectionViewDataSource

    override func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }


    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        if subject.decks == nil {
            return 0
        }
        else {
            return subject.decks!.count
        }
    }

    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(reuseIdentifier, forIndexPath: indexPath) as! DeckCollectionViewCell
        let deck = subject.getDeck(indexPath.row)
        // Configure the cell
        cell.deckNameLabel.configureCollectionViewCellLabel(deck.name)
        
        if let deckDetail = deck.detail {
            cell.deckDetailLabel.configureCollectionViewCellLabel(deckDetail)
        }

        // Set the color
        cell.backgroundColor = UIColor.whiteColor()
        cell.alpha = 0.7
   
        return cell
    }

    func configureLabels() {
    }

    override func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        let deck = subject.getDeck(indexPath.row)
        let detailDeckViewController = self.storyboard?.instantiateViewControllerWithIdentifier("detailDeckViewController") as! DetailDeckViewController
        detailDeckViewController.deck = deck
        self.navigationController?.pushViewController(detailDeckViewController, animated: true)
    }
    
    // MARK: UICollectionViewDelegate

    /*
     Uncomment this method to specify if the specified item should be highlighted during tracking
    override func collectionView(collectionView: UICollectionView, shouldHighlightItemAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    */

    /*
     Uncomment this method to specify if the specified item should be selected
    override func collectionView(collectionView: UICollectionView, shouldSelectItemAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
    override func collectionView(collectionView: UICollectionView, shouldShowMenuForItemAtIndexPath indexPath: NSIndexPath) -> Bool {
        return false
    }

    override func collectionView(collectionView: UICollectionView, canPerformAction action: Selector, forItemAtIndexPath indexPath: NSIndexPath, withSender sender: AnyObject?) -> Bool {
        return false
    }

    override func collectionView(collectionView: UICollectionView, performAction action: Selector, forItemAtIndexPath indexPath: NSIndexPath, withSender sender: AnyObject?) {
    
    }
    */

}
