//
//  APCDesignViewController.swift
//  AppCreator
//
//  Created by Andre Muis on 5/27/16.
//  Copyright © 2016 Andre Muis. All rights reserved.
//

import UIKit

class APCDesignViewController: UIViewController
{
    var screen : APCScreen?
    
    required init?(coder aDecoder: NSCoder)
    {
        super.init(coder: aDecoder)
        
        self.screen = nil
    }
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
    }

    @IBAction func deleteScreenButtonTapped(sender: AnyObject)
    {
        if let screen = self.screen
        {
            if APCScreenList.shared.remove(screen: screen) == true
            {
                self.navigationController?.popViewControllerAnimated(true)
            }
        }
    }
}
