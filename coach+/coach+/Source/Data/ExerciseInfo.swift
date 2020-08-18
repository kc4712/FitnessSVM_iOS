//
//  ExerciseInfo.swift
//  CoachPlus
//
//  Created by 양정은 on 2016. 8. 1..
//  Copyright © 2016년 Company Green Comm. All rights reserved.
//

import Foundation
import MiddleWare

class ExerciseInfo: BaseJsonParser, WebRequestDelegate, WebResponseDelegate {
    fileprivate let TAG = String(describing: ExerciseInfo.self)
    
    fileprivate var m_index: Int32 = 0
    fileprivate var m_course: Int32 = 0;
    fileprivate var m_begTime: Int64 = 0
    fileprivate var m_endTime: Int64 = 0;
    fileprivate var m_totalCount: Int32 = 0;
    fileprivate var m_matchCount: Int32 = 0;
    fileprivate var m_accuracy: Int32 = 0;
    fileprivate var m_point: Int32 = 0;
    fileprivate var m_calorie: Int32 = 0;
    fileprivate var m_maxHeart: Int32 = 0;
    fileprivate var m_avgHeart: Int32 = 0;
    fileprivate var m_minHeart: Int32 = 0;
    fileprivate var m_intensityL: Int32 = 0;
    fileprivate var m_intensityM: Int32 = 0;
    fileprivate var m_intensityH: Int32 = 0;
    fileprivate var m_intensityD: Int32 = 0;
    
    override init() {
     
    }
    
    init(info: CoachActivityData) {
        m_index = info.Index
        m_course = info.ExerIdx
        m_begTime = info.StartTime
        m_endTime = info.EndTime
        m_totalCount = info.ExerCount
        m_matchCount = info.Count
        m_accuracy = info.AvgAccuracy
        m_point = info.Point
        m_calorie = info.ConsumeCalorie
        m_maxHeart = info.MaxHeartRate
        m_avgHeart = info.AvgHeartRate
    }
    
    init(info: ActivityData) {
        m_index = info.Index
        m_course = Int32(info.Label.rawValue)
        m_begTime = info.StartDate
        m_endTime = info.EndDate
        m_calorie = Int32(info.Calorie * 1000)
        m_maxHeart = info.MaxHR
        m_minHeart = info.MinHR
        m_avgHeart = info.AvgHR
        m_intensityL = info.IntensityL
        m_intensityM = info.IntensityM
        m_intensityH = info.IntensityH
        m_intensityD = info.IntensityD
    }
    
    func setExerciseInfo(_ info: CoachActivityData) {
        m_index = info.Index
        m_course = info.ExerIdx
        m_begTime = info.StartTime
        m_endTime = info.EndTime
        m_totalCount = info.ExerCount
        m_matchCount = info.Count
        m_accuracy = info.AvgAccuracy
        m_point = info.Point
        m_calorie = info.ConsumeCalorie
        m_maxHeart = info.MaxHeartRate
        m_avgHeart = info.AvgHeartRate
    }
    
    func setActivityInfo(_ info: ActivityData) {
        m_index = info.Index
        m_course = Int32(info.Label.rawValue)
        m_begTime = info.StartDate
        m_endTime = info.EndDate
        m_calorie = Int32(info.Calorie * 1000)
        m_maxHeart = info.MaxHR
        m_minHeart = info.MinHR
        m_avgHeart = info.AvgHR
        m_intensityL = info.IntensityL
        m_intensityM = info.IntensityM
        m_intensityH = info.IntensityH
        m_intensityD = info.IntensityD
    }
    
