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
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var screenNameTextField: UITextField!
    
    var cellReuseIdentifier : String
    
    var movingCell : UICollectionViewCell?
    var movingCellInitalCenter : CGPoint?
    
    var screenList : APCScreenList
    var session : APCSession
    
    required init?(coder aDecoder: NSCoder)
    {
        self.cellReuseIdentifier = String(APCScreenCollectionViewCell.self)
        
        self.movingCell = nil
        self.movingCellInitalCenter = nil
        
        self.screenList = APCScreenList()
        self.session = (UIApplication.sharedApplication().delegate as? AppDelegate)!.session
    
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        self.collectionView.backgroundColor = UIColor(white: 0.8, alpha: 1.0)
        self.collectionView.showsVerticalScrollIndicator = false
        
        self.collectionView.registerNib(APCScreenCollectionViewCell.nib, forCellWithReuseIdentifier: self.cellReuseIdentifier)
        
        if let layout = self.collectionView.collectionViewLayout as? UICollectionViewFlowLayout
        {
            layout.itemSize = CGSize(width: 150.0, height: 150.0)
            
            layout.sectionInset = UIEdgeInsets(top: 20.0, left: 20.0, bottom: 20.0, right: 20.0)
            layout.minimumInteritemSpacing = 20.0
            layout.minimumLineSpacing = 20.0
        }
        
        
        let doubleTapGestureRecognizer : UITapGestureRecognizer = UITapGestureRecognizer(target: self,
                                                                                         action: #selector(APCScreenCollectionViewCell.handleDoubleTap))
        doubleTapGestureRecognizer.numberOfTapsRequired = 2
        
        self.collectionView.addGestureRecognizer(doubleTapGestureRecognizer)

        
        let longPressGestureRecognizer : UILongPressGestureRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(APCInterfaceObjectListViewController.handleLongPress))
        
        self.collectionView.addGestureRecognizer(longPressGestureRecognizer)


        
        self.screenList.add(screen: APCScreen(name: "Screen 1"))
        self.screenList.add(screen: APCScreen(name: "Screen 2"))
        self.screenList.add(screen: APCScreen(name: "Screen 3"))
        self.screenList.add(screen: APCScreen(name: "Screen 4"))
        self.screenList.add(screen: APCScreen(name: "Screen 5"))
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
            self.screenNameTextField.text = screen.name
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

    @IBAction func addButtonTapped(sender: AnyObject)
    {
        let screen : APCScreen = APCScreen(name: self.screenNameTextField.text!)
        self.screenList.add(screen: screen)
         
        let indexPath : NSIndexPath = NSIndexPath(forRow: self.screenList.count - 1, inSection: 0)
        self.collectionView.insertItemsAtIndexPaths([indexPath])
         
        self.collectionView.selectItemAtIndexPath(indexPath,
                                                  animated: false,
                                                  scrollPosition: UICollectionViewScrollPosition.None)
    }
    
    @IBAction func saveButtonTapped(sender: AnyObject)
    {
        if let indexPaths = self.collectionView.indexPathsForSelectedItems() where indexPaths.count >= 1
        {
            let indexPath = indexPaths[0]
    
            if let screen : APCScreen = self.screenList[indexPath.row]
            {
                screen.name = self.screenNameTextField.text!
            }
        }
    }

    @IBAction func deleteButtonTapped(sender: AnyObject)
    {
        if let indexPaths = self.collectionView.indexPathsForSelectedItems() where indexPaths.count >= 1
        {
            let indexPath = indexPaths[0]
            
            self.screenList.remove(objectAtIndex: indexPath.row)
            
            self.collectionView.deleteItemsAtIndexPaths([indexPath])
            
            self.screenNameTextField.text = ""
        }
    }
}





















