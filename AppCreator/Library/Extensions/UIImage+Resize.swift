//
//  UIImage+Resize.swift
//  AppCreator
//
//  Created by Andre Muis on 6/26/16.
//  Copyright © 2016 Andre Muis. All rights reserved.
//

import ImageIO
import UIKit

extension UIImage
{
    func resizedJPEGImage(maxSideLength maxSideLength: CGFloat, jpegCompressionQuality: CGFloat) -> UIImage?
    {
        var resizedImage : UIImage? = nil
        
        if let nsData : NSData = UIImageJPEGRepresentation(self, jpegCompressionQuality)
        {
            let cfData : CFData = CFDataCreate(kCFAllocatorDefault, UnsafePointer<UInt8>(nsData.bytes), nsData.length)
            
            if let imageSource : CGImageSource = CGImageSourceCreateWithData(cfData, nil)
            {
                let options: [NSString : NSObject] =
                    [
                        kCGImageSourceThumbnailMaxPixelSize: maxSideLength,
                        kCGImageSourceCreateThumbnailFromImageAlways: true
                    ]
                
                if let image : UIImage = (CGImageSourceCreateThumbnailAtIndex(imageSource, 0, options).flatMap { UIImage(CGImage: $0) })
                {
                    resizedImage = image
                }
            }
        }
        
        return resizedImage
    }
}