    func makeRequest(_ queryCode: QueryCode) -> String {
        var ret = "";
        ret += WebQuery.SERVER_ADDR;
        
        switch queryCode {
        case .InsertExercise:
            ret += QueryCode.InsertExercise.rawValue;
            ret += "?User=\(Preference.getUrlUsercode()!)"
            ret += "&Course=\(m_course)";
            ret += "&Begtime=\(m_begTime)";
            ret += "&Endtime=\(m_endTime)";
            ret += "&Total=\(m_totalCount)";
            ret += "&Match=\(m_matchCount)";
            ret += "&Accuracy=\(m_accuracy)";
            ret += "&Point=\(m_point)";
            ret += "&Calorie=\(m_calorie)";
            ret += "&Maxrate=\(m_maxHeart)";
            ret += "&Avgrate=\(m_avgHeart)";
        case .InsertFitness:
            ret += QueryCode.InsertExercise2.rawValue;
            ret += "?User=\(Preference.getUrlUsercode()!)"
            ret += "&Course=\(m_course)";
            ret += "&Begtime=\(m_begTime)";
            ret += "&Endtime=\(m_endTime)";
            ret += "&Accuracy=\(m_accuracy)";
            ret += "&Point=\(m_point)";
            ret += "&Calorie=\(m_calorie)";
            ret += "&Maxrate=\(m_maxHeart)";
            ret += "&Avgrate=\(m_avgHeart)";
            ret += "&Minrate=\(m_minHeart)";
            ret += "&Inten1=\(m_intensityL)";
            ret += "&Inten2=\(m_intensityM)";
            ret += "&Inten3=\(m_intensityH)";
            ret += "&Inten4=\(m_intensityD)";
        default:
            break;
        }
        //let url = ret.stringByAddingPercentEscapesUsingEncoding(NSUTF8StringEncoding);
        let url = ret.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed);
        return url!;
    }
    
    func parse(_ json: NSDictionary, queryCode: QueryCode) -> QueryStatus {
        Log.d(TAG, msg: "=====================================================");
        Log.d(TAG, msg: "웹 반환 값 파싱");
        Log.d(TAG, msg: "=====================================================");
        //Log.d(TAG, msg: "Query Code = \(queryCode), Result Json = \(json)");
        Log.d(TAG, msg:"Query Code = \(queryCode)");
        
        let result = json["Result"] as! Int?;
        
        if (result == nil) {
            return QueryStatus.ERROR_Result_Parse;
        }
        
        print("Result = \(result!)");
        
        if (result == 2) {
            return QueryStatus.ERROR_Exists_Email;
        }
        
        if (result == 3) {
            return QueryStatus.ERROR_Account_Not_Match;
        }

        
        return QueryStatus.Success
    }
    
    func OnQuerySuccess(_ queryCode: QueryCode) {
        //        if queryCode == QueryCode.LoginUser {
        //            MWNotification.postNotification(MWNotification.Etc.getLogin);
        //        }
        // 성공 콜백을 UI 스레드에서 실행
//        dispatch_async(dispatch_get_main_queue(), {
//            () -> () in
//            self.successProc?();
//        })
        if m_success != nil {
            m_success!(queryCode)
        }
        
        if queryCode == .InsertExercise {
            let helper = SQLHelper.getInstance()
            _ = helper?.deleteCoachActivityData(m_index)
        }
    }
    
    func OnQueryFail(_ queryStatus: QueryStatus) {
//        dispatch_async(dispatch_get_main_queue(), {
//            () -> () in
//            self.failProc?(queryStatus);
//        })
        
        //fail 되면, 다음 이벤트(앱 재실행, 운동 데이터 발생)에 재전송.
        if m_fail != nil {
            m_fail!(queryStatus)
        }
    }
    
    fileprivate var m_success: ((_ queryCode: QueryCode) -> ())?
    fileprivate var m_fail: ((_ queryStatus: QueryStatus) -> ())?
    func setSuccess(_ handler: @escaping (_ queryCode: QueryCode) -> ()) {
        m_success = handler
    }
    
    func setFail(_ handler: @escaping (_ queryStatus: QueryStatus) -> ()) {
        m_fail = handler
    }
}
