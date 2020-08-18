//
//  FeatureData.swift
//  CoachPlus
//
//  Created by 심규창 on 2017. 10. 25..
//  Copyright © 2017년 Company Green Comm. All rights reserved.
//

import Foundation
import MiddleWare

//"addConsume->act:\(actIndex) intensity:\(intensity) consumeCalorie:\(consumeCalorie) speed:\(speed) heartrate:\(heartrate) step:\(step) swing:\(swing) pressVariance:pressVariance coach_intensity:\(coach_intensity)")


class FeatureData: BaseJsonParser {
    fileprivate var m_index: Int32 = 0
    var Index: Int32 {
        get {
            return m_index
        }
        set {
            m_index = newValue
        }
    }
    
    fileprivate var m_label: Int32 = 0
    var Label: CourseLabel {
        get {
            if let course = CourseLabel(rawValue: m_label) {
                return course
            }
            return CourseLabel.activity
        }
        set {
            m_label = Int32(newValue.rawValue)
        }
    }
    
    fileprivate var m_actIndex:Int32 = 0
    var ActIndex: Int32 {
        get {
            return m_actIndex
        }
        set {
            m_actIndex = newValue
        }
    }
    
    fileprivate var m_start_date: Int64 = 0
    var StartDate: Int64 {
        get {
            return m_start_date
        }
        set {
            m_start_date = newValue
        }
    }
    /*
    fileprivate var m_end_date: Int64 = 0
    var EndDate: Int64 {
        get {
            return m_end_date
        }
        set {
            m_end_date = newValue
        }
    }*/
    
    fileprivate var m_intensity: Double = 0
    var Intensity: Double {
        get {
            return m_intensity
        }
        set {
            m_intensity = newValue
        }
    }
    
    fileprivate var m_calorie: Double = 0
    var Calorie: Double {
        get {
            return m_calorie
        }
        set {
            m_calorie = newValue
        }
    }
    
    fileprivate var m_speed: Double = 0
    var Speed: Double {
        get {
            return m_speed
        }
        set {
            m_speed = newValue
        }
    }
    
    fileprivate var m_heartrate: Int32 = 0
    var Heartrate: Int32 {
        get {
            return m_heartrate
        }
        set {
            m_heartrate = newValue
        }
    }
    
    fileprivate var m_step: Int32 = 0
    var Step: Int32 {
        get {
            return m_step
        }
        set {
            m_step = newValue
        }
    }
    
    fileprivate var m_swing: Int32 = 0
    var Swing: Int32 {
        get {
            return m_swing
        }
        set {
            m_swing = newValue
        }
    }
    
    fileprivate var m_press_var: Double = 0
    var Press_var: Double {
        get {
            return m_press_var
        }
        set {
            m_press_var = newValue
        }
    }
    
    fileprivate var m_coach_intensity: Double = 0
    var Coach_intensity: Double {
        get {
            return m_coach_intensity
        }
        set {
            m_coach_intensity = newValue
        }
    }
    fileprivate var m_upload: Int32 = 0
    var Upload: Int32 {
        get {
            return m_upload
        }
        set {
            m_upload = newValue
        }
    }
    
    override init() {
        
    }
    
    convenience init(index: Int32?, label: Int32?, actIndex: Int32?, start_date: Int64?, intensity: Double?, calorie: Double?, speed: Double?, heartrate: Int32?, step: Int32?, swing: Int32?, press_var: Double?, coach_intensity: Double?, upload:Int32?) {
        self.init()
        Index = index!
        if let course = CourseLabel(rawValue: label!) {
            Label = course
        }
        ActIndex = actIndex!
        StartDate = start_date!
        Intensity = intensity!
        Calorie = calorie!
        Speed = speed!
        Heartrate = heartrate!
        Step = step!
        Swing = swing!
        Press_var = press_var!
        Coach_intensity = coach_intensity!
        Upload = upload!
    }
    
    convenience init(json: NSDictionary) {
        self.init()
        
        if let course = CourseLabel(rawValue: Int32(getInt(json, "CourseCode"))) {
            Label = course
        }
        
        ActIndex = Int32(getInt(json, "ActIndex"))
        StartDate = Int64(getInt(json, "BegTime"))
        Intensity = Double(getInt(json, "Intensity"))
        Calorie = Double(getInt(json, "Calorie"))
        Speed = Double(getInt(json, "Speed"))
        Heartrate = Int32(getInt(json, "HeartRate"))
        Step = Int32(getInt(json, "Step"))
        Swing = Int32(getInt(json, "Swing"))
        Press_var = Double(getInt(json, "Press_var"))
        Coach_intensity = Double(getInt(json, "Coach_intensity"))
        Upload = SQLHelper.SET_UPLOAD
        
        
        /*
        Calorie = Double(getInt(json, "Calorie")) / 1000
        StartDate = Int64(getInt(json, "BegTime"))
        EndDate = Int64(getInt(json, "EndTime"))
        IntensityL = Int32(getInt(json, "Inten1"))
        IntensityM = Int32(getInt(json, "Inten2"))
        IntensityH = Int32(getInt(json, "Inten3"))
        IntensityD = Int32(getInt(json, "Inten4"))
        MaxHR = Int32(getInt(json, "HeartRateMax"))
        MinHR = Int32(getInt(json, "HeartRateMin"))
        AvgHR = Int32(getInt(json, "HeartRateAvg"))
        Upload = SQLHelper.SET_UPLOAD
 */
    }
}

