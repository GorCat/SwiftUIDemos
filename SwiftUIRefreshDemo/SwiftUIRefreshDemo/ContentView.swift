//
//  ContentView.swift
//  SwiftUIRefreshDemo
//
//  Created by GorCat on 2023/3/20.
//

import SwiftUI
import Introspect

extension View {
    func onRefresh(_ isRefreshing: Binding<Bool>) -> some View {
        self
    }
    
    func onLoadMore() -> some View {
        self
    }
}

struct ContentView: View {
    @State var datas: [String] = []
    @State private var headerRefreshing: Bool = false
    @State private var footerRefreshing: Bool = false
    @State private var noMoreData: Bool = false
    
    var body: some View {
        NavigationView {
            LazyVStack {
                ForEach(datas.indices, id: \.self) { index in
                    GGGGGGGGGCell(index: index)
                }
            }
            .onRefreshable(headerRefreshing: $headerRefreshing, headerAction: {
                reloadData()
            }, footerRefreshing: $footerRefreshing, noMoreData: $noMoreData, footerAction: {
                loadMoreData()
            })
            .border(.red)
            .padding(.bottom, 40)
            .navigationTitle("Refresh Demo")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
    
    private func reloadData() {
        print("begin refresh data ...\(headerRefreshing)")
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.datas = Array(repeating: "", count: 10)
            headerRefreshing = false
            print("end refresh data ...\(headerRefreshing)")
        }
    }
    
    private func loadMoreData() {
        print("begin load more data ... \(footerRefreshing)")
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.datas.append(contentsOf: Array(repeating: "", count: 100))
            footerRefreshing = false
            print("end load more data ... \(footerRefreshing)")
        }
    }
}

struct GGGGGGGGGCell: View {
    let index: Int
    
    var body: some View  {
        HStack {
            Text("Row\(index)")
            Spacer()
            Image("\(index % 5 + 1)")
                .resizable()
                .frame(width: 50, height: 50)
                .aspectRatio(contentMode: .fit)
                .clipShape(Circle())
        }
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
