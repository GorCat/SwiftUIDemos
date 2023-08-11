//
//  ContentView.swift
//  TestDemo
//
//  Created by GorCat on 2023/8/1.
//

import SwiftUI

struct ContentView: View {
    @State var selectedIndex = 0
    var body: some View {
        
        VStack {
            Text("current selected index :\(selectedIndex)")
            SliderView(selectedIndex: $selectedIndex)
            TabView(selection: $selectedIndex) {
                ZStack{
                    Color.red
                    Text("Page0")
                        .foregroundColor(.white)
                }
                .tag(0)
                ZStack{
                    Color.orange
                    Text("Page1")
                        .foregroundColor(.white)
                }
                .tag(1)
                ZStack{
                    Color.blue
                    Text("Page2")
                        .foregroundColor(.white)
                }
                .tag(2)
                ZStack{
                    Color.green
                    Text("Page3")
                        .foregroundColor(.white)
                }
                .tag(3)
            }
        }
        .environment(\.layoutDirection, .rightToLeft)
        .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

struct SliderView: View {
    @Binding var selectedIndex: Int
    let titles = ["View0", "View1", "View2", "View3"]
    
    var body: some View {
        HStack {
            ForEach(titles.indices, id: \.self) { index in
                Button {
                    selectedIndex = index
                } label: {
                    Text(titles[index])
                        .foregroundColor(selectedIndex == index ? .black : .gray)
                }
                .frame(width: 100)
            }
        }
    }
}


