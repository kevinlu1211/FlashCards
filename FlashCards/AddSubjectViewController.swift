//
//  AddSubjectViewController.swift
//  FlashCards
//
//  Created by Kevin Lu on 2/01/2016.
//  Copyright © 2016 Kevin Lu. All rights reserved.
//

import UIKit
import CoreData

class AddSubjectViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var addSubjectView: UIView!
    @IBOutlet weak var subjectNameTextField: UITextField!
    
    lazy var sharedContext : NSManagedObjectContext =  {
        return CoreDataStackManager.sharedInstance().managedObjectContext
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        // Do any additional setup after loading the view.
    }
    
    func configureUI() {
        configureView()
        configureTextField()
        configureNavigationBar()
        
    }
    
    func configureView() {
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "woodenBackground")!)
        addSubjectView.backgroundColor = UIColor.whiteColor()
        addSubjectView.alpha = 0.7
        
        let tapGesture = UITapGestureRecognizer(target: self, action: "dismissKeyboard")
        self.view.addGestureRecognizer(tapGesture)
    }
    
    func configureNavigationBar() {
        
        self.navigationController?.navigationBar.blackTransparentWithWhiteTint()
        
        // Configure the items
        self.navigationItem.title = "Add your subject"
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Create", style: .Plain, target: self, action: "addSubject")
        self.navigationItem.rightBarButtonItem?.enabled = false
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .Cancel, target: self, action: "dismissViewController")
    }
    
    func configureTextField() {
        let str = NSAttributedString(string: "Subject Name", attributes: [NSForegroundColorAttributeName:UIColor.grayColor()])
        subjectNameTextField.attributedPlaceholder = str
        subjectNameTextField.delegate = self
    }
    

    func addSubject() {
        _ = Subject(context: sharedContext, name: subjectNameTextField.text!)
        CoreDataStackManager.sharedInstance().saveContext()
        dismissViewController()
    }
    
    func dismissViewController() {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    
    // MARK: - UITextFieldDelegate
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        let text = (textField.text! as NSString).stringByReplacingCharactersInRange(range, withString: string)
        
        // If there is no text then don't enable the Create button
        if !text.isEmpty {
            self.navigationItem.rightBarButtonItem?.enabled = true
        }
        else {
            self.navigationItem.rightBarButtonItem?.enabled = false
        }
        return true
    }
    
    // MARK: Keyboard
    
    func dismissKeyboard() {
        // endEditing iterates through the subviews of our view and dismisses the keyboard which is a subview?
        self.view.endEditing(true)
    }


}
