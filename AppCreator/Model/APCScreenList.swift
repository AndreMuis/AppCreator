//
//  APCScreenList.swift
//  AppCreator
//
//  Created by Andre Muis on 5/27/16.
//  Copyright © 2016 Andre Muis. All rights reserved.
//

import Foundation

class APCScreenList : NSObject, NSCoding
{
    private var screens : [APCScreen]

    var initialScreenId : NSUUID?
    var selectedScreen : APCScreen?
    
    override init()
    {
        self.screens = [APCScreen]()
        self.initialScreenId = nil
        
        super.init()
    }
    
    init(screens : [APCScreen], rootScreenId : NSUUID)
    {
        self.screens = screens
        self.initialScreenId = rootScreenId
    }
    
    required convenience init?(coder decoder: NSCoder)
    {
        guard let screens = decoder.decodeObjectForKey("screens") as? [APCScreen],
            let rootScreenId = decoder.decodeObjectForKey("initialScreenId") as? NSUUID
            else
        {
            return nil
        }
        
        self.init(screens: screens, rootScreenId: rootScreenId)
    }
    
    func encodeWithCoder(coder: NSCoder)
    {
        coder.encodeObject(self.screens, forKey: "screens")
        coder.encodeObject(self.initialScreenId, forKey: "initialScreenId")
    }
    
    var count : Int
    {
        return self.screens.count
    }
    
    var allScreens : [APCScreen]
    {
        return self.screens
    }
    
    subscript(index : Int) -> APCScreen?
    {
        get
        {
            var screen : APCScreen? = nil
            
            if 0..<self.screens.count ~= index
            {
                screen = self.screens[index]
            }
            
            return screen
        }
    }

    func screenWithId(id : NSUUID) -> APCScreen?
    {
        let screen : APCScreen? = self.screens.filter({$0.id == id}).first
        
        return screen
    }

    func indexWithId(id : NSUUID) -> Int?
    {
        var index : Int?
        
        if let screen : APCScreen = self.screens.filter({$0.id == id}).first
        {
            index = self.screens.indexOf(screen)
        }
        
        return index
    }
    
    func add(screen screen : APCScreen)
    {
        self.screens.append(screen)
    }
    
    func move(objectAtIndex fromIndex : Int, toIndex: Int) -> Bool
    {
        if 0 ..< self.screens.count ~= fromIndex && 0 ..< self.screens.count ~= toIndex
        {
            let object = self.screens[fromIndex]
            
            self.screens.removeAtIndex(fromIndex)
            
            self.screens.insert(object, atIndex: toIndex)
            
            return true
        }
        else
        {
            return false
        }
    }
    
    func remove(objectAtIndex index : Int) -> Bool
    {
        if 0 ..< self.screens.count ~= index
        {
            self.screens.removeAtIndex(index)
            
            return true
        }
        else
        {
            return false
        }
    }
}












