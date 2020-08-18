//
//  Background.swift
//  testPJ
//
//  Created by 양정은 on 2016. 4. 4..
//  Copyright © 2016년 양정은. All rights reserved.
//

import UIKit
import Foundation

fileprivate let obj = Background()

class Background: NSObject {
    fileprivate var app: UIApplication
    fileprivate var id: UIBackgroundTaskIdentifier = UIBackgroundTaskInvalid
    
    class func getInstance() -> Background {
        return obj
    }
    
    fileprivate override init() {
        self.app = UIApplication.shared
        super.init()
    }
    
    func begin() {
        print("---begin background")
        id = app.beginBackgroundTask() {
            self.app.endBackgroundTask(self.id)
        }
        print(id)
    }
    
    func end() {
        if id == UIBackgroundTaskInvalid {
            return
        }
        
        print("---end background")
        app.endBackgroundTask(id)
        
        id = UIBackgroundTaskInvalid
    }
    
    func run(exe: () ) {
        begin()
        exe
        end()
    }
}
