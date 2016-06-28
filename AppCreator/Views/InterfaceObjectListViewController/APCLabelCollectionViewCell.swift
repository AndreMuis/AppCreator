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
    
    let style : APCLabelCellStyle
    
    var delegate : APCLabelCollectionViewCellDelegate?
    var label : APCLabel?
    
    static var nib : UINib
    {
        let nib : UINib = UINib(nibName: String(self), bundle: nil)
        
        return nib
    }
    
    required init?(coder aDecoder: NSCoder)
    {
        self.style = APCLabelCellStyle()
        
        self.delegate = nil
        self.label = nil
        
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

        self.textLabel.textColor = self.style.textTextColor
        self.textLabel.font = APCLabelCellStyle.font
    }
    
    private var context = 0

    override func observeValueForKeyPath(keyPath: String?, ofObject object: AnyObject?, change: [String : AnyObject]?, context: UnsafeMutablePointer<Void>)
    {
        if (context == &self.context)
        {
            if let label : APCLabel = self.label
            {
                self.textLabel.text = label.text
                
                if let delegate : APCLabelCollectionViewCellDelegate = self.delegate
                {
                    delegate.labelCollectionViewCellDidUpdateText(self)
                }
            }
        }
    }
    
    override func prepareForReuse()
    {
        super.prepareForReuse()

        if let label : APCLabel = self.label
        {
            label.removeObserver(self, forKeyPath: APCConstants.textKeyPath)
        }
    }

    static func size(width width : CGFloat, text : String) -> CGSize
    {
        let label : UILabel = UILabel()
        label.text = text
        label.font = APCLabelCellStyle.font
        
        let height : CGFloat = label.systemLayoutSizeFittingSize(UILayoutFittingCompressedSize).height
        
        let size = CGSize(width: width, height: height)
        
        return size
    }
    
    func refresh(label label : APCLabel)
    {
        self.label = label
        
        self.textLabel.text = label.text
        
        label.addObserver(self, forKeyPath: APCConstants.textKeyPath, options: NSKeyValueObservingOptions([.New]), context: &context)
    }
    
    deinit
    {
        if let label = self.label
        {
            label.removeObserver(self, forKeyPath: APCConstants.textKeyPath)
        }
    }
}












