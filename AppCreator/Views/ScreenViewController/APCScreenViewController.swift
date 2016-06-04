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
        
        if let screen = self.screen
        {
            self.navigationItem.title = screen.name
            
            session.refreshInterfaceObjectList(screen.interfaceObjectList)
            
            self.session.addObservers(screen.interfaceObjectList)
        }
    }
    
    deinit
    {
        self.session.clearInterfaceObjectList()
        
        if let screen = self.screen
        {
            self.session.removeObservers(screen.interfaceObjectList)
        }
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
}


















