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

    init(id : NSUUID, title : String, pushToScreenId : NSUUID?)
    {
        self.id = id
        self.title = title
        self.pushToScreenId = pushToScreenId
    }
    
    required convenience init?(coder decoder: NSCoder)
    {
        guard let id = decoder.decodeObjectForKey(APCConstants.idKeyPath) as? NSUUID,
            title = decoder.decodeObjectForKey(APCConstants.titleKeyPath) as? String
            else
        {
            return nil
        }
        
        let pushToScreenId : NSUUID? = decoder.decodeObjectForKey(APCConstants.pushToScreenIdKeyPath) as? NSUUID
        
        self.init(id: id, title: title, pushToScreenId: pushToScreenId)
    }
    
    func encodeWithCoder(coder: NSCoder)
    {
        coder.encodeObject(self.id, forKey: APCConstants.idKeyPath)
        coder.encodeObject(self.title, forKey: APCConstants.titleKeyPath)
        
        if let screenId = self.pushToScreenId
        {
            coder.encodeObject(screenId, forKey: APCConstants.pushToScreenIdKeyPath)
        }
    }
}













