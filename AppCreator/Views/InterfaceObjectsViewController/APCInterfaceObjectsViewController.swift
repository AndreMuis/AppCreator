//
//  APCObjectsViewController.swift
//  AppCreator
//
//  Created by Andre Muis on 5/31/16.
//  Copyright © 2016 Andre Muis. All rights reserved.
//

import UIKit

class APCInterfaceObjectsViewController :
    UIViewController,
    APCButtonViewControllerDelegate,
    APCImageViewControllerDelegate,
    APCLabelViewControllerDelegate
{
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    @IBOutlet weak var containerView: UIView!
    
    let buttonViewController : APCButtonViewController
    let imageViewController : APCImageViewController
    let labelViewController : APCLabelViewController
    
    var session : APCSession
    var objectList : APCInterfaceObjectList?

    required init?(coder aDecoder: NSCoder)
    {
        self.buttonViewController = APCButtonViewController(nibName: String(APCButtonViewController.self), bundle: nil)
        self.imageViewController = APCImageViewController(nibName: String(APCImageViewController.self), bundle: nil)
        self.labelViewController = APCLabelViewController(nibName: String(APCLabelViewController.self), bundle: nil)
        
        self.session = (UIApplication.sharedApplication().delegate as? AppDelegate)!.session
        
        super.init(coder: aDecoder)
    }

    private var context = 0
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        self.buttonViewController.delegate = self
        self.imageViewController.delegate = self
        self.labelViewController.delegate = self

        self.addObjectViewController(self.buttonViewController)
        self.addObjectViewController(self.imageViewController)
        self.addObjectViewController(self.labelViewController)
        
        self.segmentedControl.selectedSegmentIndex = 0
        self.showObjectView()
        
        if let list = self.objectList
        {
            list.addObserver(self, forKeyPath: "selectedObject", options: NSKeyValueObservingOptions([.New, .Old]), context: &context)
        }
    }

    override func observeValueForKeyPath(keyPath: String?, ofObject object: AnyObject?, change: [String : AnyObject]?, context: UnsafeMutablePointer<Void>)
    {
        if (context == &self.context)
        {
            if let object = self.objectList?.selectedObject
            {
                if let button = object as? APCButton
                {
                    self.buttonViewController.button = button
                    self.imageViewController.image = nil
                    self.labelViewController.label = nil
                    
                    self.segmentedControl.selectedSegmentIndex = 2
                    self.showObjectView()
                }
                else if let image = object as? APCImage
                {
                    self.buttonViewController.button = nil
                    self.imageViewController.image = image
                    self.labelViewController.label = nil
                    
                    self.segmentedControl.selectedSegmentIndex = 1
                    self.showObjectView()
                }
                else if let label = object as? APCLabel
                {
                    self.buttonViewController.button = nil
                    self.imageViewController.image = nil
                    self.labelViewController.label = label
                    
                    self.segmentedControl.selectedSegmentIndex = 0
                    self.showObjectView()
                }
            }
            else
            {
                self.buttonViewController.button = nil
                self.imageViewController.image = nil
                self.labelViewController.label = nil
            }
        }
    }
    
    func addObjectViewController(viewController : UIViewController)
    {
        self.addChildViewController(viewController)
        self.containerView.addSubview(viewController.view)
        viewController.didMoveToParentViewController(self)
    }
    
    @IBAction func segmentedControlValueChanged(sender: AnyObject)
    {
        self.showObjectView()
    }
    
    func showObjectView()
    {
        switch self.segmentedControl.selectedSegmentIndex
        {
        case 0:
            self.containerView.bringSubviewToFront(self.labelViewController.view)
            
        case 1:
            self.containerView.bringSubviewToFront(self.imageViewController.view)
            
        case 2:
            self.containerView.bringSubviewToFront(self.buttonViewController.view)
            
        default:
            print("selected segment index not handled ")
        }
    }
    
    // MARK: APCButtonViewControllerDelegate
    
    func buttonViewController(viewController: APCButtonViewController, addButton button: APCButton)
    {
        if let list : APCInterfaceObjectList = self.objectList
        {
            list.add(object: button)
        }
    }
    
    func buttonViewController(viewController: APCButtonViewController, deleteButton button: APCButton)
    {
        if let list = self.objectList,
            let index : Int = list.indexOfObject(button)
        {
            list.remove(objectAtIndex: index)
        }
    }
    
    // MARK: APCImageViewControllerDelegate
    
    func imageViewController(viewController: APCImageViewController, addImage image: APCImage)
    {
        if let list : APCInterfaceObjectList = self.objectList
        {
            list.add(object: image)
        }
    }
    
    func imageViewController(viewController: APCImageViewController, deleteImage image: APCImage)
    {
        if let list = self.objectList,
            let index : Int = list.indexOfObject(image)
        {
            list.remove(objectAtIndex: index)
        }
    }
    
    // MARK: APCLabelViewControllerDelegate
    
    func labelViewController(viewController: APCLabelViewController, addLabel label: APCLabel)
    {
        if let list : APCInterfaceObjectList = self.objectList
        {
            list.add(object: label)
        }
    }
    
    func labelViewController(viewController: APCLabelViewController, deleteLabel label: APCLabel)
    {
        if let list = self.objectList,
            let index : Int = list.indexOfObject(label)
        {
            list.remove(objectAtIndex: index)
        }
    }

    // MARK:
    
    deinit
    {
        if let list = self.objectList
        {
            list.removeArrayObserver(self)
        }
    }
}















