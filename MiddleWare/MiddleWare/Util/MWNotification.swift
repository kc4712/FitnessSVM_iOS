//
//  MWNotification.swift
//  MiddleWare
//
//  Created by 양정은 on 2016. 3. 25..
//  Copyright © 2016년 그린콤 김영일. All rights reserved.
//

import Foundation

open class MWNotification {
    open class Bluetooth {
        open static let Battery = "Battery";
        open static let StepCountNCalorie = "StepCountNCalorie";
        open static let ActivityInform = "ActivityInform";
        open static let StressInform = "StressInform";
        open static let SleepInform = "SleepInform";
        open static let StatePeripheral = "StatePeripheral";
        
        
        //규창 ---  코치 노말 스트레스
        open static let NormalStressInform = "NormalStressInform"
        open static let NormalStressErrorInform = "NormalStressErrorInform"
        
        //규창 16.11.09 --- 펌웨어 업데이트 상태 정의
        open static let FirmUpFaild = "FirmUpFaild"
        open static let FirmUpComplete = "FirmUpComplete"
        open static let FirmUpProgress = "FirmUpProgress"
        
        
        /** 블루투스 장치 리스트 갱신 **/
        open static let GenerateScanList = "GenerateScanList";
        /** 블루투스 장치 스캔 종료 **/
        open static let EndOfScanList = "EndOfScanList";
        /** 블루투스 장치 연결 상태 갱신. */
        open static let RaiseConnectionState = "RaiseConnectionState";
        /** 블루투스 장치 접속 실패 알림. */
        open static let FailedConnection = "FailedConnection";
        /** 블루투스 데이터 동기화 **/
        open static let DataSync = "DataSync";
        /** 블루투스 펌웨어 버전 **/
        open static let FirmVersion = "FirmVersion";
        
        
        
        //규창 171023 피쳐 결과값 노티
        open static let FeatureDataError = "FeatureDataError";
        open static let FeatureDataComplete = "FeatureDataComplete";
        open static let PastFeatureDataComplete = "PastFeatureDataComplete";
        open static let PastFeatureDataALLComplete = "PastFeatureDataALLComplete";
    }
    
    open class Video {
        open static let TotalScore = "TotalScore"
        open static let MainUI = "MainUI"
        open static let TopComment = "TopComment"
        open static let BottomComment = "BottomComment"
        open static let HeartWarnning = "HeartWarnning"
        open static let ExerData = "ExerData"
        open static let ShowUI = "ShowUI"
    }
    
    class Etc {
        static let getLogin = "getLogin";
    }
    
    fileprivate var handler: (_ notification: Notification) -> () = { _ in }
    //private var handler: (notification: NSNotification) -> (boolean) = { (notification: NSNotification) in guard let noti =  notification.userInfo else {return false}; return noti["result"] as! boolean }
    
    //{ (notification: NSNotification) in if notification.userInfo != nil {return notification.userInfo!["result"] as! boolean}; return false }
    
    class func getInstance() -> MWNotification {
        return MWNotification()
    }
    
    func receiveNotification(_ name: String, selector: @escaping (_ notification: Notification) -> ()) {
        self.handler = selector;
        let nc = NotificationCenter.default;
        nc.addObserver(self, selector: #selector(MWNotification.process), name: NSNotification.Name(rawValue: name), object: nil);
    }
    
    func removeNotification() {
        let nc = NotificationCenter.default;
        nc.removeObserver(self);
    }
    
    @objc fileprivate func process(_ notification: Notification) {
        self.handler(notification);
    }
    
    open static func postNotification(_ name: String) {
        let nc = NotificationCenter.default;
        nc.post(name: Notification.Name(rawValue: name), object: nil);
    }
    
    static func postNotification(_ name: String, info: [String : AnyObject]) {
        let nc = NotificationCenter.default;
        nc.post(name: Notification.Name(rawValue: name), object: nil, userInfo: info);
    }
    
    static func getUserInfo<T>(_ notification: Notification) -> T? {
        guard let noti =  (notification as NSNotification).userInfo else {
            return nil
        }
        return noti["result"] as? T
    }
}
