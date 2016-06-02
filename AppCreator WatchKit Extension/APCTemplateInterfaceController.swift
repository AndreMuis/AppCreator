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
        NSKeyedUnarchiver.setClass(APCImage.self, forClassName: "APCImage")
        NSKeyedUnarchiver.setClass(APCLabel.self, forClassName: "APCLabel")

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
                else if interfaceObject is APCImage
                {
                    rowTypes.append("APCImageTableRowController")
                }
                else if interfaceObject is APCLabel
                {
                    rowTypes.append("APCLabelTableRowController")
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
                else if let image = interfaceObject as? APCImage,
                    let rowController = self.table.rowControllerAtIndex(index) as? APCImageTableRowController
                {
                    rowController.image.setImage(image.uiImage)
                }
                else if let label = interfaceObject as? APCLabel,
                    let rowController = self.table.rowControllerAtIndex(index) as? APCLabelTableRowController
                {
                    rowController.label.setText(label.text)
                }
            }

            break
            
        case APCInterfaceObjectListAction.Clear:
            self.table.setNumberOfRows(0, withRowType: "")

            break
            
        case APCInterfaceObjectListAction.Insert:
            let objectData : NSData = message["objectData"] as! NSData
            let object = NSKeyedUnarchiver.unarchiveObjectWithData(objectData) as? APCInterfaceObject

            let index : Int = message["index"] as! Int
            let indexSet : NSIndexSet = NSIndexSet(index: index)
            
            if let button = object as? APCButton
            {
                self.table.insertRowsAtIndexes(indexSet, withRowType: "APCButtonTableRowController")
                
                if let rowController = self.table.rowControllerAtIndex(index) as? APCButtonTableRowController
                {
                    rowController.button.setTitle(button.title)
                }
            }
            else if let image = object as? APCImage
            {
                self.table.insertRowsAtIndexes(indexSet, withRowType: "APCImageTableRowController")
                
                if let rowController = self.table.rowControllerAtIndex(index) as? APCImageTableRowController
                {
                    rowController.image.setImage(image.uiImage)
                }
            }
            else if let label = object as? APCLabel
            {
                self.table.insertRowsAtIndexes(indexSet, withRowType: "APCLabelTableRowController")
                
                if let rowController = self.table.rowControllerAtIndex(index) as? APCLabelTableRowController
                {
                    rowController.label.setText(label.text)
                }
            }

            break
            
        case APCInterfaceObjectListAction.Modify:
            let objectData : NSData = message["objectData"] as! NSData
            let object = NSKeyedUnarchiver.unarchiveObjectWithData(objectData) as? APCInterfaceObject
            
            let index : Int = message["index"] as! Int

            if let button = object as? APCButton
            {
                if let rowController = self.table.rowControllerAtIndex(index) as? APCButtonTableRowController
                {
                    rowController.button.setTitle(button.title)
                }
            }
            else if let label = object as? APCLabel
            {
                if let rowController = self.table.rowControllerAtIndex(index) as? APCLabelTableRowController
                {
                    rowController.label.setText(label.text)
                }
            }
            
            break
            
        case APCInterfaceObjectListAction.Delete:
            let index : Int = message["index"] as! Int
            
            let indexSet : NSIndexSet = NSIndexSet(index: index)
            
            self.table.removeRowsAtIndexes(indexSet)

            break
        }
    }
    
    func session(session: WCSession, didReceiveFile file: WCSessionFile)
    {
        let paths : [String] = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentDirectory,
                                                                   NSSearchPathDomainMask.UserDomainMask,
                                                                   true)
        
        let filePathURL : NSURL = NSURL(fileURLWithPath: "\(paths[0])/Image.png")

        do
        {
            try NSFileManager.defaultManager().removeItemAtURL(filePathURL)
        }
        catch let error
        {
            print(error)
        }
        
        do
        {
            try NSFileManager.defaultManager().copyItemAtURL(file.fileURL, toURL: filePathURL)
        }
        catch let error
        {
            print(error)
        }
        
        let image = UIImage(data: NSData(contentsOfURL: filePathURL)!)
        
        for index in 0 ..< self.table.numberOfRows
        {
            if let rowController = self.table.rowControllerAtIndex(index) as? APCImageTableRowController
            {
                rowController.image.setImage(image)
            }
        }
    }
    
    override func didDeactivate()
    {
        super.didDeactivate()
    }
}
















