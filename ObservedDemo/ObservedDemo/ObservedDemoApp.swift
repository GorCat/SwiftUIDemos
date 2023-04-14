//
//  ObservedDemoApp.swift
//  ObservedDemo
//
//  Created by GorCat on 2023/4/6.
//

import SwiftUI

@main
struct ObservedDemoApp: App {
    let store = Store()
    
    var body: some Scene {
        WindowGroup {
            ContentView(m1: MessageState())
                .environmentObject(store)
        }
    }
}
