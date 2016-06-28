//
//  APCInterfaceObjectList.swift
//  AppCreator
//
//  Created by Andre Muis on 5/28/16.
//  Copyright © 2016 Andre Muis. All rights reserved.
//

import Foundation

public class APCInterfaceObjectList : NSObject, NSCoding, SequenceType
{
    public typealias Generator = AnyGenerator<APCInterfaceObject>

    private dynamic var objects : NSMutableArray
    dynamic var selectedObject : APCInterfaceObject?

    override init()
    {
        self.objects = NSMutableArray()
        self.selectedObject = nil
        
        super.init()
    }
    
    public required convenience init?(coder decoder: NSCoder)
    {
        guard let objects = decoder.decodeObjectForKey(APCConstants.objectsKeyPath) as? NSMutableArray
            else
        {
            return nil
        }
        
        self.init()
        
        self.objects = objects
    }
    
    public func encodeWithCoder(coder: NSCoder)
    {
        coder.encodeObject(self.objects, forKey: APCConstants.objectsKeyPath)
    }

    func addObjectsObserver(observer: NSObject, inout context : Int)
    {
        self.addObserver(observer,
                         forKeyPath: APCConstants.objectsKeyPath,
                         options: NSKeyValueObservingOptions([.New, .Old]),
                         context: &context)
    }
    
    func removeObjectsObserver(observer: NSObject)
    {
        self.removeObserver(observer, forKeyPath: APCConstants.objectsKeyPath)
    }
    
    public func generate() -> Generator
    {
        var index : Int = 0
        
        return AnyGenerator
        {
            var result : APCInterfaceObject?
            
            if index < self.objects.count
            {
                if let object = self.objects[index] as? APCInterfaceObject
                {
                    result = object
                    index += 1
                }
                else
                {
                    result = nil
                }
            }
            
            return result
        }
    }

    var count : Int
    {
        return self.objects.count
    }
    
    subscript(index: Int) -> APCInterfaceObject?
    {
        get
        {
            var object : APCInterfaceObject? = nil
            
            if 0 ..< self.objects.count ~= index
            {
                object = self.objects[index] as? APCInterfaceObject
            }
            
            return object
        }
    }
    
    func indexOfObject(object: APCInterfaceObject) -> Int?
    {
        return self.objects.indexOfObject(object)
    }
    
    func add(object object: APCInterfaceObject)
    {
        let childrenProxy = mutableArrayValueForKey(APCConstants.objectsKeyPath)
        
        childrenProxy.addObject(object)
    }

    func move(objectAtIndex fromIndex: Int, toIndex: Int) -> Bool
    {
        if 0 ..< self.objects.count ~= fromIndex && 0 ..< self.objects.count ~= toIndex
        {
            let object = self.objects[fromIndex]
            
            let childrenProxy = mutableArrayValueForKey(APCConstants.objectsKeyPath)

            childrenProxy.removeObjectAtIndex(fromIndex)
            childrenProxy.insertObject(object, atIndex: toIndex)
            
            return true
        }
        else
        {
            return false
        }
    }
    
    func remove(objectAtIndex index: Int) -> Bool
    {
        if 0 ..< self.objects.count ~= index
        {
            let childrenProxy = mutableArrayValueForKey(APCConstants.objectsKeyPath)
            
            childrenProxy.removeObjectAtIndex(index)
            
            return true
        }
        else
        {
            return false
        }
    }
}













