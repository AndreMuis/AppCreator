//
//  APCKeyedUnarchiver.swift
//  AppCreator
//
//  Created by Andre Muis on 6/27/16.
//  Copyright © 2016 Andre Muis. All rights reserved.
//

import Foundation

class APCKeyedUnarchiver : NSKeyedUnarchiver
{
    override class func unarchiveObjectWithData(data: NSData) -> AnyObject?
    {
        NSKeyedUnarchiver.setClass(APCScreenList.self, forClassName: String(APCScreenList.self))
        NSKeyedUnarchiver.setClass(APCScreen.self, forClassName: String(APCScreen.self))
        NSKeyedUnarchiver.setClass(APCInterfaceObjectList.self, forClassName: String(APCInterfaceObjectList.self))
        NSKeyedUnarchiver.setClass(APCButton.self, forClassName: String(APCButton.self))
        NSKeyedUnarchiver.setClass(APCImage.self, forClassName: String(APCImage.self))
        NSKeyedUnarchiver.setClass(APCLabel.self, forClassName: String(APCLabel.self))
                
        let object : AnyObject? = super.unarchiveObjectWithData(data)
        
        return object
    }
}