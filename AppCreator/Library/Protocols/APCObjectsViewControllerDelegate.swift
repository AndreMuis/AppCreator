//
//  APCObjectsViewControllerProtocol.swift
//  AppCreator
//
//  Created by Andre Muis on 5/31/16.
//  Copyright © 2016 Andre Muis. All rights reserved.
//

protocol APCObjectsViewControllerDelegate
{
    func objectsViewController(viewController : APCObjectsViewController, appendInterfaceObject object : APCInterfaceObject)
    
    func objectsViewController(viewController : APCObjectsViewController, didModifyInterfaceObject object : APCInterfaceObject)
    
    func objectsViewController(viewController : APCObjectsViewController, deleteInterfaceObject object : APCInterfaceObject)
}
