//
//  AddDeckViewController.swift
//  FlashCards
//
//  Created by Kevin Lu on 29/12/2015.
//  Copyright © 2015 Kevin Lu. All rights reserved.
//

import UIKit

import CoreData
class AddDeckViewController: UIViewController, UITextFieldDelegate, UITextViewDelegate  {

    // MARK : - Variables
    
    var subject : Subject!

    // MARK : - UI Variables
    @IBOutlet weak var addDeckView: UIView!
    @IBOutlet weak var deckNameTextField: UITextField!
    @IBOutlet weak var deckDetailTextView: UITextView!
    
    lazy var sharedContext : NSManagedObjectContext =  {
        return CoreDataStackManager.sharedInstance().managedObjectContext
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        print(subject.name)
        // Do any additional setup after loading the view.
    }

    func configureUI() {
        configureView()
        configureNavigationBar()
    }
    
    func configureView() {
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "woodenBackground")!)
        addDeckView.backgroundColor = UIColor.whiteColor()
        addDeckView.alpha = 0.7
        
        let tapGesture = UITapGestureRecognizer(target: self, action: "dismissKeyboard")
        self.view.addGestureRecognizer(tapGesture)
        
        configureTextField(deckNameTextField)
        configureTextView(deckDetailTextView)
    }
    
    func configureNavigationBar() {

        self.navigationController?.navigationBar.blackTransparentWithWhiteTint()
        
        // Configure the items
        self.navigationItem.title = "Add your deck"
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Create", style: .Plain, target: self, action: "addDeck")
        self.navigationItem.rightBarButtonItem?.enabled = false
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .Cancel, target: self, action: "dismissViewController")
    }
    
    func configureTextField(textField : UITextField) {
        let str = NSAttributedString(string: "Deck Name", attributes: [NSForegroundColorAttributeName:UIColor.grayColor()])
        textField.attributedPlaceholder = str
        textField.delegate = self
    }
    
    func configureTextView(textView : UITextView) {
        textView.delegate = self
        textView.backgroundColor = UIColor.clearColor()
        textView.text = "Enter deck details"
        textView.textColor = UIColor.grayColor()
    }
    
    func addDeck() {
        if deckDetailTextView.text == "Enter deck details" {
            let deck = Deck(context: sharedContext, name: deckNameTextField.text!, detail: nil)
            deck.subject = self.subject
        }
        else {
            let deck = Deck(context: sharedContext, name: deckNameTextField.text!, detail: deckDetailTextView.text)
            deck.subject = self.subject

        }
        CoreDataStackManager.sharedInstance().saveContext()
        dismissViewController()
        print(subject.decks!.count)
    }
    
    func dismissViewController() {
        self.dismissViewControllerAnimated(true, completion: nil)

    }
    // MARK: - UITextFieldDelegate
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        let text = (textField.text! as NSString).stringByReplacingCharactersInRange(range, withString: string)
        

        if textField == deckNameTextField {
            if !text.isEmpty {
                self.navigationItem.rightBarButtonItem?.enabled = true
            }
            else {
                self.navigationItem.rightBarButtonItem?.enabled = false
            }
        }
        return true
    }
    
    // MARK: - UITextViewDelegate
    
    func textViewDidBeginEditing(textView: UITextView) {
        if textView.text == "Enter deck details" {
            textView.text = ""
            textView.textColor = UIColor.blackColor()
        }
        textView.becomeFirstResponder()
    }
    
    func textViewDidEndEditing(textView: UITextView) {
        if textView.text == "" {
            textView.text = "Enter deck details"
            textView.textColor = UIColor.grayColor()
        }
        textView.resignFirstResponder()
    }
    
    // MARK: Keyboard
    
    func dismissKeyboard() {
        // endEditing iterates through the subviews of our view and dismisses the keyboard which is a subview?
        self.view.endEditing(true)
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
