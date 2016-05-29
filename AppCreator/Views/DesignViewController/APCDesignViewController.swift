//
//  APCDesignViewController.swift
//  AppCreator
//
//  Created by Andre Muis on 5/27/16.
//  Copyright © 2016 Andre Muis. All rights reserved.
//

import UIKit

class APCDesignViewController: UIViewController
{
    var screenViewController : APCScreenViewController?
    
    var screenList : APCScreenList?
    var screen : APCScreen?
    
    required init?(coder aDecoder: NSCoder)
    {
        super.init(coder: aDecoder)
        
        self.screenViewController = nil
        
        self.screenList = nil
        self.screen = nil
    }
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?)
    {
        if let viewController = segue.destinationViewController as? APCScreenViewController
        {
            viewController.screen = self.screen
            self.screenViewController = viewController
        }
    }
    
    @IBAction func addButtonTapped(sender: AnyObject)
    {
        if let viewController = self.screenViewController
        {
            viewController.addButton()
        }
    }

    @IBAction func deleteScreenButtonTapped(sender: AnyObject)
    {
        if let screen = self.screen
        {
            if self.screenList?.remove(screen: screen) == true
            {
                self.navigationController?.popViewControllerAnimated(true)
            }
        }
    }
}
