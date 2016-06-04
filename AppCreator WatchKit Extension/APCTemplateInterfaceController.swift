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

        super.init()
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

            for index in 0 ..< list!.count
            {
                let interfaceObject = list![index]!
                
                if let button = interfaceObject as? APCButton
                {
                    self.table.insertRowsAtIndexes(NSIndexSet(index: index), withRowType: "APCButtonTableRowController")
                    
                    let rowController = self.table.rowControllerAtIndex(index) as! APCButtonTableRowController
                    rowController.interfaceObjectId = button.id
                    rowController.button.setTitle(button.title)
                }
                else if let image = interfaceObject as? APCImage
                {
                    self.table.insertRowsAtIndexes(NSIndexSet(index: index), withRowType: "APCImageTableRowController")
                    
                    let rowController = self.table.rowControllerAtIndex(index) as! APCImageTableRowController
                    rowController.interfaceObjectId = image.id
                    rowController.image.setImage(image.uiImage)
                }
                else if let label = interfaceObject as? APCLabel
                {
                    self.table.insertRowsAtIndexes(NSIndexSet(index: index), withRowType: "APCLabelTableRowController")
                    
                    let rowController = self.table.rowControllerAtIndex(index) as! APCLabelTableRowController
                    rowController.interfaceObjectId = label.id
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
            {111
                self.table.insertRowsAtIndexes(indexSet, withRowType: "APCButtonTableRowController")
            
                let rowController = self.table.rowControllerAtIndex(index) as! APCButtonTableRowController
                rowController.interfaceObjectId = button.id
                rowController.button.setTitle(button.title)
            }
            else if let image = object as? APCImage
            {
                self.table.insertRowsAtIndexes(indexSet, withRowType: "APCImageTableRowController")
                
                let rowController = self.table.rowControllerAtIndex(index) as! APCImageTableRowController
                rowController.interfaceObjectId = image.id
                rowController.image.setImage(image.uiImage)
            }
            else if let label = object as? APCLabel
            {
                self.table.insertRowsAtIndexes(indexSet, withRowType: "APCLabelTableRowController")
                
                let rowController = self.table.rowControllerAtIndex(index) as! APCLabelTableRowController
                rowController.interfaceObjectId = label.id
                rowController.label.setText(label.text)
            }

            break
            
        case APCInterfaceObjectListAction.Modify:
            if let objectData : NSData = message["objectData"] as? NSData,
                let object = NSKeyedUnarchiver.unarchiveObjectWithData(objectData) as? APCInterfaceObject,
                let index = self.indexOfTableRowControllerWithInterfaceObjectId(object.id),
                let rowController = self.table.rowControllerAtIndex(index)
            {
                if let button = object as? APCButton
                {
                    let buttonController = rowController as! APCButtonTableRowController
                    buttonController.button.setTitle(button.title)
                }
                else if let image = object as? APCImage
                {
                    let imageController = rowController as! APCImageTableRowController
                    imageController.image.setImage(image.uiImage)
                }
                else if let label = object as? APCLabel
                {
                    let labelController = rowController as! APCLabelTableRowController
                    labelController.label.setText(label.text)
                }
            }
            
            break
            
        case APCInterfaceObjectListAction.Delete:
            if let objectData : NSData = message["objectData"] as? NSData,
                let object = NSKeyedUnarchiver.unarchiveObjectWithData(objectData) as? APCInterfaceObject,
                let index = self.indexOfTableRowControllerWithInterfaceObjectId(object.id)
            {
                self.table.removeRowsAtIndexes(NSIndexSet(index: index))
            }
        
            break
        }
    }

    func indexOfTableRowControllerWithInterfaceObjectId(id : NSUUID) -> Int?
    {
        var index : Int? = nil
        
        for someIndex : Int in 0 ..< self.table.numberOfRows
        {
            let rowController = self.table.rowControllerAtIndex(someIndex) as! APCTableRowController
            
            if rowController.interfaceObjectId == id
            {
                index = someIndex
            }
        }
        
        return index
    }
    
    func session(session: WCSession, didReceiveFile file: WCSessionFile)
    {
        let imageId : NSUUID = NSUUID(UUIDString: file.metadata!["imageIdAsString"] as! String)!
        
        let documentDirectoryURLs : [NSURL] = NSFileManager.defaultManager().URLsForDirectory(NSSearchPathDirectory.DocumentDirectory,
                                                                                              inDomains: NSSearchPathDomainMask.UserDomainMask)
        
        let documentDirectoryURL : NSURL = documentDirectoryURLs[0]
        
        let fileDestinationURL = documentDirectoryURL.URLByAppendingPathComponent("\(imageId.UUIDString).png")
        
        do
        {
            try NSFileManager.defaultManager().removeItemAtURL(fileDestinationURL)
        }
        catch let error
        {
            print(error)
        }
        
        do
        {
            try NSFileManager.defaultManager().copyItemAtURL(file.fileURL, toURL: fileDestinationURL)
        }
        catch let error
        {
            print(error)
        }
        
        let uiImage = UIImage(data: NSData(contentsOfURL: fileDestinationURL)!)
        
        if let index = self.indexOfTableRowControllerWithInterfaceObjectId(imageId),
            let rowController = self.table.rowControllerAtIndex(index),
            let imageRowController = rowController as? APCImageTableRowController
            {
                imageRowController.image.setImage(uiImage)
            }
    }
    
    override func didDeactivate()
    {
        super.didDeactivate()
    }
}
















