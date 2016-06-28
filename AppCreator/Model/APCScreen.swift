//
//  APCScreen.swift
//  AppCreator
//
//  Created by Andre Muis on 5/27/16.
//  Copyright © 2016 Andre Muis. All rights reserved.
//

import Foundation

class APCScreen : NSObject, NSCoding
{
    let id : NSUUID
    dynamic var title : String
    var interfaceObjectList : APCInterfaceObjectList
    
    init(title: String)
    {
        self.id = NSUUID()
        self.title = title
        self.interfaceObjectList = APCInterfaceObjectList()

        super.init()
    }

    init(id: NSUUID, title: String, interfaceObjectList: APCInterfaceObjectList)
    {
        self.id = id
        self.title = title
        self.interfaceObjectList = APCInterfaceObjectList()
        
        super.init()
    }

    required convenience init?(coder decoder: NSCoder)
    {
        guard let id : NSUUID = decoder.decodeObjectForKey(APCConstants.idKeyPath) as? NSUUID,
            title : String = decoder.decodeObjectForKey(APCConstants.titleKeyPath) as? String,
            interfaceObjectList : APCInterfaceObjectList = decoder.decodeObjectForKey(APCConstants.interfaceObjectListKeyPath) as? APCInterfaceObjectList
            else
        {
            return nil
        }
        
        self.init(id: id, title: title, interfaceObjectList: interfaceObjectList)
    }

    func encodeWithCoder(coder: NSCoder)
    {
        coder.encodeObject(self.id, forKey: APCConstants.idKeyPath)
        coder.encodeObject(self.title, forKey: APCConstants.titleKeyPath)
        coder.encodeObject(self.interfaceObjectList, forKey: APCConstants.interfaceObjectListKeyPath)
    }
}

func ==(lhs: APCScreen, rhs: APCScreen) -> Bool
{
    return lhs.id == rhs.id
}













