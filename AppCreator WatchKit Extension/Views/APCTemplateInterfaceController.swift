//
//  APCTemplateInterfaceController.swift
//  AppCreator WatchKit Extension
//
//  Created by Andre Muis on 5/26/16.
//  Copyright © 2016 Andre Muis. All rights reserved.
//

import Foundation
import WatchConnectivity
import WatchKit

class APCTemplateInterfaceController: WKInterfaceController,
    WCSessionDelegate,
    APCButtonTableRowControllerDelegate
{
    @IBOutlet var table : WKInterfaceTable!
    
    let extensionDelegate : ExtensionDelegate

    override init()
    {
        self.extensionDelegate = WKExtension.sharedExtension().delegate as! ExtensionDelegate
        
        super.init()
    }
    
    override func awakeWithContext(context: AnyObject?)
    {
        super.awakeWithContext(context)
        
        if self == WKExtension.sharedExtension().rootInterfaceController
        {
            if WCSession.isSupported()
            {
                if let session : WCSession = self.extensionDelegate.session
                {
                    session.delegate = self
                    session.activateSession()   
                }
            }
        }
        else
        {
            if let context : [String : AnyObject] = context as? [String : AnyObject],
                screen : APCScreen = context[APCConstants.screenKey] as? APCScreen
            {
                self.refresh(screen)
            }
        }
    }
    
    override func willActivate()
    {
        self.extensionDelegate.session?.activateSession()
    }

    func session(session: WCSession, didReceiveMessage message: [String : AnyObject], replyHandler: ([String : AnyObject]) -> Void)
    {
        if let actionAsString : String = message[APCConstants.actionKey] as? String,
            action : APCWatchAppAction = APCWatchAppAction(rawValue: actionAsString)
        {
            switch action
            {
            case APCWatchAppAction.RefreshScreen:
                if let screenData : NSData = message[APCConstants.screenDataKey] as? NSData,
                    screen : APCScreen = APCKeyedUnarchiver.unarchiveObjectWithData(screenData) as? APCScreen
                {
                    self.extensionDelegate.screenList = nil

                    self.popToRootController()
                    self.refresh(screen)
                }
                
            case APCWatchAppAction.ClearScreen:
                self.setTitle("")
                self.table.setRowTypes([])
                
            case APCWatchAppAction.InsertInterfaceObject:
                if let objectData : NSData = message[APCConstants.objectDataKey] as? NSData,
                    object : APCInterfaceObject = APCKeyedUnarchiver.unarchiveObjectWithData(objectData) as? APCInterfaceObject,
                    index : Int = message[APCConstants.indexKey] as? Int
                {
                    let indexSet : NSIndexSet = NSIndexSet(index: index)
                    
                    if let button = object as? APCButton
                    {
                        self.table.insertRowsAtIndexes(indexSet, withRowType: String(APCButtonTableRowController.self))
                    
                        if let rowController = self.table.rowControllerAtIndex(index) as? APCButtonTableRowController
                        {
                            rowController.delegate = self
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
                        
                        replyHandler([APCConstants.transferFileWithImageIdAsStringKey : image.id.UUIDString])
                    }
                    else if let label = object as? APCLabel
                    {
                        self.table.insertRowsAtIndexes(indexSet, withRowType: String(APCLabelTableRowController.self))
                        
                        if let rowController = self.table.rowControllerAtIndex(index) as? APCLabelTableRowController
                        {
                            rowController.label = label
                        }
                    }
                    else
                    {
                        print("Interface object not handled.")
                    }
                }
                
            case APCWatchAppAction.ModifyInterfaceObject:
                if let objectData : NSData = message[APCConstants.objectDataKey] as? NSData,
                    object : APCInterfaceObject = APCKeyedUnarchiver.unarchiveObjectWithData(objectData) as? APCInterfaceObject,
                    index : Int = self.indexOfTableRowControllerWithInterfaceObjectId(object.id),
                    rowController : APCTableRowController = self.table.rowControllerAtIndex(index) as? APCTableRowController
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
                        
                        replyHandler([APCConstants.transferFileWithImageIdAsStringKey : image.id.UUIDString])
                    }
                    else if let label = object as? APCLabel
                    {
                        if let labelController = rowController as? APCLabelTableRowController
                        {
                            labelController.label = label
                        }
                    }
                    else
                    {
                        print("Interface object not handled.")
                    }
                }
                
            case APCWatchAppAction.DeleteInterfaceObject:
                if let objectData : NSData = message[APCConstants.objectDataKey] as? NSData,
                    object : APCInterfaceObject = APCKeyedUnarchiver.unarchiveObjectWithData(objectData) as? APCInterfaceObject,
                    index : Int = self.indexOfTableRowControllerWithInterfaceObjectId(object.id)
                {
                    self.table.removeRowsAtIndexes(NSIndexSet(index: index))
                }
            
            case APCWatchAppAction.Run:
                if let screenListData : NSData = message[APCConstants.screenListDataKey] as? NSData,
                    screenList : APCScreenList = APCKeyedUnarchiver.unarchiveObjectWithData(screenListData) as? APCScreenList
                {
                    self.extensionDelegate.screenList = screenList
                    
                    if let initialScreenId : NSUUID = screenList.initialScreenId,
                        screen : APCScreen = screenList.screenWithId(initialScreenId)
                    {
                        self.popToRootController()
                        self.refresh(screen)
                    }
                }
            }
        }
    }
    
    func refresh(screen: APCScreen)
    {
        self.setTitle(screen.title)
        
        var rowTypes : [String] = [String]()
        
        for interfaceObject : APCInterfaceObject in screen.interfaceObjectList
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

        self.table.setRowTypes(rowTypes)
        
        for index in 0 ..< screen.interfaceObjectList.count
        {
            let rowController : APCTableRowController? = self.table.rowControllerAtIndex(index) as? APCTableRowController
            
            if let interfaceObject : APCInterfaceObject = screen.interfaceObjectList[index]
            {
                if let button = interfaceObject as? APCButton,
                    rowController = rowController as? APCButtonTableRowController
                {
                    rowController.delegate = self
                    rowController.button = button
                }
                else if let image = interfaceObject as? APCImage,
                    rowController = rowController as? APCImageTableRowController
                {
                    rowController.image = image
                }
                else if let label = interfaceObject as? APCLabel,
                    rowController = rowController as? APCLabelTableRowController
                {
                    rowController.label = label
                }
            }
        }
    }

    // MARK: WCSessionDelegate

    func session(session: WCSession, didReceiveFile file: WCSessionFile)
    {
        if let imageIdAsString : String = file.metadata?[APCConstants.imageIdAsStringKey] as? String,
            imageId : NSUUID = NSUUID(UUIDString: imageIdAsString)
        {
            let image : APCImage = APCImage(id: imageId)
            
            if let path : String = image.fileURL.path
            {
                if NSFileManager.defaultManager().fileExistsAtPath(path) == true
                {
                    do
                    {
                        try NSFileManager.defaultManager().removeItemAtURL(image.fileURL)
                    }
                    catch let error
                    {
                        print(error)
                    }
                }
            }
            
            do
            {
                try NSFileManager.defaultManager().copyItemAtURL(file.fileURL, toURL: image.fileURL)
            }
            catch let error
            {
                print(error)
            }
            
            if let imageData : NSData = NSData(contentsOfURL: image.fileURL),
                uiImage : UIImage = UIImage(data: imageData)
            {
                image.uiImage = uiImage
                
                if let index : Int = self.indexOfTableRowControllerWithInterfaceObjectId(imageId),
                    imageRowController : APCImageTableRowController = self.table.rowControllerAtIndex(index) as? APCImageTableRowController
                {
                    imageRowController.interfaceImage.setImage(uiImage)
                }
            }
        }
    }
    
    // MARK: APCButtonTableRowControllerDelegate
    
    func buttonTableRowControllerDidTap(rowController: APCButtonTableRowController)
    {
        if let pushToScreenId : NSUUID = rowController.button?.pushToScreenId,
            screen : APCScreen = self.extensionDelegate.screenList?.screenWithId(pushToScreenId)
        {
            let context : Dictionary<String, AnyObject> =
                [
                    APCConstants.screenKey : screen
                ]
            
            self.pushControllerWithName(String(APCTemplateInterfaceController.self), context: context)
        }
    }
    
    // MARK:

    func indexOfTableRowControllerWithInterfaceObjectId(id: NSUUID) -> Int?
    {
        var index : Int? = nil
        
        for someIndex : Int in 0 ..< self.table.numberOfRows
        {
            if let rowController : APCTableRowController = self.table.rowControllerAtIndex(someIndex) as? APCTableRowController
            {
                if rowController.interfaceObjectId == id
                {
                    index = someIndex
                }
            }
        }
        
        return index
    }
}
















