//
//  APCScreenList.swift
//  AppCreator
//
//  Created by Andre Muis on 5/27/16.
//  Copyright © 2016 Andre Muis. All rights reserved.
//

class APCScreenList
{
    internal weak var delegate : APCScreenListDelegate?

    private var screens : [APCScreen]
    
    init()
    {
        self.screens = [APCScreen]()
        
        self.delegate = nil
    }
    
    var count : Int
    {
        return self.screens.count
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












