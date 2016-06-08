//
//  APCButtonViewController.swift
//  AppCreator
//
//  Created by Andre Muis on 5/31/16.
//  Copyright © 2016 Andre Muis. All rights reserved.
//

import UIKit

class APCButtonViewController : UIViewController, UIPickerViewDataSource, UIPickerViewDelegate
{
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var deleteButton: UIButton!
    @IBOutlet weak var pickerView: UIPickerView!
    
    var delegate : APCButtonViewControllerDelegate?
    var pushToScreens : [APCScreen]!

    var button : APCButton?
    {
        didSet
        {
            self.titleTextField.text = self.button?.title ?? ""
            
            self.saveButton.enabled = self.button != nil ? true : false
            self.deleteButton.enabled = self.button != nil ? true : false
            
            if let pushToScreenId : NSUUID = self.button?.pushToScreenId,
                let pushToScreen : APCScreen = self.pushToScreens.filter({$0.id == pushToScreenId}).first,
                let pushToScreenIndex = self.pushToScreens.indexOf(pushToScreen)
            {
                let row = pushToScreenIndex + 1
                
                self.pickerView.selectRow(row, inComponent: 0, animated: true)
            }
            else
            {
                self.pickerView.selectRow(0, inComponent: 0, animated: true)
            }
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
        self.pushToScreens = [APCScreen]()
    }
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        self.saveButton.enabled = false
        self.deleteButton.enabled = false

        let screenList : APCScreenList = (UIApplication.sharedApplication().delegate as? AppDelegate)!.screenList
        
        if let selectedScreen : APCScreen = screenList.selectedScreen
        {
            self.pushToScreens = screenList.allScreens.filter({$0.id != selectedScreen.id})
        }
    }
    
    @IBAction func addButtonTapped(sender: AnyObject)
    {
        if self.titleTextField.trimmedText.isEmpty == false
        {
            if let delegate = self.delegate
            {
                let button = APCButton(title: self.titleTextField.text!)
                
                if self.pickerView.selectedRowInComponent(0) >= 1
                {
                    if let screen = self.pushToScreens?[self.pickerView.selectedRowInComponent(0) - 1]
                    {
                        button.pushToScreenId = screen.id
                    }
                    else
                    {
                        button.pushToScreenId = nil
                    }
                }
                else
                {
                    button.pushToScreenId = nil
                }
                
                delegate.buttonViewController(self, addButton: button)
            }
        }
    }
    
    @IBAction func saveButtonTapped(sender: AnyObject)
    {
        if self.titleTextField.trimmedText.isEmpty == false
        {
            if let button = self.button
            {
                button.title = self.titleTextField.text!
                
                if self.pickerView.selectedRowInComponent(0) >= 1
                {
                    if let screen = self.pushToScreens?[self.pickerView.selectedRowInComponent(0) - 1]
                    {
                        button.pushToScreenId = screen.id
                    }
                    else
                    {
                        button.pushToScreenId = nil
                    }
                }
                else
                {
                    button.pushToScreenId = nil
                }
            }
        }
    }
    
    @IBAction func deleteButtonTapped(sender: AnyObject)
    {
        if self.titleTextField.trimmedText.isEmpty == false
        {
            if let delegate = self.delegate,
                button = self.button
            {
                delegate.buttonViewController(self, deleteButton: button)
            }
        }
    }
    
    // MARK: UIPickerViewDataSource
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int
    {
        return 1
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int
    {
        return self.pushToScreens.count + 1
    }

    // MARK: UIPickerViewDelegate
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String?
    {
        var title : String = ""
        
        if row == 0
        {
            title = "No Screen"
        }
        else if let screen : APCScreen = self.pushToScreens[row - 1]
        {
            title = screen.title
        }
        
        return title
    }
    
    // MARK:
}













