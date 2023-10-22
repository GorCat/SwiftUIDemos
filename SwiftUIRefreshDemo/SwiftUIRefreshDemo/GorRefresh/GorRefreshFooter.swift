//
//  GorRefreshFooter.swift
//  Moss
//
//  Created by GorCat on 2023/10/21.
//

import Foundation

import SwiftUI

struct GorRefreshFooter: View {
    @Binding var refreshState: GorRefreshData
    
    var state: GorRefreshState {
        refreshState.footerState
    }
    
    var progress: CGFloat {
        refreshState.footerProgress
    }
    
    var body: some View {
        ZStack {
            if state == .stopped {
//                if noMoreData {
//                    Text(.noMoreData) // 已经到底了
//                        .padding()
//                        .frame(height: 20)
//                } else {
                    HStack(spacing: 0){
                        Image(systemName:"arrow.up")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 14, height: 14)
                            .rotationEffect(.init(degrees: progress * 180))
                        Text("Tap or pull up to load more") // 已经到底了
                            .padding()
                            .frame(height: 20)
                    }
//                }
            }
            if state == .triggered {
                
                HStack(spacing: 0){
                    Image(systemName:"arrow.up")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 14, height: 14)
                        .rotationEffect(.init(degrees: progress * 180))
                    Text("Release to load more") // 已经到底了
                        .padding()
                        .frame(height: 20)
                }
            }
            if state == .loading {
                Text("Loading")
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
