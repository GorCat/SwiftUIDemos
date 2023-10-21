//
//  GorRefreshHeader.swift
//  Moss
//
//  Created by GorCat on 2023/10/21.
//

import Foundation
import SwiftUI

struct GorRefreshHeader: View {
    @Binding var refreshState: GorRefreshData
    
    var state: GorRefreshState {
        refreshState.headerState
    }
    
    var progress: CGFloat {
        refreshState.headerProgress
    }
    
    var body: some View {
        ZStack {
            if state == .stopped {
                HStack(spacing: 0){
                    Image(systemName:"arrow.down")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 14, height: 14)
                        .rotationEffect(.init(degrees: progress * 180))
                    Text("Pull To Refresh") // 已经到底了
                        .padding()
                }
            }
            if state == .triggered {
                HStack(spacing: 0){
                    Image(systemName:"arrow.down")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 14, height: 14)
                        .rotationEffect(.init(degrees: progress * 180))
                    Text("Release To Refresh") // 已经到底了
                        .padding()
                }
            }
            if state == .loading {
                Text("Loading...")
            }
            if state == .invalid {
                Spacer()
                    .padding()
            }
        }
        .frame(height: 44)
        .font(.system(size: 14))
        .foregroundColor(.black)
    }
}
