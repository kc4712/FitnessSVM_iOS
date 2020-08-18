//
//  QueryCode.swift
//  MiddleWare
//
//  Created by 양정은 on 2016. 3. 30..
//  Copyright © 2016년 그린콤 김영일. All rights reserved.
//

import Foundation
import MiddleWare

public enum QueryCode: String {
    case CreateUser
    case LoginUser
    case SetDevice
    case SetProfile
    case SetTarget
    
    case InsertExercise, InsertExercise2, ExerciseToday, WeekData, YearData
    case ListExercise, ListCalorieToday
    
    case ListStep, InsertStep
    
    case CheckVersion
    
    // 이하는 실제 쿼리에 들어가는 코드는 아니고, 내부에서 구분하기 위한 코드.
    case InsertCoach, InsertFitness
    case GetFirmware
    case DownLoadFile
}

public enum QueryResult {
    case success
    case fail
    case invalid
}

enum CourseLabel: Int32 {
    case activity = 9999910
    case sleep = 9999920
    case daily = 9999930
    
    static let CoachCourse = [2, 3, 4, 101, 102, 201, 202, 301, 302]
    
    // 내부에서만 씀. 서버로는 올리지 않음.
    case stress = 1111111
    case feature = 9999940
}

enum XmlVersionCode: String {
    case Version002 = "320002"
    case Version003 = "320003"
    case Version004 = "320004"
    case Version101 = "320101"
    case Version102 = "320102"
    case Version201 = "320201"
    case Version202 = "320202"
    case Version301 = "320301"
    case Version302 = "320302"
    
    var storeVersion: String? {
        get {
            var version: String?
            switch self {
            case .Version002:
                version = Preference.XmlVersion002
            case .Version003:
                version = Preference.XmlVersion003
            case .Version004:
                version = Preference.XmlVersion004
            case .Version101:
                version = Preference.XmlVersion101
            case .Version102:
                version = Preference.XmlVersion102
            case .Version201:
                version = Preference.XmlVersion201
            case .Version202:
                version = Preference.XmlVersion202
            case .Version301:
                version = Preference.XmlVersion301
            case .Version302:
                version = Preference.XmlVersion302
            }
            
            return version
        }
        set {
            switch self {
            case .Version002:
                Preference.XmlVersion002 = newValue
            case .Version003:
                Preference.XmlVersion003 = newValue
            case .Version004:
                Preference.XmlVersion004 = newValue
            case .Version101:
                Preference.XmlVersion101 = newValue
            case .Version102:
                Preference.XmlVersion102 = newValue
            case .Version201:
                Preference.XmlVersion201 = newValue
            case .Version202:
                Preference.XmlVersion202 = newValue
            case .Version301:
                Preference.XmlVersion301 = newValue
            case .Version302:
                Preference.XmlVersion302 = newValue
            }
        }
    }
}
