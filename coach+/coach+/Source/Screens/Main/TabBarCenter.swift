//
//  TabBarCenter.swift
//  CoachPlus
//
//  Created by 양정은 on 2016. 8. 12..
//  Copyright © 2016년 Company Green Comm. All rights reserved.
//

import Foundation
import UIKit
import MiddleWare

class TabBarCenter: UITabBarController {
    static var selecter: BaseProtocol?
    
    fileprivate var alertController: UIAlertController?
    fileprivate var isStart = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("tabbar center viewDidLoad")
        
        BaseViewController.MainMode = true
        
        makeUpActivityData()
        BaseViewController.getTodayData()
        
        let transfer = DataTransfer()
        transfer.start()
        
        receiveNotification(MWNotification.Video.ExerData)
        receiveNotification(MWNotification.Bluetooth.Battery)
        receiveNotification(MWNotification.Bluetooth.GenerateScanList)
        receiveNotification(MWNotification.Bluetooth.EndOfScanList)
        receiveNotification(MWNotification.Bluetooth.FailedConnection)
        receiveNotification(MWNotification.Bluetooth.StepCountNCalorie)
        receiveNotification(MWNotification.Bluetooth.RaiseConnectionState)
        receiveNotification(MWNotification.Bluetooth.StressInform)
        receiveNotification(MWNotification.Bluetooth.SleepInform)
        receiveNotification(MWNotification.Bluetooth.ActivityInform)
        receiveNotification(MWNotification.Bluetooth.DataSync)
        receiveNotification(MWNotification.Bluetooth.StatePeripheral)
        receiveNotification(MWNotification.Bluetooth.FirmVersion)
        receiveNotification(MWNotification.Bluetooth.NormalStressInform)
        receiveNotification(MWNotification.Bluetooth.NormalStressErrorInform)
        receiveNotification(MWNotification.Bluetooth.FirmUpProgress)
        receiveNotification(MWNotification.Bluetooth.FirmUpFaild)
        receiveNotification(MWNotification.Bluetooth.FirmUpComplete)
        receiveNotification(MWNotification.Bluetooth.FeatureDataComplete)
        receiveNotification(MWNotification.Bluetooth.PastFeatureDataComplete)
        receiveNotification(MWNotification.Bluetooth.PastFeatureDataALLComplete)
    }
    
    fileprivate func receiveNotification(_ name: String) {
        let nc = NotificationCenter.default;
        nc.addObserver(self, selector: #selector(run), name: NSNotification.Name(rawValue: name), object: nil);
    }
    
    fileprivate func savePreference() {
        let mc = MWControlCenter.getInstance()
        
        if Int32(mc.Step) != Preference.MainStep {
            Preference.MainStep = Int32(mc.Step)
            let current = Int64((Date().timeIntervalSince1970 * 1000))
            
            let m_datas = StepInfo()
            m_datas.Reg = current
            m_datas.Step = Int32(mc.Step)
            
            let query = WebQuery(queryCode: .InsertStep, request: m_datas, response: m_datas)
            query.start()
        }
        
        Preference.MainCalorieActivity = Int32(mc.TotalActivityCalorie)
        Preference.MainCalorieCoach = Int32(mc.TotalCoachCalorie)
        Preference.MainCalorieSleep = Int32(mc.TotalSleepCalorie)
        Preference.MainCalorieDaily = Int32(mc.TotalDailyCalorie)
    }
    
    @objc fileprivate func run(_ notification: Notification) {
        if notification.name.rawValue == MWNotification.Bluetooth.StepCountNCalorie {
            savePreference()
        }
        relayNoti(notification)
        
        let noti = notification.name
        print("\(className) ########################### \(noti)")
        switch noti.rawValue {
        case MWNotification.Bluetooth.FirmVersion:
            //let firm = FirmInfo(version: mc.Version) // 밴드에서 항상 0.0.0.0 으로 오기 때문에 임시로 막았음.
            //let firm = FirmInfo(version: "0.0.1.1")
            let mc: MWControlCenter = MWControlCenter.getInstance()
            
            var firm:FirmInfo?
            
            if mc.getSelectedProduct() == .coach {
                //coach mini firmware C1_0.0.8.5.hex 쿼리
                //firm = FirmInfo(version: "0.0.1.1")
                firm = FirmInfo(version: mc.Version)
                firm?.setHandler(handler)
                let hex_firm = FirmInfo.NAME + "." + FirmInfo.EXTENTION_HEX
                if FileManager.isExistFile(hex_firm) {
                    print("펌웨어 파일 존재! -> HEX")
                    let url = FileManager.getUrlPath(hex_firm)
                    firm?.restartFirmUp(url)
                    return
                }
            }
            
            else if mc.getSelectedProduct() == .fitness {
                //coach+ firmware F1_1.0.1.2.hex 쿼리
                //firm = FirmInfo(version: "0.9.29.27")
                firm = FirmInfo(version: mc.Version)
                firm?.setHandler(handler)
                let zip_firm = FirmInfo.NAME + "." + FirmInfo.EXTENTION_ZIP
                if FileManager.isExistFile(zip_firm) {
                    print("펌웨어 파일 존재! -> ZIP")
                    let url = FileManager.getUrlPath(zip_firm)
                    firm?.restartFirmUp(url)
                    return
                }
            }
            
            // 펌웨어 업그레이드를 막으려면 이하 코드를 주석 처리하면 된다.
            if firm != nil {
                let query = WebQuery(queryCode: .CheckVersion, request: firm!, response: firm!)
                            query.start() // 기능 검증할때 주석 풀어서 사용.
            }
        case MWNotification.Video.ExerData:
            let sql = SQLHelper.getInstance()
            let mc = MWControlCenter.getInstance()
            
            let data = mc.ExerData
            
            let coach = CoachActivityData(index: 0, video_idx: Int32(data.videoID), video_full_count: Int32(data.video_full_count), exer_idx: Int32(data.exer_idx), exer_count: Int32(data.exer_count), start_time: data.start_time, end_time: data.end_time, consume_calorie: Int32(data.consume_calorie), count: Int32(data.count), count_percent: Int32(data.count_percent), perfect_count: Int32(data.perfect_count), min_accuracy: Int32(data.minAccuracy), max_accuracy: Int32(data.maxAccuracy), avg_accuracy: Int32(data.avgAccuracy), min_heartrate: Int32(data.minHeartRate), max_heartrate: Int32(data.maxHeartRate), avg_heartrate: Int32(data.avgHeartRate), cmp_heartrate: Int32(data.cmpHeartRate), point: Int32(data.point), reserv_1: 0, reserv_2: 0)
            
            _ = sql?.addConsume(coach)
        case MWNotification.Bluetooth.FirmUpComplete:
            dismissPopup()
            isStart = false
            popup(Common.ResString("success_firmup"), buttonCaption: Common.ResString("OK"))
        case MWNotification.Bluetooth.FirmUpFaild:
            dismissPopup()
            isStart = false
            popup(Common.ResString("failed_firmup"), buttonCaption: Common.ResString("OK"))
        case MWNotification.Bluetooth.FirmUpProgress:
            if !isStart {
                dismissPopup()
            }
            isStart = true
            let progress = notification.userInfo?["progress"] as! NSNumber
            let format = String(format: "%@\n%3d/100 (%%)", Common.ResString("firm_progress"), progress.intValue)
            if alertController == nil {
                popup(format, buttonCaption: nil)
            } else {
                updateMessage(format)
            }
        case MWNotification.Bluetooth.StatePeripheral:
            let sql = SQLHelper.getInstance()
            let mc = MWControlCenter.getInstance()
            
            if mc.State == .idle {
                Log.i("TabbarCenter idle Check", msg: "Preference.PeripheralState = \(Preference.PeripheralState)  Int32(StatePeripheral.idle.rawValue)=\(Int32(StatePeripheral.idle.rawValue))")
                Preference.PeripheralState = Int32(StatePeripheral.idle.rawValue)
                Log.i("TabbarCenter idle Check", msg: "Preference.PeripheralState = \(Preference.PeripheralState)  Int32(StatePeripheral.idle.rawValue)=\(Int32(StatePeripheral.idle.rawValue))")
                _ = sql?.deleteIndexTime()
            }
        default:
            break
        }
    }
    
    fileprivate func relayNoti(_ notification: Notification) {
        if let object = TabBarCenter.selecter {
            let vc = object.getCurrentChildViewController()
            print("relayNoti -> \(vc.className)")
            if let scName = ScreenName(rawValue: vc.className) {
                switch scName {
                case .FitnessHomeScreen:
                    let screen = vc as! FitnessHomeScreen
                    screen.run(notification)
                case .StepCountScreen:
                    let screen = vc as! StepCountScreen
                    screen.run(notification)
                case .TodayScreen:
                    let screen = vc as! TodayScreen
                    screen.run(notification)
                case .ActivityMeasureScreen:
                    let screen = vc as! ActivityMeasureScreen
                    screen.run(notification)
                case .SleepScreen:
                    let screen = vc as! SleepScreen
                    screen.run(notification)
                case .StressScreen:
                    let screen = vc as! StressScreen
                    screen.run(notification)
                case .DeviceManager:
                    let screen = vc as! DeviceManager
                    screen.run(notification)
                case .SelectDevice:
                    let screen = vc as! SelectDevice
                    screen.run(notification)
                case .SelectExercise:
                    let screen = vc as! SelectExercise
                    screen.run(notification)
                    //규창 171026 피처 상세 그래프 추가
                case .PLGraphDetailScreen:
                    let screen = vc as! PLGraphDetailScreen
                    screen.run(notification)
                case .HomeTabScreen:
                    break
                }
            }
        }
    }
    
    fileprivate func handler(_ success: Bool) {
        if success {
            // firm start...
            dismissPopup()
            popup(Common.ResString("start_firm_warnning"), buttonCaption: nil)
            Preference.removeForFirmUp()
            let sql = SQLHelper.getInstance()
            _ = sql?.deleteIndexTime()
            
            if let object = TabBarCenter.selecter {
                let vc = object.getCurrentChildViewController()
                if vc.className == "FitnessHomeScreen" {
                    let screen = vc as! FitnessHomeScreen
                    screen.reloadSleep()
                    screen.reloadStress()
                    screen.reloadActivity()
                }
            }
        }
    }
    
    fileprivate func popup(_ msg: String, buttonCaption: String?) {
        if buttonCaption != nil {
            showMessage(nil, message: msg, buttonCaption: buttonCaption!, viewController: self)
        } else {
            showMessage(nil, message: msg, viewController: self)
        }
    }
    
    fileprivate func dismissPopup() {
        if alertController == nil {
            return
        }
        alertController?.dismiss(animated: true, completion: nil)
        alertController = nil
    }
    
    fileprivate func updateMessage(_ message: String) {
        alertController?.message = message
    }
    
    fileprivate func showMessage(_ title: String?, message: String, buttonCaption: String, viewController: UIViewController,
                     callback: (() -> ())? = nil) {
        if alertController != nil {
            return
        }
        alertController = UIAlertController(
            title: title,
            message: message,
            preferredStyle: UIAlertControllerStyle.alert);
        
        let confirmAction = UIAlertAction(title: buttonCaption, style: UIAlertActionStyle.default) {
            (action) in
            self.alertController = nil
            if callback != nil {
                callback!()
            }
        }
        
        alertController!.addAction(confirmAction);
        viewController.present(alertController!, animated: true, completion: nil);
    }
    
    fileprivate func showMessage(_ title: String?, message: String, viewController: UIViewController,
                                 callback: (() -> ())? = nil) {
        if alertController != nil {
            return
        }
        alertController = UIAlertController(
            title: title,
            message: message,
            preferredStyle: UIAlertControllerStyle.alert);
        
        viewController.present(alertController!, animated: true, completion: nil);
    }
    
    fileprivate func makeUpActivityData() {
        let sql = SQLHelper.getInstance()
        if let datas = sql?.getActivityData() {
            let milli_week: Int64 = 86400000 * 7
            
            let calendar = MWCalendar.getInstance()
            let today = calendar.getTimeInMillis()
            for data in datas {
                let diff = today - data.StartDate
                if diff > milli_week {
                    _ = sql?.deleteActivityData(data.Index)
                }
            }
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        print("tabbar center viewDidAppear")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print("tabbar center viewWillAppear")
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        print("tabbar center viewWillDisappear")
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        let nc = NotificationCenter.default;
        nc.removeObserver(self)
    }
}
