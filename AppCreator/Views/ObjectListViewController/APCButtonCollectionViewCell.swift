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
    
    var button : APCButton?
    
    override func awakeFromNib()
    {
        super.awakeFromNib()

        self.layer.cornerRadius = 10.0
        self.layer.masksToBounds = true

        self.titleLabel.backgroundColor = UIColor.clearColor()
        self.titleLabel.textColor = UIColor.whiteColor()

        let backgroundView : UIView = UIView()
        backgroundView.backgroundColor = UIColor(white: 0.3, alpha: 1.0)
        
        self.backgroundView = backgroundView
        
        let selectedBackgroundView : UIView = UIView()
        selectedBackgroundView.backgroundColor = UIColor(white: 0.5, alpha: 1.0)
        
        self.selectedBackgroundView = selectedBackgroundView
    }
    
    static var nib : UINib
    {
        let nib : UINib = UINib(nibName: String(APCButtonCollectionViewCell.self), bundle: nil)
        
        return nib
    }
    
    override func observeValueForKeyPath(keyPath: String?, ofObject object: AnyObject?, change: [String : AnyObject]?, context: UnsafeMutablePointer<Void>)
    {
        self.titleLabel.text = self.button!.title
    }
    
    override func prepareForReuse()
    {
        self.button?.removeObserver(self, forKeyPath: "title")
    }
    
    private var context = 0

    func refresh(button button : APCButton)
    {
        self.titleLabel.text = button.title

        self.button = button
        
        button.addObserver(self, forKeyPath: "title", options: NSKeyValueObservingOptions([.New, .Old]), context: &context)
    }
    
    deinit
    {
        self.button?.removeObserver(self, forKeyPath: "title")
    }
}















