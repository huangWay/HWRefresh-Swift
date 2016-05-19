//
//  HWRefreshView.swift
//  HWRefresh-Swift
//
//  Created by HuangWay on 16/5/18.
//  Copyright © 2016年 HuangWay. All rights reserved.
//

import Foundation
import UIKit
let headPullText = "下拉 加载";
let footPullText = "上拉 加载";
let leftPullText = "右\n滑\n加\n载";
let rightPullText = "左\n滑\n加\n载";
let releaseText = "释放 加载";
let refreshGoingText = "正在 加载";
let leftGoingText = "正\n在\n加\n载";
let leftReleaseText = "释\n放\n加\n载";
let HWRefreshContentOffSet = "contentOffset";
let HWRefreshContentSize = "contentSize";
let HWRefreshAnimationTime = 0.4;
let headFootHeight = 55;
let leftRightWidth = 55;

enum HWRefreshType {
    case head
    case foot
    case left
    case right
}
enum HWRefreshState {
    case normal
    case ready
    case refreshing
}
typealias callback = ()->()

class HWRefreshView: UIView {
    var scrollView:UIScrollView?
    var normalText:String?
    var readyText:String?
    var refreshingText:String?
    var beiginRefreshingTarget:AnyObject?
    var beiginRefreshingAction:Selector?
    var beiginRefreshCallback:callback!
    var scrollViewOriginalInset:UIEdgeInsets?
    lazy var statusLabel:UILabel = {
        var label = UILabel.init()
        label.font = UIFont.systemFontOfSize(14)
        label.backgroundColor = UIColor.redColor()
        label.numberOfLines = 0
        label.autoresizingMask = UIViewAutoresizing.FlexibleWidth
        self.addSubview(label)
        return label
    }()
    
