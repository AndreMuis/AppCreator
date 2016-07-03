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
        self.selectedScreen = nil
        
        super.init()
    }
    
    init(screens : [APCScreen], initialScreenId: NSUUID?)
    {
        self.screens = screens
        self.initialScreenId = initialScreenId
        self.selectedScreen = nil
    }
    
    required convenience init?(coder decoder: NSCoder)
    {
        guard let screens = decoder.decodeObjectForKey(APCConstants.screensKeyPath) as? [APCScreen]
            else
        {
            return nil
        }
        
        let initialScreenId : NSUUID? = decoder.decodeObjectForKey(APCConstants.initialScreenIdKeyPath) as? NSUUID

        self.init(screens: screens, initialScreenId: initialScreenId)
    }
    
    func encodeWithCoder(coder: NSCoder)
    {
        coder.encodeObject(self.screens, forKey: APCConstants.screensKeyPath)
        
        if let screenId = self.initialScreenId
        {
            coder.encodeObject(screenId, forKey: APCConstants.initialScreenIdKeyPath)
        }
    }
    
    var count : Int
    {
        return self.screens.count
    }
    
    subscript(index: Int) -> APCScreen?
    {
        get
        {
            var screen : APCScreen? = nil
            
            if 0 ..< self.screens.count ~= index
            {
                screen = self.screens[index]
            }
            
            return screen
        }
    }

    func screenWithId(id: NSUUID) -> APCScreen?
    {
        let screen : APCScreen? = self.screens.filter({$0.id == id}).first
        
        return screen
    }

    func allScreens(excludingScreen screen: APCScreen) -> [APCScreen]
    {
        let screens : [APCScreen] = self.screens.filter({$0.id != screen.id})
        
        return screens
    }
    
    func indexWithId(id: NSUUID) -> Int?
    {
        var index : Int?
        
        if let screen : APCScreen = self.screens.filter({$0.id == id}).first
        {
            index = self.screens.indexOf(screen)
        }
        
        return index
    }
    
    func add(screen: APCScreen)
    {
        self.screens.append(screen)
    }
    
    func move(fromIndex fromIndex: Int, toIndex: Int) -> Bool
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
    
    func remove(index index: Int) -> APCScreen?
    {
        var removedScreen : APCScreen?
        
        if 0 ..< self.screens.count ~= index
        {
            removedScreen = self.screens.removeAtIndex(index)
        }
        else
        {
            removedScreen = nil
        }
        
        return removedScreen
    }
}












