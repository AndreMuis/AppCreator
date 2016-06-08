//
//  APCScreenCollectionViewCell.swift
//  AppCreator
//
//  Created by Andre Muis on 5/27/16.
//  Copyright © 2016 Andre Muis. All rights reserved.
//

import UIKit

class APCScreenCollectionViewCell: UICollectionViewCell
{
    @IBOutlet weak var titleLabel: UILabel!

    let style : APCScreenListCellStyle

    var screen : APCScreen?
    
    static var nib : UINib
    {
        let nib : UINib = UINib(nibName: String(APCScreenCollectionViewCell.self), bundle: nil)
        
        return nib
    }
    
    required init?(coder aDecoder: NSCoder)
    {
        self.style = APCScreenListCellStyle()
        
        super.init(coder: aDecoder)
    }
    
    override func awakeFromNib()
    {
        super.awakeFromNib()
    
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
            if let screen = self.screen
            {
                self.titleLabel.text = screen.title
            }
        }
    }
    
    override func prepareForReuse()
    {
        super.prepareForReuse()
        
        if let screen = self.screen
        {
            screen.removeObserver(self, forKeyPath: "name")
        }
    }

    func refresh(screen screen : APCScreen)
    {
        self.screen = screen
        
        self.titleLabel.text = screen.title
        
        screen.addObserver(self, forKeyPath: "name", options: NSKeyValueObservingOptions([.New, .Old]), context: &context)
    }
    
    deinit
    {
        if let screen = self.screen
        {
            screen.removeObserver(self, forKeyPath: "name")
        }
    }
}














