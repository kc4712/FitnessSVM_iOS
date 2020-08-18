//
//  SleepScreen.swift
//  CoachPlus
//
//  Created by 양정은 on 2016. 7. 29..
//  Copyright © 2016년 Company Green Comm. All rights reserved.
//

import Foundation
import MiddleWare

class SleepScreen: BaseViewController, BaseProtocol {
    
    @IBOutlet var m_State: UILabel!
    @IBOutlet var m_TotalSleepTime: UILabel!
    @IBOutlet var m_RolledCount: UILabel!
    @IBOutlet var m_AwakenCount: UILabel!
    @IBOutlet var m_Heartrate: UILabel!
    
    
    // fileprivate let mc: MWControlCenter = MWControlCenter.getInstance()
    fileprivate var isStart = false
    
    fileprivate var now: Date?
    
    fileprivate var isWait = false
    fileprivate var success = false
    
    fileprivate var mDispatchQ: DispatchQueue?
    fileprivate var mDispatchWorkItem: DispatchWorkItem?
    
    fileprivate func createDispatchforLoading() {
        mDispatchQ = DispatchQueue.global(qos: .background)
        mDispatchWorkItem = DispatchWorkItem {
            self.success = self.MiddleWare.getConnectionState() == .state_DISCONNECTED ? false : true
            self.dismissLoadingPopup(self.dismissCallback)
        }
    }
    
    fileprivate func cancelDispatch() {
        if mDispatchQ != nil && mDispatchWorkItem != nil {
            mDispatchWorkItem?.cancel()
        }
    }
    
    fileprivate func dismissCallback() {
        if success {
            showPopup(Common.ResString("success_connect"))
        } else {
            showPopup(Common.ResString("fail_connect_device_confirm"))
        }
        isWait = false
    }
    
