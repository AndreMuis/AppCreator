//
//  APCLabelCollectionViewCell.swift
//  AppCreator
//
//  Created by Andre Muis on 6/1/16.
//  Copyright © 2016 Andre Muis. All rights reserved.
//

import UIKit

class APCLabelCollectionViewCell: UICollectionViewCell
{
    @IBOutlet weak var textLabel: UILabel!
    
    var label : APCLabel?
    
    static var nib : UINib
    {
        let nib : UINib = UINib(nibName: String(self), bundle: nil)
        
        return nib
    }

    override func awakeFromNib()
    {
        super.awakeFromNib()
        
        self.textLabel.textColor = UIColor.whiteColor()
        
        let backgroundView : UIView = UIView()
        backgroundView.backgroundColor = UIColor(white: 0.3, alpha: 1.0)
        
        self.backgroundView = backgroundView
        
        let selectedBackgroundView : UIView = UIView()
        selectedBackgroundView.backgroundColor = UIColor(white: 0.5, alpha: 1.0)
        
        self.selectedBackgroundView = selectedBackgroundView
    }
    
    override func observeValueForKeyPath(keyPath: String?, ofObject object: AnyObject?, change: [String : AnyObject]?, context: UnsafeMutablePointer<Void>)
    {
        self.textLabel.text = self.label!.text
    }
    
    override func prepareForReuse()
    {
        self.label?.removeObserver(self, forKeyPath: "text")
    }
    
    private var context = 0
    
    func refresh(label label : APCLabel)
    {
        self.label = label

        self.textLabel.text = label.text
        
        label.addObserver(self, forKeyPath: "text", options: NSKeyValueObservingOptions([.New, .Old]), context: &context)
    }
    
    deinit
    {
        self.label?.removeObserver(self, forKeyPath: "text")
    }
}












