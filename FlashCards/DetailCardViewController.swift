//
//  DetailCardViewController.swift
//  FlashCards
//
//  Created by Kevin Lu on 6/01/2016.
//  Copyright © 2016 Kevin Lu. All rights reserved.
//

import UIKit
import CoreData

class DetailCardViewController: UIViewController, UITextViewDelegate {

    // MARK: - Constant
    private let phrasePlaceholder = "Enter phrase here"
    private let pronunciationPlaceholder = "Enter pronunciation here"
    private let definitionPlaceholder = "Enter definition here"
    
    @IBOutlet weak var phraseLabel: UILabel!
    @IBOutlet weak var pronunciationLabel: UILabel!
    @IBOutlet weak var definitionLabel: UILabel!
    @IBOutlet weak var phraseTextView: UITextView!
    @IBOutlet weak var pronunciationTextView: UITextView!
    @IBOutlet weak var definitionTextView: UITextView!
    @IBOutlet weak var cardView : UIView!
    @IBOutlet weak var toolbar: UIToolbar!
    @IBOutlet weak var deleteButton: UIBarButtonItem!
    
    var card : FlashCard!
    var sharedContext : NSManagedObjectContext = {
        return CoreDataStackManager.sharedInstance().managedObjectContext
    }()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - UI Configuration
    func configureUI() {
        configureView()
        configureNavigationBar()
        configureToolbar()
    }
    
    func configureView() {
        
        // Add tapview to view
        let tapView = UITapGestureRecognizer(target: self, action: "dismissKeyboard")
        self.view.addGestureRecognizer(tapView)
        
        self.view.backgroundColor = UIColor(patternImage: UIImage(named:
            "woodenBackground")!)
        
        // Configure the cardView
        cardView.alpha = 0.7
        cardView.backgroundColor = UIColor.whiteColor()
        
        // Configure the labels
        configureLabel(phraseLabel)
        phraseTextView.text = card.phrase
        configureLabel(pronunciationLabel)
        pronunciationTextView.text = card.pronunciation
        configureLabel(definitionLabel)
        definitionTextView.text = card.definition
        
        // Configure the textView
        configureTextView(phraseTextView)
        configureTextView(pronunciationTextView)
        configureTextView(definitionTextView)

    }
    
    func configureLabel(label: UILabel) {
        let labelSize = 17.0 as CGFloat
        label.font = UIFont(name: "FuturaLight", size: labelSize)
        label.textColor = UIColor.blackColor()
    }
    
    func configureTextView(textView : UITextView) {
        textView.delegate = self
        textView.editable = false
        textView.resignFirstResponder()
        textView.backgroundColor = UIColor.clearColor()
    }
    
    func configureNavigationBar() {
        self.navigationController?.navigationBar.blackTransparentWithWhiteTint()
        
        // Configure the items
        self.navigationItem.title = "Edit your card"
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Edit", style: .Plain, target: self, action: "editAction")
    }
    
    func configureToolbar() {
        toolbar.tintColor = UIColor.whiteColor()
        toolbar.barStyle = UIBarStyle.BlackOpaque
        toolbar.translucent = true
        deleteButton.tintColor = UIColor.whiteColor()
    }
    
    
    func editAction() {
        
        if self.navigationItem.rightBarButtonItem?.title == "Edit"{
            self.navigationItem.rightBarButtonItem?.title = "Done"
            phraseTextView.editable = true
            pronunciationTextView.editable = true
            definitionTextView.editable = true
            
        }
        else {
            if phraseTextView.text == "" || phraseTextView.text == phrasePlaceholder {
                let alertController = UIAlertController(title: "", message: "Please enter something for the phrase", preferredStyle: .ActionSheet)
                let okAction = UIAlertAction(title: "Ok", style: .Default) {
                    (action) -> Void in
                }
                alertController.addAction(okAction)
                self.presentViewController(alertController, animated: true, completion: nil)
            }
            else {
                // Set the UI to original state that is not editable
                self.navigationItem.rightBarButtonItem!.title = "Edit"
                phraseTextView.editable = false
                pronunciationTextView.editable = false
                definitionTextView.editable = false

                card.phrase = phraseTextView.text
                card.pronunciation = pronunciationTextView.text
                card.definition = definitionTextView.text
                CoreDataStackManager.sharedInstance().saveContext()
            }
          
        }
    }
    
    func dismissKeyboard() {
        self.view.endEditing(true)
    }

    @IBAction func deleteCard(sender: AnyObject) {
        let alertController = UIAlertController(title: "", message: "Confirmation to delete card?", preferredStyle: .ActionSheet)
        let yesAction = UIAlertAction(title: "Yes", style: .Default) {
            (action) -> Void in
            self.sharedContext.deleteObject(self.card)
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
    // MARK: - UITextViewDelegate
    
    func textViewDidBeginEditing(textView: UITextView) {
        if textView == phraseTextView && textView.text == phrasePlaceholder {
            textView.text = ""
            textView.textColor = UIColor.blackColor()
        }
        else if textView == pronunciationTextView && textView.text == pronunciationPlaceholder {
            textView.text = ""
            textView.textColor = UIColor.blackColor()
            
        }
        else if textView == definitionTextView && textView.text == definitionPlaceholder {
            textView.text = ""
            textView.textColor = UIColor.blackColor()
            
        }
        textView.becomeFirstResponder()
        
        
    }
    
    func textViewDidEndEditing(textView: UITextView) {
        if textView == phraseTextView && textView.text == "" {
            textView.text = phrasePlaceholder
            textView.textColor = UIColor.grayColor()
        }
        else if textView == pronunciationTextView && textView.text == "" {
            textView.text = pronunciationPlaceholder
            textView.textColor = UIColor.grayColor()
        }
        else if textView == definitionTextView && textView.text == "" {
            textView.text = definitionPlaceholder
            textView.textColor = UIColor.grayColor()
        }
        textView.resignFirstResponder()
    }
    
    func textView(textView: UITextView, shouldChangeTextInRange range: NSRange, replacementText text: String) -> Bool {
        if textView == phraseTextView {
            print("here")
            if textView.text == phrasePlaceholder || textView.text == "" {
                self.navigationItem.rightBarButtonItem?.enabled = false
            }
            else {
                self.navigationItem.rightBarButtonItem?.enabled = true
            }
        }
        return true
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
