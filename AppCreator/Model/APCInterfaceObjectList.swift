//
//  APCInterfaceObjectList.swift
//  AppCreator
//
//  Created by Andre Muis on 5/28/16.
//  Copyright © 2016 Andre Muis. All rights reserved.
//

class APCInterfaceObjectList
{
    private var objects : [APCInterfaceObject]
    
    init()
    {
        self.objects = [APCInterfaceObject]()
    }
    
    var count : Int
    {
        return self.objects.count
    }
    
    subscript(index : Int) -> APCInterfaceObject?
    {
        get
        {
            var object : APCInterfaceObject? = nil
            
            if 0..<self.objects.count ~= index
            {
                object = self.objects[index]
            }
            
            return object
        }
    }
    
    func add(object object : APCInterfaceObject)
    {
        self.objects.append(object)
    }
    
    func remove(object object : APCInterfaceObject) -> Bool
    {
        if let first : APCInterfaceObject = self.objects.filter({$0.id == object.id}).first
        {
            self.objects = self.objects.filter({$0.id != first.id})
            
            return true
        }
        else
        {
            return false
        }
    }
}













