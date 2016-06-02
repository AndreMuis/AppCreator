//
//  APCObjectListViewController.swift
//  AppCreator
//
//  Created by Andre Muis on 5/28/16.
//  Copyright © 2016 Andre Muis. All rights reserved.
//

import UIKit

class APCObjectListViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate
{
    @IBOutlet weak var collectionView: UICollectionView!
    
    var delegate : APCObjectListViewControllerDelegate?
    
    let buttonCellReuseIdentifier : String
    let imageCellReuseIdentifier : String
    let labelCellReuseIdentifier : String

    var objectList : APCInterfaceObjectList?
    
    required init?(coder aDecoder: NSCoder)
    {
        self.delegate = nil
        
        self.buttonCellReuseIdentifier = String(APCButtonCollectionViewCell.self)
        self.imageCellReuseIdentifier = String(APCImageCollectionViewCell.self)
        self.labelCellReuseIdentifier = String(APCLabelCollectionViewCell.self)

        self.objectList = nil
        
        super.init(coder: aDecoder)
    }

    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor.blackColor()
        
        self.collectionView.backgroundColor = UIColor.blackColor()
        self.collectionView.showsVerticalScrollIndicator = false

        self.collectionView.registerNib(APCButtonCollectionViewCell.nib, forCellWithReuseIdentifier: self.buttonCellReuseIdentifier)
        self.collectionView.registerNib(APCImageCollectionViewCell.nib, forCellWithReuseIdentifier: self.imageCellReuseIdentifier)
        self.collectionView.registerNib(APCLabelCollectionViewCell.nib, forCellWithReuseIdentifier: self.labelCellReuseIdentifier)
        
        if let layout = self.collectionView.collectionViewLayout as? UICollectionViewFlowLayout
        {
            layout.itemSize = CGSize(width: 200.0, height: 52.0)
            
            layout.sectionInset = UIEdgeInsets(top: 10.0, left: 10.0, bottom: 10.0, right: 10.0)
            layout.minimumInteritemSpacing = 10.0
            layout.minimumLineSpacing = 10.0
        }
        
        self.collectionView.addGestureRecognizer(UILongPressGestureRecognizer(target: self, action: #selector(APCObjectListViewController.handleLongPress)))
        
        if let list = self.objectList
        {
            list.addObserver(self)
        }
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
        self.delegate?.objectListViewController(self, didMoveItemAtIndex: sourceIndexPath.row, toIndex: destinationIndexPath.row)
    }
    
    override func observeValueForKeyPath(keyPath: String?, ofObject object: AnyObject?, change: [String : AnyObject]?, context: UnsafeMutablePointer<Void>)
    {
        if let indexSet = change?["indexes"] as? NSIndexSet,
            let changeRaw = change?["kind"] as? UInt,
            let keyValuechange : NSKeyValueChange = NSKeyValueChange(rawValue: changeRaw)
        {
            switch keyValuechange
            {
            case NSKeyValueChange.Setting:
                break
            
            case NSKeyValueChange.Insertion:
                let indexPath =  NSIndexPath(forRow: indexSet.firstIndex, inSection: 0)
                self.collectionView!.insertItemsAtIndexPaths([indexPath])
            
            case NSKeyValueChange.Removal:
                let indexPath =  NSIndexPath(forRow: indexSet.firstIndex, inSection: 0)
                self.collectionView!.deleteItemsAtIndexPaths([indexPath])
            
            case NSKeyValueChange.Replacement:
                break
            }
        }
    }
    
    // MARK: UICollectionViewDataSource
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int
    {
        return 1
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        var rows : Int = 0
        
        if let count = self.objectList?.count
        {
            rows = count
        }
        
        return rows
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell
    {
        var objectCell : UICollectionViewCell = UICollectionViewCell()
        
        if let object : APCInterfaceObject = self.objectList![indexPath.row]
        {
            if let button = object as? APCButton,
                let buttonCell = self.collectionView!.dequeueReusableCellWithReuseIdentifier(self.buttonCellReuseIdentifier, forIndexPath: indexPath) as? APCButtonCollectionViewCell
            {
                buttonCell.refresh(button: button)
                objectCell = buttonCell
            }
            else if let image = object as? APCImage,
                let imageCell = self.collectionView!.dequeueReusableCellWithReuseIdentifier(self.imageCellReuseIdentifier, forIndexPath: indexPath) as? APCImageCollectionViewCell
            {
                imageCell.refresh(image: image)
                objectCell = imageCell
            }
            else if let label = object as? APCLabel,
                let labelCell = self.collectionView!.dequeueReusableCellWithReuseIdentifier(self.labelCellReuseIdentifier, forIndexPath: indexPath) as? APCLabelCollectionViewCell
            {
                labelCell.refresh(label: label)
                objectCell = labelCell
            }
        }
        
        return objectCell
    }
    
    // MARK: UICollectionViewDelegate

    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath)
    {
        if let delegate : APCObjectListViewControllerDelegate = self.delegate
        {
            delegate.objectListViewController(self, didSelectInterfaceObjectAtIndex: indexPath.row)
        }
    }

    // MARK:
    
    deinit
    {
        if let list = self.objectList
        {
            list.removeObserver(self)
        }
    }
}

















