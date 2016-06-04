//
//  APCImageViewControllerDelegate.swift
//  AppCreator
//
//  Created by Andre Muis on 6/1/16.
//  Copyright © 2016 Andre Muis. All rights reserved.
//

protocol APCImageViewControllerDelegate
{
    func imageViewController(viewController : APCImageViewController, addImage image : APCImage)
    
    func imageViewController(viewController : APCImageViewController, deleteImage image : APCImage)
}
