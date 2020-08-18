//
//  TimerBase.swift
//  Swift_MW_AART
//
//  Created by 양정은 on 2016. 6. 30..
//  Copyright © 2016년 심규창. All rights reserved.
//

import Foundation
import CoreBluetooth

class TimerBase: DataControlBase {
    fileprivate static let tag = TimerBase.className
    var mBluetoothDeviceName: String?
    
    fileprivate let PERIOD: TimeInterval = 60000
    fileprivate let TIMER_SCAN_DELAY = 0
    fileprivate let TIMER_SCAN_PERIOD: TimeInterval = 5000
    
    fileprivate static let SIZE_RSSI_Q = 10;
    fileprivate var rssi_Q = [NSNumber](repeating: 0, count: SIZE_RSSI_Q);
    
    let sender = CommSender.getInstance()
    
    fileprivate var BatteryTimer: MWTimer?
    fileprivate var StepCalorieTimer: MWTimer?
    fileprivate var StressTimer: MWTimer?
    fileprivate var ActivityTimer: MWTimer?
    fileprivate var SleepTimer: MWTimer?
    fileprivate var StateTimer: MWTimer?
    fileprivate var m_timer_scan: MWTimer?
    fileprivate var mRssi_Timer: MWTimer?
    fileprivate var VersionTimer: MWTimer?
    fileprivate var mTimerConnect: MWTimer?
    fileprivate var RTCTimer: MWTimer?
    fileprivate var UserInfoTimer: MWTimer?
    
    func tryBluetooth() -> Int32 {return 0;}
    func startBluetooth() -> Int32 {return 0;}
    func setIsLiveApp(_ isLiveApp: Bool) {}
    
    /** Set 하면 자동 cancel **/
    var GetBatteryTimer: MWTimer {
        set {
            if BatteryTimer != nil {
                BatteryTimer!.cancel()
            }
            BatteryTimer = newValue
        }
        
        get {
            if BatteryTimer != nil {
                BatteryTimer!.cancel()
            } else {
                BatteryTimer = MWTimer()
            }
            
            
            BatteryTimer!.setRun() {
                if self.discoveredPeripheral == nil || self.discoveredPeripheral?.state != CBPeripheralState.connected {
                    return
                }
                
                self.requestBattery()
            }
            
            return BatteryTimer!
        }
    }
    
    var GetVersionTimer: MWTimer {
        set {
            if VersionTimer != nil {
                VersionTimer!.cancel()
            }
            VersionTimer = newValue
        }
        
        get {
            if VersionTimer != nil {
                VersionTimer!.cancel()
            } else {
                VersionTimer = MWTimer()
            }
            
            VersionTimer!.setRun() {
                if self.discoveredPeripheral == nil || self.discoveredPeripheral?.state != CBPeripheralState.connected {
                    return
                }
                
                self.requestVersion()
            }
            
            return VersionTimer!
        }
    }
    
    var GetStepCalorieTimer: MWTimer {
        set {
            if StepCalorieTimer != nil {
                StepCalorieTimer!.cancel()
            }
            StepCalorieTimer = newValue
        }
        
        get {
            if StepCalorieTimer != nil {
                StepCalorieTimer!.cancel()
            } else {
                StepCalorieTimer = MWTimer()
            }
            
            StepCalorieTimer!.setRun() {
                if self.discoveredPeripheral == nil || self.discoveredPeripheral?.state != CBPeripheralState.connected {
                    return
                }
                
//                self.requestStepCount_Calorie(MWCalendar.currentTimeMillis())
                //규창 171027 피쳐 동기화 플래그.... 
                if MWControlCenter.getInstance().getStateFeatureSync() == false {
                    self.sender.append((.stepCount_Calorie, MWCalendar.currentTimeMillis(), .start, true, .empty))
                }
            }
            
            return StepCalorieTimer!
        }
    }
    
    var GetStressTimer: MWTimer {
        set {
            if StressTimer != nil {
                StressTimer!.cancel()
            }
            StressTimer = newValue
        }
        
        get {
            if StressTimer != nil {
                StressTimer!.cancel()
            } else {
                StressTimer = MWTimer()
            }
            
            StressTimer!.setRun() {
                if self.discoveredPeripheral == nil || self.discoveredPeripheral?.state != CBPeripheralState.connected {
                    return
                }
                
                self.requestStress(RequestAction.inform, time: MWCalendar.currentTimeMillis())
            }
            
            return StressTimer!
        }
    }
    
