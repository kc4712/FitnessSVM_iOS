//
//  MainInfo.swift
//  CoachPlus
//
//  Created by 양정은 on 2016. 8. 5..
//  Copyright © 2016년 Company Green Comm. All rights reserved.
//

import Foundation
import MiddleWare

class MainInfo: BaseJsonParser, WebRequestDelegate, WebResponseDelegate
{
    fileprivate let TAG = String(describing: MainInfo.self)
    
    let today = TodayData()
    let week = WeekData()
    
    func makeRequest(_ queryCode: QueryCode) -> String {
        let calendar = MWCalendar.getInstance()
        var ret = "";
        
        ret += WebQuery.SERVER_ADDR;
        ret += queryCode.rawValue;
        ret += "?User=\(BaseViewController.User.Code!)";
        ret += "&Year=\(calendar.year)";
        ret += "&Month=\(calendar.month)";
        ret += "&Day=\(calendar.day)";
        
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
        
        if result == nil {
            return QueryStatus.ERROR_Result_Parse;
        }
        
        if result != 1 {
            return QueryStatus.Service_Error;
        }
        
        if let dic = json["WeekInfo"] as! NSDictionary? {
            week.parse(dic)
        }
        
        if let dic = json["TodayInfo"] as! NSDictionary? {
            today.parse(dic)
        }
        
        return QueryStatus.Success;
    }
    
    typealias VoidMethod = (()->());
    typealias VoidError = ((QueryStatus) -> ());
    
    var successProc: VoidMethod?;
    var failProc: VoidError?;
    
    func SetSuccess(_ callback: VoidMethod?) {
        successProc = callback;
    }
    
    func SetFail(_ callback: VoidError?) {
        failProc = callback;
    }
    
    func OnQuerySuccess(_ queryCode: QueryCode) {
        //        if queryCode == QueryCode.LoginUser {
        //            MWNotification.postNotification(MWNotification.Etc.getLogin);
        //        }
        // 성공 콜백을 UI 스레드에서 실행
        DispatchQueue.main.async(execute: {
            () -> () in
            self.successProc?();
        })
    }
    
    func OnQueryFail(_ queryStatus: QueryStatus) {
        DispatchQueue.main.async(execute: {
            () -> () in
            self.failProc?(queryStatus);
        })
    }
    
    func executQuery(_ code: QueryCode, success: VoidMethod?, fail: VoidError?) {
        // 사용자 데이터베이스 처리에 성공한 경우 콜백 설정
        SetSuccess(success);
        SetFail(fail);
        // 웹 쿼리 실행
        let query = WebQuery(queryCode: code, request: self, response: self);
        query.start();
    }
}
