//
//  APCInterfaceObjectListViewController.swift
//  AppCreator
//
//  Created by Andre Muis on 5/28/16.
//  Copyright © 2016 Andre Muis. All rights reserved.
//

import UIKit

class APCInterfaceObjectListViewController:
    UIViewController,
    UICollectionViewDataSource,
    UICollectionViewDelegateFlowLayout,
    APCImageCollectionViewCellDelegate,
    APCLabelCollectionViewCellDelegate
{
    @IBOutlet weak var collectionView: UICollectionView!
    
    let style : APCInterfaceObjectListStyle
    
    let buttonCellReuseIdentifier : String
    let imageCellReuseIdentifier : String
    let labelCellReuseIdentifier : String

    var movingCell : UICollectionViewCell?
    var movingCellInitalCenter : CGPoint?

    var objectList : APCInterfaceObjectList?
    
    required init?(coder aDecoder: NSCoder)
    {
        self.style = APCInterfaceObjectListStyle()
        
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
            layout.itemSize = CGSize(width: CGRectGetWidth(self.collectionView.bounds) - 2.0 * self.style.cellMargin,
                                     height: 0.0)
            
            layout.sectionInset = UIEdgeInsets(top: self.style.cellMargin,
                                               left: self.style.cellMargin,
                                               bottom: self.style.cellMargin,
                                               right: self.style.cellMargin)
            
            layout.minimumInteritemSpacing = self.style.cellMargin
            layout.minimumLineSpacing = self.style.cellMargin
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
                    
                    self.collectionView.selectItemAtIndexPath(indexPath,
                                                              animated: false,
                                                              scrollPosition: UICollectionViewScrollPosition.None)
                    
                    if let list = self.objectList,
                        let object = list[indexPath.row]
                    {
                        list.selectedObject = object
                    }
                }
                
            case NSKeyValueChange.Removal:
                if let objectList = self.objectList where objectList.isPerformingMove == false
                {
                    let indexPath =  NSIndexPath(forRow: indexSet.firstIndex, inSection: 0)
                    
                    if let selectedIndexPath = self.collectionView.indexPathsForSelectedItems()?[0],
                        let list = self.objectList
                    {
                        if selectedIndexPath == indexPath
                        {
                            list.selectedObject = nil
                        }
                    }
                    
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
            if let indexPath = self.collectionView.indexPathForItemAtPoint(gesture.locationInView(self.collectionView)),
                let movingCell = self.collectionView.cellForItemAtIndexPath(indexPath)
            {
                self.movingCell = movingCell
                self.movingCellInitalCenter = movingCell.center
                
                self.collectionView.selectItemAtIndexPath(indexPath,
                                                          animated: true,
                                                          scrollPosition: UICollectionViewScrollPosition.None)
                
                movingCell.animateExpansion()
                
                self.collectionView.beginInteractiveMovementForItemAtIndexPath(indexPath)
            }
            
        case UIGestureRecognizerState.Changed:
            
            let visibleContentFrame : CGRect = CGRect(origin: self.collectionView.contentOffset,
                                                      size: self.collectionView.bounds.size)
            
            if visibleContentFrame.contains(gesture.locationInView(self.collectionView)) == true
            {
                self.collectionView.updateInteractiveMovementTargetPosition(gesture.locationInView(gesture.view))
            }
            else
            {
                self.collectionView.endInteractiveMovement()                
            }
            
        case UIGestureRecognizerState.Ended:
            self.collectionView.endInteractiveMovement()

            if let cell = self.movingCell where cell.center == self.movingCellInitalCenter
            {
                cell.animateContraction()
            }

            self.movingCell = nil
            self.movingCellInitalCenter = CGPointZero

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
                imageCell.delegate = self
                objectCell = imageCell
            }
            else if let label = object as? APCLabel,
                let labelCell = self.collectionView.dequeueReusableCellWithReuseIdentifier(self.labelCellReuseIdentifier, forIndexPath: indexPath) as? APCLabelCollectionViewCell
            {
                labelCell.refresh(label: label)
                labelCell.delegate = self
                objectCell = labelCell
            }
        }
        
        return objectCell
    }
    
    func collectionView(collectionView: UICollectionView, moveItemAtIndexPath sourceIndexPath: NSIndexPath, toIndexPath destinationIndexPath: NSIndexPath)
    {
        
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
    
    func collectionView(collectionView: UICollectionView, targetIndexPathForMoveFromItemAtIndexPath originalIndexPath: NSIndexPath, toProposedIndexPath proposedIndexPath: NSIndexPath) -> NSIndexPath
    {
        let originalIndex = originalIndexPath.row
        let proposedIndex = proposedIndexPath.row
        
        if let list = self.objectList
        {
            if (originalIndex != proposedIndex)
            {
                if (list.move(objectAtIndex: originalIndex, toIndex: proposedIndex) == false)
                {
                    print("falied to move object")
                }
            }
        }
        
        return proposedIndexPath
    }
    
    func collectionView(collectionView: UICollectionView, canFocusItemAtIndexPath indexPath: NSIndexPath) -> Bool
    {
        return false
    }
    
    // MARK: UICollectionViewDelegateFlowLayout
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize
    {
        var size : CGSize = CGSizeZero
        
        if let object = self.objectList?[indexPath.row]
        {
            if object is APCButton
            {
                size = APCButtonCollectionViewCell.size(CGRectGetWidth(self.collectionView.bounds) - 2.0 * self.style.cellMargin)
            }
            else if let image = object as? APCImage
            {
                size = APCImageCollectionViewCell.size(CGRectGetWidth(self.collectionView.bounds) - 2.0 * self.style.cellMargin,
                                                       uiImage: image.uiImage!)
            }
            else if let label = object as? APCLabel
            {
                size = APCLabelCollectionViewCell.size(CGRectGetWidth(self.collectionView.bounds) - 2.0 * self.style.cellMargin,
                                                       text: label.text)
            }
        }
        
        return size
    }

    // MARK: APCImageCollectionViewCellDelegate
    
    func imageCollectionViewCellDidUpdateText(cell: APCImageCollectionViewCell)
    {
        self.collectionView.performBatchUpdates(
        {
            self.collectionView.collectionViewLayout.invalidateLayout()
        },
                                                completion: nil)
    }
    
    // MARK: APCLabelCollectionViewCellDelegate
    
    func labelCollectionViewCellDidUpdateText(cell: APCLabelCollectionViewCell)
    {
        self.collectionView.performBatchUpdates(
        {
            self.collectionView.collectionViewLayout.invalidateLayout()
        },
                                                completion: nil)
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

















