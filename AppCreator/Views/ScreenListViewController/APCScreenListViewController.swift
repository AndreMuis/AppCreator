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
    UICollectionViewDelegate,
    APCScreenListDelegate
{
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var screenNameTextField: UITextField!
    
    var cellReuseIdentifier : String
    
    var screenList : APCScreenList
    var session : APCSession
    
    required init?(coder aDecoder: NSCoder)
    {
        self.cellReuseIdentifier = String(APCScreenCollectionViewCell.self)
        
        self.screenList = APCScreenList()
        self.session = APCSession()
    
        super.init(coder: aDecoder)
        
        self.screenList.add(screen: APCScreen(name: "Screen 1"))
        self.screenList.add(screen: APCScreen(name: "Screen 2"))
        self.screenList.add(screen: APCScreen(name: "Screen 3"))
        self.screenList.add(screen: APCScreen(name: "Screen 4"))
        self.screenList.add(screen: APCScreen(name: "Screen 5"))
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
        
        self.collectionView.addGestureRecognizer(UILongPressGestureRecognizer(target: self, action: #selector(APCObjectListViewController.handleLongPress)))

        self.screenList.delegate = self
        
        self.session.activate()
    }
    
    func handleLongPress(gesture: UILongPressGestureRecognizer)
    {
        switch(gesture.state)
        {
        case UIGestureRecognizerState.Began:
            if let selectedIndexPath = self.collectionView!.indexPathForItemAtPoint(gesture.locationInView(self.collectionView))
            {
                self.collectionView.beginInteractiveMovementForItemAtIndexPath(selectedIndexPath)
            }
            
        case UIGestureRecognizerState.Changed:
            self.collectionView.updateInteractiveMovementTargetPosition(gesture.locationInView(gesture.view!))
            
        case UIGestureRecognizerState.Ended:
            self.collectionView.endInteractiveMovement()
            
        default:
            self.collectionView.cancelInteractiveMovement()
        }
    }
    
    func collectionView(collectionView: UICollectionView, moveItemAtIndexPath sourceIndexPath: NSIndexPath, toIndexPath destinationIndexPath: NSIndexPath)
    {
        self.screenList.move(objectAtIndex: sourceIndexPath.row, toIndex: destinationIndexPath.row)
    }
    
    // MARK: APCScreenListDelegate

    func screenList(screenList: APCScreenList, didRemoveScreen screen: APCScreen)
    {
        self.collectionView.reloadData()
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
        let cell = self.collectionView.dequeueReusableCellWithReuseIdentifier(self.cellReuseIdentifier, forIndexPath: indexPath) as! APCScreenCollectionViewCell

        if let screen : APCScreen = self.screenList[indexPath.row]
        {
            cell.refresh(screen: screen)
        }
        
        return cell
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
    
    @IBAction func addButtonTapped(sender: AnyObject)
    {
        self.screenList.add(screen: APCScreen(name: self.screenNameTextField.text!))

        let indexPath : NSIndexPath = NSIndexPath(forRow: self.screenList.count - 1, inSection: 0)
        
        self.collectionView.insertItemsAtIndexPaths([indexPath])
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
    
    @IBAction func designButtonTapped(sender: AnyObject)
    {
        if let indexPaths = self.collectionView.indexPathsForSelectedItems() where indexPaths.count >= 1
        {
            let indexPath = indexPaths[0]
        
            if let screen = self.screenList[indexPath.row],
                viewController = self.storyboard?.instantiateViewControllerWithIdentifier("APCScreenViewController") as? APCScreenViewController
            {
                viewController.session = self.session
                viewController.screen = screen
             
                self.navigationController?.pushViewController(viewController, animated: true)
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
        }
    }
}





















