//
//  ActivityData.swift
//  CoachPlus
//
//  Created by 양정은 on 2016. 7. 28..
//  Copyright © 2016년 Company Green Comm. All rights reserved.
//

import Foundation
import MiddleWare

class ActivityData: BaseJsonParser {
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
    
    fileprivate var m_calorie = 0.0
    var Calorie: Double {
        get {
            return m_calorie
        }
        set {
            m_calorie = newValue
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
    
    fileprivate var m_end_date: Int64 = 0
    var EndDate: Int64 {
        get {
            return m_end_date
        }
        set {
            m_end_date = newValue
        }
    }
    
    fileprivate var m_intensity_L: Int32 = 0
    var IntensityL: Int32 {
        get {
            return m_intensity_L
        }
        set {
            m_intensity_L = newValue
        }
    }
    
    fileprivate var m_intensity_M: Int32 = 0
    var IntensityM: Int32 {
        get {
            return m_intensity_M
        }
        set {
            m_intensity_M = newValue
        }
    }
    
    fileprivate var m_intensity_H: Int32 = 0
    var IntensityH: Int32 {
        get {
            return m_intensity_H
        }
        set {
            m_intensity_H = newValue
        }
    }
    
    fileprivate var m_intensity_D: Int32 = 0
    var IntensityD: Int32 {
        get {
            return m_intensity_D
        }
        set {
            m_intensity_D = newValue
        }
    }
    
    fileprivate var m_maxHR: Int32 = 0
    var MaxHR: Int32 {
        get {
            return m_maxHR
        }
        set {
            m_maxHR = newValue
        }
    }
    
    fileprivate var m_minHR: Int32 = 0
    var MinHR: Int32 {
        get {
            return m_minHR
        }
        set {
            m_minHR = newValue
        }
    }
    
    fileprivate var m_avgHR: Int32 = 0
    var AvgHR: Int32 {
        get {
            return m_avgHR
        }
        set {
            m_avgHR = newValue
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
    
    convenience init(index: Int32?, label: Int32?, calorie: Double?, start_date: Int64?, end_date: Int64?, intensityL: Int32?, intensityM: Int32?, intensityH: Int32?, intensityD: Int32?, maxHR: Int32?, minHR: Int32?, avgHR: Int32?, upload: Int32?) {
        self.init()
        Index = index!
        if let course = CourseLabel(rawValue: label!) {
            Label = course
        }
        Calorie = calorie!
        StartDate = start_date!
        EndDate = end_date!
        IntensityL = intensityL!
        IntensityM = intensityM!
        IntensityH = intensityH!
        IntensityD = intensityD!
        MaxHR = maxHR!
        MinHR = minHR!
        AvgHR = avgHR!
        Upload = upload!
    }
    
    convenience init(json: NSDictionary) {
        self.init()
        
        if let course = CourseLabel(rawValue: Int32(getInt(json, "CourseCode"))) {
            Label = course
        }
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
    }
}
