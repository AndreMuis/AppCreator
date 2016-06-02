//
//  APCObjectsViewController.swift
//  AppCreator
//
//  Created by Andre Muis on 5/31/16.
//  Copyright © 2016 Andre Muis. All rights reserved.
//

import UIKit

class APCObjectsViewController :
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
    
    var delegate : APCObjectsViewControllerDelegate?
    
    var interfaceObject : APCInterfaceObject?
    {
        didSet
        {
            if let button = self.interfaceObject as? APCButton
            {
                self.buttonViewController.button = button
                
                self.segmentedControl.selectedSegmentIndex = 2
                self.showObjectView()
            }
            else if let image = self.interfaceObject as? APCImage
            {
                self.imageViewController.image = image

                self.segmentedControl.selectedSegmentIndex = 1
                self.showObjectView()
            }
            else if let label = self.interfaceObject as? APCLabel
            {
                self.labelViewController.label = label

                self.segmentedControl.selectedSegmentIndex = 0
                self.showObjectView()
            }
        }
    }
    
    required init?(coder aDecoder: NSCoder)
    {
        self.buttonViewController = APCButtonViewController(nibName: String(APCButtonViewController.self), bundle: nil)
        self.imageViewController = APCImageViewController(nibName: String(APCImageViewController.self), bundle: nil)
        self.labelViewController = APCLabelViewController(nibName: String(APCLabelViewController.self), bundle: nil)

        self.delegate = nil
        
        self.interfaceObject = nil
        
        super.init(coder: aDecoder)
    }

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
        self.delegate?.objectsViewController(self, appendInterfaceObject: button)
    }
    
    func buttonViewController(viewController: APCButtonViewController, didModifyButton button: APCButton)
    {
        self.delegate?.objectsViewController(self, didModifyInterfaceObject: button)
    }
    
    func buttonViewController(viewController: APCButtonViewController, deleteButton button: APCButton)
    {
        self.delegate?.objectsViewController(self, deleteInterfaceObject: button)
    }
    
    // MARK: APCImageViewControllerDelegate
    
    func imageViewController(viewController: APCImageViewController, addImage image: APCImage)
    {
        self.delegate?.objectsViewController(self, appendInterfaceObject: image)
    }
    
    func imageViewController(viewController: APCImageViewController, didModifyImage image: APCImage)
    {
        self.delegate?.objectsViewController(self, didModifyInterfaceObject: image)
    }
    
    func imageViewController(viewController: APCImageViewController, deleteImage image: APCImage)
    {
        self.delegate?.objectsViewController(self, deleteInterfaceObject: image)
    }
    
    // MARK: APCLabelViewControllerDelegate
    
    func labelViewController(viewController: APCLabelViewController, addLabel label: APCLabel)
    {
        self.delegate?.objectsViewController(self, appendInterfaceObject: label)
    }
    
    func labelViewController(viewController: APCLabelViewController, didModifyLabel label: APCLabel)
    {
        self.delegate?.objectsViewController(self, didModifyInterfaceObject: label)
    }
    
    func labelViewController(viewController: APCLabelViewController, deleteLabel label: APCLabel)
    {
        self.delegate?.objectsViewController(self, deleteInterfaceObject: label)
    }
    
    // MARK:
}















