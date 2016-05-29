//
//  APCScreenTableViewCell.swift
//  AppCreator
//
//  Created by Andre Muis on 5/28/16.
//  Copyright © 2016 Andre Muis. All rights reserved.
//

import UIKit

class APCScreenTableViewCell : UITableViewCell
{
    override func awakeFromNib()
    {
        super.awakeFromNib()
    }
    
    static var nib : UINib
    {
        let nib : UINib = UINib(nibName: "APCScreenTableViewCell", bundle: nil)
        
        return nib
    }
}
