//
//  NSCoding+Archive.swift
//  AppCreator
//
//  Created by Andre Muis on 6/1/16.
//  Copyright © 2016 Andre Muis. All rights reserved.
//

import Foundation

extension NSCoding
{
    func archivedData() -> NSData
    {
        NSKeyedArchiver.setClassName("APCScreenList", forClass: APCScreenList.self)
        NSKeyedArchiver.setClassName("APCScreen", forClass: APCScreen.self)
        NSKeyedArchiver.setClassName("APCInterfaceObjectList", forClass: APCInterfaceObjectList.self)
        NSKeyedArchiver.setClassName("APCButton", forClass: APCButton.self)
        NSKeyedArchiver.setClassName("APCImage", forClass: APCImage.self)
        NSKeyedArchiver.setClassName("APCLabel", forClass: APCLabel.self)
        
        let data : NSData = NSKeyedArchiver.archivedDataWithRootObject(self)
        
        return data
    }
}
