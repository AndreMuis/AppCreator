//
//  APCScreenListViewController.swift
//  AppCreator
//
//  Created by Andre Muis on 5/26/16.
//  Copyright © 2016 Andre Muis. All rights reserved.
//

import UIKit
import WatchConnectivity

class APCScreenListViewController: UIViewController,
    UICollectionViewDataSource,
    UICollectionViewDelegate,
    APCScreenListDelegate,
    WCSessionDelegate
{
    @IBOutlet weak var collectionView: UICollectionView!
    
    var cellReuseIdentifier : String
    
    var screenList : APCScreenList
    var session : WCSession
    
    required init?(coder aDecoder: NSCoder)
    {
        self.cellReuseIdentifier = "APCScreenCollectionViewCell"
        
        self.screenList = APCScreenList()
        self.session = WCSession.defaultSession()
    
        super.init(coder: aDecoder)
        
        self.screenList.add(screen: self.screenList.createScreen())
        self.screenList.add(screen: self.screenList.createScreen())
        self.screenList.add(screen: self.screenList.createScreen())
        self.screenList.add(screen: self.screenList.createScreen())
        self.screenList.add(screen: self.screenList.createScreen())
    }
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        self.collectionView.backgroundColor = UIColor.whiteColor()
        
        self.collectionView.registerNib(APCScreenCollectionViewCell.nib, forCellWithReuseIdentifier: self.cellReuseIdentifier)
        
        if let layout = self.collectionView.collectionViewLayout as? UICollectionViewFlowLayout
        {
            layout.itemSize = CGSize(width: 150.0, height: 150.0)
            
            layout.sectionInset = UIEdgeInsets(top: 20.0, left: 20.0, bottom: 20.0, right: 20.0)
            layout.minimumInteritemSpacing = 20.0
            layout.minimumLineSpacing = 20.0
        }
        
        self.screenList.delegate = self
        
        if WCSession.isSupported()
        {
            self.session.delegate = self
            self.session.activateSession()
        }
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
        if let screen = self.screenList[indexPath.row],
            viewController = self.storyboard?.instantiateViewControllerWithIdentifier("APCDesignViewController") as? APCDesignViewController
        {
            viewController.screenList = screenList
            viewController.screen = screen
            
            self.navigationController?.pushViewController(viewController, animated: true)
        }
    }

    // MARK:
    
    @IBAction func addScreenButtonTapped(sender: AnyObject)
    {
        self.screenList.add(screen: self.screenList.createScreen())

        self.collectionView.reloadData()
        
        
        print("reachable = \(self.session.reachable)")
        
        
        let button : APCButton = (self.screenList[0]!.interfaceObjectList[0] as? APCButton)!
        
        NSKeyedArchiver.setClassName("APCButton", forClass: APCButton.self)
        let data = NSKeyedArchiver.archivedDataWithRootObject(button)
        
        self.session.sendMessageData(data, replyHandler:
        { (reply) in
            print(reply)
        })
        { (error) in
            print(error)
        }
    }
}





















