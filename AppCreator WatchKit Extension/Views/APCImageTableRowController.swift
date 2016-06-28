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
    @IBOutlet var interfaceImage : WKInterfaceImage!
    
    var image : APCImage?
    {
        didSet
        {
            self.interfaceImage.setImage(self.image?.uiImage)
        }
    }

    var interfaceObjectId : NSUUID?
    {
        return self.image?.id
    }
    
    override init()
    {
        super.init()
        
        self.image = nil
    }
}
