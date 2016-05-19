//
//  ViewController.swift
//  HWRefresh-Swift
//
//  Created by HuangWay on 16/5/18.
//  Copyright © 2016年 HuangWay. All rights reserved.
//

import UIKit
let ID:String = "diaodefeiqi"
let CID:String = "diaodejiangluo"
var CellLabel:String = "cellabel"
class ViewController: UIViewController,UITableViewDelegate,UITableViewDataSource,UICollectionViewDelegate,UICollectionViewDataSource {
    
    lazy var datasource:NSMutableArray = {
        var datasource:NSMutableArray = NSMutableArray()
        for index in 1 ... 20 {
            let str:String = String(format: "测试数据%d", index)
            datasource.addObject(str)
        }
        return datasource
    }()
    
    lazy var table:UITableView = {
        
        var table:UITableView = UITableView(frame: self.view.bounds, style: UITableViewStyle.Plain)
        table.dataSource = self
        table.delegate = self
        table.registerClass(UITableViewCell.self, forCellReuseIdentifier: ID)
        return table
    }()
    lazy var collection:UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 20
        layout.minimumInteritemSpacing = 0
        layout.itemSize = CGSizeMake(140, 90)
        layout.scrollDirection = UICollectionViewScrollDirection.Horizontal
        var collection = UICollectionView(frame: CGRect(x: 0.0, y: 64.0, width: UIScreen.mainScreen().bounds.size.width, height: 90.0), collectionViewLayout: layout)
        collection.registerClass(UICollectionViewCell.self, forCellWithReuseIdentifier: CID)
        collection.backgroundColor = UIColor.clearColor()
        collection.showsVerticalScrollIndicator = false
        collection.showsHorizontalScrollIndicator = false
        collection.delegate = self
        collection.dataSource = self
        return collection
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.whiteColor()
        setUpCollection()
    }
    
    func setUpCollection() {
        view.addSubview(collection)
        self.automaticallyAdjustsScrollViewInsets = false
        collection.addLeftRefresh {
            self.collectionLeft()
        }
        collection.addRightRefresh { 
            self.collectionRight()
        }
    }
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return datasource.count
    }
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collection.dequeueReusableCellWithReuseIdentifier(CID, forIndexPath: indexPath)
        if cell.contentView.subviews.count == 0 {
            let label = UILabel(frame: cell.bounds)
            label.textColor = UIColor.redColor()
            label.font = UIFont.systemFontOfSize(10)
            label.numberOfLines = 0
            label.backgroundColor = UIColor.greenColor()
            objc_setAssociatedObject(cell, &CellLabel, label, objc_AssociationPolicy.OBJC_ASSOCIATION_ASSIGN)
            cell.contentView.addSubview(label)
        }
        let label = objc_getAssociatedObject(cell, &CellLabel) as! UILabel
        label.text = (datasource[indexPath.item] as! String)
        return cell
    }
    
    func collectionLeft() {
        let time: NSTimeInterval = 5.0
        let delay = dispatch_time(DISPATCH_TIME_NOW,
                                  Int64(time * Double(NSEC_PER_SEC)))
        dispatch_after(delay, dispatch_get_main_queue()) {
            self.collection.leftEndRefreshing()
            print("延迟5秒啦")
        }
    }
    func collectionRight() {
        let time: NSTimeInterval = 5.0
        let delay = dispatch_time(DISPATCH_TIME_NOW,
                                  Int64(time * Double(NSEC_PER_SEC)))
        dispatch_after(delay, dispatch_get_main_queue()) {
            self.addMore()
            self.collection.rightEndRefreshing()
            self.collection.reloadData()
        }
    }
    
    
    
    
    //MARK:table**************************************
    func setUpTable() {
        view.addSubview(table)
        
        table.addHeadRefresh {
            self.headRefresh()
        }
        table.addFootRefresh {
            self.footRefresh()
        }
    }
    func headRefresh() {
        let time: NSTimeInterval = 5.0
        let delay = dispatch_time(DISPATCH_TIME_NOW,
                                  Int64(time * Double(NSEC_PER_SEC)))
        dispatch_after(delay, dispatch_get_main_queue()) {
            self.table.headEndRefreshing()
            print("延迟5秒啦")
        }
    }
    func footRefresh() {
        let time: NSTimeInterval = 5.0
        let delay = dispatch_time(DISPATCH_TIME_NOW,
                                  Int64(time * Double(NSEC_PER_SEC)))
        dispatch_after(delay, dispatch_get_main_queue()) {
            self.addMore()
            self.table.footEndRefreshing()
            self.table.reloadData()
            print("延迟5秒啦")
        }
    }
    func addMore() {
        let oriCount = datasource.count
        for index in 1...20 {
            let str = String(format: "测试数据%d", index+oriCount)
            datasource.addObject(str)
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return datasource.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(ID)
        cell!.textLabel!.text = datasource[indexPath.row] as? String
        return cell!
    }
    
}

