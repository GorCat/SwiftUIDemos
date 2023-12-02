//
//  Tool.swift
//  GamerDetailDemo
//
//  Created by GorCat on 2023/12/2.
//

import Foundation
import UIKit
import JXPagingView

extension UIWindow {
    func jx_layoutInsets() -> UIEdgeInsets {
        if #available(iOS 11.0, *) {
            let safeAreaInsets: UIEdgeInsets = self.safeAreaInsets
            if safeAreaInsets.bottom > 0 {
                //参考文章：https://mp.weixin.qq.com/s/Ik2zBox3_w0jwfVuQUJAUw
                return safeAreaInsets
            }
            return UIEdgeInsets.init(top: 20, left: 0, bottom: 0, right: 0)
        }
        return UIEdgeInsets.init(top: 20, left: 0, bottom: 0, right: 0)
    }

    func jx_navigationHeight() -> CGFloat {
        let statusBarHeight = jx_layoutInsets().top
        return statusBarHeight + 44
    }
}

private var ListControllerViewDidScrollKey: Void?
extension JXPagingViewListViewDelegate where Self: UIViewController {
    
    var listViewDidScrollCallback: ((UIScrollView) -> ())? {
        get { objc_getAssociatedObject(self, &ListControllerViewDidScrollKey) as? (UIScrollView) -> () }
        set { objc_setAssociatedObject(self, &ListControllerViewDidScrollKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC) }
    }
}
