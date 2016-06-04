//
//  APCButtonViewControllerDelegate.swift
//  AppCreator
//
//  Created by Andre Muis on 5/31/16.
//  Copyright © 2016 Andre Muis. All rights reserved.
//

protocol APCButtonViewControllerDelegate
{
    func buttonViewController(viewController : APCButtonViewController, addButton button : APCButton)

    func buttonViewController(viewController : APCButtonViewController, deleteButton button : APCButton)
}
