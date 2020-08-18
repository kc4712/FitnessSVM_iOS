//
//  Database.swift
//  Swift_Middleware
//
//  Created by 심규창 on 2016. 6. 6..
//  Copyright © 2016년 심규창. All rights reserved.
//

import Foundation

private let mDatabase = Database()

class Database{
    //private static let tag = Database.className;
    class func getInstance() -> Database {
        return mDatabase
    }
    
    func resetVideoVariable() {
        mActivityName = ""
        mBottomComment = ""
        mTotalScore = (0, 0, 0, 0, "")
        mAccuracy = 0
        mPoint = 0
        mCount = (0, 0)
        mCalorie = 0
        mHRCmp = 0
        mHRWarnning = ""
        mExerData = (0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0)
    }
    
    func resetTotalScore() {
        mTotalScore = (0, 0, 0, 0, "")
    }
    
    /*************** User ***************/
    fileprivate var profile: (age: Int32, sex: Int32, height: Int32, weight: Float32, goalWeight: Float32) = (0, 0, 0, 0, 0)
    var Profile: (age :Int32, sex: Int32, height: Int32, weight: Float32, goalWeight: Float32) {
        get {
            return profile
        }
        set {
            profile = newValue
        }
    }
    
    fileprivate var dietPeriod: Int32 = 0
    var DietPeriod: Int32 {
        get {
            return dietPeriod
        }
        set {
            dietPeriod = newValue
        }
    }
    
    fileprivate var heartrate_stable: Int16 = 0
    var HeartRateStable: Int16 {
        get {
            return heartrate_stable
        }
        set {
            heartrate_stable = newValue
        }
    }
    
    /*************** Bluetooth ***************/
    fileprivate var battery: (status: Int16, voltage: Int16) = (0, 0)
    var Battery: (status: Int16, voltage: Int16) {
        get {
            return battery
        }
        set {
            battery = newValue
        }
    }
    
    fileprivate var step: Int16 = 0
    var Step: Int16 {
        get {
            return step
        }
        set {
            step = newValue
        }
    }
    
    fileprivate var total_activity_calorie: Double = 0
    var TotalActivityCalorie: Double {
        get {
            return total_activity_calorie
        }
        set {
            total_activity_calorie = newValue
        }
    }
    
    fileprivate var total_sleep_calorie: Double = 0
    var TotalSleepCalorie: Double {
        get {
            return total_sleep_calorie
        }
        set {
            total_sleep_calorie = newValue
        }
    }
    
    fileprivate var total_daily_calorie: Double = 0
    var TotalDailyCalorie: Double {
        get {
            return total_daily_calorie
        }
        set {
            total_daily_calorie = newValue
        }
    }
    
    fileprivate var total_coach_calorie: Double = 0
    var TotalCoachCalorie: Double {
        get {
            return total_coach_calorie
        }
        set {
            total_coach_calorie = newValue
        }
    }
    
    fileprivate var activityData: (act_calorie: Double, intensityL: Int16, intensityM: Int16, intensityH: Int16, intensityD: Int16, minHR: Int16, maxHR: Int16, avgHR: Int16) = (0, 0, 0, 0, 0, 0, 0, 0)
    var ActivityData: (act_calorie: Double, intensityL: Int16, intensityM: Int16, intensityH: Int16, intensityD: Int16, minHR: Int16, maxHR: Int16, avgHR: Int16) {
        get {
            return activityData
        }
        set {
            activityData = newValue
        }
    }
    
    fileprivate var sleepData: (rolled: Int16, awaken: Int16, stabilityHR: Int16) = (0, 0, 0)
    var SleepData: (rolled: Int16, awaken: Int16, stabilityHR: Int16) {
        get {
            return sleepData
        }
        set {
            sleepData = newValue
        }
    }
    
    fileprivate var stress: Int16 = 0
    var Stress: Int16 {
        get {
            return stress
        }
        set {
            stress = newValue
        }
    }
    
    fileprivate var state: Int16 = 0
    var State: Int16 {
        get {
            return state
        }
        set {
            state = newValue
        }
    }
    
    fileprivate var version: String = ""
    var Version: String {
        get {
            return version
        }
        set {
            version = newValue
        }
    }
    
    //규창 171025 피쳐데이터 추가
    //(index: Int32?, label: Int32?, actIndex: Int32?, start_date: Int64?, intensity: Double?, calorie: Double?, speed: Double?, heartrate: Int32?, step: Int32?, swing: Int32?, press_var: Double?, coach_intensity: Double?, upload:Int32?)
    fileprivate var featureData: (actIndex: Int32, start_date: Int64, intensity: Double, calorie: Double, speed: Double, heartrate: Int32, step: Int32, swing: Int32, press_var: Double, coach_intensity: Double) = (0, 0, 0, 0, 0, 0, 0, 0, 0, 0)
    var FeatureData: (actIndex: Int32, start_date: Int64, intensity: Double, calorie: Double, speed: Double, heartrate: Int32, step: Int32, swing: Int32, press_var: Double, coach_intensity: Double) {
        get {
            return featureData
        }
        set {
            featureData = newValue
        }
    }
    
    
    /*************** Video ***************/
    fileprivate var mActivityName: String = ""
    var ActivityName: String {
        set {
            if mActivityName == newValue || "" == newValue {
                return
            }
            mActivityName = newValue
            MWNotification.postNotification(MWNotification.Video.TopComment)
        }
        get {
            return mActivityName
        }
    }
    
