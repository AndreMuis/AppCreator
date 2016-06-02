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

    required init?(coder aDecoder: NSCoder)
    {
        super.init(coder: aDecoder)
        
        self.objectsViewController = nil
        
        self.session = nil
        self.screen = nil
    }
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        self.navigationItem.title = self.screen!.name

        self.session?.refreshInterfaceObjectList(self.screen!.interfaceObjectList)
    }
    
    deinit
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
        if let object : APCInterfaceObject = self.screen?.interfaceObjectList[index]
        {
            self.objectsViewController?.interfaceObject = object
        }
    }
    
    func objectListViewController(viewController: APCObjectListViewController, didMoveItemAtIndex sourceIndex: Int, toIndex destinationIndex: Int)
    {
        if self.screen!.interfaceObjectList.move(objectAtIndex: sourceIndex, toIndex: destinationIndex) == true
        {
            self.session?.deleteInterfaceObject(atIndex: sourceIndex)

            let object : APCInterfaceObject = self.screen!.interfaceObjectList[destinationIndex]!
            self.session?.insertInterfaceObject(object, atIndex: destinationIndex)
        }
    }
    
    // MARK: APCObjectsViewControllerDelegate
    
    func objectsViewController(viewController: APCObjectsViewController, appendInterfaceObject object: APCInterfaceObject)
    {
        if let list = self.screen?.interfaceObjectList
        {
            list.add(object: object)
         
            self.session?.insertInterfaceObject(object, atIndex: list.count - 1)
        }
    }

    func objectsViewController(viewController: APCObjectsViewController, didModifyInterfaceObject object: APCInterfaceObject)
    {
        if let index : Int = self.screen!.interfaceObjectList.indexOfObject(object)
        {
            self.session?.modifyInterfaceObject(object, atIndex: index)
        }
    }

    func objectsViewController(viewController: APCObjectsViewController, deleteInterfaceObject object: APCInterfaceObject)
    {
        if let list = self.screen?.interfaceObjectList,
            let index : Int = self.screen!.interfaceObjectList.indexOfObject(object)
        {
            list.remove(objectAtIndex: index)

            self.session?.deleteInterfaceObject(atIndex: index)
        }
    }

    // MARK:
}


















