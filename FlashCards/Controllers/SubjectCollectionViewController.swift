//
//  SubjectCollectionViewController.swift
//  FlashCards
//
//  Created by Kevin Lu on 2/01/2016.
//  Copyright © 2016 Kevin Lu. All rights reserved.
//

import UIKit
import CoreData

private let reuseIdentifier = "subjectCell"

class SubjectCollectionViewController: UICollectionViewController, UIGestureRecognizerDelegate {
    
    var subjects = [Subject]()
    lazy var sharedContext = {
        return CoreDataStackManager.sharedInstance().managedObjectContext
    }()
    
    let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate

    // MARK: - Lifecycle
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        subjects = fetchAllSubjects()
        self.collectionView?.reloadData()
        
        // Recieve notifications for one-time setup
        subscribeToPersistentStoreCoordinatorStoresNotifications()
        
        
    
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
    
    override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(animated)
        unsubscribeFromPersistentStoreCoordinatorStoresNotifications()
    }
    // MARK: - UI Configuration
    
    func configureUI() {
        self.collectionView!.configureCollectionView()
        configureNavigationBar()
        configureGestureRecognizer()
    }
    
    func configureNavigationBar() {
        
        self.navigationController?.navigationBar.blackTransparentWithWhiteTint()
        
        // Configure the items
        self.navigationItem.title = "Library"
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .Add, target: self, action: "addSubject")
    }

    func addSubject() {
        let addSubjectViewController = self.storyboard?.instantiateViewControllerWithIdentifier("addSubjectViewController")
        let addSubjectNavigationController = UINavigationController(rootViewController: addSubjectViewController!)
        self.presentViewController(addSubjectNavigationController, animated: true, completion: nil)
    }

    func configureGestureRecognizer() {
        let longPressGestureRecognizer = UILongPressGestureRecognizer(target: self, action: "handleLongPress:")
        longPressGestureRecognizer.delegate = self
        longPressGestureRecognizer.minimumPressDuration = 1.0
        self.collectionView?.addGestureRecognizer(longPressGestureRecognizer)
    }
    
    func handleLongPress(gestureRecognizer : UILongPressGestureRecognizer) {
        if gestureRecognizer.state != UIGestureRecognizerState.Began {
            return
        }
        let point = gestureRecognizer.locationInView(self.collectionView)
        let indexPath = self.collectionView?.indexPathForItemAtPoint(point)
        
        if indexPath == nil {
            // Do nothing
        }
        else {
            let subject = subjects[(indexPath?.row)!]
            let alertController = UIAlertController(title: "", message: "Confirmation to delete subject?", preferredStyle: .ActionSheet)
            let yesAction = UIAlertAction(title: "Yes", style: .Default) {
                (action) -> Void in
                
                // Delete the object
                subject.decks = nil
                self.sharedContext.deleteObject(subject)
                self.navigationController?.popViewControllerAnimated(true)
                CoreDataStackManager.sharedInstance().saveContext()
                
                // Remove the item from the subjects array so that XCode won't complain
                self.subjects.removeAtIndex((indexPath?.row)!)
                print(self.subjects.count)
                
                // Update the collectionView
                dispatch_async(dispatch_get_main_queue()) {
                    self.collectionView?.performBatchUpdates({() -> Void in
                        (self.collectionView?.deleteItemsAtIndexPaths([indexPath!]))!
                        }, completion: nil)
                }
            }
            let noAction = UIAlertAction(title: "No", style: .Default) {
                (action) -> Void in
            }
            alertController.addAction(yesAction)
            alertController.addAction(noAction)
            self.presentViewController(alertController, animated: true, completion: nil)
            self.collectionView?.reloadData()
        }
        
        
    }
    // MARK: Fetch subjects
    
    func fetchAllSubjects() -> [Subject] {
        let fetchRequest = NSFetchRequest(entityName: "Subject")
        do {
            let subjects = try sharedContext.executeFetchRequest(fetchRequest) as! [Subject]
            return subjects
        }
        catch {
            print("handle error")
            return [Subject]()
        }
    }

    // MARK: UICollectionViewDataSource

    override func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return subjects.count
    }

    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(reuseIdentifier, forIndexPath: indexPath) as! SubjectCollectionViewCell
        let subject = subjects[indexPath.row]
        
        
        // Configure the cell
        cell.subjectNameLabel.configureCollectionViewCellLabel(subject.name)
        cell.backgroundColor = UIColor.whiteColor()
        cell.alpha = 0.7
        return cell
    }

    // MARK: UICollectionViewDelegate

    override func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        let deckCollectionViewController = self.storyboard?.instantiateViewControllerWithIdentifier("deckCollectionViewController") as! DeckCollectionViewController
        deckCollectionViewController.subject = subjects[indexPath.row]
        print(subjects[indexPath.row].name)
        self.navigationController?.pushViewController(deckCollectionViewController, animated: true)
    }
    
    // MARK: Notification Center
    func subscribeToPersistentStoreCoordinatorStoresNotifications() {
        
        // Subscribe for first time setup of iCloud
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "enableUI", name: NSPersistentStoreCoordinatorStoresDidChangeNotification, object: sharedContext.persistentStoreCoordinator)
        NSNotificationCenter.defaultCenter().addObserverForName(NSPersistentStoreCoordinatorStoresWillChangeNotification, object: sharedContext.persistentStoreCoordinator, queue: NSOperationQueue.mainQueue()) { notification in
            
            // First reset the managed object context
            self.sharedContext.performBlock() {
                print("=== RESETTING CONTEXT ===")
                self.sharedContext.reset()
            }
            
            // Then disable UI
            dispatch_async(dispatch_get_main_queue()) {
                print("=== DISABLING UI===")
                self.disableUI()
            }
        }
    }
    
    func unsubscribeFromPersistentStoreCoordinatorStoresNotifications() {
        NSNotificationCenter.defaultCenter().removeObserver(self, name: NSPersistentStoreCoordinatorStoresDidChangeNotification, object: sharedContext.persistentStoreCoordinator)
        NSNotificationCenter.defaultCenter().removeObserver(self, name:  NSPersistentStoreCoordinatorStoresWillChangeNotification, object: sharedContext.persistentStoreCoordinator)
    }

    func enableUI() {
        print("=== ENABLING UI===")
        self.view.alpha = 1.0
        subjects = fetchAllSubjects()
        self.collectionView?.reloadData()
        appDelegate.window?.userInteractionEnabled = true
    }
    
    func disableUI() {
        self.view.alpha = 0.5
        appDelegate.window?.userInteractionEnabled = false
    }

}