    fileprivate var mBottomComment: String = ""
    var BottomComment: String {
        set {
            if "" == newValue {
                return
            }
            mBottomComment = newValue
            MWNotification.postNotification(MWNotification.Video.BottomComment)
        }
        get {
            return mBottomComment
        }
    }
    
    fileprivate var mTotalScore: (duration: Double, point: Int, count_percent: Int, accuracy_percent: Int, comment: String) = (0, 0, 0, 0, "")
    var TotalScore: (duration: Double, point: Int, count_percent: Int, accuracy_percent: Int, comment: String) {
        set {
            if mTotalScore == newValue {
                return
            }
            mTotalScore = newValue
            MWNotification.postNotification(MWNotification.Video.TotalScore)
        }
        get {
            return mTotalScore
        }
    }
    
    fileprivate var mAccuracy: Int = 0
    var Accuracy: Int {
        set {
            if mAccuracy == newValue {
                return
            }
            mAccuracy = newValue
            MWNotification.postNotification(MWNotification.Video.MainUI)
        }
        get {
            return mAccuracy
        }
    }
    
    fileprivate var mPoint: Int = 0
    var Point: Int {
        set {
            if mPoint == newValue {
                return
            }
            mPoint = newValue
            MWNotification.postNotification(MWNotification.Video.MainUI)
        }
        get {
            return mPoint
        }
    }
    
    fileprivate var mCount: (count: Int, refCount: Int) = (0, 0)
    var Count: (count: Int, refCount: Int) {
        set {
            if mCount == newValue {
                return
            }
            mCount = newValue
            MWNotification.postNotification(MWNotification.Video.MainUI)
        }
        get {
            return mCount
        }
    }
    
    fileprivate var mCalorie: Float = 0
    var VideoCalorie: Float {
        set {
            if mCalorie == newValue {
                return
            }
            mCalorie = newValue
            MWNotification.postNotification(MWNotification.Video.MainUI)
        }
        get {
            return mCalorie
        }
    }
    
    fileprivate var mHRCmp: Int = 0
    var HRCmp: Int {
        set {
            if mHRCmp == newValue {
                return
            }
            mHRCmp = newValue
            MWNotification.postNotification(MWNotification.Video.MainUI)
        }
        get {
            return mHRCmp
        }
    }
    
    fileprivate var mHRWarnning: String = ""
    var HRWarnning: String {
        set {
            if "" == newValue {
                return
            }
            mHRWarnning = newValue
            MWNotification.postNotification(MWNotification.Video.HeartWarnning)
        }
        get {
            return mHRWarnning
        }
    }
    
    
    fileprivate var mExerData: (videoID:Int, video_full_count:Int, exer_idx:Int, exer_count:Int, start_time:Int64, end_time:Int64, consume_calorie:Int, count:Int, count_percent:Int, perfect_count:Int, minAccuracy:Int, maxAccuracy:Int, avgAccuracy:Int, minHeartRate:Int, maxHeartRate:Int, avgHeartRate:Int , cmpHeartRate:Int, point:Int) = (0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0)
    var ExerData: (videoID:Int, video_full_count:Int, exer_idx:Int, exer_count:Int, start_time:Int64, end_time:Int64, consume_calorie:Int, count:Int, count_percent:Int, perfect_count:Int, minAccuracy:Int, maxAccuracy:Int, avgAccuracy:Int, minHeartRate:Int, maxHeartRate:Int, avgHeartRate:Int , cmpHeartRate:Int, point:Int) {
        set {
            mExerData = newValue
            MWNotification.postNotification(MWNotification.Video.ExerData)
        }
        get {
            return mExerData
        }
    }
    
    
    
    
    
//*** 규창
//************************************** 코치 노말 스트레스측정 용 **********************************************
    //private var mStressNResult: (maxBPM: Double, minBPM: Double, avgBPM: Double, SDNN: Double, RMSSD: Double) = (0.0, 0.0, 0.0, 0.0, 0.0)
    //var StressNResult: (maxBPM: Double, minBPM: Double, avgBPM: Double, SDNN: Double, RMSSD: Double) {
    fileprivate var mStressNResult:Int16 = 0
    var StressNResult: Int16 {
        set {
            //if mStressNResult == newValue {
            //    return
            //}
            mStressNResult = newValue
            print("Database에 값 들어옴!!!!!! \(mStressNResult)")
            MWNotification.postNotification(MWNotification.Bluetooth.NormalStressInform)
        }
        get {
            return mStressNResult
        }
    }
//************************************** 코치 노말 스트레스측정 용 **********************************************
    
    
}
