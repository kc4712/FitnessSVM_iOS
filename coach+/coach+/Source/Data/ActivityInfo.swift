//
//  ActivityInfo.swift
//  CoachPlus
//
//  Created by 양정은 on 2016. 8. 1..
//  Copyright © 2016년 Company Green Comm. All rights reserved.
//

import Foundation
import MiddleWare

class ActivityInfo: BaseJsonParser, WebRequestDelegate, WebResponseDelegate {
    fileprivate let TAG = String(describing: ActivityInfo.self)
    //9999910 ,20, 30 코스
    fileprivate var m_index: Int32 = 0
    fileprivate var m_label: CourseLabel = .activity;
    
    var Index: Int32 {
        get {
            return m_index
        }
        set {
            m_index = newValue
        }
    }
    
    var Label: Int32 {
        get {
            return m_label.rawValue
        }
        set {
            if let label = CourseLabel(rawValue: newValue) {
                m_label = label
            } else {
                m_label = CourseLabel.activity
            }
        }
    }
    
    
    fileprivate var list_activityInfo: [ActivityData] = [];
    
    override init() {
        
    }
    
    func makeRequest(_ queryCode: QueryCode) -> String {
        var ret = "";
        ret += WebQuery.SERVER_ADDR;
        ret += queryCode.rawValue;
        
        switch queryCode {
        case .ListExercise:
            ret += "?User=\(Preference.getUrlUsercode()!)"
            ret += "&Course=\(m_label.rawValue)"
        case .ListCalorieToday:
            ret += "?User=\(Preference.getUrlUsercode()!)"
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

        if let arr = json["Items"] as! NSArray? {
            var data1 = 0.0
            var data2 = 0.0
            var data3 = 0.0
            var data4 = 0.0
            for inner in arr {
                if let dic = inner as? NSDictionary {
                    if queryCode == .ListCalorieToday {
                        switch Int32(getInt(dic, "CourseCode")) {
                        case CourseLabel.activity.rawValue:
                            data1 += Double(getInt(dic, "Calorie"))
                        case CourseLabel.sleep.rawValue:
                            data3 += Double(getInt(dic, "Calorie"))
                        case CourseLabel.daily.rawValue:
                            data4 += Double(getInt(dic, "Calorie"))
                        default:
                            break
                        }
                        
                        for c in CourseLabel.CoachCourse {
                            if getInt(dic, "CourseCode") == c {
                                data2 += Double(getInt(json, "Calorie"))
                            }
                        }
                        
//                        BaseViewController.PieData = (data1, data2, data3, data4)
                    } else if queryCode == .ListExercise {
                        list_activityInfo.append(ActivityData(json: dic));
                    }
                }
            }
            
            let helper = SQLHelper.getInstance()
            for act in list_activityInfo {
                if helper?.getActivityData(act.StartDate) == nil {
                    // label이 0이면 데이가 없는것이므로 추가함.
                    _ = helper?.addConsume(act)
                }
            }
            
            list_activityInfo.removeAll()
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
    }
    
    func OnQueryFail(_ queryStatus: QueryStatus) {
        //        dispatch_async(dispatch_get_main_queue(), {
        //            () -> () in
        //            self.failProc?(queryStatus);
        //        })
        
        //fail 되면, 다음 이벤트(앱 재실행, 운동 데이터 발생)에 재전송.
        if m_fail != nil {
            m_fail!()
        }
    }
    
    fileprivate var m_success: ((_ queryCode: QueryCode) -> ())?
    fileprivate var m_fail: (() -> ())?
    func setSuccess(_ handler: @escaping (_ queryCode: QueryCode) -> ()) {
        m_success = handler
    }
    
    func setFail(_ handler: @escaping () -> ()) {
        m_fail = handler
    }
}
