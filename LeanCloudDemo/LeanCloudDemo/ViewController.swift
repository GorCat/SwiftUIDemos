//
//  ViewController.swift
//  LeanCloudDemo
//
//  Created by 罗杨成果 on 2023/2/10.
//

import UIKit
import LeanCloud

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        model2()
    }
    
    func model1() {
        // Do any additional setup after loading the view.
        do {
            let testObject = LCObject(className: "TestObject")
            try testObject.set("words", value: "Hello world!")
            let result = testObject.save()
            if let error = result.error {
                print(error)
            }
        } catch {
            print(error)
        }
    }
    
    func model2() {
        let user = LCApplication.default.currentUser
        do {
            // 构建对象
            let todo = LCObject(className: "Todo")

            // 为属性赋值
            try todo.set("title",   value: "工程师周会")
            try todo.set("content", value: "周二两点，全体成员")

            // 将对象保存到云端
            _ = todo.save { result in
                switch result {
                case .success:
                    // 成功保存之后，执行其他逻辑
                    break
                case .failure(error: let error):
                    // 异常处理
                    print(error)
                }
            }
        } catch {
            print(error)
        }
        
    }


}

