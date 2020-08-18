//
//  TImer.swift
//  MiddleWare
//
//  Created by 양정은 on 2016. 3. 22..
//  Copyright © 2016년 그린콤 김영일. All rights reserved.
//

import Foundation

class MWTimer: NSObject {
    fileprivate var handler: () -> () = { () in}
    
    fileprivate var mTimer: Timer?
    
    
    func setRun(_ run: @escaping () -> ()) {
        self.handler = run
    }
    
    override init() {
        
    }
    
    init(run: @escaping () -> ()) {
        self.handler = run
    }
    
    func start(_ delay: TimeInterval, repeats: Bool) {
        mTimer = Timer.scheduledTimer(timeInterval: delay/1000, target: self, selector: #selector(process), userInfo: nil, repeats: repeats)
    }

    
    func start(_ delay: TimeInterval, repeats: Bool, run: @escaping () -> ()) {
        self.handler = run
        mTimer = Timer.scheduledTimer(timeInterval: delay/1000, target: self, selector: #selector(process), userInfo: nil, repeats: repeats)
    }
    
    func start(_ delay: TimeInterval, period: TimeInterval, run: @escaping () -> ()) {
        self.handler = run
        let date = Date(timeIntervalSinceNow: delay/1000)
        
        mTimer = Timer(fireAt: date, interval: period/1000, target: self, selector: #selector(process), userInfo: nil, repeats: true)
        
        let loop = RunLoop.current
        loop.add(mTimer!, forMode: RunLoopMode.defaultRunLoopMode)
    }
    
    func start(_ delay: TimeInterval, period: TimeInterval) {
        let date = Date(timeIntervalSinceNow: delay/1000)
        
        mTimer = Timer(fireAt: date, interval: period/1000, target: self, selector: #selector(process), userInfo: nil, repeats: true)
        
        let loop = RunLoop.current
        loop.add(mTimer!, forMode: RunLoopMode.defaultRunLoopMode)
    }
    
    @objc fileprivate func process() {
        self.handler()
    }
    
    func cancel() {
        if mTimer != nil {
            mTimer?.invalidate()
            mTimer = nil
        }
    }
}
