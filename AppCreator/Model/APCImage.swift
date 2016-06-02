//
//  APCImage.swift
//  AppCreator
//
//  Created by Andre Muis on 5/29/16.
//  Copyright © 2016 Andre Muis. All rights reserved.
//

import UIKit

class APCImage: NSObject, APCInterfaceObject, NSCoding
{
    let id : NSUUID
    var filePathURL : NSURL?
    dynamic var uiImage : UIImage?
    
    init(filePathURL : NSURL?)
    {
        self.id = NSUUID()
        self.filePathURL = filePathURL
        //self.uiImage = UIImage(contentsOfFile: filePathURL.absoluteString)
    }
    
    init(id : NSUUID, filePathURL : NSURL?)
    {
        self.id = id
        self.filePathURL = filePathURL
        //self.uiImage = UIImage(contentsOfFile: filePathURL.absoluteString)
    }
    
    required convenience init?(coder decoder: NSCoder)
    {
        guard let id = decoder.decodeObjectForKey("id") as? NSUUID
            else
        {
            return nil
        }
        
        self.init(id: id, filePathURL: nil)
    }
    
    func encodeWithCoder(coder: NSCoder)
    {
        coder.encodeObject(self.id, forKey: "id")
    }
}
