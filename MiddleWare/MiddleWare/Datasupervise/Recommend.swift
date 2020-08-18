//
//  Recommend.swift
//  MiddleWare
//
//  Created by 양정은 on 2016. 3. 30..
//  Copyright © 2016년 그린콤 김영일. All rights reserved.
//

import Foundation

open class Recommend {
    fileprivate var activity_index: Int32 = 0
    fileprivate var time: Int64 = 0
    fileprivate var speed: Int32 = 0
    fileprivate var unit: Int32 = 0
    fileprivate var flag:Int = 0
    
    
    //규창 전임자 코드에서 사용하던 부분...
    init(activity_index: Int32, time: Int64, speed: Int32, unit: Int32) {
        self.activity_index = activity_index
        self.time = time
        self.speed = speed
        self.unit = unit
    }
    //규창 이 부분은 자바에서 사용하던 부분...
    public init(time:Int64, flag:Int) {
        self.time = time;
        self.flag = flag;
    }
    public init() {
        self.time = 0
        self.flag = 0
    }
    /////////////
    
    open var getActivityIndex: Int32 {
        return activity_index
    }
    
    open var getTime: Int64 {
        return time
    }
    open func setTime(time: Int64){
        self.time = time;
    }
    
    open var getSpeed: Int32 {
        return speed
    }
    
    open var getUnit: Int32 {
        return unit
    }
    func getFlag() -> Int {
        return flag
    }
    func setFlag(flag:Int) {
        self.flag = flag;
    }
}
