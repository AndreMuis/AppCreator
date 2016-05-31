//
//  APCScreenViewController.swift
//  AppCreator
//
//  Created by Andre Muis on 5/27/16.
//  Copyright © 2016 Andre Muis. All rights reserved.
//

import UIKit

class APCScreenViewController: UIViewController, APCObjectListViewControllerDelegate, APCObjectsViewControllerDelegate
{
    var objectsViewController : APCObjectsViewController?
    
    var session : APCSession?
    var screen : APCScreen?
    var selectedIndex : Int?

    required init?(coder aDecoder: NSCoder)
    {
        super.init(coder: aDecoder)
        
        self.objectsViewController = nil
        
        self.session = nil
        self.screen = nil
        self.selectedIndex = nil
    }
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        self.navigationItem.title = self.screen!.name
    }
    
    override func viewDidAppear(animated: Bool)
    {
        self.session?.refreshInterfaceObjectList(self.screen!.interfaceObjectList)
    }
    
    override func viewWillDisappear(animated: Bool)
    {
        self.session?.clearInterfaceObjectList()
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?)
    {
        if let viewController = segue.destinationViewController as? APCObjectListViewController
        {
            viewController.delegate = self
            viewController.objectList = self.screen?.interfaceObjectList
        }
        else if let viewController = segue.destinationViewController as? APCObjectsViewController
        {
            viewController.delegate = self
            self.objectsViewController = viewController
        }
    }
    
    // MARK: APCObjectListViewControllerDelegate
    
    func objectListViewController(viewController: APCObjectListViewController, didSelectInterfaceObjectAtIndex index: Int)
    {
        if let button = self.screen?.interfaceObjectList[index] as? APCButton
        {
            self.selectedIndex = index

            self.objectsViewController?.interfaceObject = button
        }
    }
    
    func objectListViewController(viewController: APCObjectListViewController, didMoveItemAtIndex sourceIndex: Int, toIndex destinationIndex: Int)
    {
        if self.screen!.interfaceObjectList.move(objectAtIndex: sourceIndex, toIndex: destinationIndex) == true
        {
            self.session?.deleteInterfaceObject(atIndex: sourceIndex)

            let button : APCButton = self.screen!.interfaceObjectList[destinationIndex] as! APCButton
            self.session?.insertInterfaceObject(button, atIndex: destinationIndex)
        }
    }
    
    // MARK: APCObjectsViewControllerProtocol
    
    func objectsViewController(viewController: APCObjectsViewController, appendInterfaceObject object: APCInterfaceObject)
    {
        if let list = self.screen?.interfaceObjectList
        {
            list.add(object: object)
         
            self.session?.insertInterfaceObject(object as! APCButton, atIndex: list.count - 1)
        }
    }

    func objectsViewController(viewController: APCObjectsViewController, didModifyInterfaceObject object: APCInterfaceObject)
    {
        if let button = self.screen?.interfaceObjectList[self.selectedIndex!] as? APCButton
        {
            self.session?.modifyInterfaceObject(button, atIndex: self.selectedIndex!)
        }
    }

    func objectsViewController(viewController: APCObjectsViewController, deleteInterfaceObject object: APCInterfaceObject)
    {
        if self.screen!.interfaceObjectList.remove(objectAtIndex: self.selectedIndex!) == true
        {
            self.session?.deleteInterfaceObject(atIndex: self.selectedIndex!)
        }
    }

    // MARK:
}


















