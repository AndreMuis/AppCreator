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
    @IBOutlet weak var textTextView : UITextView!
    @IBOutlet weak var saveButton : UIButton!
    @IBOutlet weak var deleteButton : UIButton!

    var style : APCLabelViewStyle!
    
    var delegate : APCLabelViewControllerDelegate?

    var label : APCLabel?
    {
        didSet
        {
            self.textTextView.text = self.label?.text ?? ""
            
            self.saveButton.enabled = self.label != nil ? true : false
            self.deleteButton.enabled = self.label != nil ? true : false
        }
    }

    required init?(coder aDecoder: NSCoder)
    {
        super.init(coder: aDecoder)

        initCommon()
    }
    
    override init(nibName: String?, bundle: NSBundle?)
    {
        super.init(nibName: nibName, bundle: bundle)
        
        initCommon()
    }
    
    func initCommon()
    {
        self.style = APCLabelViewStyle()
        
        self.delegate = nil
    }
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        self.textTextView.backgroundColor = self.style.textTextViewBackgroundColor
        
        self.saveButton.enabled = false
        self.deleteButton.enabled = false
    }

    @IBAction func addButtonTapped(sender: AnyObject)
    {
        if self.textTextView.trimmedText.isEmpty == false
        {
            if let delegate = self.delegate
            {
                let label = APCLabel(text: self.textTextView.text!)
                
                delegate.labelViewController(self, addLabel: label)
            }
        }
    }
    
    @IBAction func saveButtonTapped(sender: AnyObject)
    {
        if self.textTextView.trimmedText.isEmpty == false
        {
            if let label = self.label
            {
                label.text = self.textTextView.text!
            }
        }
    }
    
    @IBAction func deleteButtonTapped(sender: AnyObject)
    {
        if let delegate = self.delegate,
        let label = self.label
        {
            delegate.labelViewController(self, deleteLabel: label)
        }
    }
}





















