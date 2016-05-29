//
//  APCScreenViewController.swift
//  AppCreator
//
//  Created by Andre Muis on 5/28/16.
//  Copyright © 2016 Andre Muis. All rights reserved.
//

import UIKit

class APCScreenViewController: UIViewController, UITableViewDataSource, UITableViewDelegate
{
    @IBOutlet weak var tableView: UITableView!
    
    let cellReuseIdentifier : String
    var screen : APCScreen?
    
    required init?(coder aDecoder: NSCoder)
    {
        self.cellReuseIdentifier = "APCScreenTableViewCell"
        self.screen = nil
        
        super.init(coder: aDecoder)
    }

    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        self.tableView.registerNib(APCScreenTableViewCell.nib, forCellReuseIdentifier: self.cellReuseIdentifier)
    }
    
    func addButton()
    {
        if let list = self.screen?.interfaceObjectList
        {
            list.add(object: APCButton(id: 100, title: "andre"))
            
            self.tableView.reloadData()
        }
    }

    // MARK: UITableViewDataSource
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int
    {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        var rows : Int = 0
        
        if let count = self.screen?.interfaceObjectList.count
        {
            rows = count
        }
        
        return rows
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        let someCell : UITableViewCell = self.tableView.dequeueReusableCellWithIdentifier(self.cellReuseIdentifier, forIndexPath: indexPath)
        
        //if let cell = someCell as? APCScreenTableViewCell
        //{
        //}
        
        return someCell
    }
    
    // MARK: UITableViewDelegate

    

    // MARK:
}

















