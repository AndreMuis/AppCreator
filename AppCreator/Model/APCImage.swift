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
    var fileURL : NSURL
    dynamic var uiImage : UIImage?
    
    init?(uiImage : UIImage)
    {
        self.id = NSUUID()
        self.uiImage = uiImage
        
        if let imageData = UIImagePNGRepresentation(uiImage)
        {
            let documentDirectoryURLs : [NSURL] = NSFileManager.defaultManager().URLsForDirectory(NSSearchPathDirectory.DocumentDirectory,
                                                                                                  inDomains: NSSearchPathDomainMask.UserDomainMask)
            
            let documentDirectoryURL : NSURL = documentDirectoryURLs[0]
            
            let fileURL = documentDirectoryURL.URLByAppendingPathComponent("\(self.id.UUIDString).png")
            self.fileURL = fileURL
            
            if imageData.writeToURL(fileURL, atomically: true) == false
            {
                return nil
            }
        }
        else
        {
            return nil
        }
    }
    
    init(id : NSUUID, fileURL : NSURL)
    {
        self.id = id
        self.fileURL = fileURL
        
        if let imageData = NSData(contentsOfURL: fileURL)
        {
            self.uiImage = UIImage(data: imageData)
        }
    }
    
    required convenience init?(coder decoder: NSCoder)
    {
        guard let id = decoder.decodeObjectForKey("id") as? NSUUID,
            let fileURL = decoder.decodeObjectForKey("fileURL") as? NSURL
            else
        {
            return nil
        }
        
        self.init(id: id, fileURL: fileURL)
    }
    
    func encodeWithCoder(coder: NSCoder)
    {
        coder.encodeObject(self.id, forKey: "id")
        coder.encodeObject(self.fileURL, forKey: "fileURL")
    }

    func updateUIImage(uiImage : UIImage) -> Bool
    {
        var success : Bool = false
 
        if let imageData = UIImagePNGRepresentation(uiImage)
        {
            if imageData.writeToURL(self.fileURL, atomically: true) == true
            {
                self.uiImage = uiImage
                
                success = true
            }
        }
        
        return success
    }
}

















