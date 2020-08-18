//
//  CoachActivityData.swift
//  CoachPlus
//
//  Created by 양정은 on 2016. 7. 30..
//  Copyright © 2016년 Company Green Comm. All rights reserved.
//

import Foundation

class CoachActivityData {
    fileprivate var m_index: Int32 = 0
    var Index: Int32 {
        get {
            return m_index
        }
        set {
            m_index = newValue
        }
    }
    
    fileprivate var m_video_idx: Int32 = 0
    var VideoIdx: Int32 {
        get {
            return m_video_idx
        }
        set {
            m_video_idx = newValue
        }
    }
    
    fileprivate var m_video_full_count: Int32 = 0
    var VideoFullCount: Int32 {
        get {
            return m_video_full_count
        }
        set {
            m_video_full_count = newValue
        }
    }
    
    fileprivate var m_exer_idx: Int32 = 0
    var ExerIdx: Int32 {
        get {
            return m_exer_idx
        }
        set {
            m_exer_idx = newValue
        }
    }
    
    fileprivate var m_exer_count: Int32 = 0
    var ExerCount: Int32 {
        get {
            return m_exer_count
        }
        set {
            m_exer_count = newValue
        }
    }
    
    fileprivate var m_start_time: Int64 = 0
    var StartTime: Int64 {
        get {
            return m_start_time
        }
        set {
            m_start_time = newValue
        }
    }
    
    fileprivate var m_end_time: Int64 = 0
    var EndTime: Int64 {
        get {
            return m_end_time
        }
        set {
            m_end_time = newValue
        }
    }
    
    fileprivate var m_consume_calorie: Int32 = 0
    var ConsumeCalorie: Int32 {
        get {
            return m_consume_calorie
        }
        set {
            m_consume_calorie = newValue
        }
    }
    
    fileprivate var m_count: Int32 = 0
    var Count: Int32 {
        get {
            return m_count
        }
        set {
            m_count = newValue
        }
    }
    
    fileprivate var m_count_percent: Int32 = 0
    var CountPercent: Int32 {
        get {
            return m_count_percent
        }
        set {
            m_count_percent = newValue
        }
    }
    
    fileprivate var m_perfect_count: Int32 = 0
    var PerfectCount: Int32 {
        get {
            return m_count_percent
        }
        set {
            m_count_percent = newValue
        }
    }
    
    fileprivate var m_min_accuracy: Int32 = 0
    var MinAccuracy: Int32 {
        get {
            return m_min_accuracy
        }
        set {
            m_min_accuracy = newValue
        }
    }
    
    fileprivate var m_max_accuracy: Int32 = 0
    var MaxAccuracy: Int32 {
        get {
            return m_max_accuracy
        }
        set {
            m_max_accuracy = newValue
        }
    }
    
    fileprivate var m_avg_accuracy: Int32 = 0
    var AvgAccuracy: Int32 {
        get {
            return m_avg_accuracy
        }
        set {
            m_avg_accuracy = newValue
        }
    }
    
    fileprivate var m_min_heartrate: Int32 = 0
    var MinHeartRate: Int32 {
        get {
            return m_min_heartrate
        }
        set {
            m_min_heartrate = newValue
        }
    }
    
    fileprivate var m_max_heartrate: Int32 = 0
    var MaxHeartRate: Int32 {
        get {
            return m_max_heartrate
        }
        set {
            m_max_heartrate = newValue
        }
    }
    
    fileprivate var m_avg_heartrate: Int32 = 0
    var AvgHeartRate: Int32 {
        get {
            return m_avg_heartrate
        }
        set {
            m_avg_heartrate = newValue
        }
    }
    
    fileprivate var m_cmp_heartrate: Int32 = 0
    var CmpHeartRate: Int32 {
        get {
            return m_cmp_heartrate
        }
        set {
            m_cmp_heartrate = newValue
        }
    }
    
    fileprivate var m_point: Int32 = 0
    var Point: Int32 {
        get {
            return m_point
        }
        set {
            m_point = newValue
        }
    }
    
    fileprivate var m_reserv_1: Int32 = 0
    var Reserv_1: Int32 {
        get {
            return m_reserv_1
        }
        set {
            m_reserv_1 = newValue
        }
    }
    
    fileprivate var m_reserv_2: Int32 = 0
    var Reserv_2: Int32 {
        get {
            return m_reserv_2
        }
        set {
            m_reserv_2 = newValue
        }
    }
    
    init() {
    
    }
    
    init(index: Int32?, video_idx: Int32?, video_full_count: Int32?, exer_idx: Int32?, exer_count: Int32?, start_time: Int64?, end_time: Int64?, consume_calorie: Int32?, count: Int32?, count_percent: Int32?, perfect_count: Int32?, min_accuracy: Int32?, max_accuracy: Int32?, avg_accuracy: Int32?, min_heartrate: Int32?, max_heartrate: Int32?, avg_heartrate: Int32?, cmp_heartrate: Int32?, point: Int32?, reserv_1: Int32?, reserv_2: Int32?) {
        Index = index!
        VideoIdx = video_idx!
        VideoFullCount = video_full_count!
        ExerIdx = exer_idx!
        ExerCount = exer_count!
        StartTime = start_time!
        EndTime = end_time!
        ConsumeCalorie = consume_calorie!
        Count = count!
        CountPercent = count_percent!
        PerfectCount = perfect_count!
        MinAccuracy = min_accuracy!
        MaxAccuracy = max_accuracy!
        AvgAccuracy = avg_accuracy!
        MinHeartRate = min_heartrate!
        MaxHeartRate = max_heartrate!
        AvgHeartRate = avg_heartrate!
        CmpHeartRate = cmp_heartrate!
        Point = point!
        Reserv_1 = reserv_1!
        Reserv_2 = reserv_2!
    }
}
