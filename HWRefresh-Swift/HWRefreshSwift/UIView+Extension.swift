//
//  UIView+Extension.swift
//  HWRefresh-Swift
//
//  Created by HuangWay on 16/5/18.
//  Copyright © 2016年 HuangWay. All rights reserved.
//

import Foundation
import UIKit
extension UIView {
    public var x:CGFloat {
        get{
            return self.frame.origin.x
        }
        set{
            var frm = self.frame
            frm.origin.x = newValue
            self.frame = frm
        }
    }
    public var y:CGFloat {
        get{
            return self.frame.origin.y
        }
        set{
            var frm = self.frame
            frm.origin.y = newValue
            self.frame = frm;
            
        }
    }
    public var width:CGFloat {
        get{
            return self.frame.size.width
        }
        set{
            var frm = self.frame
            frm.size.width = newValue
            self.frame = frm
        }
    }
    public var height:CGFloat {
        get{
            return self.frame.size.height
        }
        set{
            var frm = self.frame
            frm.size.height = newValue
            self.frame = frm;
        }
    }
}