    @IBOutlet var m_ButtonOutlet: UIButton!
    @IBAction func m_ButtonAction(_ sender: UIButton) {
        if MiddleWare.getConnectionState() == ConnectStatus.state_DISCONNECTED {
            MiddleWare.tryConnectionBluetooth()
            showLoadingPopup(Common.ResString("connecting_device"))
            isWait = true
            if mDispatchQ != nil && mDispatchWorkItem != nil {
                let popTime = DispatchTime.now() + Double(Int64(4 * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)
                mDispatchQ?.asyncAfter(deadline: popTime, execute: mDispatchWorkItem!)
            }
            return
        }
        
        if MiddleWare.isBusySender {
            showPopup(Common.ResString("device_initial_wating"))
            return
        }
        
        if Preference.PeripheralState != Int32(StatePeripheral.idle.rawValue) && Preference.PeripheralState != Int32(StatePeripheral.sleep.rawValue) {
            showPopup(Common.ResString("state_not_idle"))
            return
        }
        
        let sql = SQLHelper.getInstance()
        
        if !isStart {
//            sender.setBackgroundImage(UIImage(named: "버튼_02.png"), for: UIControlState())
            sender.setTitle(Common.ResString("measure_end"), for: UIControlState())
            
            Preference.PeripheralState = Int32(StatePeripheral.sleep.rawValue)
            
            now = Date()
            let time = Int64(now!.timeIntervalSince1970 * 1000)
            _ = sql?.addIndexTime(Int32(BluetoothCommand.sleep.rawValue), start_time: time)
            
            MiddleWare.sendSleepMeasure(true, time: time)
            isStart = true
        } else {
//            sender.setBackgroundImage(UIImage(named: "버튼_01.png"), for: UIControlState())
            sender.setTitle(Common.ResString("measure_start"), for: UIControlState())
//            let interval = now?.timeIntervalSinceDate(NSDate())
//            m_TotalSleepTime.text = String(Int(-interval!) / 60)
            
            Preference.PeripheralState = Int32(StatePeripheral.idle.rawValue)
            
            MiddleWare.sendSleepMeasure(false)
            
            let time = Int64(now!.timeIntervalSince1970 * 1000)
            let end_time = Int64(Date().timeIntervalSince1970 * 1000)
            
            _ = sql?.updateIndexTime(time, end_time: end_time)
            print("sleep 1 end:\(end_time) start:\(time)")
            
            let save_time = sql?.getIndexTime(BLCmdLabel: Int32(BluetoothCommand.sleep.rawValue))
            print("sleep get end:\(String(describing: save_time?.2)) start:\(String(describing: save_time?.1))")
            
            MiddleWare.sendSleepInfo(time)
            isStart = false
        }
    }
    
    override func viewDidLoad() {
        MiddleWare.sendRequestState()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        createDispatchforLoading()
        TabBarCenter.selecter = self
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        TabBarCenter.selecter = nil
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if Preference.PeripheralState == Int32(StatePeripheral.sleep.rawValue) {
            // 첫화면인데, 상태는 수면 시작 했음.
            loadData()
        }
        if let idfier = SleepIdentifier(rawValue: Int16(Preference.SleepState)) {
            m_State.text = idfier.toString
            m_State.textColor = idfier.getColor
            m_TotalSleepTime.text = String(Preference.SleepTime)
            m_RolledCount.text = String(Preference.SleepRolled)
            m_AwakenCount.text = String(Preference.SleepAwaken)
            m_Heartrate.text = String(Preference.SleepStabilityHR)
        }
    }
    
    fileprivate func loadData() {
        let sql = SQLHelper.getInstance()
        
        let save_time = sql?.getIndexTime(BLCmdLabel: Int32(BluetoothCommand.sleep.rawValue))
        now = Date(timeIntervalSince1970: Double((save_time?.1)!)/1000)
        
//        m_ButtonOutlet.setBackgroundImage(UIImage(named: "버튼_02.png"), for: UIControlState())
        m_ButtonOutlet.setTitle(Common.ResString("measure_end"), for: UIControlState())
        
        Preference.PeripheralState = Int32(StatePeripheral.sleep.rawValue)
        
        isStart = true
    }
    
    func run(_ notification: Notification) {
        print("\(className) ************************ \(notification.name)")
        switch notification.name.rawValue {
        case MWNotification.Bluetooth.RaiseConnectionState:
            if isWait {
                if MiddleWare.getConnectionState() == .state_CONNECTED {
                    cancelDispatch()
                    createDispatchforLoading()
                    success = true
                    dismissLoadingPopup(dismissCallback)
                    return
                }
            }
        case MWNotification.Bluetooth.SleepInform:
            if !isStart {
                let sql = SQLHelper.getInstance()
                
                let save_time = sql?.getIndexTime(BLCmdLabel: Int32(BluetoothCommand.sleep.rawValue))
                now = Date(timeIntervalSince1970: Double((save_time?.1)!)/1000)
                _ = sql?.deleteIndexTime((save_time?.1)!)
                
                let sleep = MiddleWare.SleepData
                if sleep.stabilityHR == 0 {
                    showPopup(Common.ResString("error_measure"))
                    return
                }
                let interval = ((save_time?.2)! - (save_time?.1)!) / Int64(60000)
                print("sleep 2 end:\(String(describing: save_time?.2)) start:\(String(describing: save_time?.1))")
                
                let idfier = Common.getSleepCalc(Int64(interval))
                m_State.text = idfier.toString
                m_State.textColor = idfier.getColor
                m_TotalSleepTime.text = String(interval)
                m_RolledCount.text = String(sleep.rolled)
                m_AwakenCount.text = String(sleep.awaken)
                m_Heartrate.text = String(sleep.stabilityHR)
                
                Preference.SleepState = Int32(idfier.rawValue) // 현재 값을 산출하는 공식이 정해지지 않음.
                Preference.SleepTime = Int32(interval)
                Preference.SleepAwaken = Int32(sleep.awaken)
                Preference.SleepRolled = Int32(sleep.rolled)
                Preference.SleepStabilityHR = Int32(sleep.stabilityHR)
            }
        case MWNotification.Bluetooth.StatePeripheral:
            let state = MiddleWare.State
            if state == .sleep && Preference.PeripheralState != Int32(StatePeripheral.sleep.rawValue) {
                loadData()
            }
        default:
            break
        }
    }
    
    func getCurrentChildViewController() -> UIViewController {
        return self
    }
}
