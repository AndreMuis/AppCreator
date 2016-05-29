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

    func createScreen() -> APCScreen
    {
        let screen : APCScreen
        
        if let last = self.screens.sort({$0.id < $1.id}).last
        {
            let nextId : Int = last.id + 1
            screen = APCScreen(id: nextId)
        }
        else
        {
            screen = APCScreen(id: 1)
        }
        
        return screen
    }
    
    func add(screen screen : APCScreen)
    {
        self.screens.append(screen)
    }
    
    func remove(screen screen : APCScreen) -> Bool
    {
        if let index = self.screens.indexOf(screen)
        {
            self.screens.removeAtIndex(index)
            
            self.delegate?.screenList(self, didRemoveScreen: screen)
            
            return true
        }
        else
        {
            return false
        }
    }
}












