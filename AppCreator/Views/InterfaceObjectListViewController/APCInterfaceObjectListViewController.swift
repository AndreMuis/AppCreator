//
//  APCInterfaceObjectListViewController.swift
//  AppCreator
//
//  Created by Andre Muis on 5/28/16.
//  Copyright © 2016 Andre Muis. All rights reserved.
//

import UIKit

class APCInterfaceObjectListViewController : UIViewController,
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
        
        self.collectionView.backgroundColor = UIColor.blackColor()
        self.collectionView.showsVerticalScrollIndicator = false
        
        self.collectionView.registerNib(APCButtonCollectionViewCell.nib, forCellWithReuseIdentifier: self.buttonCellReuseIdentifier)
        self.collectionView.registerNib(APCImageCollectionViewCell.nib, forCellWithReuseIdentifier: self.imageCellReuseIdentifier)
        self.collectionView.registerNib(APCLabelCollectionViewCell.nib, forCellWithReuseIdentifier: self.labelCellReuseIdentifier)
        
        if let layout : UICollectionViewFlowLayout = self.collectionView.collectionViewLayout as? UICollectionViewFlowLayout
        {
            layout.itemSize = CGSize(width: CGRectGetWidth(self.view.bounds) - 2.0 * self.style.cellMargin,
                                     height: 0.0)
            
            layout.sectionInset = UIEdgeInsets(top: self.style.cellMargin,
                                               left: self.style.cellMargin,
                                               bottom: self.style.cellMargin,
                                               right: self.style.cellMargin)
            
            layout.minimumInteritemSpacing = 0.0
            layout.minimumLineSpacing = self.style.lineSpacing
        }
        
        if let list : APCInterfaceObjectList = self.objectList
        {
            list.addObjectsObserver(self, context: &self.context)
        }
    }
    
    override func observeValueForKeyPath(keyPath: String?, ofObject object: AnyObject?, change: [String : AnyObject]?, context: UnsafeMutablePointer<Void>)
    {
        if let changeRaw : UInt = change?[APCConstants.kindKey] as? UInt,
            keyValueChange : NSKeyValueChange = NSKeyValueChange(rawValue: changeRaw),
            indexSet : NSIndexSet = change?[APCConstants.indexesKey] as? NSIndexSet
        {
            switch keyValueChange
            {
            case NSKeyValueChange.Setting:
                break
                
            case NSKeyValueChange.Insertion:
                let indexPath =  NSIndexPath(forRow: indexSet.firstIndex, inSection: 0)
                self.collectionView.insertItemsAtIndexPaths([indexPath])
                
                self.collectionView.selectItemAtIndexPath(indexPath,
                                                          animated: false,
                                                          scrollPosition: UICollectionViewScrollPosition.None)
                
                if let list = self.objectList,
                    object = list[indexPath.row]
                {
                    list.selectedObject = object
                }
                
            case NSKeyValueChange.Removal:
                let indexPath =  NSIndexPath(forRow: indexSet.firstIndex, inSection: 0)
                self.collectionView.deleteItemsAtIndexPaths([indexPath])

                if let list = self.objectList
                {
                    list.selectedObject = nil
                }
                                
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
        let rows = self.objectList?.count ?? 0
        
        return rows
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell
    {
        var objectCell : UICollectionViewCell = UICollectionViewCell()
        
        if let object : APCInterfaceObject = self.objectList?[indexPath.row]
        {
            if let button = object as? APCButton,
                buttonCell = self.collectionView.dequeueReusableCellWithReuseIdentifier(self.buttonCellReuseIdentifier, forIndexPath: indexPath) as? APCButtonCollectionViewCell
            {
                buttonCell.refresh(button: button)
                objectCell = buttonCell
            }
            else if let image = object as? APCImage,
                imageCell = self.collectionView.dequeueReusableCellWithReuseIdentifier(self.imageCellReuseIdentifier, forIndexPath: indexPath) as? APCImageCollectionViewCell
            {
                imageCell.refresh(image: image)
                imageCell.delegate = self
                objectCell = imageCell
            }
            else if let label = object as? APCLabel,
                labelCell = self.collectionView.dequeueReusableCellWithReuseIdentifier(self.labelCellReuseIdentifier, forIndexPath: indexPath) as? APCLabelCollectionViewCell
            {
                labelCell.refresh(label: label)
                labelCell.delegate = self
                objectCell = labelCell
            }
        }
        
        return objectCell
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
    
    // MARK: UICollectionViewDelegateFlowLayout

    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize
    {
        var size : CGSize = CGSizeZero
        
        if let object = self.objectList?[indexPath.row]
        {
            let width : CGFloat = CGRectGetWidth(self.collectionView.bounds) - 2.0 * self.style.cellMargin
            
            if object is APCButton
            {
                size = APCButtonCollectionViewCell.size(width: width)
            }
            else if let image = object as? APCImage,
                uiImage = image.uiImage
            {
                size = APCImageCollectionViewCell.size(width: width, uiImage: uiImage)
            }
            else if let label = object as? APCLabel
            {
                size = APCLabelCollectionViewCell.size(width: width, text: label.text)
            }
        }
        
        return size
    }

    // MARK: APCImageCollectionViewCellDelegate
    
    func imageCollectionViewCellDidUpdateImage(cell: APCImageCollectionViewCell)
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
            list.removeObjectsObserver(self)
        }
    }
}

















