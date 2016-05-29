//
//  APCScreen.swift
//  AppCreator
//
//  Created by Andre Muis on 5/27/16.
//  Copyright © 2016 Andre Muis. All rights reserved.
//

import UIKit

class APCScreen : Equatable
{
    let id : Int
    var interfaceObjectList : APCInterfaceObjectList
    
    init(id : Int)
    {
        self.id = id
        self.interfaceObjectList = APCInterfaceObjectList()
    }
}

func ==(lhs: APCScreen, rhs: APCScreen) -> Bool
{
    return lhs.id == rhs.id
}


