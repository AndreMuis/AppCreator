//
//  AppDelegate.swift
//  AppCreator
//
//  Created by Andre Muis on 5/26/16.
//  Copyright © 2016 Andre Muis. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate
{
    var window: UIWindow?

    let session : APCSession
    let screenList : APCScreenList
    
    override init()
    {
        self.session = APCSession()
        self.screenList = APCScreenList()
        
        super.init()
    }
    
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool
    {
        self.session.activate()
    
        return true
    }
}

