//
//  APCLabelViewController.swift
//  AppCreator
//
//  Created by Andre Muis on 5/31/16.
//  Copyright © 2016 Andre Muis. All rights reserved.
//

import UIKit

class APCLabelViewController: UIViewController
{
    @IBOutlet weak var textTextField: UITextField!

    var delegate : APCLabelViewControllerDelegate?

    var label : APCLabel?
    {
        didSet
        {
            self.textTextField.text = self.label!.text
        }
    }

    required init?(coder aDecoder: NSCoder)
    {
        super.init(coder: aDecoder)
    }
    
    override init(nibName: String?, bundle: NSBundle?)
    {
        super.init(nibName: nibName, bundle: bundle)
        
        self.delegate = nil
    }
    
    @IBAction func addLabelTapped(sender: AnyObject)
    {
        let label = APCLabel(text: self.textTextField.text!)
        
        self.delegate?.labelViewController(self, addLabel: label)
    }
    
    @IBAction func saveLabelTapped(sender: AnyObject)
    {
        self.label!.text = self.textTextField.text!
        
        self.delegate?.labelViewController(self, didModifyLabel: self.label!)
    }
    
    @IBAction func deleteLabelTapped(sender: AnyObject)
    {
        self.delegate?.labelViewController(self, deleteLabel: self.label!)
    }
}
