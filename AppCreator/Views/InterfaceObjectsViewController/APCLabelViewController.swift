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
    @IBOutlet weak var moveUpButton: UIButton!
    @IBOutlet weak var moveDownButton: UIButton!
    @IBOutlet weak var deleteButton : UIButton!

    let style : APCLabelViewStyle

    var delegate : APCLabelViewControllerDelegate?

    var label : APCLabel?
    {
        didSet
        {
            self.textTextView.text = self.label?.text ?? ""
            
            self.saveButton.enabled = self.label != nil ? true : false
            self.moveUpButton.enabled = self.label != nil ? true : false
            self.moveDownButton.enabled = self.label != nil ? true : false
            self.deleteButton.enabled = self.label != nil ? true : false
        }
    }

    var textTextViewBottomMargin : CGFloat
    {
        let margin : CGFloat = CGRectGetHeight(self.view.bounds) - CGRectGetMaxY(self.textTextView.frame)
        
        return margin
    }
    
    required init?(coder aDecoder: NSCoder)
    {
        self.style = APCLabelViewStyle()

        super.init(coder: aDecoder)
    }
    
    override init(nibName: String?, bundle: NSBundle?)
    {
        self.style = APCLabelViewStyle()
        self.delegate = nil

        super.init(nibName: nibName, bundle: bundle)
    }
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        self.view.translatesAutoresizingMaskIntoConstraints = false

        self.textTextView.backgroundColor = self.style.textTextViewBackgroundColor
        
        self.saveButton.enabled = false
        self.moveUpButton.enabled = false
        self.moveDownButton.enabled = false
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
    
    @IBAction func moveUpButtonTapped(sender: AnyObject)
    {
        if let delegate = self.delegate,
            label = self.label
        {
            delegate.labelViewController(self, moveLabel: label, moveDirection: APCMoveDirection.Up)
        }
    }
    
    @IBAction func moveDownButtonTapped(sender: AnyObject)
    {
        if let delegate = self.delegate,
            label = self.label
        {
            delegate.labelViewController(self, moveLabel: label, moveDirection: APCMoveDirection.Down)
        }
    }
    
    @IBAction func deleteButtonTapped(sender: AnyObject)
    {
        if let delegate = self.delegate,
            label = self.label
        {
            delegate.labelViewController(self, deleteLabel: label)
        }
    }
}





















