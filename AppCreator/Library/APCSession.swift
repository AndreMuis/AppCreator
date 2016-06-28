//
//  APCSession.swift
//  AppCreator
//
//  Created by Andre Muis on 5/30/16.
//  Copyright © 2016 Andre Muis. All rights reserved.
//

import WatchConnectivity

class APCSession : NSObject, WCSessionDelegate
{
    let session : WCSession?

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
            
        super.init()
        
        if WCSession.isSupported()
        {
            self.session!.delegate = self
        }
    }
    
    private var objectsContext = 0
    private var selectedInterfaceObjectContext = 0
    private var interfaceObjectContext = 0
    
    func addObservers(list: APCInterfaceObjectList)
    {
        list.addObjectsObserver(self, context: &self.objectsContext)
        
        list.addObserver(self,
                         forKeyPath: APCConstants.selectedObjectKeyPath,
                         options: NSKeyValueObservingOptions([.New, .Old]),
                         context: &self.selectedInterfaceObjectContext)
    }

    func removeObservers(list: APCInterfaceObjectList)
    {
        list.removeObjectsObserver(self)
        
        list.removeObserver(self, forKeyPath: APCConstants.selectedObjectKeyPath)
    }

    override func observeValueForKeyPath(keyPath: String?, ofObject object: AnyObject?, change: [String : AnyObject]?, context: UnsafeMutablePointer<Void>)
    {
        if (context == &self.objectsContext)
        {
            if let changeRaw : UInt = change?[APCConstants.kindKey] as? UInt,
                keyValueChange : NSKeyValueChange = NSKeyValueChange(rawValue: changeRaw),
                indexSet : NSIndexSet = change?[APCConstants.indexesKey] as? NSIndexSet
            {
                switch keyValueChange
                {
                case NSKeyValueChange.Setting:
                    break
                    
                case NSKeyValueChange.Insertion:
                    if let objects : [APCInterfaceObject] = change?[APCConstants.newKey] as? [APCInterfaceObject],
                        object : APCInterfaceObject = objects[0]
                    {
                        self.insertInterfaceObject(object, atIndex: indexSet.firstIndex)
                    }
                    
                case NSKeyValueChange.Removal:
                    if let objects : [APCInterfaceObject] = change?[APCConstants.oldKey] as? [APCInterfaceObject],
                        object : APCInterfaceObject = objects[0]
                    {
                        self.deleteInterfaceObject(object)
                    }
                    
                case NSKeyValueChange.Replacement:
                    break
                }
            }
        }
        else if (context == &self.selectedInterfaceObjectContext)
        {
            if let button = change?[APCConstants.oldKey] as? APCButton
            {
                button.removeObserver(self, forKeyPath: APCConstants.titleKeyPath)
            }
            
            if let button = change?[APCConstants.newKey] as? APCButton
            {
                button.addObserver(self,
                                   forKeyPath: APCConstants.titleKeyPath,
                                   options: NSKeyValueObservingOptions([.New]),
                                   context: &self.interfaceObjectContext)
            }
            
            if let image = change?[APCConstants.oldKey] as? APCImage
            {
                image.removeObserver(self, forKeyPath: APCConstants.uiImageKeyPath)
            }
            
            if let image = change?[APCConstants.newKey] as? APCImage
            {
                image.addObserver(self,
                                  forKeyPath: APCConstants.uiImageKeyPath,
                                  options: NSKeyValueObservingOptions([.New]),
                                  context: &self.interfaceObjectContext)
            }

            if let label = change?[APCConstants.oldKey] as? APCLabel
            {
                label.removeObserver(self, forKeyPath: APCConstants.textKeyPath)
            }

            if let label = change?[APCConstants.newKey] as? APCLabel
            {
                label.addObserver(self,
                                  forKeyPath: APCConstants.textKeyPath,
                                  options: NSKeyValueObservingOptions([.New]),
                                  context: &self.interfaceObjectContext)
            }
        }
        else if (context == &self.interfaceObjectContext)
        {
            if let object = object as? APCInterfaceObject
            {
                self.modifyInterfaceObject(object)
            }
        }
        else
        {
            print("KVO context not handled. context = \(context)")
        }
    }
    
    func activate()
    {
        if let session = self.session
        {
            session.activateSession()
        }
    }

    func refreshScreen(screen: APCScreen)
    {
        let message : [String : AnyObject] =
            [
                APCConstants.actionKey : APCWatchAppAction.RefreshScreen.rawValue,
                APCConstants.screenDataKey : APCKeyedArchiver.archivedDataWithRootObject(screen)
            ]
        
        self.sendMessage(message)
    }

    func clearScreen()
    {
        let message : [String : AnyObject] =
            [
                APCConstants.actionKey : APCWatchAppAction.ClearScreen.rawValue
            ]
        
        self.sendMessage(message)
    }
    
    func insertInterfaceObject(object: APCInterfaceObject, atIndex index: Int)
    {
        let message : [String : AnyObject] =
            [
                APCConstants.actionKey : APCWatchAppAction.InsertInterfaceObject.rawValue,
                APCConstants.objectDataKey : APCKeyedArchiver.archivedDataWithRootObject(object),
                APCConstants.indexKey : index
            ]

        self.sendMessage(message)
    }
    
    func modifyInterfaceObject(object: APCInterfaceObject)
    {
        let message : [String : AnyObject] =
            [
                APCConstants.actionKey : APCWatchAppAction.ModifyInterfaceObject.rawValue,
                APCConstants.objectDataKey : APCKeyedArchiver.archivedDataWithRootObject(object)
            ]
        
        self.sendMessage(message)
    }

    func deleteInterfaceObject(object: APCInterfaceObject)
    {
        let message : [String : AnyObject] =
            [
                APCConstants.actionKey : APCWatchAppAction.DeleteInterfaceObject.rawValue,
                APCConstants.objectDataKey : APCKeyedArchiver.archivedDataWithRootObject(object)
            ]
        
        self.sendMessage(message)
    }

    func runWatchApp(screenList: APCScreenList)
    {
        let message : [String : AnyObject] =
            [
                APCConstants.actionKey : APCWatchAppAction.Run.rawValue,
                APCConstants.screenListDataKey : APCKeyedArchiver.archivedDataWithRootObject(screenList)
            ]
        
        self.sendMessage(message)
    }
    
    func sendMessage(message : [String : AnyObject])
    {
        if let session = self.session
        {
            session.sendMessage(message, replyHandler:
                { (reply) in
                    if let imageIdAsString : String = reply[APCConstants.transferFileWithImageIdAsStringKey] as? String,
                        imageId : NSUUID = NSUUID(UUIDString: imageIdAsString)
                    {
                        let fileURL : NSURL = APCImage.getFileURL(id: imageId)
                        
                        session.transferFile(fileURL, metadata: [APCConstants.imageIdAsStringKey : imageIdAsString])
                    }
                })
                { (error) in
                    print(error)
                }
        }
    }
}















