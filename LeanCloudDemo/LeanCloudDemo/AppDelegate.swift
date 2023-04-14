//
//  AppDelegate.swift
//  LeanCloudDemo
//
//  Created by 罗杨成果 on 2023/2/10.
//

import UIKit
import LeanCloud

let LEANCLOUDTOKEN = "SGsKL3CyAyM58Nb2LcWIvRuUumFVOtZ38rC0MwzgdOVG8rHp6Nd6Qdb9q0gwuXcV-cn-n1"
let LEANCLOUDAPPID = "ynesFr7EKeD246sJJBLctr2z-gzGzoHsz"
let LEANCLOUDAPPKEY = "lNGaVMAAftiy85xa8nrAAKg0"
let LEANCLOUDURL = "https://ynesfr7e.lc-cn-n1-shared.com"

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // 在 Application 初始化代码执行之前执行
        LCApplication.logLevel = .all
        
        // Override point for customization after application launch.
        do {
            try LCApplication.default.set(
                id: LEANCLOUDAPPID,
                key: LEANCLOUDAPPKEY,
                serverURL: LEANCLOUDURL)
        } catch {
            print(error)
        }
        
        let window = UIWindow(frame: UIScreen.main.bounds)
        window.backgroundColor = .white
        window.rootViewController = ViewController()
        window.makeKeyAndVisible()
        self.window = window
        return true
    }

}

