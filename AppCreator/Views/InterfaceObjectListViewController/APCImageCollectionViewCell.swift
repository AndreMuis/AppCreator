//
//  APCImageCollectionViewCell.swift
//  AppCreator
//
//  Created by Andre Muis on 6/1/16.
//  Copyright © 2016 Andre Muis. All rights reserved.
//

import UIKit

class APCImageCollectionViewCell: UICollectionViewCell
{
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var overlayView: UIView!
    
    let style : APCImageCellStyle
    
    var delegate : APCImageCollectionViewCellDelegate?
    var image : APCImage?
    
    static var nib : UINib
    {
        let nib : UINib = UINib(nibName: String(self), bundle: nil)
        
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
            if (self.selected == true)
            {
                self.overlayView.hidden = false
            }
            else
            {
                self.overlayView.hidden = true
            }
        }
    }

    override var highlighted : Bool
    {
        didSet
        {
            if (self.highlighted == true)
            {
                self.overlayView.hidden = false
            }
            else if (self.selected == false)
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
            if let image = self.image
            {
                self.imageView.image = image.uiImage
                
                if let delegate = self.delegate
                {
                    delegate.imageCollectionViewCellDidUpdateText(self)
                }
            }
        }
    }
    
    override func prepareForReuse()
    {
        super.prepareForReuse()

        if let image = self.image
        {
            image.removeObserver(self, forKeyPath: "uiImage")
        }
    }
    
    static func size(width : CGFloat, uiImage : UIImage) -> CGSize
    {
        var size : CGSize = CGSizeZero

        let topLevelObjects : [AnyObject] = NSBundle.mainBundle().loadNibNamed(String(APCImageCollectionViewCell.self), owner: nil, options: nil)
        
        if let cell : APCImageCollectionViewCell = topLevelObjects[0] as? APCImageCollectionViewCell,
            let image = APCImage(uiImage: uiImage)
            {
                cell.refresh(image: image)
                
                cell.imageView.addConstraint(NSLayoutConstraint(item: cell.imageView,
                                                                attribute: NSLayoutAttribute.Height,
                                                                relatedBy: NSLayoutRelation.Equal,
                                                                toItem: cell.imageView,
                                                                attribute: NSLayoutAttribute.Width,
                                                                multiplier: uiImage.size.height / uiImage.size.width,
                                                                constant: 0.0))
                
                size = cell.systemLayoutSizeFittingSize(CGSize(width: width, height: 10000.0),
                                                        withHorizontalFittingPriority: UILayoutPriorityRequired,
                                                        verticalFittingPriority: UILayoutPriorityDefaultLow)
            }
        
        return size
    }
    
    func refresh(image image : APCImage)
    {
        self.image = image
        
        self.imageView.image = image.uiImage
        
        image.addObserver(self, forKeyPath: "uiImage", options: NSKeyValueObservingOptions([.New, .Old]), context: &context)
    }
   
    deinit
    {
        if let image = self.image
        {
            image.removeObserver(self, forKeyPath: "uiImage")
        }
    }
}
