    var GetRTCTimer: MWTimer {
        set {
            if RTCTimer != nil {
                RTCTimer!.cancel()
            }
            RTCTimer = newValue
        }
        
        get {
            if RTCTimer != nil {
                RTCTimer!.cancel()
            } else {
                RTCTimer = MWTimer()
            }
            
            RTCTimer!.setRun() {
                if self.discoveredPeripheral == nil || self.discoveredPeripheral?.state != CBPeripheralState.connected {
                    return
                }
                
                self.sendRTC()
            }
            
            return RTCTimer!
        }
    }
    
    var GetActivityTimer: MWTimer {
        set {
            if ActivityTimer != nil {
                ActivityTimer!.cancel()
            }
            ActivityTimer = newValue
        }
        
        get {
            if ActivityTimer != nil {
                ActivityTimer!.cancel()
            } else {
                ActivityTimer = MWTimer()
            }
            
            ActivityTimer!.setRun() {
                if self.discoveredPeripheral == nil || self.discoveredPeripheral?.state != CBPeripheralState.connected {
                    return
                }
                
                self.requestActivity(RequestAction.inform, time: MWCalendar.currentTimeMillis())
            }
            
            return ActivityTimer!
        }
    }
    
    var GetSleepTimer: MWTimer {
        set {
            if SleepTimer != nil {
                SleepTimer!.cancel()
            }
            SleepTimer = newValue
        }
        
        get {
            if SleepTimer != nil {
                SleepTimer!.cancel()
            } else {
                SleepTimer = MWTimer()
            }
            
            SleepTimer!.setRun() {
                if self.discoveredPeripheral == nil || self.discoveredPeripheral?.state != CBPeripheralState.connected {
                    return
                }
                
                self.requestSleep(RequestAction.inform, time: MWCalendar.currentTimeMillis())
            }
            
            return SleepTimer!
        }
    }
    
    var GetStateTimer: MWTimer {
        set {
            if StateTimer != nil {
                StateTimer!.cancel()
            }
            StateTimer = newValue
        }
        
        get {
            if StateTimer != nil {
                StateTimer!.cancel()
            } else {
                StateTimer = MWTimer()
            }
            
            StateTimer!.setRun() {
                if self.discoveredPeripheral == nil || self.discoveredPeripheral?.state != CBPeripheralState.connected {
                    return
                }
                
                self.requestState()
            }
            
            return StateTimer!
        }
    }
    
    var GetUserInfoTimer: MWTimer {
        set {
            if UserInfoTimer != nil {
                UserInfoTimer!.cancel()
            }
            UserInfoTimer = newValue
        }
        
        get {
            if UserInfoTimer != nil {
                UserInfoTimer!.cancel()
            } else {
                UserInfoTimer = MWTimer()
            }
            
            UserInfoTimer!.setRun() {
                if self.discoveredPeripheral == nil || self.discoveredPeripheral?.state != CBPeripheralState.connected {
                    return
                }
                
                self.sendUserData()
            }
            
            return UserInfoTimer!
        }
    }

    override func startScanTimer() {
        if m_timer_scan != nil {return;}
        
        // 동작하지 않는 코드라면 밖으로 빼서 단독 메서드로 만들어야함
        func run() {
            //Log.i(tag,"ble connection state:"+mConnectionState);
            if isConnect() == false {
                //queue.clear();
                if mScanning == false {
                    //Log.d(TimerBase.tag, msg: "scanLe start!!!!!!!!!");
                    scanLeDevice(true);
                }
            } else {
                cancelScanTimer();
            }
        }
        
        m_timer_scan = MWTimer();
        m_timer_scan?.start(TIMER_SCAN_PERIOD, repeats: true) {
            run();
        }
    }
    
