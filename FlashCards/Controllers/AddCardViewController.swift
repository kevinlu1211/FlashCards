//
//  AddCardViewController.swift
//  FlashCards
//
//  Created by Kevin Lu on 2/01/2016.
//  Copyright © 2016 Kevin Lu. All rights reserved.
//

import UIKit
import CoreData

enum Language {
    case Chinese
    case English
}
class AddCardViewController: UIViewController, UITextViewDelegate {
    
    // MARK: - Constant
    private let phrasePlaceholder = "Enter phrase here"
    private let pronunciationPlaceholder = "Enter pronunciation here"
    private let definitionPlaceholder = "Enter definition here"
    
    // MARK: - Variables
    var deck : Deck!
    lazy var sharedContext : NSManagedObjectContext = {
        CoreDataStackManager.sharedInstance().managedObjectContext
    }()
    var results : [NSObject]?
    var resultIndex = 0
    var maxIndex : Int!
    var currentLanguage : Language = .English
    
    // MARK: - UI Variables
    @IBOutlet weak var toolbar: UIToolbar!
    @IBOutlet weak var phraseLabel: UILabel!
    @IBOutlet weak var pronunciationLabel: UILabel!
    @IBOutlet weak var definitionLabel: UILabel!
    @IBOutlet weak var cardView: UIView!
    
    @IBOutlet weak var phraseTextView: UITextView!
    @IBOutlet weak var pronunciationTextView: UITextView!
    @IBOutlet weak var definitionTextView: UITextView!
    
    @IBOutlet weak var previousResultButton: UIButton!
    @IBOutlet weak var nextResultButton: UIButton!
    @IBOutlet weak var searchWordButton: UIBarButtonItem!
    @IBOutlet weak var activityIndicatorView: UIActivityIndicatorView!
    
    @IBOutlet weak var topConstraintActivity: NSLayoutConstraint!
    @IBOutlet weak var bottomConstraintActivity: NSLayoutConstraint!
    
