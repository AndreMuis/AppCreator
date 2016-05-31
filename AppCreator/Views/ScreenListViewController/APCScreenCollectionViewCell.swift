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
    @IBOutlet weak var nameLabel: UILabel!

    var screen : APCScreen?
    
    static var nib : UINib
    {
        let nib : UINib = UINib(nibName: String(APCScreenCollectionViewCell.self), bundle: nil)
        
        return nib
    }
    
    override func awakeFromNib()
    {
        super.awakeFromNib()
    
        let backgroundView : UIView = UIView()
        backgroundView.backgroundColor = UIColor.whiteColor()
        
        self.backgroundView = backgroundView
        
        let selectedBackgroundView : UIView = UIView()
        selectedBackgroundView.backgroundColor = UIColor(white: 0.9, alpha: 1.0)
        
        self.selectedBackgroundView = selectedBackgroundView
    }
    
    override func observeValueForKeyPath(keyPath: String?, ofObject object: AnyObject?, change: [String : AnyObject]?, context: UnsafeMutablePointer<Void>)
    {
        self.nameLabel.text = self.screen!.name
    }
    
    override func prepareForReuse()
    {
        self.screen?.removeObserver(self, forKeyPath: "name")
    }

    private var context = 0

    func refresh(screen screen : APCScreen)
    {
        self.screen = screen
        
        self.nameLabel.text = screen.name
        
        screen.addObserver(self, forKeyPath: "name", options: NSKeyValueObservingOptions([.New, .Old]), context: &context)
    }
    
    deinit
    {
        self.screen?.removeObserver(self, forKeyPath: "name")
    }
}














