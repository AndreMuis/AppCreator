//
//  UITextField+TrimText.swift
//  AppCreator
//
//  Created by Andre Muis on 6/4/16.
//  Copyright © 2016 Andre Muis. All rights reserved.
//

import UIKit

extension UITextField
{
    var trimmedText : String
    {
        let result : String = self.text!.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet())
        
        return result
    }
}

