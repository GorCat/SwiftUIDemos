//
//  MgcRefreshHeader.swift
//  SwiftUIRefreshDemo
//
//  Created by GorCat on 2023/3/20.
//

import SwiftUI

extension View {
    func onRefresh(_ isRefreshing: Binding<Bool>, action: @escaping () -> Void) -> some View {
        self.modifier(Refreshable(header: MgcRefreshHeader(), footer: EmptyView(), isHeaderRefreshing: isRefreshing, isFooterRefreshing: .constant(false), onHeaderRefresh: action, onFooterRefresh: nil))
    }
    
    func onRefreshable(headerRefreshing: Binding<Bool>,
                       headerAction: @escaping () -> Void,
                       footerRefreshing: Binding<Bool>,
                       noMoreData: Binding<Bool>,
                       footerAction: @escaping () -> Void
    ) -> some View {
        self.modifier(Refreshable(header: MgcRefreshHeader(), footer: MgcRefreshFooter(noMoreData: noMoreData), isHeaderRefreshing: headerRefreshing, isFooterRefreshing: footerRefreshing, onHeaderRefresh: headerAction, onFooterRefresh: footerAction))
    }
}

struct Refreshable<Header: View, Footer: View>: ViewModifier {
    var header: Header
    var footer: Footer
    @Binding var isHeaderRefreshing: Bool
    @Binding var isFooterRefreshing: Bool
    
    let onHeaderRefresh: (() -> Void)?
    let onFooterRefresh: (() -> Void)?
    
    @State private var headerRefreshData = RefreshData()
    @State private var footerRefreshData = RefreshData()
    
    func body(content: Content) -> some View {
        GeometryReader { proxy in
            ScrollView {
                VStack(spacing: 0) {
                    header
                        .opacity(dynamicHeaderOpacity)
                        .frame(maxWidth: .infinity)
                        .anchorPreference(key: HeaderBoundsPreferenceKey.self, value: .bounds, transform: {
                            [.init(bounds: $0)]
                        }) // 把header的bounds加入已HeaderBoundsPreferenceKey标记的Preference中
                        .border(.blue)
                    content
                        .anchorPreference(key: FooterBoundsPreferenceKey.self, value: .bounds, transform: {
                            [.init(bounds: $0)]
                        }) // 把content的bounds加入已FooterBoundsPreferenceKey标记的Preference中
                    footer
                        .opacity(dynamicFooterOpacity)
                        .frame(maxWidth: .infinity)
                        .anchorPreference(key: FooterBoundsPreferenceKey.self, value: .bounds, transform: {
                            [.init(bounds: $0)]
                        }) // 把footer的frame加入已FooterBoundsPreferenceKey标记的Preference中
                    // 上面content和footer的bounds都加入了FooterBoundsPreferenceKey，此时FooterBoundsPreferenceKey的value是一个有两个元素的数组：[content.bounds, footer.bounds]
                }
                .padding(.top, dynamicHeaderPadding)
                .padding(.bottom, dynamicFooterPadding)
                .onChange(of: isHeaderRefreshing, perform: { value in
                    if !value {
                        self.headerRefreshData.refreshState = .stopped
                    }
                })
                .onChange(of: isFooterRefreshing, perform: { value in
                    if !value {
                        self.footerRefreshData.refreshState = .stopped
                    }
                })
                .backgroundPreferenceValue(HeaderBoundsPreferenceKey.self) { value -> Color in
                    DispatchQueue.main.async {
                        calculateHeaderRefreshState(proxy, value: value)
                    }
                    return Color.clear // 返回一个透明背景，无效果，仅用于在视图更新时触发calculateHeaderRefreshState函数
                }
                
                .backgroundPreferenceValue(FooterBoundsPreferenceKey.self) { value -> Color in
                    // 接收到以FooterBoundsPreferenceKey标记的Preference，也就是value=[content.bounds, footer.bounds]
                    DispatchQueue.main.async {
                        calculateFooterRefreshState(proxy, value: value)
                    }
                    return Color.clear
                }
            }
        }
    }
    
    var dynamicHeaderOpacity: Double {
        if headerRefreshData.refreshState == .invalid {
            return 0.0
        }
        if headerRefreshData.refreshState == .stopped {
            return headerRefreshData.progress
        }
        return 1.0
    }
    
    var dynamicFooterOpacity: Double {
        if footerRefreshData.refreshState == .invalid {
            return 0.0
        }
        if footerRefreshData.refreshState == .stopped {
            return footerRefreshData.progress
        }
        return 1.0
    }
    
    var dynamicHeaderPadding: CGFloat {
        return (headerRefreshData.refreshState == .loading) ? 0.0 : -headerRefreshData.thresold
    }
    
    var dynamicFooterPadding: CGFloat {
        return (footerRefreshData.refreshState == .loading) ? 0.0 : -footerRefreshData.thresold
    }
}
//
//struct MgcRefreshHeader_Previews: PreviewProvider {
//    static var previews: some View {
//        MgcRefreshHeader()
//    }
//}

