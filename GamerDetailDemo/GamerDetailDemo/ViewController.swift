//
//  ViewController.swift
//  GamerDetailDemo
//
//  Created by GorCat on 2023/12/2.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
    }

    @IBAction func buttonTaped(_ sender: Any) {
        let vc = ListRefreshViewController()
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func homeDetailTaped(_ sender: Any) {
        let vc = MgcHomeDtailController()
        navigationController?.pushViewController(vc, animated: true)
    }
}
