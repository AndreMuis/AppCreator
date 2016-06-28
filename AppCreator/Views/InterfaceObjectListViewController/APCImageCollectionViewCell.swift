//
//  APCImageCollectionViewCell.swift
//  AppCreator
//
//  Created by Andre Muis on 6/1/16.
//  Copyright © 2016 Andre Muis. All rights reserved.
//

import UIKit

class APCImageCollectionViewCell : UICollectionViewCell
{
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var overlayView: UIView!
    
    let style : APCImageCellStyle
    
    var delegate : APCImageCollectionViewCellDelegate?
    var image : APCImage?
    
    static var nib : UINib
    {
        let nib : UINib = UINib(nibName: String(APCImageCollectionViewCell.self), bundle: nil)
        
        return nib
    }
    
    required init?(coder aDecoder: NSCoder)
    {
        self.style = APCImageCellStyle()
        
        self.delegate = nil
        self.image = nil
        
        super.init(coder: aDecoder)
    }
    
    override var selected: Bool
    {
        didSet
        {
            if self.selected == true
            {
                self.overlayView.hidden = false
            }
            else
            {
                self.overlayView.hidden = true
            }
        }
    }

    override func awakeFromNib()
    {
        super.awakeFromNib()

        self.overlayView.backgroundColor = self.style.overlayBackgroundColor
        self.overlayView.hidden = true
    }
    
    private var context = 0
    
    override func observeValueForKeyPath(keyPath: String?, ofObject object: AnyObject?, change: [String : AnyObject]?, context: UnsafeMutablePointer<Void>)
    {
        if (context == &self.context)
        {
            if let image : APCImage = self.image
            {
                self.imageView.image = image.uiImage
                
                if let delegate : APCImageCollectionViewCellDelegate = self.delegate
                {
                    delegate.imageCollectionViewCellDidUpdateImage(self)
                }
            }
        }
    }
    
    override func prepareForReuse()
    {
        super.prepareForReuse()

        if let image : APCImage = self.image
        {
            image.removeObserver(self, forKeyPath: APCConstants.uiImageKeyPath)
        }
    }
    
    static func size(width width: CGFloat, uiImage: UIImage) -> CGSize
    {
        let height : CGFloat = width * (uiImage.size.height / uiImage.size.width)
        
        let size : CGSize = CGSize(width: width, height: height)

        return size
    }
    
    func refresh(image image: APCImage)
    {
        self.image = image
        
        self.imageView.image = image.uiImage
        
        image.addObserver(self, forKeyPath: APCConstants.uiImageKeyPath, options: NSKeyValueObservingOptions([.New]), context: &context)
    }
   
    deinit
    {
        if let image = self.image
        {
            image.removeObserver(self, forKeyPath: APCConstants.uiImageKeyPath)
        }
    }
}
















