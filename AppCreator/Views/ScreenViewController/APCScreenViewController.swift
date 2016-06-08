//
//  APCScreenViewController.swift
//  AppCreator
//
//  Created by Andre Muis on 5/27/16.
//  Copyright © 2016 Andre Muis. All rights reserved.
//

import UIKit

class APCScreenViewController: UIViewController
{
    @IBOutlet weak var scrollView: UIScrollView!

    var session : APCSession
    var screen : APCScreen?

    required init?(coder aDecoder: NSCoder)
    {
        self.session = (UIApplication.sharedApplication().delegate as? AppDelegate)!.session
        self.screen = nil

        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad()
    {
        super.viewDidLoad()

        self.scrollView.delaysContentTouches = false
    
        if let screen = self.screen
        {
            self.navigationItem.title = screen.title
            
            session.refreshScreen(screen)
            
            self.session.addObservers(screen.interfaceObjectList)
        }
        
        NSNotificationCenter.defaultCenter().addObserver(self,
                                                         selector: #selector(keyboardWillShow),
                                                         name: UIKeyboardWillShowNotification,
                                                         object: nil)
        
        NSNotificationCenter.defaultCenter().addObserver(self,
                                                         selector: #selector(keyboardWillHide),
                                                         name: UIKeyboardWillHideNotification,
                                                         object: nil)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?)
    {
        if let screen = self.screen
        {
            if let viewController = segue.destinationViewController as? APCInterfaceObjectListViewController
            {
                viewController.objectList = screen.interfaceObjectList
            }
            else if let viewController = segue.destinationViewController as? APCInterfaceObjectsViewController
            {
                viewController.objectList = screen.interfaceObjectList
            }
        }
    }
    
    // MARK: Keyboard
    
    func keyboardWillShow(notification : NSNotification)
    {
        /*
        if let keyboardFrame : CGRect = (notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.CGRectValue()
        {
            self.scrollView.contentOffset = CGPoint(x: 0.0, y: 250.0)
        }
        */
    }
    
    func keyboardWillHide(notification : NSNotification)
    {
        self.scrollView.contentOffset = CGPoint(x: 0.0, y: 0.0)
    }
    
    // MARK:
    
    deinit
    {
        self.session.clearScreen()
        
        if let screen = self.screen
        {
            self.session.removeObservers(screen.interfaceObjectList)
        }
        
        NSNotificationCenter.defaultCenter().removeObserver(self,
                                                            name: UIKeyboardWillShowNotification,
                                                            object: nil)
        
        NSNotificationCenter.defaultCenter().removeObserver(self,
                                                            name: UIKeyboardWillHideNotification,
                                                            object: nil)
    }

}


















