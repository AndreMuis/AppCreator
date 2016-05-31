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
    @IBOutlet var table : WKInterfaceTable!
    
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

    func session(session: WCSession, didReceiveMessage message: [String : AnyObject], replyHandler: ([String : AnyObject]) -> Void)
    {
        NSKeyedUnarchiver.setClass(APCInterfaceObjectList.self, forClassName: "APCInterfaceObjectList")
        NSKeyedUnarchiver.setClass(APCButton.self, forClassName: "APCButton")

        let actionAsString : String = message["action"] as! String
        let action : APCInterfaceObjectListAction = APCInterfaceObjectListAction(rawValue: actionAsString)!
        
        switch action
        {
        case APCInterfaceObjectListAction.Refresh:
            let listData : NSData = message["listData"] as! NSData
            let list = NSKeyedUnarchiver.unarchiveObjectWithData(listData) as? APCInterfaceObjectList

            var rowTypes : [String] = [String]()
            
            for index in 0 ..< list!.count
            {
                let interfaceObject = list![index]!
                
                if interfaceObject is APCButton
                {
                    rowTypes.append("APCButtonTableRowController")
                }
            }
            
            self.table.setRowTypes(rowTypes)
            
            for index in 0 ..< list!.count
            {
                let interfaceObject = list![index]!
                
                if let button = interfaceObject as? APCButton,
                    let rowController = self.table.rowControllerAtIndex(index) as? APCButtonTableRowController
                {
                    rowController.button.setTitle(button.title)
                }
            }

            break
            
        case APCInterfaceObjectListAction.Clear:
            self.table.setNumberOfRows(0, withRowType: "")

            break
            
        case APCInterfaceObjectListAction.Insert:
            let objectData : NSData = message["objectData"] as! NSData
            let button = NSKeyedUnarchiver.unarchiveObjectWithData(objectData) as? APCButton

            let index : Int = message["index"] as! Int
            
            let indexSet : NSIndexSet = NSIndexSet(index: index)
            
            self.table.insertRowsAtIndexes(indexSet, withRowType: "APCButtonTableRowController")
            
            if let rowController = self.table.rowControllerAtIndex(index) as? APCButtonTableRowController
            {
                rowController.button.setTitle(button?.title)
            }
            
            break
            
        case APCInterfaceObjectListAction.Modify:
            let objectData : NSData = message["objectData"] as! NSData
            let button = NSKeyedUnarchiver.unarchiveObjectWithData(objectData) as? APCButton
            
            let index : Int = message["index"] as! Int
            
            if let rowController = self.table.rowControllerAtIndex(index) as? APCButtonTableRowController
            {
                rowController.button.setTitle(button?.title)
            }
            
            break
            
        case APCInterfaceObjectListAction.Delete:
            let index : Int = message["index"] as! Int
            
            let indexSet : NSIndexSet = NSIndexSet(index: index)
            
            self.table.removeRowsAtIndexes(indexSet)

            break
        }
    }
    
    override func didDeactivate()
    {
        super.didDeactivate()
    }
}
















