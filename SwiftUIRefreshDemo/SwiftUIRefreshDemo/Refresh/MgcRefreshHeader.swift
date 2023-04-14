//
//  MgcRefreshHeader.swift
//  SwiftUIPullToRefresh
//
//  Created by GorCat on 2023/3/20.
//

import SwiftUI


struct MgcRefreshHeader: View {
    
    @Environment(\.headerRefreshData) private var headerRefreshData
    
    var body: some View {
        let state = headerRefreshData.refreshState
        let progress = headerRefreshData.progress
        ZStack {
            if state == .stopped {
                HStack(spacing: 0){
                    Image(systemName:"arrow.down")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 14, height: 14)
                        .rotationEffect(.init(degrees: progress * 180))
                    Text("下拉可以刷新") // 已经到底了
                        .padding()
                        .frame(height: 20)
                }
            }
            if state == .triggered {
                HStack(spacing: 0){
                    Image(systemName:"arrow.down")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 14, height: 14)
                        .rotationEffect(.init(degrees: progress * 180))
                    Text("松开立即刷新") // 已经到底了
                        .padding()
                        .frame(height: 20)
                }
            }
            if state == .loading {
                Text("正在刷新数据...")
            }
            if state == .invalid {
                Spacer()
                    .padding()
                    .frame(height: 60)
            }
        }
        .font(.system(size: 14))
    }
}
