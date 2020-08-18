//
//  TodayData.swift
//  CoachPlus
//
//  Created by 양정은 on 2016. 8. 5..
//  Copyright © 2016년 Company Green Comm. All rights reserved.
//

import Foundation

class TodayData: BaseJsonParser {
    fileprivate var m_runsec = 0
    var RunSec: Int {
        get {
            return m_runsec
        }
        set {
            m_runsec = newValue
        }
    }
    
    fileprivate var m_calorie = 0
    var Calorie: Int {
        get {
            return m_calorie
        }
        set {
            m_calorie = newValue
        }
    }

    fileprivate var m_point = 0
    var Point: Int {
        get {
            return m_point
        }
        set {
            m_point = newValue
        }
    }
    
    fileprivate var m_userlevel = 0
    var UserLevel: Int {
        get {
            return m_userlevel
        }
        set {
            m_userlevel = newValue
        }
    }
    
    func parse(_ json: NSDictionary) {
        Point = getInt(json, "Point")
        RunSec = getInt(json, "RunSec")
        Calorie = getInt(json, "Calorie")
        UserLevel = getInt(json, "UserLevel")
    }
}
