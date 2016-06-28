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
    @IBOutlet var interfaceButton : WKInterfaceButton!

    var delegate : APCButtonTableRowControllerDelegate?
    
    var button : APCButton?
    {
        didSet
        {
            self.interfaceButton.setTitle(self.button?.title ?? "")
        }
    }

    var interfaceObjectId : NSUUID?
    {
        return self.button?.id
    }
    
    override init()
    {
        super.init()
        
        self.delegate = nil
        self.button = nil
    }
    
    @IBAction func tap()
    {
        if let delegate : APCButtonTableRowControllerDelegate = self.delegate
        {
            delegate.buttonTableRowControllerDidTap(self)
        }
    }
}















