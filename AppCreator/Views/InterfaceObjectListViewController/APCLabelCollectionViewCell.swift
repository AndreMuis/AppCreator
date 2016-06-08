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
        
        self.textLabel.textColor = self.style.textTextColor
        
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
            if let label = self.label
            {
                self.textLabel.text = label.text
                
                if let delegate = self.delegate
                {
                    delegate.labelCollectionViewCellDidUpdateText(self)
                }
            }
        }
    }
    
    override func prepareForReuse()
    {
        super.prepareForReuse()

        if let label = self.label
        {
            label.removeObserver(self, forKeyPath: "text")
            
            self.invalidateIntrinsicContentSize()

        }
    }

    static func size(width : CGFloat, text : String) -> CGSize
    {
        var size : CGSize = CGSizeZero
        
        let topLevelObjects : [AnyObject] = NSBundle.mainBundle().loadNibNamed(String(APCLabelCollectionViewCell.self), owner: nil, options: nil)
    
        if let cell : APCLabelCollectionViewCell = topLevelObjects[0] as? APCLabelCollectionViewCell
        {
            let label = APCLabel(text: text)
            cell.refresh(label: label)
            
            size = CGSize(width: width, height: cell.systemLayoutSizeFittingSize(UILayoutFittingCompressedSize).height)
        }
        
        return size
    }
    
    func refresh(label label : APCLabel)
    {
        self.label = label
        
        self.textLabel.text = label.text
        
        label.addObserver(self, forKeyPath: "text", options: NSKeyValueObservingOptions([.New, .Old]), context: &context)
    }
    
    deinit
    {
        if let label = self.label
        {
            label.removeObserver(self, forKeyPath: "text")
        }
    }
}












