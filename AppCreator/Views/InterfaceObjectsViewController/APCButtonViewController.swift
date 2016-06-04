//
//  APCButtonViewController.swift
//  AppCreator
//
//  Created by Andre Muis on 5/31/16.
//  Copyright © 2016 Andre Muis. All rights reserved.
//

import UIKit

class APCButtonViewController : UIViewController, UITextFieldDelegate
{
    @IBOutlet weak var titleTextField: UITextField!
    
    var delegate : APCButtonViewControllerDelegate?
    
    var button : APCButton?
    {
        didSet
        {
            self.titleTextField.text = self.button?.title ?? ""
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
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        self.titleTextField.backgroundColor = UIColor(white: 0.9, alpha: 1.0)
    }
    
    @IBAction func addButtonTapped(sender: AnyObject)
    {
        let viewController : APCAlertViewController = APCAlertViewController(title: "Add Button",
                                                                             textFieldPlaceholder: "button title")
        {
            (enteredText : String) in

            if let delegate = self.delegate
            {
                let button = APCButton(title: enteredText)
                
                delegate.buttonViewController(self, addButton: button)
            }
        }
        
        self.presentViewController(viewController, animated: true, completion: nil)
    }
    
    @IBAction func deleteButtonTapped(sender: AnyObject)
    {
        if let delegate = self.delegate,
            button = self.button
        {
            delegate.buttonViewController(self, deleteButton: button)
        }
    }
    
    // MARK: UITextFieldDelegate
    
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool
    {
        if let button = self.button
        {
            button.title = (button.title as NSString).stringByReplacingCharactersInRange(range, withString: string)
        }
        
        return true
    }
    
    // MARK:
}













