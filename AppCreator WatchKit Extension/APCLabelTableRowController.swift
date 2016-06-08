//
//  APCLabelTableRowController.swift
//  AppCreator
//
//  Created by Andre Muis on 5/31/16.
//  Copyright © 2016 Andre Muis. All rights reserved.
//

import Foundation
import WatchKit

class APCLabelTableRowController : NSObject, APCTableRowController
{
    @IBOutlet var labelOutlet : WKInterfaceLabel!
    
    var label : APCLabel?
    {
        didSet
        {
            if let label = self.label
            {
                self.labelOutlet.setText(label.text)
            }
            else
            {
                self.labelOutlet.setText("")
            }
        }
    }

    var interfaceObjectId : NSUUID?
    {
        return self.label?.id
    }
    
    override init()
    {
        super.init()
        
        self.label = nil
    }
}
