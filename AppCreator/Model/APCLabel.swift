//
//  APCLabel.swift
//  AppCreator
//
//  Created by Andre Muis on 5/29/16.
//  Copyright © 2016 Andre Muis. All rights reserved.
//

import Foundation

class APCLabel: NSObject, APCInterfaceObject, NSCoding
{
    let id : NSUUID
    
    init(id : NSUUID)
    {
        self.id = id
    }
    
    required convenience init?(coder decoder: NSCoder)
    {
        guard let id = decoder.decodeObjectForKey("id") as? NSUUID
            else
        {
            return nil
        }
        
        self.init(id: id)
    }
    
    func encodeWithCoder(coder: NSCoder)
    {
        coder.encodeObject(self.id, forKey: "id")
    }
}
