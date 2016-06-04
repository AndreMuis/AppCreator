//
//  APCAlertViewController.swift
//  AppCreator
//
//  Created by Andre Muis on 6/4/16.
//  Copyright © 2016 Andre Muis. All rights reserved.
//

import UIKit

class APCAlertViewController: UIViewController, UIViewControllerTransitioningDelegate
{
    @IBOutlet weak var titleLabel : UILabel!
    @IBOutlet weak var textField : UITextField!
    
    let alertTitle : String
    let textFieldPlaceholder : String
    let confirmationHandler : (enteredText : String) -> ()
    
    init(title : String, textFieldPlaceholder : String, confirmationHandler : (enteredText : String) -> ())
    {
        self.alertTitle = title
        self.textFieldPlaceholder = textFieldPlaceholder
        self.confirmationHandler = confirmationHandler
        
        super.init(nibName: String(APCAlertViewController.self), bundle: nil)
        
        self.modalPresentationStyle = UIModalPresentationStyle.Custom
        self.transitioningDelegate = self
    }

    required init?(coder: NSCoder)
    {
        self.alertTitle = ""
        self.textFieldPlaceholder = ""
        self.confirmationHandler = {(enteredText : String) in}
        
        super.init(coder: coder)
    }
    
    override func viewDidLoad()
    {
        self.titleLabel.text = self.alertTitle
        self.textField.placeholder = self.textFieldPlaceholder
    }
    
    @IBAction func cancelButtonTapped(sender: AnyObject)
    {
        if let viewController = self.presentingViewController
        {
            viewController.dismissViewControllerAnimated(true, completion: nil)
        }
    }
    
    @IBAction func confirmButtonTapped(sender: AnyObject)
    {
        var text : String = self.textField.text!
        text = text.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet())

        if text.isEmpty == false
        {
            if let viewController = self.presentingViewController
            {
                self.confirmationHandler(enteredText: text)
                
                viewController.dismissViewControllerAnimated(true, completion: nil)
            }
        }
    }

    // MARK: UIViewControllerTransitioningDelegate
    
    func presentationControllerForPresentedViewController(presented: UIViewController,
                                                          presentingViewController presenting: UIViewController,
                                                          sourceViewController source: UIViewController) -> UIPresentationController?
    {
        let presentationController = APCAlertViewControllerPresentationController(presentedViewController: presented,
                                                                                  presentingViewController: presenting)
        
        return presentationController
    }
    
    func animationControllerForPresentedController(presented: UIViewController,
                                                   presentingController presenting: UIViewController,
                                                   sourceController source: UIViewController) -> UIViewControllerAnimatedTransitioning?
    {
        let animationController = APCAlertViewControllerAnimatedTransitioning(isPresenting: true)
        
        return animationController
    }
    
    func animationControllerForDismissedController(dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning?
    {
        let animationController = APCAlertViewControllerAnimatedTransitioning(isPresenting: false)
        
        return animationController
    }
    
    // MARK:
}


















