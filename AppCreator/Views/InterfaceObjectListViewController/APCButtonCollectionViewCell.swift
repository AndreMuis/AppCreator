//
//  APCButtonCollectionViewCell.swift
//  AppCreator
//
//  Created by Andre Muis on 5/28/16.
//  Copyright © 2016 Andre Muis. All rights reserved.
//

import UIKit

class APCButtonCollectionViewCell : UICollectionViewCell
{
    @IBOutlet weak var titleLabel: UILabel!
    
    let style : APCButtonCellStyle
    var button : APCButton?
    
    static var nib : UINib
    {
        let nib : UINib = UINib(nibName: String(APCButtonCollectionViewCell.self), bundle: nil)
        
        return nib
    }
    
    required init?(coder aDecoder: NSCoder)
    {
        self.style = APCButtonCellStyle()
        self.button = nil
        
        super.init(coder: aDecoder)
    }
    
    override func awakeFromNib()
    {
        super.awakeFromNib()

        self.layer.cornerRadius = self.style.cornerRadius
        self.layer.masksToBounds = true

        let backgroundView : UIView = UIView()
        backgroundView.backgroundColor = self.style.backgroundColor
        
        self.backgroundView = backgroundView
        
        let selectedBackgroundView : UIView = UIView()
        selectedBackgroundView.backgroundColor = self.style.selectedBackgroundColor
        
        self.selectedBackgroundView = selectedBackgroundView
        
        self.titleLabel.textColor = self.style.titleTextColor
        self.titleLabel.font = self.style.font
    }
    
    private var context = 0
    
    override func observeValueForKeyPath(keyPath: String?, ofObject object: AnyObject?, change: [String : AnyObject]?, context: UnsafeMutablePointer<Void>)
    {
        if (context == &self.context)
        {
            if let button = self.button
            {
                self.titleLabel.text = button.title
            }
        }
    }
    
    override func prepareForReuse()
    {
        super.prepareForReuse()

        if let button = self.button
        {
            button.removeObserver(self, forKeyPath: APCConstants.titleKeyPath)
        }
    }
    
    static func size(width width: CGFloat) -> CGSize
    {
        let size : CGSize = CGSize(width: width, height: width * (1.0 / APCButtonCellStyle.aspectRatio))
        
        return size
    }

    func refresh(button button : APCButton)
    {
        self.titleLabel.text = button.title

        self.button = button
        
        button.addObserver(self, forKeyPath: APCConstants.titleKeyPath, options: NSKeyValueObservingOptions([.New]), context: &context)
    }
    
    deinit
    {
        if let button = self.button
        {
            button.removeObserver(self, forKeyPath: APCConstants.titleKeyPath)
        }
    }
}















