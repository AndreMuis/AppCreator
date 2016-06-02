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

    var image : APCImage?
    
    static var nib : UINib
    {
        let nib : UINib = UINib(nibName: String(self), bundle: nil)
        
        return nib
    }

    override func awakeFromNib()
    {
        super.awakeFromNib()
        
        let backgroundView : UIView = UIView()
        backgroundView.backgroundColor = UIColor(white: 0.3, alpha: 1.0)
        
        self.backgroundView = backgroundView
        
        let selectedBackgroundView : UIView = UIView()
        selectedBackgroundView.backgroundColor = UIColor(white: 0.5, alpha: 1.0)
        
        self.selectedBackgroundView = selectedBackgroundView
    }
    
    override func observeValueForKeyPath(keyPath: String?, ofObject object: AnyObject?, change: [String : AnyObject]?, context: UnsafeMutablePointer<Void>)
    {
        self.imageView.image = self.image?.uiImage
    }
    
    override func prepareForReuse()
    {
        self.image?.removeObserver(self, forKeyPath: "uiImage")
    }
    
    private var context = 0
    
    func refresh(image image : APCImage)
    {
        self.image = image
        
        self.imageView.image = image.uiImage
        
        image.addObserver(self, forKeyPath: "uiImage", options: NSKeyValueObservingOptions([.New, .Old]), context: &context)
    }
    
    deinit
    {
        self.image?.removeObserver(self, forKeyPath: "uiImage")
    }
}
















