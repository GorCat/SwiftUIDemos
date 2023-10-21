//
//  GorRefresh.swift
//  Moss
//
//  Created by GorCat on 2023/10/21.
//

import Foundation
import SwiftUI

enum GorRefreshState: Int {
    case invalid // 无效
    case stopped // 停止
    case triggered // 触发
    case loading // 加载
}

struct GorRefreshData {
    var headerProgress: Double = 0
    var headerState: GorRefreshState = .stopped
    
    var footerProgress: Double = 0
    var footerState: GorRefreshState = .stopped
}

extension View {
    func gor_refreshable(state: Binding<GorRefreshData>, refresh: @escaping (() -> Void), loadMore: (() -> Void)? = nil) -> some View {
        self.modifier(RioRefreshModifier(state: state, headerRefreshAction: refresh, footerRefreshAction: loadMore))
    }
}

struct RioRefreshModifier: ViewModifier {
    
    @Binding var state: GorRefreshData
    
    var headerRefreshAction: (() -> Void)?
    var footerRefreshAction: (() -> Void)?
    
    @State private var topPadding = -44.0
    @State private var isFirstShow = true
    
    @State private var bottomPadding = -44.0
    
    var headerOpacity: CGFloat {
        switch state.headerState {
        case .loading:
            return 1
        default:
            return state.headerProgress
        }
    }
    
    var footerOpacity: CGFloat {
        switch state.footerState {
        case .loading:
            return 1
        default:
            return state.footerProgress
        }
    }
    
    func body(content: Content) -> some View {
        ZStack {
            
            GeometryReader { proxy in
                ScrollView(showsIndicators: false) {
                    
                    VStack(spacing: 0) {
                        
                        GorRefreshHeader(refreshState: $state)
                            .frame(maxWidth: .infinity)
                            .opacity(headerOpacity)
                            .anchorPreference(key: GorHeaderBoundsPreferenceKey.self, value: .bounds) { [.init(bounds: $0)] } // 通过此方法将 header 的位置记录下来，传给父视图
                        
                        content
                        
                        GorRefreshFooter(refreshState: $state)
                            .frame(maxWidth: .infinity)
                            .opacity(footerOpacity)
                            .anchorPreference(key: GorFooterBoundsPreferenceKey.self, value: .bounds) { [.init(bounds: $0)] }
                    }
                    .padding(.top, topPadding)
                    .padding(.bottom, bottomPadding)
                }
                .backgroundPreferenceValue(GorHeaderBoundsPreferenceKey.self) { value -> Color in
                    DispatchQueue.main.async {
                        updateHeaderGorRefreshState(proxy, value: value)
                    }
                    return Color.clear
                }
                .backgroundPreferenceValue(GorFooterBoundsPreferenceKey.self) { value -> Color in
                    DispatchQueue.main.async {
                        updateFooterRefreshState(proxy, value: value)
                    }
                    return Color.clear
                }
            }
            .onChange(of: state.headerState) { newValue in
                withAnimation {
                    if newValue == .loading {
                        topPadding = 0
                    } else if newValue == .stopped {
                        topPadding = -44
                    }
                }
            }
            .onChange(of: state.footerState) { newValue in
                
                if newValue == .loading {
                    bottomPadding = 0
                } else if newValue == .stopped {
                    bottomPadding = -44
                }
            }
            
        }
        .onAppear {
            DispatchQueue.main.async {
                if isFirstShow {
                    isFirstShow = false
                    state.headerState = .loading
                    headerRefreshAction?()
                }
            }
        }
    }
}

extension RioRefreshModifier {
    
    private func updateHeaderGorRefreshState(_ proxy: GeometryProxy, value: [GorHeaderBoundsPreferenceKey.Item]) {
        
        guard let bounds = value.first?.bounds else {
            return
        }
        
        // 如果是 loading 状态，则返回
        guard state.headerState != .loading else {
            return
        }

        // 如果 footer 正在 loading， 也返回
        if state.footerState == .loading {
            return
        }
        
        // 通过 proxy 获取到 header 在 scrollow 上的 frame
        // 获取 header 的 frame，初始位置是 y:-44 ，height:44，下拉则 y 逐渐增大为正数
        let headerFrame = proxy[bounds]
        // debugPrint("Refresh - header headerFrame \(headerFrame)")
        
        let y = headerFrame.minY
        let topDistance: CGFloat = 30.0
        
        // 初始化状态，将 invalid 状态改为 stop，只会在最开始时调用一次，作用是判断当前 scrollow 是否能正常显示 header
        if -y == headerFrame.height && state.headerState == .invalid {
            state.headerState = .stopped
        }
        
        // 获取偏移量，初试位置的偏移量为 0，header y 为 -44，下拉 contentOffset 则变为正数
        let contentOffset = y + headerFrame.height
        
        if contentOffset == 0 {
            state.headerProgress = 0.0
        }
        
        /// 如果偏移量小于 30，则认为用户只是误触，不显示 header，如果大于了 30，则认为用户想要刷新，开始显示 header 图片
        guard contentOffset > topDistance else {
            return
        }
        
//         debugPrint("Refresh - header contentOffset > topDistance \(contentOffset > topDistance) contentOffset\(contentOffset)")
        /// 获取以 header 显示为初始点的偏移量，showHeaderContentOffset == 0 时， contentOffset == 30，header y = -44 + 30，继续下拉为正数
        let showHeaderContentOffset = contentOffset - topDistance
        
        if showHeaderContentOffset <= headerFrame.height && state.headerState == .stopped {
            let oldProgress = state.headerProgress
            let progress = Double(contentOffset / headerFrame.height)
            if progress < oldProgress {
                return
            }
            state.headerProgress = (progress >= 1.0) ? 1.0 : progress
        }
        
        if showHeaderContentOffset > headerFrame.height && state.headerState == .stopped {
            // debugPrint("Refresh - header triggered")
            state.headerState = .triggered
            state.headerProgress = 1.0
        }
        
        if showHeaderContentOffset <= headerFrame.height && state.headerState == .triggered {
            // debugPrint("Refresh - header loading")
            state.headerState = .loading
            state.headerProgress = 1.0
            
            headerRefreshAction?()
            
        }
    }
    
