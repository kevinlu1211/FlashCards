//
//  DetailCollectionDeckViewController.swift
//  FlashCards
//
//  Created by Kevin Lu on 2/01/2016.
//  Copyright © 2016 Kevin Lu. All rights reserved.
//

import UIKit

class DetailCollectionDeckViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    var deck : Deck?
    
    lazy var sharedContext : NSManagedObjectContext = {
        return CoreDataStackManager.sharedInstance().managedObjectContext
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func configureUI() {
        configureView()
        configureNavigationBar()
    }
    func configureView() {
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "woodenBackground")!)
    }
    func configureNavigationBar() {
        
        let navigationBarFontSize = 17.0 as CGFloat
        
        let textAttributes = [
            NSFontAttributeName : UIFont(name: "FuturaLight", size: navigationBarFontSize)!,
            NSForegroundColorAttributeName : UIColor.whiteColor()
        ]
        
        // Configure the navigation bar
        let navigationBar = self.navigationController!.navigationBar
        navigationBar.hidden = false
        navigationBar.titleTextAttributes = textAttributes
        navigationBar.tintColor = UIColor.whiteColor()
        navigationBar.barStyle = UIBarStyle.BlackOpaque
        navigationBar.translucent = true
        
        // Configure the items
        self.navigationItem.title = deck!.name
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Delete", style: .Plain, target: self, action: "deleteDeck")
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .Cancel, target: self, action: "dismissViewController")
    }
    
    
    func deleteDeck() {
        sharedContext.deleteObject(deck!)
        CoreDataStackManager.sharedInstance().saveContext()
        self.dismissViewControllerAnimated(true, completion: nil)
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
