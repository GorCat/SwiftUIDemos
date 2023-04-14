//
//  HiddenNavigationBackButtonDemoApp.swift
//  HiddenNavigationBackButtonDemo
//
//  Created by GorCat on 2023/3/28.
//

import SwiftUI

@main
struct HiddenNavigationBackButtonDemoApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}

class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        setupNavigation()
        return true
    }
    
    func setupNavigation() {
        let newNavAppearance = UINavigationBarAppearance()
        newNavAppearance.configureWithTransparentBackground()
        newNavAppearance.setBackIndicatorImage(UIImage(named: "gmc_return")!, transitionMaskImage: UIImage(named: "gmc_return")!)

        UINavigationBar.appearance().standardAppearance = newNavAppearance
    }
}