    private func updateFooterRefreshState(_ proxy: GeometryProxy, value: [GorFooterBoundsPreferenceKey.Item]) {
        // value = [content.bounds, footer.bounds]
        guard let bounds = value.last?.bounds else {
            return
        }
        guard let contentBounds = value.first?.bounds else {
            return
        }
        
        // 如果是 loading 状态，则返回
        if state.footerState == .loading {
            return
        }
        
        // 如果 header 是 loading 状态，也返回
        if state.headerState == .loading {
            return
        }
        
        // 获取 footer 的 frame
        let footerFrame = proxy[bounds]
        let contentFrame = proxy[contentBounds]
        
        let y = footerFrame.minY
        let threshold = footerFrame.height
        let bottomDistance: CGFloat = 30.0
        
        let scrollViewHeight = min(proxy.size.height, contentFrame.height) // 如果满了就以屏幕下边沿计算，如果没填满就以内容下边沿计算
        
        // 初始化状态，将 invalid 状态改为 stop，只会在最开始时调用一次，作用是判断当前 scrollow 是否能正常显示 footer
        if state.footerState == .invalid {
            state.footerState = .stopped
        }
        
        var contentOffset = scrollViewHeight - y
        
        if contentOffset == 0 {
            state.footerProgress = 0.0
        }
        
        guard contentOffset > bottomDistance else {
            return
        }
        
        contentOffset -= bottomDistance
        
//        print("the footer frame is: \(footerFrame) | \(contentFrame) and scroll view size: \(proxy.size)")
//        print("content offset is: \(contentOffset) / \(threshold)")
        
        if contentOffset <= threshold && state.footerState == .stopped {
//            let oldProgress = state.footerProgress
            let progress = Double(contentOffset / threshold)
//            if progress < oldProgress {
//                return
//            }
            state.footerProgress = (progress >= 1.0) ? 1.0 : progress
        }
        
        if contentOffset > threshold && state.footerState == .stopped {
            // 进入预备刷新状态，条件
            // 1. 滚动到下方空白大于threshold(=footer的高度)
            // 2. 当前有滚动、不在初始状态
            // 3. 当前没在刷新（==.stopped）
            state.footerState = .triggered
            state.footerProgress = 1.0
        }
        if contentOffset <= threshold && state.footerState == .triggered && state.footerState != .loading {
            // 正式开始刷新，条件
            // 1. 当前在预备刷新状态（==.triggered）
            // 2. 回弹到下方空白小于threshold(=footer的高度)/或者在没滚动状态（也就是因为list太短没法滚动）
            state.footerState = .loading
            state.footerProgress = 0.0
            footerRefreshAction?()
        }
    }
}

struct RioRefreshView_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            ForEach(0...20, id: \.self) { index in
                Text("Row \(index)")
                    .frame(height: 80)
                    .border(.green)
            }
        }
        .gor_refreshable(state: .constant(GorRefreshData())) {
            
        }
    }
}

struct GorHeaderBoundsPreferenceKey: PreferenceKey {
    struct Item {
        let bounds: Anchor<CGRect>
    }
    static var defaultValue: [Item] = []
    
    // 每次有新的init(bounds)就加入value数组
    static func reduce(value: inout [Item], nextValue: () -> [Item]) {
        value.append(contentsOf: nextValue())
    }
}

struct GorFooterBoundsPreferenceKey: PreferenceKey {
    struct Item {
        let bounds: Anchor<CGRect>
    }
    static var defaultValue: [Item] = []
    
    // 每次有新的init(bounds)就加入value数组
    static func reduce(value: inout [Item], nextValue: () -> [Item]) {
        value.append(contentsOf: nextValue())
    }
}
