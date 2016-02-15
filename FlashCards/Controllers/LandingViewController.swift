//
//  LandingViewController.swift
//  FlashCards
//
//  Created by Kevin Lu on 12/02/2016.
//  Copyright © 2016 Kevin Lu. All rights reserved.
//

import UIKit

class LandingViewController: UIViewController {

    var backgroundImageView : UIImageView!
    
    @IBOutlet weak var actionStackViewContainer: UIView!
    @IBOutlet weak var actionStackView: UIStackView!
    override func viewDidLoad() {
        super.viewDidLoad()
        actionStackViewContainer.backgroundColor = UIColor.clearColor()
        backgroundImageView = UIImageView(frame: self.view.frame)
        backgroundImageView.contentMode = .ScaleAspectFill
        backgroundImageView.image = UIImage(named: "calmBackground")
        backgroundImageView.blurView(duration: 0.0, alpha: 0.2, style: .Dark)
        self.view.addSubview(backgroundImageView)
        self.view.bringSubviewToFront(actionStackViewContainer)
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
