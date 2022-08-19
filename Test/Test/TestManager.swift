//
//  TestManager.swift
//  Test
//
//  Created by huangkunpeng on 2022/8/19.
//

import Foundation
import UIKit
open class TestManager {
    public init(){
        
    }
    
    
    public func test_print() {
        print("TestManager sdk print ")
    }
    
    
    ///资源文件
    public func test_image(named:String) -> UIImage? {
        let bundleName = "Test.framework/TestBundle.bundle/\(named)"
        return UIImage(named: bundleName)
    }
}
