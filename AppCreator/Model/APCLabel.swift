//
//  APCLabel.swift
//  AppCreator
//
//  Created by Andre Muis on 5/29/16.
//  Copyright © 2016 Andre Muis. All rights reserved.
//

import Foundation

class APCLabel: NSObject, APCInterfaceObject
{
    let id : NSUUID
    dynamic var text : String
    
    init(text : String)
    {
        self.id = NSUUID()
        self.text = text
    }

    init(id : NSUUID, text : String)
    {
        self.id = id
        self.text = text
    }
    
    required convenience init?(coder decoder: NSCoder)
    {
        guard let id : NSUUID = decoder.decodeObjectForKey(APCConstants.idKeyPath) as? NSUUID,
            text : String  = decoder.decodeObjectForKey(APCConstants.textKeyPath) as? String
            else
        {
            return nil
        }
        
        self.init(id: id, text: text)
    }
    
    func encodeWithCoder(coder: NSCoder)
    {
        coder.encodeObject(self.id, forKey: APCConstants.idKeyPath)
        coder.encodeObject(self.text, forKey: APCConstants.textKeyPath)
    }
}
