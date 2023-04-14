//
//  ContentView.swift
//  ObservedDemo
//
//  Created by GorCat on 2023/4/6.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var store: Store
    
    @ObservedObject var m1: MessageState
    
//    @ObservedObject var manager = CustomMananger.share
    
    init(m1: MessageState) {
        self._m1 = ObservedObject(wrappedValue: m1)
    }
    
    var appStateBinding: Binding<AppState> {
        $store.state
    }
    
    var appState: AppState {
        store.state
    }
    
    var m1Binding: Binding<MessageState> {
        $store.message1
    }
    
    var body: some View {
        VStack {
            Button("appState \(appState.appState)") {
                appStateBinding.wrappedValue.add()
            }
            
            
            Button("m1 \(m1.count)") {
                m1.add()
            }
            
            Button("share \(m1.manager.count)") {
                CustomMananger.share.add()
            }
        }
        .onChange(of: m1.count, perform: { newValue in
            debugPrint(newValue)
        })
        .padding()
    }
}

struct ContentView_Previews: PreviewProvider {
    
    static var store: Store {
        let s = Store()
        return s
    }
    
    static var previews: some View {
        ContentView(m1: MessageState())
            .environmentObject(store)
    }
}
