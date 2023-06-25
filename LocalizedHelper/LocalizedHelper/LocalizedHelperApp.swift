//
//  LocalizedHelperApp.swift
//  LocalizedHelper
//
//  Created by GorCat on 2023/6/19.
//

import SwiftUI

@main
struct LocalizedHelperApp: App {
    @State var store = Store()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(store)
        }
    }
}
