//
//  APCLabelViewController.swift
//  AppCreator
//
//  Created by Andre Muis on 5/31/16.
//  Copyright © 2016 Andre Muis. All rights reserved.
//

import UIKit

class APCLabelViewController: UIViewController, UITextFieldDelegate
{
    @IBOutlet weak var textTextField: UITextField!

    var delegate : APCLabelViewControllerDelegate?

    var label : APCLabel?
    {
        didSet
        {
            self.textTextField.text = self.label?.text ?? ""
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
        let viewController : APCAlertViewController = APCAlertViewController(title: "Add Label",
                                                                             textFieldPlaceholder: "label text")
        {
            (enteredText : String) in
            
            if let delegate = self.delegate
            {
                let label = APCLabel(text: enteredText)
                
                delegate.labelViewController(self, addLabel: label)
            }
        }
        
        self.presentViewController(viewController, animated: true, completion: nil)
    }
    
    @IBAction func deleteLabelTapped(sender: AnyObject)
    {
        if let delegate = self.delegate,
        let label = self.label
        {
            delegate.labelViewController(self, deleteLabel: label)
        }
    }
    
    // MARK: UITextFieldDelegate
    
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool
    {
        if let label = self.label
        {
            label.text = (label.text as NSString).stringByReplacingCharactersInRange(range, withString: string)
        }
        
        return true
    }
    
    // MARK:
}





















