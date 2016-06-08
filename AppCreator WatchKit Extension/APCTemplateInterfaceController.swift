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
    var mode : APCWatchAppMode
    var screenList : APCScreenList?
    var screen : APCScreen?
    
    override init()
    {
        self.session = WCSession.defaultSession()
        self.mode = APCWatchAppMode.Unknown
        self.screenList = nil
        self.screen = nil
        
        super.init()
    }
    
    override func awakeWithContext(context: AnyObject?)
    {
        super.awakeWithContext(context)
        
        if context == nil
        {
            if WCSession.isSupported()
            {
                self.session.delegate = self
                self.session.activateSession()
            }
        }
        else
        {
            if let context : [String : AnyObject] = context as? [String : AnyObject],
                let modeRawValue : String = context["modeRawValue"] as? String,
                let mode : APCWatchAppMode = APCWatchAppMode(rawValue: modeRawValue),
                let screenList : APCScreenList = context["screenList"] as? APCScreenList,
                let screen : APCScreen = context["screen"] as? APCScreen
            {
                self.mode = mode
                self.screenList = screenList
                self.screen = screen
                
                self.refresh(screen)
            }
        }
    }

    override func willActivate()
    {
        super.willActivate()
    }

    func session(session: WCSession, didReceiveMessage message: [String : AnyObject], replyHandler: ([String : AnyObject]) -> Void)
    {
        NSKeyedUnarchiver.setClass(APCScreenList.self, forClassName: "APCScreenList")
        NSKeyedUnarchiver.setClass(APCScreen.self, forClassName: "APCScreen")
        NSKeyedUnarchiver.setClass(APCInterfaceObjectList.self, forClassName: "APCInterfaceObjectList")
        NSKeyedUnarchiver.setClass(APCButton.self, forClassName: "APCButton")
        NSKeyedUnarchiver.setClass(APCImage.self, forClassName: "APCImage")
        NSKeyedUnarchiver.setClass(APCLabel.self, forClassName: "APCLabel")

        if let actionAsString : String = message["action"] as? String,
            let action : APCWatchAppAction = APCWatchAppAction(rawValue: actionAsString)
        {
            switch action
            {
            case APCWatchAppAction.RefreshScreen:
                if let screenData : NSData = message["screenData"] as? NSData,
                    let screen = NSKeyedUnarchiver.unarchiveObjectWithData(screenData) as? APCScreen
                {
                    self.refresh(screen)
                
                    self.mode = APCWatchAppMode.Design
                    self.screenList = nil
                    self.screen = nil
                }
                
            case APCWatchAppAction.ClearScreen:
                self.clear()
                
            case APCWatchAppAction.InsertInterfaceObject:
                if let objectData : NSData = message["objectData"] as? NSData,
                    let object = NSKeyedUnarchiver.unarchiveObjectWithData(objectData) as? APCInterfaceObject,
                    let index : Int = message["index"] as? Int
                {
                    let indexSet : NSIndexSet = NSIndexSet(index: index)
                    
                    if let button = object as? APCButton
                    {
                        self.table.insertRowsAtIndexes(indexSet, withRowType: String(APCButtonTableRowController.self))
                    
                        if let rowController = self.table.rowControllerAtIndex(index) as? APCButtonTableRowController
                        {
                            rowController.button = button
                        }
                    }
                    else if let image = object as? APCImage
                    {
                        self.table.insertRowsAtIndexes(indexSet, withRowType: String(APCImageTableRowController.self))
                        
                        if let rowController = self.table.rowControllerAtIndex(index) as? APCImageTableRowController
                        {
                            rowController.image = image
                        }
                        
                        if image.uiImage == nil
                        {
                            replyHandler(["transferFileWithImageIdAsString" : image.id.UUIDString])
                        }
                    }
                    else if let label = object as? APCLabel
                    {
                        self.table.insertRowsAtIndexes(indexSet, withRowType: String(APCLabelTableRowController.self))
                        
                        if let rowController = self.table.rowControllerAtIndex(index) as? APCLabelTableRowController
                        {
                            rowController.label = label
                        }
                    }
                }
                
            case APCWatchAppAction.ModifyInterfaceObject:
                if let objectData : NSData = message["objectData"] as? NSData,
                    let object = NSKeyedUnarchiver.unarchiveObjectWithData(objectData) as? APCInterfaceObject,
                    let index = self.indexOfTableRowControllerWithInterfaceObjectId(object.id),
                    let rowController = self.table.rowControllerAtIndex(index)
                {
                    if let button = object as? APCButton
                    {
                        if let buttonController = rowController as? APCButtonTableRowController
                        {
                            buttonController.button = button
                        }
                    }
                    else if let image = object as? APCImage
                    {
                        if let imageController = rowController as? APCImageTableRowController
                        {
                            imageController.image = image
                        }
                        
                        replyHandler(["transferFileWithImageIdAsString" : image.id.UUIDString])
                    }
                    else if let label = object as? APCLabel
                    {
                        if let labelController = rowController as? APCLabelTableRowController
                        {
                            labelController.label = label
                        }
                    }
                }
                
            case APCWatchAppAction.DeleteInterfaceObject:
                if let objectData : NSData = message["objectData"] as? NSData,
                    let object = NSKeyedUnarchiver.unarchiveObjectWithData(objectData) as? APCInterfaceObject,
                    let index = self.indexOfTableRowControllerWithInterfaceObjectId(object.id)
                {
                    self.table.removeRowsAtIndexes(NSIndexSet(index: index))
                }
            
            case APCWatchAppAction.Run:
                if let screenListData : NSData = message["screenListData"] as? NSData,
                    let screenList = NSKeyedUnarchiver.unarchiveObjectWithData(screenListData) as? APCScreenList
                {
                    self.screenList = screenList
                    
                    if let screen : APCScreen = screenList[0]
                    {
                        self.screen = screen

                        self.refresh(screen)
                    }

                    self.mode = APCWatchAppMode.Design
                }
            }
        }
    }
    
    override func table(table: WKInterfaceTable, didSelectRowAtIndex rowIndex: Int)
    {
        super.table(table, didSelectRowAtIndex: rowIndex)
        
        if let buttonController : APCButtonTableRowController = self.table.rowControllerAtIndex(rowIndex) as? APCButtonTableRowController,
            let pushToScreenId : NSUUID = buttonController.button?.pushToScreenId,
            let screenList : APCScreenList = self.screenList,
            let screen : APCScreen = screenList.screenWithId(pushToScreenId)
        {
            let context : Dictionary<String, AnyObject> =
                [
                    "modeRawValue" : self.mode.rawValue,
                    "screenList" : screenList,
                    "screen" : screen
                ]
            
            self.pushControllerWithName("APCTemplateInterfaceController", context: context)
        }
    }
    
    func refresh(screen : APCScreen)
    {
        self.setTitle(screen.title)
        
        var rowTypes : [String] = [String]()
        
        for index in 0 ..< screen.interfaceObjectList.count
        {
            if let interfaceObject = screen.interfaceObjectList[index]
            {
                if interfaceObject is APCButton
                {
                    rowTypes.append(String(APCButtonTableRowController.self))
                }
                else if interfaceObject is APCImage
                {
                    rowTypes.append(String(APCImageTableRowController.self))
                }
                else if interfaceObject is APCLabel
                {
                    rowTypes.append(String(APCLabelTableRowController.self))
                }
            }
        }

        self.table.setRowTypes(rowTypes)
        
        for index in 0 ..< screen.interfaceObjectList.count
        {
            let rowController : APCTableRowController? = self.table.rowControllerAtIndex(index) as? APCTableRowController
            
            if let interfaceObject = screen.interfaceObjectList[index]
            {
                if let button = interfaceObject as? APCButton,
                    let rowController = rowController as? APCButtonTableRowController
                {
                    rowController.button = button
                }
                else if let image = interfaceObject as? APCImage,
                    let rowController = rowController as? APCImageTableRowController
                {
                    rowController.image = image
                }
                else if let label = interfaceObject as? APCLabel,
                    let rowController = rowController as? APCLabelTableRowController
                {
                    rowController.label = label
                }
            }
        }
    }

    func clear()
    {
        self.setTitle("")
        self.table.setRowTypes([])
    }
    
    func indexOfTableRowControllerWithInterfaceObjectId(id : NSUUID) -> Int?
    {
        var index : Int? = nil
        
        for someIndex : Int in 0 ..< self.table.numberOfRows
        {
            if let rowController = self.table.rowControllerAtIndex(someIndex) as? APCTableRowController
            {
                if rowController.interfaceObjectId == id
                {
                    index = someIndex
                }
            }
        }
        
        return index
    }
    
    func session(session: WCSession, didReceiveFile file: WCSessionFile)
    {
        if let imageIdAsString : String = file.metadata?["imageIdAsString"] as? String,
            let imageId : NSUUID = NSUUID(UUIDString: imageIdAsString)
        {
            let image : APCImage = APCImage(id: imageId)
            
            do
            {
                try NSFileManager.defaultManager().removeItemAtURL(image.fileURL)
            }
            catch let error
            {
                print(error)
            }
            
            do
            {
                try NSFileManager.defaultManager().copyItemAtURL(file.fileURL, toURL: image.fileURL)
            }
            catch let error
            {
                print(error)
            }
            
            if let imageData = NSData(contentsOfURL: image.fileURL),
                let uiImage = UIImage(data: imageData)
            {
                image.updateUIImage(uiImage)
                
                if let index = self.indexOfTableRowControllerWithInterfaceObjectId(imageId),
                    let rowController = self.table.rowControllerAtIndex(index),
                    let imageRowController = rowController as? APCImageTableRowController
                    {
                        imageRowController.imageOutlet.setImage(uiImage)
                    }
            }
        }
    }
    
    override func didDeactivate()
    {
        super.didDeactivate()
    }
}
















