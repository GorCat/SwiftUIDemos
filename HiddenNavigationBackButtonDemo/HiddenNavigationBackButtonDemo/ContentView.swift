//
//  ContentView.swift
//  HiddenNavigationBackButtonDemo
//
//  Created by GorCat on 2023/3/28.
//

import SwiftUI

struct ContentView: View {
    @State var color = Color.orange
    
    var body: some View {
        NavigationView {
            VStack {
                Text("Hello, world!")
                NavigationLink(destination: DetailView(color: $color)) {
                    Text("Go to detail view")
                }
            }
            .navigationTitle("")
            .navigationBarBackButtonHidden(true) // 隐藏返回按钮
            .toolbar {
                ToolbarItem {
//                    Button("Save") {
//                        print("Save")
//                    }
                    Text("Save")
                        .onTapGesture {
                            print("Save")
                        }
                }
            }
        }
        .accentColor(color)
        .navigationViewStyle(StackNavigationViewStyle()) // 支持 iOS 14 导航栏手势
    }
    
}

struct DetailView: View {
    @Environment(\.presentationMode) var presentationMode
    @Binding var color: Color

    var body: some View {
        VStack {
            Text("Detail view")
                .onTapGesture {
                    color = .red
                }
            NavigationLink(destination: DetailView(color: $color)) {
                Text("Go to detail view")
            }
        }
        .navigationTitle("Detail View")
        .navigationBarTitleDisplayMode(.inline)
    }
    
}
 
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

