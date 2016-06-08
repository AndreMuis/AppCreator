//
//  APCButton.swift
//  AppCreator
//
//  Created by Andre Muis on 5/28/16.
//  Copyright © 2016 Andre Muis. All rights reserved.
//

import Foundation

class APCButton : NSObject, APCInterfaceObject
{
    let id : NSUUID
    dynamic var title : String
    var pushToScreenId : NSUUID?
    
    init(title : String)
    {
        self.id = NSUUID()
        self.title = title
        self.pushToScreenId = nil
    }

    init(id : NSUUID, title : String, pushToScreenId : NSUUID)
    {
        self.id = id
        self.title = title
        self.pushToScreenId = pushToScreenId
    }
    
    required convenience init?(coder decoder: NSCoder)
    {
        guard let id = decoder.decodeObjectForKey("id") as? NSUUID,
            let title = decoder.decodeObjectForKey("title") as? String,
            let pushToScreenId = decoder.decodeObjectForKey("pushToScreenId") as? NSUUID
            else
        {
            return nil
        }
        
        self.init(id: id, title: title, pushToScreenId: pushToScreenId)
    }
    
    func encodeWithCoder(coder: NSCoder)
    {
        coder.encodeObject(self.id, forKey: "id")
        coder.encodeObject(self.title, forKey: "title")
        
        if let screenId = self.pushToScreenId
        {
            coder.encodeObject(screenId, forKey: "pushToScreenId")
        }
    }
}













