//
//  ViewController.swift
//  d
//
//  Created by huangkunpeng on 2022/8/19.
//

import UIKit
import Test

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        let imageV = UIImageView(frame: CGRect.init(x: 40, y: 100, width: 60, height: 60))
        imageV.image = TestManager().test_image(named: "goal_ttc")
        self.view.addSubview(imageV)
    }


}

