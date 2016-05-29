//
//  APCTemplateInterfaceController.swift
//  AppCreator WatchKit Extension
//
//  Created by Andre Muis on 5/26/16.
//  Copyright © 2016 Andre Muis. All rights reserved.
//

import Foundation
import WatchKit
import WatchConnectivity

class APCTemplateInterfaceController: WKInterfaceController, WCSessionDelegate
{
    @IBOutlet var label1: WKInterfaceLabel!
    @IBOutlet var image1: WKInterfaceImage!
    @IBOutlet var button1: WKInterfaceButton!
    @IBOutlet var table1: WKInterfaceTable!
    
    @IBOutlet var label2: WKInterfaceLabel!
    @IBOutlet var image2: WKInterfaceImage!
    @IBOutlet var button2: WKInterfaceButton!
    @IBOutlet var table2: WKInterfaceTable!
    
    @IBOutlet var label3: WKInterfaceLabel!
    @IBOutlet var image3: WKInterfaceImage!
    @IBOutlet var button3: WKInterfaceButton!
    @IBOutlet var table3: WKInterfaceTable!
    
    let session : WCSession

    override init()
    {
        self.session = WCSession.defaultSession()
    }
    
    override func awakeWithContext(context: AnyObject?)
    {
        super.awakeWithContext(context)
    }

    override func willActivate()
    {
        super.willActivate()
        
        if WCSession.isSupported()
        {
            self.session.delegate = self
            self.session.activateSession()
        }
        
    }

    func session(session: WCSession, didReceiveMessageData messageData: NSData, replyHandler: (NSData) -> Void)
    {
        NSKeyedUnarchiver.setClass(APCButton.self, forClassName: "APCButton")
        let button = NSKeyedUnarchiver.unarchiveObjectWithData(messageData) as? APCButton
        
        let message = "\(button!.id) \(button!.title)"
        
        let alertAction = WKAlertAction.init(title: "OK", style: WKAlertActionStyle.Cancel, handler: {})
        self.presentAlertControllerWithTitle("title", message: message, preferredStyle: WKAlertControllerStyle.Alert, actions: [alertAction])
    }
    
    override func didDeactivate()
    {
        super.didDeactivate()
    }
}












