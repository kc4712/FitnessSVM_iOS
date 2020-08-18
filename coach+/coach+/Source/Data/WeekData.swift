//
//  WeekData.swift
//  CoachPlus
//
//  Created by 양정은 on 2016. 8. 5..
//  Copyright © 2016년 Company Green Comm. All rights reserved.
//

import Foundation

class WeekData: BaseJsonParser {
    fileprivate var m_accuracy = 0
    var Accuracy: Int {
        get {
            return m_accuracy
        }
        set {
            m_accuracy = newValue
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
    
    fileprivate var m_heartrate_max = 0
    var HeartMax: Int {
        get {
            return m_heartrate_max
        }
        set {
            m_heartrate_max = newValue
        }
    }
    
    fileprivate var m_heartrate_avg = 0
    var HeartAvg: Int {
        get {
            return m_heartrate_avg
        }
        set {
            m_heartrate_avg = newValue
        }
    }
    
    fileprivate var m_total_count = 0
    var TotalCount: Int {
        get {
            return m_total_count
        }
        set {
            m_total_count = newValue
        }
    }
    
    fileprivate var m_match_count = 0
    var MatchCount: Int {
        get {
            return m_match_count
        }
        set {
            m_match_count = newValue
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
    
    func parse(_ json: NSDictionary) {
        Accuracy = getInt(json, "Accuracy")
        Calorie = getInt(json, "Calorie")
        HeartMax = getInt(json, "HeartRateMax")
        HeartAvg = getInt(json, "HeartRateAvg")
        TotalCount = getInt(json, "TotalCount")
        MatchCount = getInt(json, "MatchCount")
        Point = getInt(json, "Point")
    }
}
