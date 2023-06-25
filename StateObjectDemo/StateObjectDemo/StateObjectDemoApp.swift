//
//  StateObjectDemoApp.swift
//  StateObjectDemo
//
//  Created by GorCat on 2023/5/7.
//

import SwiftUI

@main
struct StateObjectDemoApp: App {
    
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}

class AppDelegate: NSObject, UIApplicationDelegate {
}
