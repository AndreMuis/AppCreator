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
    
    init(title : String)
    {
        self.id = NSUUID()
        self.title = title
        self.interfaceObjectList = APCInterfaceObjectList()

        super.init()
    }

    init(id : NSUUID, title : String)
    {
        self.id = id
        self.title = title
        self.interfaceObjectList = APCInterfaceObjectList()
        
        super.init()
    }

    required convenience init?(coder decoder: NSCoder)
    {
        guard let id = decoder.decodeObjectForKey("id") as? NSUUID,
            title = decoder.decodeObjectForKey("title") as? String,
            interfaceObjectList = decoder.decodeObjectForKey("interfaceObjectList") as? APCInterfaceObjectList
            else
        {
            return nil
        }
        
        self.init(id: id, title: title)
        self.interfaceObjectList = interfaceObjectList

    }

    func encodeWithCoder(coder: NSCoder)
    {
        coder.encodeObject(self.id, forKey: "id")
        coder.encodeObject(self.title, forKey: "title")
        coder.encodeObject(self.interfaceObjectList, forKey: "interfaceObjectList")
    }
}

func ==(lhs: APCScreen, rhs: APCScreen) -> Bool
{
    return lhs.id == rhs.id
}













