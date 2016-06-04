//
//  APCImageTableRowController.swift
//  AppCreator
//
//  Created by Andre Muis on 5/31/16.
//  Copyright © 2016 Andre Muis. All rights reserved.
//

import Foundation
import WatchKit

class APCImageTableRowController : NSObject, APCTableRowController
{
    @IBOutlet var image : WKInterfaceImage!
    
    var interfaceObjectId : NSUUID?
    
    override init()
    {
        super.init()
        
        self.interfaceObjectId = nil
    }
}