    var type:HWRefreshType!
    var state:HWRefreshState = .normal {
        
        willSet{
            switch newValue {
            case .normal: break
            case .ready: break
            case .refreshing:break
                
            }
        }
        didSet{
            if oldValue != HWRefreshState.refreshing {
                self.scrollViewOriginalInset = self.scrollView?.contentInset
            }
            if oldValue == state {
                return
            }
            switch state {
            case .normal:
                if oldValue == HWRefreshState.refreshing {
                    insetWithRefreshType(type, insetValue: self.scrollViewOriginalInset!)
                }
            case .ready:break
            case .refreshing:
                if beiginRefreshCallback != nil {
                    beiginRefreshCallback!()
                }
                
                contentWithType(type)
            }
            setLabelText()
            
        }
    }
    init(frame:CGRect,type:HWRefreshType,callback:()->()){
        super.init(frame: frame)
        self.type = type
        switch type {
        case .head:
            normalText = headPullText
            readyText = releaseText
            refreshingText = refreshGoingText
        case .foot:
            normalText = footPullText
            readyText = releaseText
            refreshingText = refreshGoingText
        case .left:
            normalText = leftPullText
            readyText = leftReleaseText
            refreshingText = leftGoingText
        case .right:
            normalText = rightPullText
            readyText = leftReleaseText
            refreshingText = leftGoingText
        }
        self.beiginRefreshCallback = callback
        setLabelText()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        self.statusLabel.frame = self.bounds
    }
    override func willMoveToSuperview(newSuperview: UIView?) {
        super.willMoveToSuperview(newSuperview)
        if self.superview?.observationInfo != nil {
            self.superview?.removeObserver(self, forKeyPath: HWRefreshContentOffSet)
        }
        
        if (newSuperview != nil) {
            newSuperview?.addObserver(self, forKeyPath: HWRefreshContentOffSet, options: NSKeyValueObservingOptions.New, context: nil)
            x = 0
            scrollView = newSuperview as? UIScrollView
            scrollViewOriginalInset = scrollView?.contentInset
        }
        if type == HWRefreshType.head || type == HWRefreshType.left {
            if type == HWRefreshType.head {
                width = (newSuperview?.width)!
                height = CGFloat(headFootHeight)
                y = -height
            }else{
                height = (newSuperview?.height)!
                width = CGFloat(leftRightWidth)
                x = -width
            }
        }else{
            if type == HWRefreshType.foot {
                x = 0
                width = newSuperview!.width
                height = CGFloat(headFootHeight)
            }else{
                y = 0
                width = CGFloat(headFootHeight)
                height = newSuperview!.height
            }
            if newSuperview != nil {
                newSuperview?.addObserver(self, forKeyPath: HWRefreshContentSize, options: NSKeyValueObservingOptions.New, context: nil)
            }
            adjustFrames(type)
        }
    }
    override func observeValueForKeyPath(keyPath: String?, ofObject object: AnyObject?, change: [String : AnyObject]?, context: UnsafeMutablePointer<Void>) {
        if userInteractionEnabled == false || alpha <= 0.01 || hidden == true {
            return
        }
        
        if keyPath == HWRefreshContentSize {
            adjustFrames(type)
        }else{
            if state == HWRefreshState.refreshing {
                return
            }
            
        }
        adjustStateWithContentOffSet(type)
    }
    func beginRefresh() {
        state = HWRefreshState.refreshing
    }
    func endRefresh() {
        state = HWRefreshState.normal
    }
    //MARK: *************************一些私有方法*************************
    /**
     设置label 的文字
     */
    private func setLabelText() {
        switch state {
        case .normal:
            statusLabel.text = normalText
        case .ready:
            statusLabel.text = readyText
        case .refreshing:
            statusLabel.text = refreshingText
        }
    }
    private func insetWithRefreshType(type:HWRefreshType,insetValue:UIEdgeInsets) {
        switch type {
        case .head:
            UIView.animateWithDuration(HWRefreshAnimationTime, animations: { 
                self.scrollView?.contentInsetTop = insetValue.top
            })
        case .foot:
            UIView.animateWithDuration(HWRefreshAnimationTime, animations: {
                self.scrollView?.contentInsetBottom = insetValue.bottom
            })
            
        case .left:
            UIView.animateWithDuration(HWRefreshAnimationTime, animations: {
                self.scrollView?.contentInsetLeft = insetValue.left
            })
            
        case .right:
            UIView.animateWithDuration(HWRefreshAnimationTime, animations: {
                self.scrollView?.contentInsetRight = insetValue.right
            })
            
        }
    }
    private func contentWithType(type:HWRefreshType) {
        switch type {
        case .head:
            let top = scrollViewOriginalInset!.top + self.height;
            scrollView!.contentInsetTop = top;
            scrollView!.contentOffsetY = -top;
        case .foot:
            UIView.animateWithDuration(HWRefreshAnimationTime, animations: { 
                var bottom = self.height + self.scrollViewOriginalInset!.bottom
                let deltaH = self.heightBeyoundScrollView()
                if deltaH<0{
                    bottom -= deltaH
                }
                self.scrollView?.contentInsetBottom = bottom
            })
        case .left:
            let left = scrollViewOriginalInset!.left + width
            self.scrollView?.contentInsetLeft = left
            self.scrollView?.contentOffsetX = -left
        case .right:
            UIView.animateWithDuration(HWRefreshAnimationTime, animations: { 
                var right = self.width + self.scrollViewOriginalInset!.right
                let deltaX = self.widthBeyoundScrollView()
                if deltaX < 0 {
                    right -= deltaX
                }
                self.scrollView?.contentInsetRight = right
            })
        }
    }
    private func heightBeyoundScrollView() -> CGFloat {
        let h = scrollView!.height - scrollViewOriginalInset!.top - scrollViewOriginalInset!.bottom
        return scrollView!.contentSizeHeight - h
    }
    private func happenOffsetY() -> CGFloat {
        let deltaH = heightBeyoundScrollView()
        if deltaH > 0 {
            return deltaH - scrollViewOriginalInset!.top
        }else{
            return -scrollViewOriginalInset!.top
        }
    }
    private func widthBeyoundScrollView() -> CGFloat {
        let w = scrollView!.width - scrollViewOriginalInset!.right - scrollViewOriginalInset!.left
        return scrollView!.contentSizeWidth - w
    }
    private func happenOffsetX() -> CGFloat {
        let deltaX = widthBeyoundScrollView()
        if deltaX > 0 {
            return deltaX - scrollViewOriginalInset!.left
        }else{
            return -scrollViewOriginalInset!.left
        }
    }
    private func adjustFrames(type:HWRefreshType) {
        switch type {
        case .head:break
        case .foot:
            let contentH = scrollView!.contentSizeHeight
            let scrollH = scrollView!.height - scrollViewOriginalInset!.top - scrollViewOriginalInset!.bottom
            y = max(contentH, scrollH)
        case .left:break
        case .right:
           let contentX = scrollView!.contentSizeWidth
           let scrollX = scrollView!.width - scrollViewOriginalInset!.left - scrollViewOriginalInset!.right
            x = max(contentX, scrollX)
        
        }
    }
    private func adjustStateWithContentOffSet(type:HWRefreshType) {
        let currentOffsetY = scrollView?.contentOffsetY
        let currentOffsetX = scrollView?.contentOffsetX
        switch type {
        case .head:
            let happenOffsetY = -(scrollViewOriginalInset?.top)!
            if currentOffsetY > happenOffsetY {
                return
            }
            if scrollView!.dragging {
                let willrefreshOffsetY = happenOffsetY - height
                if state == HWRefreshState.normal && currentOffsetY <= willrefreshOffsetY {
                    state = HWRefreshState.ready
                }else if state == HWRefreshState.ready && currentOffsetY > willrefreshOffsetY {
                    state = HWRefreshState.normal
                }
            }else if state == HWRefreshState.ready {
                state = HWRefreshState.refreshing
            }
        case .foot:
            let happenOffsetY = self.happenOffsetY()
            if currentOffsetY < happenOffsetY {
                return
            }
            if scrollView!.dragging {
                let readyOffsetY = happenOffsetY + height
                if state == HWRefreshState.normal && currentOffsetY >= readyOffsetY {
                    state = HWRefreshState.ready
                }else if state == HWRefreshState.ready && currentOffsetY < readyOffsetY {
                    state = HWRefreshState.normal
                }
            }else if state == HWRefreshState.ready {
                state = HWRefreshState.refreshing
            }
        case .left:
            let happenOffsetX = -scrollViewOriginalInset!.left
            if currentOffsetX > happenOffsetX {
                return
            }
            if  scrollView!.dragging {
                let willrefreshOffsetX = scrollViewOriginalInset!.left - width
                if state == HWRefreshState.normal && currentOffsetX < willrefreshOffsetX {
                    state = HWRefreshState.ready
                }else if state == HWRefreshState.ready && currentOffsetX >= willrefreshOffsetX {
                    state = HWRefreshState.normal
                }
            }else if state == HWRefreshState.ready {
                state = HWRefreshState.refreshing
            }
        case .right:
            let happenOffsetX = self.happenOffsetX()
            if  currentOffsetX < happenOffsetX {
                return
            }
            if scrollView!.dragging {
                let readyOffsetX = happenOffsetX + width
                if state == HWRefreshState.normal && currentOffsetX > readyOffsetX {
                    state = HWRefreshState.ready
                }else if state == HWRefreshState.ready && currentOffsetX <= readyOffsetX {
                    state = HWRefreshState.normal
                }
            }else if state == HWRefreshState.ready {
                state = HWRefreshState.refreshing
            }
        }
    }
    
}