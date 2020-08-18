//
//  StepInfo.swift
//  CoachPlus
//
//  Created by 양정은 on 2016. 8. 9..
//  Copyright © 2016년 Company Green Comm. All rights reserved.
//

import Foundation
import MiddleWare

class StepInfo: BaseJsonParser, WebRequestDelegate, WebResponseDelegate {
    fileprivate let TAG = String(describing: StepInfo.self)
    
    fileprivate var m_index: Int32 = 0
    fileprivate var m_reg: Int64 = 0
    fileprivate var m_step: Int32 = 0
    
    fileprivate var m_stepArray: [Int32] = [0, 0, 0, 0, 0, 0, 0]
    
    var Reg: Int64 {
        get {
            return m_reg
        }
        set {
            m_reg = newValue
        }
    }
    
    var Step: Int32 {
        get {
            return m_step
        }
        set {
            m_step = newValue
        }
    }
    
    var StepArray: [Int32] {
        get {
            return m_stepArray
        }
        set {
            m_stepArray = newValue
        }
    }
    
    init(reg: Int64, step: Int32) {
        m_reg = reg
        m_step = step
    }
    
    override init() {
        
    }
    
    func makeRequest(_ queryCode: QueryCode) -> String {
        var ret = "";
        ret += WebQuery.SERVER_ADDR;
        ret += queryCode.rawValue;
        
        switch queryCode {
        case .ListStep:
            ret += "?User=\(Preference.getUrlUsercode()!)"
        case .InsertStep:
            ret += "?User=\(Preference.getUrlUsercode()!)"
            ret += "&Reg=\(m_reg)";
            ret += "&Step=\(m_step)";
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
        if queryCode == .ListStep {
            if let arr = json["Items"] as! NSArray? {
                m_stepArray.removeAll()
                for inner in arr {
                    if let dic = inner as? NSDictionary {
                        Reg = UtilsWeb.convertDate(getString(dic, "RegDate")!)
                        Step = Int32(getInt(dic, "Step"))
                        
                        m_stepArray.append(Step)
                    }
                }
            }
            
            return QueryStatus.Success
        }
        
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
        
        if queryCode == .InsertStep {
            if let lastStepDate = getString(json, "LastStepDate") {
                let calendar = MWCalendar.getInstance()
                let nowDate = calendar.getTimeInMillis()
                let getDate = UtilsWeb.convertDate(lastStepDate)
                
                let diff = nowDate - getDate
                let milli_today: Int64 = 86400000
                if diff / milli_today > 1 {
                    let mc = MWControlCenter.getInstance()
                    let len = diff / milli_today
                    
                    print("len :: \(len)")
                    for i in 0..<len {
                        let dat: BLSender = (.stepCount_Calorie, getDate + (i * milli_today), .start, true, .empty)
                        mc.appendSender(dat)
                    }
                }
            }
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
