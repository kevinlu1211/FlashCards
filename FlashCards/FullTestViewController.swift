//
//  TestViewController.swift
//  FlashCards
//
//  Created by Kevin Lu on 3/01/2016.
//  Copyright © 2016 Kevin Lu. All rights reserved.
//

import UIKit
import CoreData

class FullTestViewController: UIViewController, UITextViewDelegate {

    
    // MARK: - Variables
    var deck : Deck!
    lazy var sharedContext : NSManagedObjectContext = {
        CoreDataStackManager.sharedInstance().managedObjectContext
    }()
    var currentIndex : Int = 0
    var maxIndex : Int!
    
    // MARK: - UI Variables
    @IBOutlet weak var phraseLabel: UILabel!
    @IBOutlet weak var pronunciationLabel: UILabel!
    @IBOutlet weak var definitionLabel: UILabel!
    @IBOutlet weak var phraseTextView: UITextView!
    @IBOutlet weak var pronunciationTextView: UITextView!
    @IBOutlet weak var definitionTextView: UITextView!
    @IBOutlet weak var previousButton: UIButton!
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var cardView: UIView!
    
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
        maxIndex = (deck.flashCards?.count)! - 1
        configureView()
        configureNavigationBar()
        
        
        let firstCard = deck.flashCards![currentIndex]
        phraseTextView.text = firstCard.phrase
        pronunciationTextView.text = firstCard.pronunciation
        definitionTextView.text = firstCard.definition
    }
    
    func configureView() {
        
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
        
        // Add tap gestures to pronunciation and definition label
        let pronunciationLabelTapGesture = UITapGestureRecognizer(target: self, action: "showPronunciationTextView")
        pronunciationLabel.addGestureRecognizer(pronunciationLabelTapGesture)
        pronunciationLabel.userInteractionEnabled = true
        
        let definitionLabelViewTapGesture = UITapGestureRecognizer(target: self, action: "showDefinitionTextView")
        definitionLabel.addGestureRecognizer(definitionLabelViewTapGesture)
        definitionLabel.userInteractionEnabled = true
        
        // Configure the buttons
        configureButton(previousButton)
        configureButton(nextButton)
        
        // As the first card is always shown first there is no previous card
        previousButton.disableButton()
    }
    
    func showPronunciationTextView() {
        showTextView(pronunciationTextView)
    }
    
    func showDefinitionTextView() {
        showTextView(definitionTextView)
    }
    
    func showTextView(textView : UITextView) {
        textView.fadeIn()
    }
    
    func configureLabel(label: UILabel) {
        let labelSize = 17.0 as CGFloat
        label.font = UIFont(name: "FuturaLight", size: labelSize)
        label.textColor = UIColor.blackColor()
    }
    
    func configureTextView(textView : UITextView) {
        textView.delegate = self
        textView.editable = false
        textView.backgroundColor = UIColor.clearColor()
        
        if textView != phraseTextView {
            textView.alpha = 0.0
        }
    }
    
    func configureButton(button : UIButton) {
        let buttonTitleFontSize : CGFloat = 17.0
        button.backgroundColor = UIColor(colorLiteralRed: 1.0, green: 1.0, blue: 1.0, alpha: 0.7)
        button.titleLabel!.font = UIFont(name: "FuturaLight", size: buttonTitleFontSize)
        button.setTitleColor(UIColor.blackColor(), forState: .Normal)
        if (button == nextButton) && (currentIndex == maxIndex) {
            button.setTitle("Finish", forState: .Normal)
        }
    }

    func configureNavigationBar() {
        
        self.navigationController?.navigationBar.blackTransparentWithWhiteTint()
        
        // Configure the items
        self.navigationItem.title = "Full Test"
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Quit", style: .Plain, target: self, action: "dismissViewController")
        
        // Don't want to enable the button if the user didn't enter anything for the phrase
        self.navigationItem.rightBarButtonItem?.enabled = false
    }
    
    func dismissViewController() {
        self.dismissViewControllerAnimated(true, completion: nil)
    }

        // MARK: - Button
    @IBAction func previousButton(sender: AnyObject) {
        currentIndex -= 1
        // Enable the next button if we can go back
        nextButton.enableButton()
        nextButton.setTitle("Next", forState: .Normal)
        if (currentIndex - 1 < 0) {
            previousButton.disableButton()
        }
        let card = deck.flashCards![currentIndex]
        
        // Fade card view out and then update the cardView
        updateCardView(card)
       
    }
    
    @IBAction func nextButton(sender: AnyObject) {
        if nextButton.titleLabel!.text! == "Finish" {
            self.dismissViewControllerAnimated(true, completion: nil)
        }
        else {
            currentIndex += 1
            print("Current Index is: \(currentIndex)")
            print("Max Index is: \(maxIndex)")
            previousButton.enableButton()
            if (currentIndex == maxIndex) {
                nextButton.setTitle("Finish", forState: .Normal)
                let card = deck.flashCards![currentIndex]
                updateCardView(card)
            }
            else if (currentIndex > maxIndex) {
                return
            }
            else {
                let card = deck.flashCards![currentIndex]
                updateCardView(card)
            }
            

        }
        
        
    }
    
    // MARK: - Updating UI
    func updateCardView(card : FlashCard) {
        cardView.fadeOut()
        phraseTextView.text = card.phrase
        pronunciationTextView.text = card.pronunciation
        pronunciationTextView.fadeOut(0.1, delay: 0.0, alpha: 0, completion: nil)
        definitionTextView.text = card.definition
        definitionTextView.fadeOut(0.1, delay: 0.0, alpha: 0, completion: nil)
        cardView.fadeIn(1.0, delay: 0, alpha: 0.7, completion: nil)
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
