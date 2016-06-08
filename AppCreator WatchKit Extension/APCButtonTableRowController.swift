//
//  APCButtonTableRowController.swift
//  AppCreator
//
//  Created by Andre Muis on 5/31/16.
//  Copyright © 2016 Andre Muis. All rights reserved.
//

import Foundation
import WatchKit

class APCButtonTableRowController : NSObject, APCTableRowController
{
    @IBOutlet var buttonOutlet : WKInterfaceButton!

    var button : APCButton?
    {
        didSet
        {
            if let button = self.button
            {
                self.buttonOutlet.setTitle(button.title)
            }
            else
            {
                self.buttonOutlet.setTitle("")
            }

            self.buttonOutlet.setTitle(self.button?.title ?? "")
        }
    }

    var interfaceObjectId : NSUUID?
    {
        return self.button?.id
    }
    
    override init()
    {
        super.init()
        
        self.button = nil
    }
}