extension Refreshable {
    private func calculateHeaderRefreshState(_ proxy: GeometryProxy, value: [HeaderBoundsPreferenceKey.Item]) {
        guard let bounds = value.first?.bounds else {
            return
        }
        
        // caculate state
        guard headerRefreshData.refreshState != .loading else {
            return
        }
        
        guard isFooterRefreshing != true else {
            return
        }
        
        let headerFrame = proxy[bounds] // we need geometry proxy to get real frame
        
        let y = headerFrame.minY
        let threshold = headerFrame.height
        let topDistance: CGFloat = 30.0
        
        if threshold != headerRefreshData.thresold {
            headerRefreshData.thresold = threshold
        }
        
        if -y == headerRefreshData.thresold && headerFrame.width == proxy.size.width && headerRefreshData.refreshState == .invalid {
            headerRefreshData.refreshState = .stopped
        }
        
        var contentOffset = y + threshold
        
        if contentOffset == 0 {
            headerRefreshData.progress = 0.0
        }
        
        guard contentOffset > topDistance else {
            return
        }
        
        contentOffset -= topDistance
        
        if contentOffset <= threshold && headerRefreshData.refreshState == .stopped {
            let oldProgress = headerRefreshData.progress
            let progress = Double(contentOffset / threshold)
            if progress < oldProgress {
                return
            }
            headerRefreshData.progress = (progress >= 1.0) ? 1.0 : progress
        }
        
        if contentOffset > threshold && headerRefreshData.refreshState == .stopped && headerRefreshData.refreshState != .triggered {
            headerRefreshData.refreshState = .triggered
            headerRefreshData.progress = 1.0
        }
        
        if contentOffset <= threshold && headerRefreshData.refreshState == .triggered && headerRefreshData.refreshState != .loading {
            headerRefreshData.refreshState = .loading
            headerRefreshData.progress = 1.0
            isHeaderRefreshing = true
            onHeaderRefresh?()
            if(!isHeaderRefreshing){
                // 检查一下避免在onHeaderRefresh中同步的改回了false导致onChange没有触发
                headerRefreshData.refreshState = .stopped
            }
        }
    }
    
    private func calculateFooterRefreshState(_ proxy: GeometryProxy, value: [FooterBoundsPreferenceKey.Item]) {
        guard let bounds = value.last?.bounds else {
            return
        }
        guard let contentBounds = value.first?.bounds else {
            return
        }
                
        guard footerRefreshData.refreshState != .loading else {
            return
        }
        
        guard isHeaderRefreshing != true else {
            return
        }
        
        let footerFrame = proxy[bounds]
        let contentFrame = proxy[contentBounds]
        
        let y = footerFrame.minY
        let threshold = footerFrame.height
        let bottomDistance: CGFloat = 30.0
        
        let scrollViewHeight = min(proxy.size.height, contentFrame.height) // 如果满了就以屏幕下边沿计算，如果没填满就以内容下边沿计算
        
        if threshold != footerRefreshData.thresold {
            footerRefreshData.thresold = threshold
        }
        
        let isA = abs(y - (scrollViewHeight + footerRefreshData.thresold))
        let isB = footerFrame.width == proxy.size.width
        let isC = footerRefreshData.refreshState == .invalid
        print("isA = \(isA), isB = \(isB), isC = \(isC)")
        print("y \(y)")
        print("scrollViewHeight \(scrollViewHeight)")
        print("footerRefreshData.thresold \(footerRefreshData.thresold)")
        
        if abs(y - (scrollViewHeight + footerRefreshData.thresold)) < 0.001 && footerFrame.width == proxy.size.width && footerRefreshData.refreshState == .invalid {
            footerRefreshData.refreshState = .stopped
        }
        
        var contentOffset = scrollViewHeight - y
        
        if contentOffset == 0 {
            footerRefreshData.progress = 0.0
        }
        
        guard contentOffset > bottomDistance else {
            return
        }
        
        contentOffset -= bottomDistance
        
        if contentOffset <= threshold && footerRefreshData.refreshState == .stopped {
            let progress = Double(contentOffset / threshold)
            footerRefreshData.progress = (progress >= 1.0) ? 1.0 : progress
        }
        
        if contentOffset > threshold && footerRefreshData.refreshState == .stopped && footerRefreshData.refreshState != .triggered {
            // 进入预备刷新状态，条件
            // 1. 滚动到下方空白大于threshold(=footer的高度)
            // 2. 当前有滚动、不在初始状态
            // 3. 当前没在刷新（==.stopped）
            footerRefreshData.refreshState = .triggered
            footerRefreshData.progress = 1.0
        }
        if contentOffset <= threshold && footerRefreshData.refreshState == .triggered && footerRefreshData.refreshState != .loading {
            // 正式开始刷新，条件
            // 1. 当前在预备刷新状态（==.triggered）
            // 2. 回弹到下方空白小于threshold(=footer的高度)/或者在没滚动状态（也就是因为list太短没法滚动）
            footerRefreshData.refreshState = .loading
            footerRefreshData.progress = 0.0
            isFooterRefreshing = true
            onFooterRefresh?()
            if(!isFooterRefreshing){
                // 检查一下避免在onFooterRefresh中同步的改回了false导致onChange没有触发
                footerRefreshData.refreshState = .stopped
            }
        }
    }
}

