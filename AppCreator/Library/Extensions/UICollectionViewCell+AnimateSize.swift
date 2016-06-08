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
        UIView.animateWithDuration(APCCommonStyles.movingCellSizeAnimationDuration,
                                   animations:
        {
            self.transform = CGAffineTransformScale(CGAffineTransformIdentity,
                                                    APCCommonStyles.movingCellSizeScale,
                                                    APCCommonStyles.movingCellSizeScale)
        })
    }

    func animateContraction()
    {
        UIView.animateWithDuration(APCCommonStyles.movingCellSizeAnimationDuration,
                                   animations:
        {
            self.transform = CGAffineTransformIdentity
        })
    }
}