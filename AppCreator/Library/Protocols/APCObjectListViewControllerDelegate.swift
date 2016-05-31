//
//  APCObjectListViewControllerDelegate.swift
//  AppCreator
//
//  Created by Andre Muis on 5/29/16.
//  Copyright © 2016 Andre Muis. All rights reserved.
//

import Foundation

protocol APCObjectListViewControllerDelegate
{
    func objectListViewController(viewController : APCObjectListViewController, didSelectInterfaceObjectAtIndex index : Int)

    func objectListViewController(viewController : APCObjectListViewController, didMoveItemAtIndex sourceIndex: Int, toIndex destinationIndex: Int)
}
