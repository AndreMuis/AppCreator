//
//  UITextView+TrimText.swift
//  AppCreator
//
//  Created by Andre Muis on 6/5/16.
//  Copyright © 2016 Andre Muis. All rights reserved.
//

import UIKit

extension UITextView
{
    var trimmedText : String
    {
        let result : String = self.text!.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet())
        
        return result
    }
}

