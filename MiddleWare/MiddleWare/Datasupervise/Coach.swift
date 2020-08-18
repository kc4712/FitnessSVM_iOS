//
//  Coach.swift
//  MiddleWare
//
//  Created by 양정은 on 2016. 3. 30..
//  Copyright © 2016년 그린콤 김영일. All rights reserved.
//

import Foundation

open class Coach {
    fileprivate var index: Int = 0
    fileprivate var intensity: Float = 0
    fileprivate var unit: Int = 0
    init() {
        
    }
    init(index:Int, intensity:Float, unit:Int){
        self.index = index
        self.intensity = intensity
        self.unit = unit
    }
    func setIndex(index:Int) {
        self.index = index
    }
    var getIndex: Int {
        return index
    }
    func setIntensity(intensity:Float) {
        self.intensity = intensity
    }
    var getIntensity: Float {
        return intensity
    }
    func setUnit(unit:Int) {
        self.unit = unit
    }
    var getUnit: Int {
        return unit
    }
}
