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
    
    func activate()
    {
        self.session.activateSession()
    }

    func sessionReachabilityDidChange(session: WCSession)
    {
        print("reachable = \(self.session.reachable)")
    }
    
    func refreshInterfaceObjectList(list : APCInterfaceObjectList)
    {
        let message : [String : AnyObject] =
            [
                "action" : APCInterfaceObjectListAction.Refresh.rawValue,
                "listData" : list.archivedData()
            ]
        
        self.sendMessage(message)
    }

    func clearInterfaceObjectList()
    {
        let message : [String : AnyObject] =
            [
                "action" : APCInterfaceObjectListAction.Clear.rawValue
            ]
        
        self.sendMessage(message)
    }

    func insertInterfaceObject(object : APCButton, atIndex index : Int)
    {
        let message : [String : AnyObject] =
            [
                "action" : APCInterfaceObjectListAction.Insert.rawValue,
                "objectData" : object.archivedData(),
                "index" : index
            ]

        self.sendMessage(message)
    }
    
    func modifyInterfaceObject(object : APCButton, atIndex index : Int)
    {
        let message : [String : AnyObject] =
            [
                "action" : APCInterfaceObjectListAction.Modify.rawValue,
                "objectData" : object.archivedData(),
                "index" : index
            ]
        
        self.sendMessage(message)
    }

    func deleteInterfaceObject(atIndex index : Int)
    {
        let message : [String : AnyObject] =
            [
                "action" : APCInterfaceObjectListAction.Delete.rawValue,
                "index" : index
            ]
        
        self.sendMessage(message)
    }

    func sendMessage(message : [String : AnyObject])
    {
        self.session.sendMessage(message, replyHandler:
            { (reply) in
                print(reply)
            })
            { (error) in
                print(error)
            }
    }
}















