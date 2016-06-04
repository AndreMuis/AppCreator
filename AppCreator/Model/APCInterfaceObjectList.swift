//
//  APCInterfaceObjectList.swift
//  AppCreator
//
//  Created by Andre Muis on 5/28/16.
//  Copyright © 2016 Andre Muis. All rights reserved.
//

import Foundation

public class APCInterfaceObjectList : NSObject, NSCoding
{
    private dynamic var objects : NSMutableArray

    dynamic var selectedObject : APCInterfaceObject?

    var isPerformingMove : Bool
    
    override init()
    {
        self.objects = NSMutableArray()

        self.selectedObject = nil
        
        self.isPerformingMove = false
        
        super.init()
    }
    
    public required convenience init?(coder decoder: NSCoder)
    {
        guard let objects = decoder.decodeObjectForKey("objects") as? NSMutableArray
            else
        {
            return nil
        }
        
        self.init()
        self.objects = objects
    }
    
    public func encodeWithCoder(coder: NSCoder)
    {
        coder.encodeObject(self.objects, forKey: "objects")
    }

    func addArrayObserver(observer : NSObject, inout context : Int)
    {
        self.addObserver(observer, forKeyPath: "objects", options: NSKeyValueObservingOptions([.New, .Old]), context: &context)
    }
    
    func removeArrayObserver(observer : NSObject)
    {
        self.removeObserver(observer, forKeyPath: "objects")
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
                object = self.objects[index] as? APCInterfaceObject
            }
            
            return object
        }
    }
    
    func indexOfObject(object : APCInterfaceObject) -> Int?
    {
        return self.objects.indexOfObject(object)
    }
    
    func add(object object : APCInterfaceObject)
    {
        let childrenProxy = mutableArrayValueForKey("objects")
        childrenProxy.addObject(object)
    }

    func move(objectAtIndex fromIndex : Int, toIndex: Int) -> Bool
    {
        if 0 ..< self.objects.count ~= fromIndex && 0 ..< self.objects.count ~= toIndex
        {
            self.isPerformingMove = true
            
            let object = self.objects[fromIndex]
            
            let childrenProxy = mutableArrayValueForKey("objects")

            childrenProxy.removeObjectAtIndex(fromIndex)
            
            childrenProxy.insertObject(object, atIndex: toIndex)
            
            self.isPerformingMove = false
            
            return true
        }
        else
        {
            return false
        }
    }
    
    func remove(objectAtIndex index : Int) -> Bool
    {
        if 0 ..< self.objects.count ~= index
        {
            let childrenProxy = mutableArrayValueForKey("objects")
            childrenProxy.removeObjectAtIndex(index)
            
            return true
        }
        else
        {
            return false
        }
    }
}













