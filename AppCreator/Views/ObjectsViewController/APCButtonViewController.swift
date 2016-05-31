//
//  APCButtonViewController.swift
//  AppCreator
//
//  Created by Andre Muis on 5/31/16.
//  Copyright © 2016 Andre Muis. All rights reserved.
//

import UIKit

class APCButtonViewController : UIViewController
{
    @IBOutlet weak var buttonTitleTextField: UITextField!
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var deleteButton: UIButton!
    
    var delegate : APCButtonViewControllerDelegate?
    
    var button : APCButton?
    {
        didSet
        {
            self.buttonTitleTextField.text = self.button!.title
            
            self.saveButton.enabled = true
            self.deleteButton.enabled = true
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
        
        self.buttonTitleTextField.backgroundColor = UIColor(white: 0.9, alpha: 1.0)
        
        self.saveButton.enabled = false
        self.deleteButton.enabled = false
    }
    
    @IBAction func addButtonTapped(sender: AnyObject)
    {
        let button = APCButton(title: self.buttonTitleTextField.text!)
        
        self.delegate?.buttonViewController(self, addButton: button)
    }
    
    @IBAction func saveButtonTapped(sender: AnyObject)
    {
        button?.title = self.self.buttonTitleTextField.text!
        
        self.delegate?.buttonViewController(self, didModifyButton: self.button!)
    }
    
    @IBAction func deleteButtonTapped(sender: AnyObject)
    {
        self.delegate?.buttonViewController(self, deleteButton: self.button!)
    }
}













