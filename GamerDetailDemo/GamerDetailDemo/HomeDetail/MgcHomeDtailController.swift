//
//  MgcHomeDtailController.swift
//  GamerDetailDemo
//
//  Created by GorCat on 2023/12/3.
//

import UIKit
import JXPagingView
import JXSegmentedView

let screenWidth = UIScreen.main.bounds.width
let screenHeight = UIScreen.main.bounds.height

class MgcHomeDtailController: UIViewController {
    let mgc_screenWidth = UIScreen.main.bounds.width
    
    lazy var mgc_pagingView = JXPagingListRefreshView(delegate: self)
    
    var mgc_headerView = UIView()
    var mgc_headerHeight: CGFloat = 0
    
    let mgc_segmentDataSource: JXSegmentedTitleDataSource = JXSegmentedTitleDataSource()
    lazy var mgc_segmentedView: JXSegmentedView = JXSegmentedView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: 40))
    
    
    // MARK: Life
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = (mgc_segmentedView.selectedIndex == 0)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = true
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        mgc_pagingView.frame = self.view.bounds
    }

    
    // MARK: UI
    func setUI() {
        let topPadding =
        
        view.backgroundColor = .white
        self.navigationController?.navigationBar.isTranslucent = false
        // 1
        setHeaderView()
       
        // 2
        setSegmentView()
        
        // 3
        setPagingView()
        
        // 4
        mgc_segmentedView.listContainer = mgc_pagingView.listContainerView
        //扣边返回处理，下面的代码要加上
        mgc_pagingView.listContainerView.scrollView.panGestureRecognizer.require(toFail: self.navigationController!.interactivePopGestureRecognizer!)
        mgc_pagingView.mainTableView.panGestureRecognizer.require(toFail: self.navigationController!.interactivePopGestureRecognizer!)
    }
    
    func setPagingView() {
        mgc_pagingView.mainTableView.gestureDelegate = self
        self.view.addSubview(mgc_pagingView)
    }
    
    func setHeaderView() {
        let mgc_topPadding = UIDevice.xp_safeDistanceTop() + UIDevice.xp_navigationBarHeight()
        
        mgc_headerHeight = UIScreen.main.bounds.width / 375 * 563 + 111 - mgc_topPadding
        
        mgc_headerView.backgroundColor = .green
        mgc_headerView.frame = CGRect(x: 0, y: -mgc_topPadding, width: screenWidth, height: mgc_headerHeight)
    }
    
    func setSegmentView() {
        
        // 标签栏
        mgc_segmentDataSource.titles = ["Profile", "Moment"]
        mgc_segmentDataSource.isTitleColorGradientEnabled = true
        mgc_segmentDataSource.isTitleZoomEnabled = true
        
        mgc_segmentDataSource.titleSelectedColor = UIColor(hex: "#8A8C99")
        mgc_segmentDataSource.titleSelectedFont = UIFont.systemFont(ofSize: 33, weight: .semibold)
        
        mgc_segmentDataSource.titleNormalColor = UIColor.black
        mgc_segmentDataSource.titleNormalFont = UIFont.systemFont(ofSize: 16)
        
        mgc_segmentedView.delegate = self
        mgc_segmentedView.isContentScrollViewClickTransitionAnimationEnabled = false
        mgc_segmentedView.dataSource = mgc_segmentDataSource
        
        let mgc_segmentLineView = JXSegmentedIndicatorImageView()
        mgc_segmentLineView.indicatorHeight = 4
        mgc_segmentLineView.indicatorWidth = 36
        mgc_segmentLineView.image = UIImage(named: "mgc_home_segment_line")
        mgc_segmentLineView.backgroundColor = UIColor(hex: "#F9F8FB")
        mgc_segmentedView.indicators = [mgc_segmentLineView]
        
    }

}

// MARK: - JXSegmentedViewDelegate
extension MgcHomeDtailController: JXSegmentedViewDelegate {
    
}

// MARK: - JXPagingViewDelegate
extension MgcHomeDtailController: JXPagingViewDelegate {
    func pagingView(_ pagingView: JXPagingView, initListAtIndex index: Int) -> JXPagingViewListViewDelegate {
        let list = ListViewController()
        list.isNeedHeader = false
        list.isNeedFooter = true
        if index == 0 {
            // TODO: Profile View
            list.dataSource = ["橡胶火箭", "橡胶火箭炮", "橡胶机关枪", "橡胶子弹", "橡胶攻城炮", "橡胶象枪", "橡胶象枪乱打", "橡胶灰熊铳", "橡胶雷神象枪", "橡胶猿王枪", "橡胶犀·榴弹炮", "橡胶大蛇炮", "橡胶火箭", "橡胶火箭炮", "橡胶机关枪", "橡胶子弹", "橡胶攻城炮", "橡胶象枪", "橡胶象枪乱打", "橡胶灰熊铳", "橡胶雷神象枪", "橡胶猿王枪", "橡胶犀·榴弹炮", "橡胶大蛇炮"]
        } else {
            // TODO: Moment View
            list.dataSource = ["【剑士】罗罗诺亚·索隆", "【航海士】娜美", "【狙击手】乌索普", "【厨师】香吉士", "【船医】托尼托尼·乔巴", "【船匠】 弗兰奇", "【音乐家】布鲁克", "【考古学家】妮可·罗宾", "【航海士】娜美", "【狙击手】乌索普", "【厨师】香吉士", "【船医】托尼托尼·乔巴", "【船匠】 弗兰奇", "【音乐家】布鲁克", "【考古学家】妮可·罗宾", "【航海士】娜美", "【狙击手】乌索普", "【厨师】香吉士", "【船医】托尼托尼·乔巴", "【船匠】 弗兰奇", "【音乐家】布鲁克", "【考古学家】妮可·罗宾", "【航海士】娜美", "【狙击手】乌索普", "【厨师】香吉士", "【船医】托尼托尼·乔巴", "【船匠】 弗兰奇", "【音乐家】布鲁克", "【考古学家】妮可·罗宾", "【航海士】娜美", "【狙击手】乌索普", "【厨师】香吉士", "【船医】托尼托尼·乔巴", "【船匠】 弗兰奇", "【音乐家】布鲁克", "【考古学家】妮可·罗宾", "【航海士】娜美", "【狙击手】乌索普", "【厨师】香吉士", "【船医】托尼托尼·乔巴", "【船匠】 弗兰奇", "【音乐家】布鲁克", "【考古学家】妮可·罗宾"]
        }
        return list
    }
    
    func tableHeaderViewHeight(in pagingView: JXPagingView) -> Int {
        Int(mgc_headerHeight)
    }
    
    func tableHeaderView(in pagingView: JXPagingView) -> UIView {
        mgc_headerView
    }
    
    func heightForPinSectionHeader(in pagingView: JXPagingView) -> Int {
        40
    }
    
    func viewForPinSectionHeader(in pagingView: JXPagingView) -> UIView {
        mgc_segmentedView
    }
    
    func numberOfLists(in pagingView: JXPagingView) -> Int {
        2
    }
    
    
}

// MARK: JXPagingMainTableViewGestureDelegate
extension MgcHomeDtailController: JXPagingMainTableViewGestureDelegate {
    func mainTableViewGestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        //禁止segmentedView左右滑动的时候，上下和左右都可以滚动
        if otherGestureRecognizer == mgc_segmentedView.collectionView.panGestureRecognizer {
            return false
        }
        return gestureRecognizer.isKind(of: UIPanGestureRecognizer.self) && otherGestureRecognizer.isKind(of: UIPanGestureRecognizer.self)
    }
    
    
}
