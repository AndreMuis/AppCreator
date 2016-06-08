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
    var session : WCSession!

    override init()
    {
        super.init()
        
        self.session = WCSession.defaultSession()

        if WCSession.isSupported()
        {
            self.session.delegate = self
        }
    }
    
    private var arrayContext = 0
    private var selectedInterfaceObjectContext = 0
    private var interfaceObjectContext = 0
    
    func addObservers(list : APCInterfaceObjectList)
    {
        list.addArrayObserver(self, context: &self.arrayContext)
        
        list.addObserver(self, forKeyPath: "selectedObject", options: NSKeyValueObservingOptions([.New, .Old]), context: &self.selectedInterfaceObjectContext)
    }

    func removeObservers(list : APCInterfaceObjectList)
    {
        list.removeArrayObserver(self)
        
        list.removeObserver(self, forKeyPath: "selectedObject")
    }

    override func observeValueForKeyPath(keyPath: String?, ofObject object: AnyObject?, change: [String : AnyObject]?, context: UnsafeMutablePointer<Void>)
    {
        if (context == &self.arrayContext)
        {
            if let indexSet = change?["indexes"] as? NSIndexSet,
                let changeRaw = change?["kind"] as? UInt,
                let keyValueChange : NSKeyValueChange = NSKeyValueChange(rawValue: changeRaw)
            {
                switch keyValueChange
                {
                case NSKeyValueChange.Setting:
                    break
                    
                case NSKeyValueChange.Insertion:
                    if let objects = change?["new"] as? [APCInterfaceObject],
                        object : APCInterfaceObject = objects[0]
                    {
                        self.insertInterfaceObject(object, atIndex: indexSet.firstIndex)
                    }
                    
                case NSKeyValueChange.Removal:
                    if let objects = change?["old"] as? [APCInterfaceObject],
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
            if let button = change?["old"] as? APCButton
            {
                button.removeObserver(self, forKeyPath: "title")
            }
            
            if let button = change?["new"] as? APCButton
            {
                button.addObserver(self, forKeyPath: "title", options: NSKeyValueObservingOptions([.New, .Old]), context: &self.interfaceObjectContext)
            }
            
            if let image = change?["old"] as? APCImage
            {
                image.removeObserver(self, forKeyPath: "uiImage")
            }
            
            if let image = change?["new"] as? APCImage
            {
                image.addObserver(self, forKeyPath: "uiImage", options: NSKeyValueObservingOptions([.New, .Old]), context: &self.interfaceObjectContext)
            }

            if let label = change?["old"] as? APCLabel
            {
                label.removeObserver(self, forKeyPath: "text")
            }

            if let label = change?["new"] as? APCLabel
            {
                label.addObserver(self, forKeyPath: "text", options: NSKeyValueObservingOptions([.New, .Old]), context: &self.interfaceObjectContext)
            }
        }
        else
        {
            if let object = object as? APCInterfaceObject
            {
                self.modifyInterfaceObject(object)
            }
        }
    }
    
    func activate()
    {
        self.session.activateSession()
    }

    func sessionReachabilityDidChange(session: WCSession)
    {
        print("reachable = \(self.session.reachable)")
    }
    
    func refreshScreen(screen : APCScreen)
    {
        let message : [String : AnyObject] =
            [
                "action" : APCWatchAppAction.RefreshScreen.rawValue,
                "screenData" : screen.archivedData()
            ]
        
        self.sendMessage(message)
    }

    func clearScreen()
    {
        let message : [String : AnyObject] =
            [
                "action" : APCWatchAppAction.ClearScreen.rawValue
        ]
        
        self.sendMessage(message)
    }
    
    func insertInterfaceObject(object : APCInterfaceObject, atIndex index : Int)
    {
        let message : [String : AnyObject] =
            [
                "action" : APCWatchAppAction.InsertInterfaceObject.rawValue,
                "objectData" : object.archivedData(),
                "index" : index
            ]

        self.sendMessage(message)
    }
    
    func modifyInterfaceObject(object : APCInterfaceObject)
    {
        let message : [String : AnyObject] =
            [
                "action" : APCWatchAppAction.ModifyInterfaceObject.rawValue,
                "objectData" : object.archivedData()
            ]
        
        self.sendMessage(message)
    }

    func deleteInterfaceObject(object : APCInterfaceObject)
    {
        let message : [String : AnyObject] =
            [
                "action" : APCWatchAppAction.DeleteInterfaceObject.rawValue,
                "objectData" : object.archivedData()
            ]
        
        self.sendMessage(message)
    }

    func runWatchApp(screenList : APCScreenList)
    {
        let message : [String : AnyObject] =
        [
            "action" : APCWatchAppAction.Run.rawValue,
            "screenListData" : screenList.archivedData()
        ]
        
        self.sendMessage(message)
    }
    
    func sendMessage(message : [String : AnyObject])
    {
        self.session.sendMessage(message, replyHandler:
            { (reply) in
                
                if let imageIdAsString = reply["transferFileWithImageIdAsString"] as? String,
                    let imageId : NSUUID = NSUUID(UUIDString: imageIdAsString)
                {
                    let image : APCImage = APCImage(id: imageId)
                    
                    self.session.transferFile(image.fileURL, metadata: ["imageIdAsString" : image.id.UUIDString])
                }
            
            })
            { (error) in
                print(error)
            }
    }
}















