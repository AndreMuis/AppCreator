//
//  ExtensionDelegate.swift
//  AppCreator WatchKit Extension
//
//  Created by Andre Muis on 5/26/16.
//  Copyright © 2016 Andre Muis. All rights reserved.
//

import WatchConnectivity
import WatchKit

class ExtensionDelegate: NSObject, WKExtensionDelegate
{
    let session : WCSession?
    var screenList : APCScreenList?

    override init()
    {
        if WCSession.isSupported()
        {
            self.session = WCSession.defaultSession()
        }
        else
        {
            self.session = nil
        }

        self.screenList = nil
        
        super.init()
    }

    func applicationDidFinishLaunching()
    {
    }

    func applicationDidBecomeActive()
    {
    }

    func applicationWillResignActive()
    {
    }
}
