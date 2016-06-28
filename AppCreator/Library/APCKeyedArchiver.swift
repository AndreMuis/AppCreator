//
//  APCKeyedArchiver.swift
//  AppCreator
//
//  Created by Andre Muis on 6/27/16.
//  Copyright © 2016 Andre Muis. All rights reserved.
//

import Foundation

class APCKeyedArchiver : NSKeyedArchiver
{
    override class func archivedDataWithRootObject(rootObject: AnyObject) -> NSData
    {
        NSKeyedArchiver.setClassName(String(APCScreenList.self), forClass: APCScreenList.self)
        NSKeyedArchiver.setClassName(String(APCScreen.self), forClass: APCScreen.self)
        NSKeyedArchiver.setClassName(String(APCInterfaceObjectList.self), forClass: APCInterfaceObjectList.self)
        NSKeyedArchiver.setClassName(String(APCButton.self), forClass: APCButton.self)
        NSKeyedArchiver.setClassName(String(APCImage.self), forClass: APCImage.self)
        NSKeyedArchiver.setClassName(String(APCLabel.self), forClass: APCLabel.self)
        
        let data : NSData = super.archivedDataWithRootObject(rootObject)
        
        return data
    }
}