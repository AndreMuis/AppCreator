//
//  APCImage.swift
//  AppCreator
//
//  Created by Andre Muis on 5/29/16.
//  Copyright © 2016 Andre Muis. All rights reserved.
//

import UIKit

class APCImage: NSObject, APCInterfaceObject
{
    let id : NSUUID
    let fileURL : NSURL
    dynamic var uiImage : UIImage?
    
    init?(uiImage : UIImage)
    {
        let id : NSUUID = NSUUID()
        
        self.id = id
        self.fileURL = APCImage.getFileURL(id: id)
        self.uiImage = uiImage
        
        super.init()

        if let imageData : NSData = UIImagePNGRepresentation(uiImage)
        {
            if imageData.writeToURL(self.fileURL, atomically: true) == false
            {
                return nil
            }
        }
        else
        {
            return nil
        }
    }
    
    init(id : NSUUID)
    {
        self.id = id
        self.fileURL = APCImage.getFileURL(id: id)
        
        super.init()

        if let imageData : NSData = NSData(contentsOfURL: self.fileURL)
        {
            self.uiImage = UIImage(data: imageData)
        }
    }
    
    required convenience init?(coder decoder: NSCoder)
    {
        guard let id : NSUUID = decoder.decodeObjectForKey(APCConstants.idKeyPath) as? NSUUID
            else
        {
            return nil
        }
        
        self.init(id: id)
    }
    
    func encodeWithCoder(coder: NSCoder)
    {
        coder.encodeObject(self.id, forKey: APCConstants.idKeyPath)
    }

    static func getFileURL(id id: NSUUID) -> NSURL
    {
        let documentDirectoryURLs : [NSURL] = NSFileManager.defaultManager().URLsForDirectory(NSSearchPathDirectory.DocumentDirectory,
                                                                                              inDomains: NSSearchPathDomainMask.UserDomainMask)
        
        let documentDirectoryURL : NSURL = documentDirectoryURLs[0]
        
        let url = documentDirectoryURL.URLByAppendingPathComponent("\(id.UUIDString).png")
        
        return url
    }
}

















