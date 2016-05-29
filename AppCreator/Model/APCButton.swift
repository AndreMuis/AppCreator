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
    let id : Int
    let title : String
    
    init(id : Int, title : String)
    {
        self.id = id
        self.title = title
    }
    
    required convenience init?(coder decoder: NSCoder)
    {
        guard let id = decoder.decodeObjectForKey("id") as? Int,
            let title = decoder.decodeObjectForKey("title") as? String
            else
        {
            return nil
        }
        
        self.init(id: id, title: title)
    }
    
    func encodeWithCoder(coder: NSCoder)
    {
        coder.encodeObject(self.id, forKey: "id")
        coder.encodeObject(self.title, forKey: "title")
    }
}

