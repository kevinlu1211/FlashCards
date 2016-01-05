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

class SubjectCollectionViewController: UICollectionViewController {
    
    var subjects = [Subject]()
    
    lazy var sharedContext = {
        return CoreDataStackManager.sharedInstance().managedObjectContext
    }()

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        subjects = fetchAllSubjects()
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
        self.navigationItem.title = "Library"
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .Add, target: self, action: "addSubject")
    }

    func addSubject() {
        let addSubjectViewController = self.storyboard?.instantiateViewControllerWithIdentifier("addSubjectViewController")
        let addSubjectNavigationController = UINavigationController(rootViewController: addSubjectViewController!)
        self.presentViewController(addSubjectNavigationController, animated: true, completion: nil)
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

}
