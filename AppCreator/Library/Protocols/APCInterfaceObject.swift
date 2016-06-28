//
//  APCInterfaceObject.swift
//  AppCreator
//
//  Created by Andre Muis on 5/28/16.
//  Copyright © 2016 Andre Muis. All rights reserved.
//

import Foundation

@objc public protocol APCInterfaceObject : NSCoding
{
    var id : NSUUID {get}
}

