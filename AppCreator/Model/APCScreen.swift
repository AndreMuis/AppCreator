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
    dynamic var name : String
    var interfaceObjectList : APCInterfaceObjectList
    
    init(name : String)
    {
        self.id = NSUUID()
        self.name = name
        self.interfaceObjectList = APCInterfaceObjectList()

        super.init()
    }

    init(id : NSUUID, name : String)
    {
        self.id = id
        self.name = name
        self.interfaceObjectList = APCInterfaceObjectList()
        
        super.init()
    }

    required convenience init?(coder decoder: NSCoder)
    {
        guard let id = decoder.decodeObjectForKey("id") as? NSUUID,
            name = decoder.decodeObjectForKey("name") as? String,
            interfaceObjectList = decoder.decodeObjectForKey("interfaceObjectList") as? APCInterfaceObjectList
            else
        {
            return nil
        }
        
        self.init(id: id, name: name)
        self.interfaceObjectList = interfaceObjectList

    }

    func encodeWithCoder(coder: NSCoder)
    {
        coder.encodeObject(self.id, forKey: "id")
        coder.encodeObject(self.name, forKey: "name")
        coder.encodeObject(self.interfaceObjectList, forKey: "interfaceObjectList")
    }
}

func ==(lhs: APCScreen, rhs: APCScreen) -> Bool
{
    return lhs.id == rhs.id
}













