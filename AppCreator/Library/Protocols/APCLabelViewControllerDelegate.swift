//
//  APCLabelViewControllerDelegate.swift
//  AppCreator
//
//  Created by Andre Muis on 6/1/16.
//  Copyright © 2016 Andre Muis. All rights reserved.
//

protocol APCLabelViewControllerDelegate
{
    func labelViewController(viewController : APCLabelViewController, addLabel label : APCLabel)
    
    func labelViewController(viewController : APCLabelViewController, didModifyLabel label : APCLabel)
    
    func labelViewController(viewController : APCLabelViewController, deleteLabel label : APCLabel)
}