    @IBOutlet weak var languageButton: UIBarButtonItem!
    
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
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "woodenBackground")!)
        
        // Configure the cardView
        cardView.alpha = 0.7
        cardView.backgroundColor = UIColor.whiteColor()

        // Configure the labels
        configureLabel(phraseLabel)
        configureLabel(pronunciationLabel)
        configureLabel(definitionLabel)
 
        // Configure the textView
        configureTextView(phraseTextView)
        configureTextView(pronunciationTextView)
        configureTextView(definitionTextView)
        
        // Configure the buttons set state to false on default if word doesn't have more than one definition
        configureButton(previousResultButton)
        previousResultButton.disableButton()
        
        configureButton(nextResultButton)
        nextResultButton.disableButton()
    }
    
    
    func configureLabel(label: UILabel) {
        let labelSize = 17.0 as CGFloat
        label.font = UIFont(name: "FuturaLight", size: labelSize)
        label.textColor = UIColor.blackColor()
    }
    
    func configureTextView(textView : UITextView) {
        textView.delegate = self
        textView.resignFirstResponder()
        textView.backgroundColor = UIColor.clearColor()
        if textView == phraseTextView {
            textView.text = phrasePlaceholder
            textView.textColor = UIColor.grayColor()
        }
        else if textView == pronunciationTextView {
            textView.text = pronunciationPlaceholder
            textView.textColor = UIColor.grayColor()
        }
        else if textView == definitionTextView{
            textView.text = definitionPlaceholder
            textView.textColor = UIColor.grayColor()
        }
    }

    func configureNavigationBar() {
        self.navigationController?.navigationBar.blackTransparentWithWhiteTint()
        
        // Configure the items
        self.navigationItem.title = "Add your card"
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Back", style: .Plain, target: self, action: "dismissViewController")
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Add", style: .Plain, target: self, action: "addCard")
        
        // Don't want to enable the button if the user didn't enter anything for the phrase
        self.navigationItem.rightBarButtonItem?.enabled = false
    }
    
    func configureToolbar() {
        toolbar.tintColor = UIColor.whiteColor()
        toolbar.barStyle = UIBarStyle.BlackOpaque
        toolbar.translucent = true
        searchWordButton.tintColor = UIColor.whiteColor()
    }
    
    func configureButton(button : UIButton) {
        let buttonTitleFontSize : CGFloat = 17.0
        button.backgroundColor = UIColor(colorLiteralRed: 1.0, green: 1.0, blue: 1.0, alpha: 0.7)
        button.titleLabel!.font = UIFont(name: "FuturaLight", size: buttonTitleFontSize)
        button.setTitleColor(UIColor.blackColor(), forState: .Normal)
        button.hidden = true
    }

    func dismissViewController() {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    // MARK: - Buttons
    
    func addCard() {
        
        // Hide the buttons that are shown when the user searches for results online
        hideButtons()
        
        if pronunciationTextView.text == pronunciationPlaceholder && definitionTextView.text == definitionPlaceholder{
            let card = FlashCard(context: sharedContext, phrase: phraseTextView.text, pronunciation: "", definition: "")
            card.deck = self.deck

        }
        
        else if pronunciationTextView.text == pronunciationPlaceholder {
            let card = FlashCard(context: sharedContext, phrase: phraseTextView.text, pronunciation: "", definition: definitionTextView.text)
            card.deck = self.deck

        }
        else if definitionTextView.text == definitionPlaceholder {
            let card = FlashCard(context: sharedContext, phrase: phraseTextView.text, pronunciation: pronunciationTextView.text, definition: "")
            card.deck = self.deck

        }
        else {
            let card = FlashCard(context: sharedContext, phrase: phraseTextView.text, pronunciation: pronunciationTextView.text, definition: definitionTextView.text)
            card.deck = self.deck
        }
        CoreDataStackManager.sharedInstance().saveContext()
        
        // Fade view out and in to create illusion of card being added
        cardView.fadeOut(1.0, delay: 0.0, alpha: 0.0) { finished in
            dispatch_async(dispatch_get_main_queue()) {
                self.configureTextView(self.phraseTextView)
                self.configureTextView(self.pronunciationTextView)
                self.configureTextView(self.definitionTextView)
                self.previousResultButton.disableButton()
                self.nextResultButton.disableButton()
            }
        }
        cardView.fadeIn(1.0, delay: 0.0, alpha: 0.7, completion: nil)
    
        // Don't want to enable the button if the user didn't enter anything for the phrase
        self.navigationItem.rightBarButtonItem?.enabled = false

        
    }

    
    func showButtons() {
        self.nextResultButton.hidden = false
        self.previousResultButton.hidden = false
    }
    
    func hideButtons() {
        self.nextResultButton.hidden = true
        self.previousResultButton.hidden = true
    }
    
    @IBAction func previousResult(sender: AnyObject) {
        // Reduce the index by one and enable next button
        resultIndex -= 1
        nextResultButton.enableButton()
        if (resultIndex == 0) {
            previousResultButton.disableButton()
        }
       
        switch currentLanguage {
        case .English:
            let currentResult = results![resultIndex] as! PearsonData
            phraseTextView.text = currentResult.headWord
            pronunciationTextView.text = currentResult.pronunciation
            definitionTextView.text = currentResult.definition
        case .Chinese:
            let currentResult = results![resultIndex] as! MDBGData
            phraseTextView.text = currentResult.headWord
            pronunciationTextView.text = currentResult.pronunciation
            definitionTextView.text = currentResult.definition
        }

    }
    
    @IBAction func nextResult(sender: AnyObject) {
        resultIndex += 1
        previousResultButton.enableButton()
        if (resultIndex == maxIndex) {
            nextResultButton.disableButton()
        }
        
        switch currentLanguage {
        case .English:
            let currentResult = results![resultIndex] as! PearsonData
            phraseTextView.text = currentResult.headWord
            pronunciationTextView.text = currentResult.pronunciation
            definitionTextView.text = currentResult.definition
        case .Chinese:
            let currentResult = results![resultIndex] as! MDBGData
            phraseTextView.text = currentResult.headWord
            pronunciationTextView.text = currentResult.pronunciation
            definitionTextView.text = currentResult.definition
        }
    }
    @IBAction func searchWord(sender: AnyObject) {
        
        // Before searching remove all the values from dictionary
        if results != nil {
            results?.removeAll()
        }
        
        // Then hide buttons 
        hideButtons()
        
        // Switch the search button with activity indicator
        activityIndicatorView.startAnimating()
        searchWordButton.enabled = false
        searchWordButton.tintColor = UIColor.clearColor()
        
        switch currentLanguage {
        case .English:
            searchEnglish()
        case .Chinese:
            searchChinese()
        }
        
        
    }
    
    func searchChinese() {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0)) {
            MDBGScraper.sharedInstance().retrieveData(self.phraseTextView.text) { success, MDBGResults, errorString in
                
                if success {
                    self.results = MDBGResults
                    self.resultIndex = 0
                    self.maxIndex = (self.results?.count)! - 1
                    
                    // Update UI
                    if self.maxIndex > -1 {
                        dispatch_async(dispatch_get_main_queue()) {
                            self.updateUIAfterDataIsRetrieved()
                        }
                    }
                }
                else {
                    dispatch_async(dispatch_get_main_queue()) {
                        self.showAlertView(errorString!)
                        
                    }
                }
            }
        }

    }
    func searchEnglish() {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0)) {
            PearsonClient.sharedInstance().retrieveData(self.phraseTextView.text) {
                success, PearsonResults, errorString in
                
                if success {
                    self.results = PearsonResults
                    self.resultIndex = 0
                    self.maxIndex = (self.results?.count)! - 1
                    
                    // Update UI
                    if self.maxIndex > -1 {
                        dispatch_async(dispatch_get_main_queue()) {
                            self.updateUIAfterDataIsRetrieved()
                        }
                    }
                }
                else {
                    dispatch_async(dispatch_get_main_queue()) {
                        self.showAlertView(errorString!)
                    }
                }
            }
        }
    }
    func updateUIAfterDataIsRetrieved() {
        
        // Updating the textViews
        switch currentLanguage{
        case .English:
            let currentResult = results![resultIndex] as! PearsonData
            self.phraseTextView.textColor = UIColor.blackColor()
            self.pronunciationTextView.text = currentResult.pronunciation
            self.pronunciationTextView.textColor = UIColor.blackColor()
            self.definitionTextView.text = currentResult.definition
            self.definitionTextView.textColor = UIColor.blackColor()
       
        case .Chinese:
            let currentResult = results![resultIndex] as! MDBGData
            self.phraseTextView.textColor = UIColor.blackColor()
            self.pronunciationTextView.text = currentResult.pronunciation
            self.pronunciationTextView.textColor = UIColor.blackColor()
            self.definitionTextView.text = currentResult.definition
            self.definitionTextView.textColor = UIColor.blackColor()
        }

        
        // Updating the Buttons and Toolbar
        if self.maxIndex > 0 {
            self.showButtons()
            self.nextResultButton.enableButton()
        }
        
        self.activityIndicatorView.stopAnimating()
        self.searchWordButton.enabled = true
        self.searchWordButton.tintColor = UIColor.whiteColor()
    }
    
    func showAlertView(errorString : String) {
        let alertController = UIAlertController(title: "", message: errorString, preferredStyle: .ActionSheet)
        let okAction = UIAlertAction(title: "Ok", style: .Default) {
            (action) -> Void in
        }
        alertController.addAction(okAction)
        self.presentViewController(alertController, animated: true, completion: nil)
        self.activityIndicatorView.stopAnimating()
        self.searchWordButton.enabled = true
        self.searchWordButton.tintColor = UIColor.whiteColor()
    }
    
    @IBAction func changeLanguage(sender: AnyObject) {
        let languageController = UIAlertController(title: "", message: "Select your language", preferredStyle: .ActionSheet)
        let englishAction = UIAlertAction(title: "English", style: .Default) { action -> Void in
            self.currentLanguage = .English
        }
        let chineseAction = UIAlertAction(title: "Chinese", style: .Default) { action -> Void in
            self.currentLanguage = .Chinese
        }
        languageController.addAction(englishAction)
        languageController.addAction(chineseAction)
        self.presentViewController(languageController, animated: true, completion: nil)
    }

    // MARK: Keyboard
    
    func dismissKeyboard() {
        // endEditing iterates through the subviews of our view and dismisses the keyboard which is a subview?
        self.view.endEditing(true)
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
        print("here")
        if textView == phraseTextView {
            if textView.text == phrasePlaceholder {
                self.navigationItem.rightBarButtonItem?.enabled = false
                searchWordButton.enabled = false
                
            }
            else {
                self.navigationItem.rightBarButtonItem?.enabled = true
                searchWordButton.enabled = true
            }
        }
        return true
    }
    
}