    override func cancelScanTimer() {
        if m_timer_scan != nil {
            m_timer_scan?.cancel();
            m_timer_scan = nil;
        }
    }
    
//    func startBatteryTimer() {
//        if BatteryTimer != nil {
//            return
//        }
//        
//        BatteryTimer!.start(PERIOD, repeats: false) {
//            if self.discoveredPeripheral == nil || self.discoveredPeripheral?.state != CBPeripheralState.Connected {
//                return
//            }
//            
//            self.requestBattery()
//        }
//    }
//    
//    func cancelBatteryTimer() {
//        BatteryTimer?.cancel()
//    }
//    
//    func startStepTimer() {
//        if StepTimer != nil {
//            return
//        }
//        
//        StepTimer!.start(PERIOD, repeats: false) {
//            if self.discoveredPeripheral == nil || self.discoveredPeripheral?.state != CBPeripheralState.Connected {
//                return
//            }
//            
//            self.requestStepCount(MWCalendar.currentTimeMillis())
//        }
//    }
//    
//    func cancelStepTimer() {
//        StepTimer?.cancel()
//    }
//    
//    func startCalorieTimer() {
//        if CalorieTimer != nil {
//            return
//        }
//        
//        CalorieTimer!.start(PERIOD, repeats: false) {
//            if self.discoveredPeripheral == nil || self.discoveredPeripheral?.state != CBPeripheralState.Connected {
//                return
//            }
//            
//            self.requestCalorie(MWCalendar.currentTimeMillis())
//        }
//    }
//    
//    func cancelCalorieTimer() {
//        CalorieTimer?.cancel()
//    }
//    
//    func startStressTimer() {
//        if StressTimer != nil {
//            return
//        }
//        
//        StressTimer!.start(PERIOD, repeats: false) {
//            if self.discoveredPeripheral == nil || self.discoveredPeripheral?.state != CBPeripheralState.Connected {
//                return
//            }
//            
//            self.requestStress(RequestAction.Inform)
//        }
//    }
//    
//    func cancelStressTimer() {
//        StressTimer?.cancel()
//    }
//    
//    func startSleepTimer() {
//        if SleepTimer != nil {
//            return
//        }
//        
//        SleepTimer!.start(PERIOD, repeats: false) {
//            if self.discoveredPeripheral == nil || self.discoveredPeripheral?.state != CBPeripheralState.Connected {
//                return
//            }
//            
//            self.self.requestSleep(RequestAction.Inform)
//        }
//    }
//    
//    func cancelSleepTimer() {
//        SleepTimer?.cancel()
//    }
//    
    func startRssiTimer() {
        if mRssi_Timer != nil {return;}
        
        // 동작하지 않는 코드라면 밖으로 빼서 단독 메서드로 만들어야함
        func run() {
            if discoveredPeripheral != nil && discoveredPeripheral!.state == CBPeripheralState.connected {
                discoveredPeripheral?.readRSSI();
            }
        }
        
        mRssi_Timer = MWTimer();
        mRssi_Timer?.start(1000, repeats: true) {
            run();
        }
    }
    
    func cancelRssiTimer() {
        if mRssi_Timer != nil {
            mRssi_Timer?.cancel();
            mRssi_Timer = nil;
        }
        
        for i in 0..<rssi_Q.count {
            rssi_Q[i] = 0;
        }
    }
    
    func isRssiDisconnect(_ rssi: NSNumber) -> Bool {
        let sum = getRssi(rssi);
        if sum != 0 && sum < DEF_RSSI.int32Value {
            return true;
        }
        
        return false;
    }
    
    func getRssi(_ rssi: NSNumber) -> Int32 {
        var ret: Int32 = 0, count: Int32 = 0;
        for i in 0  ..< TimerBase.SIZE_RSSI_Q-1 {
            rssi_Q[i] = rssi_Q[i+1];
        }
        rssi_Q[TimerBase.SIZE_RSSI_Q-1] = rssi;
        
        for i in rssi_Q {
            if i != 0 {
                ret += i.int32Value;
                count += 1;
            }
        }
        
        if count != 10 {
            return 0;
        }
        
        return ret/count;
    }
    
    func startConnectTimer() {
        if mTimerConnect != nil {return;}
        
        // 동작하지 않는 코드라면 밖으로 빼서 단독 메서드로 만들어야함
        func run() {
            Log.d(TimerBase.tag, msg: "Connect-Timer...");
            if !pB.isLiveApp() {
                return;
            }
            
            if !isConnect() {
                if discoveredPeripheral?.state == CBPeripheralState.connected { // explicit enum required to compile here?
                    centralManager!.cancelPeripheralConnection(discoveredPeripheral!);
                    
                    discoveredPeripheral = nil;
                    m_Characteristic = nil;
                    mBluetoothDeviceName = nil;
                }
                
                Log.d(TimerBase.tag, msg: "Connect-Timer...->scan");
                scanLeDevice(true);
            }
        }
        
        mTimerConnect = MWTimer();
        mTimerConnect?.start(60000, period: 60000) {
            run();
        }
    }
    
    func cancelConnectTimer() {
        if mTimerConnect != nil {
            mTimerConnect?.cancel();
            mTimerConnect = nil;
        }
    }
}
