//
//  MgcRefreshFooter.swift
//  SwiftUIPullToRefresh
//
//  Created by GorCat on 2023/3/20.
//

import SwiftUI



struct MgcRefreshFooter: View {
    
    @Environment(\.footerRefreshData) private var footerRefreshData
    @Binding var noMoreData: Bool
    
    var body: some View {
        let state = footerRefreshData.refreshState
        let progress = footerRefreshData.progress
        ZStack {
            if state == .stopped {
                if noMoreData {
                    Text("已经全部加载完毕") // 已经到底了
                        .padding()
                        .frame(height: 20)
                } else {
                    HStack(spacing: 0){
                        Image(systemName:"arrow.up")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 14, height: 14)
                            .rotationEffect(.init(degrees: progress * 180))
                        Text("上拉可以加载更多") // 已经到底了
                            .padding()
                            .frame(height: 20)
                    }
                }
            }
            if state == .triggered {
                
                HStack(spacing: 0){
                    Image(systemName:"arrow.up")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 14, height: 14)
                        .rotationEffect(.init(degrees: progress * 180))
                    Text("松开立即加载更多") // 已经到底了
                        .padding()
                        .frame(height: 20)
                }
            }
            if state == .loading {
                Text("正在加载更多数据...")
            }
            if state == .invalid {
                Spacer()
                    .padding()
                    .frame(height: 60)
            }
        }
        .font(.system(size: 14))
    }
    
    private func printLog(_ state: RefreshState) -> some View {
        print("\(state)")
        return EmptyView()
    }
}

struct MgcRefreshFooter_Previews: PreviewProvider {
    static var previews: some View {
        MgcRefreshFooter(noMoreData: .constant(false))
    }
}
