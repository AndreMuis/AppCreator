//
//  APCScreenCollectionViewCell.swift
//  AppCreator
//
//  Created by Andre Muis on 5/27/16.
//  Copyright © 2016 Andre Muis. All rights reserved.
//

import UIKit

class APCScreenCollectionViewCell: UICollectionViewCell
{
    @IBOutlet weak var idLabel: UILabel!

    static var nib : UINib
    {
        let nib : UINib = UINib(nibName: "APCScreenCollectionViewCell", bundle: nil)
        
        return nib
    }
    
    func refresh(screen screen : APCScreen)
    {
        self.idLabel.text = String(screen.id)
    }
}
