//
//  APCInterfaceObjectListViewController.swift
//  AppCreator
//
//  Created by Andre Muis on 5/28/16.
//  Copyright © 2016 Andre Muis. All rights reserved.
//

import UIKit

class APCInterfaceObjectListViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate
{
    @IBOutlet weak var collectionView: UICollectionView!
    
    let buttonCellReuseIdentifier : String
    let imageCellReuseIdentifier : String
    let labelCellReuseIdentifier : String

    var objectList : APCInterfaceObjectList?
    
    required init?(coder aDecoder: NSCoder)
    {
        self.buttonCellReuseIdentifier = String(APCButtonCollectionViewCell.self)
        self.imageCellReuseIdentifier = String(APCImageCollectionViewCell.self)
        self.labelCellReuseIdentifier = String(APCLabelCollectionViewCell.self)

        self.objectList = nil
        
        super.init(coder: aDecoder)
    }

    private var context = 0

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
        
        if let list = self.objectList
        {
            list.addArrayObserver(self, context: &self.context)
        }

        self.collectionView.addGestureRecognizer(UILongPressGestureRecognizer(target: self, action: #selector(APCInterfaceObjectListViewController.handleLongPress)))
    }
    
    override func observeValueForKeyPath(keyPath: String?, ofObject object: AnyObject?, change: [String : AnyObject]?, context: UnsafeMutablePointer<Void>)
    {
        if let indexSet = change?["indexes"] as? NSIndexSet,
            let changeRaw = change?["kind"] as? UInt,
            let keyValueChange : NSKeyValueChange = NSKeyValueChange(rawValue: changeRaw)
        {
            switch keyValueChange
            {
            case NSKeyValueChange.Setting:
                break
                
            case NSKeyValueChange.Insertion:
                if let objectList = self.objectList where objectList.isPerformingMove == false
                {
                    let indexPath =  NSIndexPath(forRow: indexSet.firstIndex, inSection: 0)
                    self.collectionView.insertItemsAtIndexPaths([indexPath])
                }
                
            case NSKeyValueChange.Removal:
                if let objectList = self.objectList where objectList.isPerformingMove == false
                {
                    let indexPath =  NSIndexPath(forRow: indexSet.firstIndex, inSection: 0)
                    self.collectionView.deleteItemsAtIndexPaths([indexPath])
                }
                
            case NSKeyValueChange.Replacement:
                break
            }
        }
    }
    
    func handleLongPress(gesture: UILongPressGestureRecognizer)
    {
        switch(gesture.state)
        {
        case UIGestureRecognizerState.Began:
            if let selectedIndexPath = self.collectionView.indexPathForItemAtPoint(gesture.locationInView(self.collectionView))
            {
                self.collectionView.beginInteractiveMovementForItemAtIndexPath(selectedIndexPath)
            }
            
        case UIGestureRecognizerState.Changed:
            self.collectionView.updateInteractiveMovementTargetPosition(gesture.locationInView(gesture.view))
            
        case UIGestureRecognizerState.Ended:
            self.collectionView.endInteractiveMovement()
            
        default:
            self.collectionView.cancelInteractiveMovement()
        }
    }
    
    // MARK: UICollectionViewDataSource
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int
    {
        return 1
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        let rows = self.objectList?.count ?? 0
        
        return rows
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell
    {
        var objectCell : UICollectionViewCell = UICollectionViewCell()
        
        if let object : APCInterfaceObject = self.objectList?[indexPath.row]
        {
            if let button = object as? APCButton,
                let buttonCell = self.collectionView.dequeueReusableCellWithReuseIdentifier(self.buttonCellReuseIdentifier, forIndexPath: indexPath) as? APCButtonCollectionViewCell
            {
                buttonCell.refresh(button: button)
                objectCell = buttonCell
            }
            else if let image = object as? APCImage,
                let imageCell = self.collectionView.dequeueReusableCellWithReuseIdentifier(self.imageCellReuseIdentifier, forIndexPath: indexPath) as? APCImageCollectionViewCell
            {
                imageCell.refresh(image: image)
                objectCell = imageCell
            }
            else if let label = object as? APCLabel,
                let labelCell = self.collectionView.dequeueReusableCellWithReuseIdentifier(self.labelCellReuseIdentifier, forIndexPath: indexPath) as? APCLabelCollectionViewCell
            {
                labelCell.refresh(label: label)
                objectCell = labelCell
                
                print(label.text)
            }
        }
        
        return objectCell
    }
    
    func collectionView(collectionView: UICollectionView, moveItemAtIndexPath sourceIndexPath: NSIndexPath, toIndexPath destinationIndexPath: NSIndexPath)
    {
        let sourceIndex = sourceIndexPath.row
        let destinationIndex = destinationIndexPath.row
        
        if let list = self.objectList
        {
            if (list.move(objectAtIndex: sourceIndex, toIndex: destinationIndex) == false)
            {
                print("falied to move object")
            }
        }
    }
    
    // MARK: UICollectionViewDelegate

    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath)
    {
        if let list : APCInterfaceObjectList = self.objectList,
            object : APCInterfaceObject = list[indexPath.row]
        {
            list.selectedObject = object
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

















