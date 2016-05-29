//
//  APCScreenListDelegate.swift
//  AppCreator
//
//  Created by Andre Muis on 5/27/16.
//  Copyright © 2016 Andre Muis. All rights reserved.
//

protocol APCScreenListDelegate : class
{
    func screenList(screenList : APCScreenList, didRemoveScreen screen : APCScreen)
}
