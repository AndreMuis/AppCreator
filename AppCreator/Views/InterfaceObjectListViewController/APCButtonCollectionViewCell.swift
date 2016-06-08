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
    
    var style : APCButtonCellStyle
    
    var button : APCButton?
    
    static var nib : UINib
    {
        let nib : UINib = UINib(nibName: String(self), bundle: nil)
        
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

        self.titleLabel.textColor = self.style.titleTextColor

        let backgroundView : UIView = UIView()
        backgroundView.backgroundColor = self.style.backgroundColor
        
        self.backgroundView = backgroundView
        
        let selectedBackgroundView : UIView = UIView()
        selectedBackgroundView.backgroundColor = self.style.selectedBackgroundColor
        
        self.selectedBackgroundView = selectedBackgroundView
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
            button.removeObserver(self, forKeyPath: "title")
        }
    }
    
    static func size(width : CGFloat) -> CGSize
    {
        let size : CGSize = CGSize(width: width, height: APCButtonCellStyle.height)
        
        return size
    }

    func refresh(button button : APCButton)
    {
        self.titleLabel.text = button.title

        self.button = button
        
        button.addObserver(self, forKeyPath: "title", options: NSKeyValueObservingOptions([.New, .Old]), context: &context)
    }
    
    deinit
    {
        if let button = self.button
        {
            button.removeObserver(self, forKeyPath: "title")
        }
    }
}















