//
//  APCScreen.swift
//  AppCreator
//
//  Created by Andre Muis on 5/27/16.
//  Copyright © 2016 Andre Muis. All rights reserved.
//

import UIKit

struct APCScreen : Equatable
{
    let id : Int
    
    init(id : Int)
    {
        self.id = id
    }
}

func ==(lhs: APCScreen, rhs: APCScreen) -> Bool
{
    return lhs.id == rhs.id
}


