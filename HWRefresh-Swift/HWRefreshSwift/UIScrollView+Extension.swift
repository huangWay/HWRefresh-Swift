//
//  UIScrollView+Extension.swift
//  HWRefresh-Swift
//
//  Created by HuangWay on 16/5/18.
//  Copyright © 2016年 HuangWay. All rights reserved.
//

import Foundation
import UIKit


extension UIScrollView {

    public var contentInsetTop:CGFloat {
        get{
            return self.contentInset.top
        }
        set{
            var inset = self.contentInset
            inset.top = newValue
            self.contentInset = inset
        }
    }
    public var contentInsetBottom:CGFloat {
        get{
            return self.contentInset.bottom
        }
        set{
            var inset = self.contentInset
            inset.bottom = newValue
            self.contentInset = inset
        }
    }
    public var contentInsetLeft:CGFloat {
        get{
            return self.contentInset.left
        }
        set{
            var inset = self.contentInset
            inset.left = newValue
            self.contentInset = inset
        }
    }
    public var contentInsetRight:CGFloat {
        get{
            return self.contentInset.right
        }
        set{
            var inset = self.contentInset
            inset.right = newValue
            self.contentInset = inset
        }
    }
    public var contentOffsetX:CGFloat {
        get{
            return self.contentOffset.x
        }
        set{
            var offset = self.contentOffset
            offset.x = newValue
            self.contentOffset = offset
        }
    }
    public var contentOffsetY:CGFloat {
        get{
            return self.contentOffset.y
        }
        set{
            var offset = self.contentOffset
            offset.y = newValue
            self.contentOffset = offset
        }
    }
    public var contentSizeWidth:CGFloat {
        get{
            return self.contentSize.width
        }
        set{
            var size = self.contentSize
            size.width = newValue
            self.contentSize = size
        }
    }
    public var contentSizeHeight:CGFloat {
        get{
            return self.contentSize.height
        }
        set{
            var size = self.contentSize
            size.height = newValue
            self.contentSize = size
        }
    }
    private struct storedProperyName {
        static var head:String = "HWRefreshHeaderViewKey"
        static var foot:String = "HWRefreshFooterViewKey"
        static var left:String = "HWRefreshLefterViewKey"
        static var right:String = "HWRefreshRighterViewKey"
        
    }
    var head:HWRefreshView? {
        set{
            objc_setAssociatedObject(self, &storedProperyName.head, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_ASSIGN)
        }
        get{
            return objc_getAssociatedObject(self, &storedProperyName.head) as? HWRefreshView
        }
    }
    var foot:HWRefreshView? {
        set{
            objc_setAssociatedObject(self, &storedProperyName.foot, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_ASSIGN)
        }
        get{
            return objc_getAssociatedObject(self, &storedProperyName.foot) as? HWRefreshView
        }
    }
    var left:HWRefreshView? {
        set{
            objc_setAssociatedObject(self, &storedProperyName.left, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_ASSIGN)
        }
        get{
            return objc_getAssociatedObject(self, &storedProperyName.left) as? HWRefreshView
        }
    }
    var right:HWRefreshView? {
        set{
            objc_setAssociatedObject(self, &storedProperyName.right, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_ASSIGN)
        }
        get{
            return objc_getAssociatedObject(self, &storedProperyName.right) as? HWRefreshView
        }
    }
    func addHeadRefresh(callback:()->()) {
        if self.head == nil {
            let temphead = HWRefreshView(frame: CGRectZero,type: HWRefreshType.head,callback: callback)
            temphead.type = HWRefreshType.head
            self.addSubview(temphead)
            self.head = temphead
        }
    }
    func headBeginRefreshing() {
        self.head?.beginRefresh()
    }
    func headEndRefreshing() {
        self.head?.endRefresh()
    }
    
    func addFootRefresh(callback:()->()) {
        if self.foot == nil {
            let tempfoot = HWRefreshView(frame: CGRectZero,type: HWRefreshType.foot,callback: callback)
            tempfoot.type = HWRefreshType.foot
            self.addSubview(tempfoot)
            self.foot = tempfoot
        }
        
    }
    func footBeginRefreshing() {
        self.foot?.beginRefresh()
    }
    func footEndRefreshing() {
        self.foot?.endRefresh()
    }
    
    func addLeftRefresh(callback:()->()) {
        if self.left == nil {
            let templeft = HWRefreshView(frame: CGRectZero,type: HWRefreshType.left,callback: callback)
            templeft.type = HWRefreshType.left
            self.addSubview(templeft)
            self.left = templeft
        }
        
    }
    func leftBeginRefreshing() {
        self.left?.beginRefresh()
    }
    func leftEndRefreshing() {
        self.left?.endRefresh()
    }
    
    
    func addRightRefresh(callback:()->()) {
        if self.right == nil {
            let tempright = HWRefreshView(frame: CGRectZero,type: HWRefreshType.right,callback: callback)
            tempright.type = HWRefreshType.right
            self.addSubview(tempright)
            self.right = tempright
        }
        
    }
    func rightBeginRefreshing() {
        self.right?.beginRefresh()
    }
    func rightEndRefreshing() {
        self.right?.endRefresh()
    }
}