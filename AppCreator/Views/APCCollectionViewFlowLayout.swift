//
//  APCCollectionViewFlowLayout.swift
//  AppCreator
//
//  Created by Andre Muis on 6/3/16.
//  Copyright © 2016 Andre Muis. All rights reserved.
//

import UIKit

class APCCollectionViewFlowLayout : UICollectionViewFlowLayout
{
    override func layoutAttributesForInteractivelyMovingItemAtIndexPath(indexPath: NSIndexPath, withTargetPosition position: CGPoint) -> UICollectionViewLayoutAttributes
    {
        let attributes = super.layoutAttributesForInteractivelyMovingItemAtIndexPath(indexPath, withTargetPosition: position)
        
        attributes.transform = CGAffineTransformScale(CGAffineTransformIdentity,
                                                      APCCommonStyles.movingCellSizeScale,
                                                      APCCommonStyles.movingCellSizeScale)
        
        return attributes
    }
}