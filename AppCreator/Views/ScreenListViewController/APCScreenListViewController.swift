//
//  APCScreenListViewController.swift
//  AppCreator
//
//  Created by Andre Muis on 5/26/16.
//  Copyright © 2016 Andre Muis. All rights reserved.
//

import UIKit

class APCScreenListViewController: UIViewController,
    UICollectionViewDataSource,
    UICollectionViewDelegate
{
    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    @IBOutlet weak var bottomContentView: UIView!
    @IBOutlet weak var screenTitleTextField: UITextField!
    @IBOutlet weak var initialScreenSwitch: UISwitch!
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var deleteButton: UIButton!
    
    var style : APCScreenListStyle
    
    var cellReuseIdentifier : String
    
    var movingCell : UICollectionViewCell?
    var movingCellInitalCenter : CGPoint?
    
    var screenList : APCScreenList
    var session : APCSession
    
    required init?(coder aDecoder: NSCoder)
    {
        self.style = APCScreenListStyle()
        
        self.cellReuseIdentifier = String(APCScreenCollectionViewCell.self)
        
        self.movingCell = nil
        self.movingCellInitalCenter = nil
        
        self.screenList = (UIApplication.sharedApplication().delegate as? AppDelegate)!.screenList
        self.session = (UIApplication.sharedApplication().delegate as? AppDelegate)!.session
    
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        self.scrollView.delaysContentTouches = false
        
        self.collectionView.backgroundColor = self.style.backgroundColor
        self.collectionView.showsVerticalScrollIndicator = false
        
        self.collectionView.registerNib(APCScreenCollectionViewCell.nib, forCellWithReuseIdentifier: self.cellReuseIdentifier)
        
        if let layout = self.collectionView.collectionViewLayout as? UICollectionViewFlowLayout
        {
            let cellWidth = (CGRectGetWidth(self.collectionView.bounds) - 3.0 * self.style.cellMargin) / 2.0
            
            layout.itemSize = CGSize(width: cellWidth,
                                     height: cellWidth)
            
            layout.sectionInset = UIEdgeInsets(top: self.style.cellMargin,
                                               left: self.style.cellMargin,
                                               bottom: self.style.cellMargin,
                                               right: self.style.cellMargin)
            
            layout.minimumInteritemSpacing = self.style.cellMargin
            layout.minimumLineSpacing = self.style.cellMargin
        }

        self.initialScreenSwitch.enabled = false
        self.initialScreenSwitch.on = false
        
        self.saveButton.enabled = false
        self.deleteButton.enabled = false

        
        let doubleTapGestureRecognizer : UITapGestureRecognizer = UITapGestureRecognizer(target: self,
                                                                                         action: #selector(APCScreenListViewController.handleDoubleTap))
        doubleTapGestureRecognizer.numberOfTapsRequired = 2
        
        self.collectionView.addGestureRecognizer(doubleTapGestureRecognizer)

        
        let longPressGestureRecognizer : UILongPressGestureRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(APCInterfaceObjectListViewController.handleLongPress))
        
        self.collectionView.addGestureRecognizer(longPressGestureRecognizer)

        NSNotificationCenter.defaultCenter().addObserver(self,
                                                         selector: #selector(keyboardWillShow),
                                                         name: UIKeyboardWillShowNotification,
                                                         object: nil)
        
        NSNotificationCenter.defaultCenter().addObserver(self,
                                                         selector: #selector(keyboardWillHide),
                                                         name: UIKeyboardWillHideNotification,
                                                         object: nil)

        
        
        self.screenList.add(screen: APCScreen(title: "Screen 1"))
        self.screenList.add(screen: APCScreen(title: "Screen 2"))
        self.screenList.add(screen: APCScreen(title: "Screen 3"))
    }

    // MARK: UICollectionViewDataSource
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int
    {
        return 1
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        return self.screenList.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell
    {
        let someCell : UICollectionViewCell = self.collectionView.dequeueReusableCellWithReuseIdentifier(self.cellReuseIdentifier, forIndexPath: indexPath)
        
        if let screen : APCScreen = self.screenList[indexPath.row],
            cell = someCell as? APCScreenCollectionViewCell
        {
            cell.refresh(screen: screen)
        }
        
        return someCell
    }

    func collectionView(collectionView: UICollectionView, moveItemAtIndexPath sourceIndexPath: NSIndexPath, toIndexPath destinationIndexPath: NSIndexPath)
    {
        self.screenList.move(objectAtIndex: sourceIndexPath.row, toIndex: destinationIndexPath.row)
    }
    
    // MARK: UICollectionViewDelegate
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath)
    {
        if let screen : APCScreen = self.screenList[indexPath.row]
        {
            self.screenList.selectedScreen = screen
            
            self.screenTitleTextField.text = screen.title
            
            self.initialScreenSwitch.enabled = true
            
            if screen.id == self.screenList.initialScreenId
            {
                self.initialScreenSwitch.on = true
            }
            else
            {
                self.initialScreenSwitch.on = false
            }

            self.saveButton.enabled = true
            self.deleteButton.enabled = true
        }
    }
    
    func collectionView(collectionView: UICollectionView, didEndDisplayingCell cell: UICollectionViewCell, forItemAtIndexPath indexPath: NSIndexPath)
    {
        if cell.selected == true
        {
            self.screenTitleTextField.text = ""

            self.screenList.initialScreenId = nil
            
            self.initialScreenSwitch.enabled = false
            self.initialScreenSwitch.on = false
            
            self.saveButton.enabled = false
            self.deleteButton.enabled = false
        }
    }
    
    // MARK:

    func handleDoubleTap(gestureRecognizer: UITapGestureRecognizer)
    {
        let point : CGPoint = gestureRecognizer.locationInView(self.collectionView)
    
        if let indexPath : NSIndexPath = self.collectionView.indexPathForItemAtPoint(point)
        {
            if let screen : APCScreen = self.screenList[indexPath.row],
                storyboard : UIStoryboard = self.storyboard,
                viewController : APCScreenViewController = storyboard.instantiateViewControllerWithIdentifier(String(APCScreenViewController.self)) as? APCScreenViewController,
                navigationController = self.navigationController
            {
                viewController.screen = screen
                
                navigationController.pushViewController(viewController, animated: true)
            }
        }
    }

    func handleLongPress(gestureRecognizer: UILongPressGestureRecognizer)
    {
        switch(gestureRecognizer.state)
        {
        case UIGestureRecognizerState.Began:
            if let indexPath = self.collectionView.indexPathForItemAtPoint(gestureRecognizer.locationInView(self.collectionView)),
                let movingCell = self.collectionView.cellForItemAtIndexPath(indexPath)
            {
                self.movingCell = movingCell
                self.movingCellInitalCenter = movingCell.center
                
                movingCell.animateExpansion()
                
                self.collectionView.beginInteractiveMovementForItemAtIndexPath(indexPath)
            }
            
        case UIGestureRecognizerState.Changed:
            self.collectionView.updateInteractiveMovementTargetPosition(gestureRecognizer.locationInView(gestureRecognizer.view))
            
        case UIGestureRecognizerState.Ended:
            self.collectionView.endInteractiveMovement()
            
            if let cell = self.movingCell where cell.center == self.movingCellInitalCenter
            {
                cell.animateContraction()
            }
            
        default:
            self.collectionView.cancelInteractiveMovement()
        }
    }

    @IBAction func initialScreenSwitchValueChanged(sender: AnyObject)
    {
        if let indexPaths = self.collectionView.indexPathsForSelectedItems() where indexPaths.count == 1,
            let screen = self.screenList[indexPaths[0].row]
        {
            self.screenList.initialScreenId = screen.id
        }
    }
    
    @IBAction func addButtonTapped(sender: AnyObject)
    {
        if self.screenTitleTextField.trimmedText.isEmpty == false
        {
            let screen : APCScreen = APCScreen(title: self.screenTitleTextField.text!)
            self.screenList.add(screen: screen)
            self.screenList.selectedScreen = screen
            
            let indexPath : NSIndexPath = NSIndexPath(forRow: self.screenList.count - 1, inSection: 0)
            self.collectionView.insertItemsAtIndexPaths([indexPath])
            
            self.collectionView.selectItemAtIndexPath(indexPath,
                                                      animated: false,
                                                      scrollPosition: UICollectionViewScrollPosition.None)
        }
    }
    
    @IBAction func saveButtonTapped(sender: AnyObject)
    {
        if self.screenTitleTextField.trimmedText.isEmpty == false
        {
            if let indexPaths = self.collectionView.indexPathsForSelectedItems() where indexPaths.count >= 1
            {
                let indexPath = indexPaths[0]
        
                if let screen : APCScreen = self.screenList[indexPath.row]
                {
                    screen.title = self.screenTitleTextField.text!
                }
            }
        }
    }

    @IBAction func deleteButtonTapped(sender: AnyObject)
    {
        if let indexPaths = self.collectionView.indexPathsForSelectedItems() where indexPaths.count >= 1
        {
            let indexPath = indexPaths[0]
            
            self.screenList.remove(objectAtIndex: indexPath.row)
            self.screenList.selectedScreen = nil
            
            self.collectionView.deleteItemsAtIndexPaths([indexPath])
            
            self.screenTitleTextField.text = ""
        }
    }
    
    @IBAction func runAppButtonTapped(sender: AnyObject)
    {
        if self.screenList.initialScreenId != nil
        {
            self.session.runWatchApp(self.screenList)
        }
        else
        {
            let alertController : UIAlertController = UIAlertController(title: "",
                                                                        message: "Please set an inital screen.",
                                                                        preferredStyle: UIAlertControllerStyle.Alert)
            
            let alertAction = UIAlertAction(title: "OK",
                                            style: UIAlertActionStyle.Default,
                                            handler: nil)
            
            alertController.addAction(alertAction)
            
            self.presentViewController(alertController,
                                       animated: true,
                                       completion: nil)
        }
    }
    
    // MARK: Keyboard
    
    func keyboardWillShow(notification : NSNotification)
    {
        if let keyboardFrame : CGRect = (notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.CGRectValue()
        {
            let textFieldBottomMargin = CGRectGetHeight(self.bottomContentView.bounds) - CGRectGetMaxY(self.screenTitleTextField.frame)
            
            let scrollViewYOffset : CGFloat = (CGRectGetHeight(keyboardFrame) - textFieldBottomMargin) + self.style.screenTitleTextFieldToKeyboardSpacing
            
            self.scrollView.contentOffset = CGPoint(x: 0.0, y: scrollViewYOffset)
        }
    }
    
    func keyboardWillHide(notification : NSNotification)
    {
        self.scrollView.contentOffset = CGPoint(x: 0.0, y: 0.0)
    }
    
    // MARK:

    deinit
    {
        NSNotificationCenter.defaultCenter().removeObserver(self,
                                                            name: UIKeyboardWillShowNotification,
                                                            object: nil)
        
        NSNotificationCenter.defaultCenter().removeObserver(self,
                                                            name: UIKeyboardWillHideNotification,
                                                            object: nil)
    }
}





















