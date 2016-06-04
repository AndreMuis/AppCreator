//
//  UICollectionViewCell+AnimateSize.swift
//  AppCreator
//
//  Created by Andre Muis on 6/3/16.
//  Copyright © 2016 Andre Muis. All rights reserved.
//

import UIKit

extension UICollectionViewCell
{
    func animateExpansion()
    {
        UIView.animateWithDuration(0.1, animations:
        {
            self.transform = CGAffineTransformScale(CGAffineTransformIdentity, 1.1, 1.1)
        })
    }

    func animateContraction()
    {
        UIView.animateWithDuration(0.1, animations:
        {
            self.transform = CGAffineTransformIdentity
        })
    }
}