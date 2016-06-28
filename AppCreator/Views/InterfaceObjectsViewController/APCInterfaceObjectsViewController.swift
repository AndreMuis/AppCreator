//
//  APCInterfaceObjectsViewController.swift
//  AppCreator
//
//  Created by Andre Muis on 5/31/16.
//  Copyright © 2016 Andre Muis. All rights reserved.
//

import UIKit

class APCInterfaceObjectsViewController : UIViewController,
    APCButtonViewControllerDelegate,
    APCImageViewControllerDelegate,
    APCLabelViewControllerDelegate
{
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    @IBOutlet weak var containerView: UIView!
    
    let buttonViewController : APCButtonViewController
    let imageViewController : APCImageViewController
    let labelViewController : APCLabelViewController
    
    var textElementBottomMargin : CGFloat
    {
        var margin : CGFloat
        
        switch self.segmentedControl.selectedSegmentIndex
        {
        case APCInterfaceObjectViewIndex.Label.rawValue:
            margin = self.labelViewController.textTextViewBottomMargin
            
        case APCInterfaceObjectViewIndex.Button.rawValue:
            margin = self.buttonViewController.titleTextFieldBottomMargin

        default:
            margin = 0
            
            print("Segmented control selected segment index not handled. index = \(self.segmentedControl.selectedSegmentIndex)")
        }

        return margin
    }
    
    let session : APCSession
    var objectList : APCInterfaceObjectList?

    var selectedObjectViewIndex : Int
    {
        return self.segmentedControl.selectedSegmentIndex
    }
    
    required init?(coder aDecoder: NSCoder)
    {
        self.buttonViewController = APCButtonViewController(nibName: String(APCButtonViewController.self), bundle: nil)
        self.imageViewController = APCImageViewController(nibName: String(APCImageViewController.self), bundle: nil)
        self.labelViewController = APCLabelViewController(nibName: String(APCLabelViewController.self), bundle: nil)
        
        self.session = (UIApplication.sharedApplication().delegate as? AppDelegate)!.session
        self.objectList = nil
        
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
        
        if let list :APCInterfaceObjectList = self.objectList
        {
            list.addObserver(self,
                             forKeyPath: APCConstants.selectedObjectKeyPath,
                             options: NSKeyValueObservingOptions([.New]),
                             context: &context)
        }
    }
    
    override func observeValueForKeyPath(keyPath: String?, ofObject object: AnyObject?, change: [String : AnyObject]?, context: UnsafeMutablePointer<Void>)
    {
        if (context == &self.context)
        {
            if let object : APCInterfaceObject = self.objectList?.selectedObject
            {
                if let button : APCButton = object as? APCButton
                {
                    self.buttonViewController.button = button
                    self.imageViewController.image = nil
                    self.labelViewController.label = nil
                    
                    self.segmentedControl.selectedSegmentIndex = APCInterfaceObjectViewIndex.Button.rawValue
                    self.showObjectView()
                }
                else if let image : APCImage = object as? APCImage
                {
                    self.buttonViewController.button = nil
                    self.imageViewController.image = image
                    self.labelViewController.label = nil
                    
                    self.segmentedControl.selectedSegmentIndex = APCInterfaceObjectViewIndex.Image.rawValue
                    self.showObjectView()
                }
                else if let label : APCLabel = object as? APCLabel
                {
                    self.buttonViewController.button = nil
                    self.imageViewController.image = nil
                    self.labelViewController.label = label
                    
                    self.segmentedControl.selectedSegmentIndex = APCInterfaceObjectViewIndex.Label.rawValue
                    self.showObjectView()
                }
                else
                {
                    print("Interface object type not handled. Interface object = \(object)")
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
        
        let views : [String : UIView] = ["view" : viewController.view]
        
        let horizontalConstraints : [NSLayoutConstraint] = NSLayoutConstraint.constraintsWithVisualFormat("H:|-0-[view]-0-|",
                                                                                                          options: [],
                                                                                                          metrics: nil,
                                                                                                          views: views)
        
        let verticalConstraints : [NSLayoutConstraint] = NSLayoutConstraint.constraintsWithVisualFormat("V:|-0-[view]-0-|",
                                                                                                        options: [],
                                                                                                        metrics: nil,
                                                                                                        views: views)
        
        self.containerView.addConstraints(horizontalConstraints + verticalConstraints)
    }
    
    @IBAction func segmentedControlValueChanged(sender: AnyObject)
    {
        self.showObjectView()
    }
    
    func showObjectView()
    {
        switch self.segmentedControl.selectedSegmentIndex
        {
        case APCInterfaceObjectViewIndex.Label.rawValue:
            self.containerView.bringSubviewToFront(self.labelViewController.view)
            
        case APCInterfaceObjectViewIndex.Image.rawValue:
            self.containerView.bringSubviewToFront(self.imageViewController.view)
            
        case APCInterfaceObjectViewIndex.Button.rawValue:
            self.containerView.bringSubviewToFront(self.buttonViewController.view)
            
        default:
            print("Selected segment index not handled. selectedSegmentIndex = \(self.segmentedControl.selectedSegmentIndex)")
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
    
    func buttonViewController(viewController: APCButtonViewController, moveButton button: APCButton, moveDirection: APCMoveDirection)
    {
        self.moveObject(button, moveDirection: moveDirection)
    }
    
    func buttonViewController(viewController: APCButtonViewController, deleteButton button: APCButton)
    {
        if let list : APCInterfaceObjectList  = self.objectList,
            index : Int = list.indexOfObject(button)
        {
            if list.remove(objectAtIndex: index) == false
            {
                print("Unable to remove interface object. index = \(index)")
            }
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
    
    func imageViewController(viewController: APCImageViewController, moveImage image: APCImage, moveDirection: APCMoveDirection)
    {
        self.moveObject(image, moveDirection: moveDirection)
    }

    func imageViewController(viewController: APCImageViewController, deleteImage image: APCImage)
    {
        if let list = self.objectList,
            index : Int = list.indexOfObject(image)
        {
            if list.remove(objectAtIndex: index) == false
            {
                print("Unable to remove interface object. index = \(index)")
            }

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
    
    func labelViewController(viewController: APCLabelViewController, moveLabel label: APCLabel, moveDirection: APCMoveDirection)
    {
        self.moveObject(label, moveDirection: moveDirection)
    }

    func labelViewController(viewController: APCLabelViewController, deleteLabel label: APCLabel)
    {
        if let list = self.objectList,
            index : Int = list.indexOfObject(label)
        {
            if list.remove(objectAtIndex: index) == false
            {
                print("Unable to remove interface object. index = \(index)")
            }
        }
    }

    // MARK:
    
    func moveObject(object: APCInterfaceObject, moveDirection: APCMoveDirection)
    {
        if let list = self.objectList,
            index : Int = list.indexOfObject(object)
        {
            switch moveDirection
            {
            case APCMoveDirection.Up:
                if index >= 1
                {
                    if list.move(objectAtIndex: index, toIndex: index - 1) == false
                    {
                        print("Unable to move interface object. fromIndex = \(index), toIndex = \(index - 1)")
                    }
                }
                
            case APCMoveDirection.Down:
                if index < list.count - 1
                {
                    if list.move(objectAtIndex: index, toIndex: index + 1) == false
                    {
                        print("Unable to move interface object. fromIndex = \(index), toIndex = \(index + 1)")
                    }
                }
            }
        }
    }

    // MARK:

    deinit
    {
        if let list = self.objectList
        {
            list.removeObjectsObserver(self)
        }
    }
}















