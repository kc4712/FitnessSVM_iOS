//
//  CommSender.swift
//  MiddleWare
//
//  Created by 양정은 on 2016. 8. 10..
//  Copyright © 2016년 심규창. All rights reserved.
//

import Foundation

private let obj = CommSender()

public typealias BLSender = (cmd: BluetoothCommand, time: Int64, action: RequestAction, resp: Bool, index: NoticeIndex)
public typealias BLSender2 = (cmd: BluetoothCommand, firsttime: Int64, lasttime: Int64, action: RequestAction, resp: Bool, index: NoticeIndex)

class CommSender: NSObject {
    fileprivate static let tag = String(describing: CommSender.self)
    
    fileprivate var m_thread: Thread?
    fileprivate static var busy = false
    
    fileprivate var isTimerCancel = false
    
    fileprivate var m_is_rdy = false
    var isReady: Bool {
        get {
            return m_is_rdy
        }
        set {
            m_is_rdy = newValue
        }
    }
    
    fileprivate var isSync = false
    
    fileprivate var mTimer: Timer?
//    private var TimeOut = MWTimer()
    fileprivate var m_timeout: TimeInterval = 3000
    
    fileprivate var mBle: BluetoothLEManager?
    
    // 규창 17.03.16 밴드 응답없음 현상 발생시 연결해제 후 재 연결!!!!!
    fileprivate var mEmergencyCnt:Int32
    
    
    
    fileprivate var m_lastSender: BLSender = (.acc, 0, .start, false, .phone)
    var LastSender: BLSender {
        get {
            return m_lastSender
        }
        set {
            m_lastSender = newValue
        }
    }
    
    fileprivate var Queue: [BLSender] = []
    
    fileprivate static var runFlag = false
    static var isRun: Bool {
        return runFlag
    }
    
    var isBusy: Bool {
        if Queue.count > 0 {
            return true
        }
        return false
    }
    
    fileprivate override init() {
        mEmergencyCnt = 0;
        super.init()
    }
    
    class func getInstance() -> CommSender {
        return obj
    }
    
    func cancelTimer() {
        isTimerCancel = true
        print("cancelTimer")
        if mTimer != nil {
            mTimer?.invalidate()
            mTimer = nil
        }
    }
    
    @objc func process() {
        if isTimerCancel {
            print("is timer cancel....")
            return
        }
        print("go Timer!!!!")
        CommSender.busy = false
        if Queue.count > 0 {
            Queue.removeFirst()
        }
    }
    
    func append(_ data: BLSender) {
        if !checkDuplicate(data) {
            Queue.append(data)
            print("append!!!! Q size->\(Queue.count) cmd->\(data.cmd)")
        }
    }
    
    fileprivate func checkDuplicate(_ data: BLSender) -> Bool {
        for dat in Queue {
            if dat == data {
                return true
            }
        }
        
        return false
    }
    
    func start() {
        print("start")
        CommSender.runFlag = true
        CommSender.busy = false
        if m_thread == nil {
            m_thread = Thread(target: self, selector: #selector(run), object: nil)
            m_thread?.start()
        }
    }
    
    func cancel() {
        print("cancel")
        notifySync(false)
        cancelTimer()
        Queue.removeAll()
        CommSender.runFlag = false
        CommSender.busy = false
        m_thread?.cancel()
        m_thread = nil
    }
    
    //규창 16.12.27 강제 동기화
    //fileprivate func notifySync(_ sync: Bool) {
    func notifySync(_ sync: Bool) {
        if isSync != sync {
            MWNotification.postNotification(MWNotification.Bluetooth.DataSync, info: [MWNotification.Bluetooth.DataSync:sync as AnyObject])
            isSync = sync
        }
    }
    
    @objc fileprivate func run() {
        print("RUN!!")
        mBle = BluetoothLEManager.getInstance()
        
        while !Thread.current.isCancelled {
            if !isReady {
                Thread.sleep(forTimeInterval: 0.05)
                continue
            }
            //print("1 -> Q count->\(Queue.count)")
            if mBle!.getConnectionState() == .state_DISCONNECTED {
                Thread.sleep(forTimeInterval: 1)
                continue
            }
//            print("2")
            if Queue.count < 1 {
                notifySync(false)
                Thread.sleep(forTimeInterval: 0.05)
                continue
            }
            print("3 LastSender.resp:\(LastSender.resp) CommSender.busy:\(CommSender.busy) LastSender.cmd \(LastSender.cmd)")
            
            if CommSender.busy {
                
                print("4")
                if LastSender.resp {
                    // 규창 17.03.16 밴드 응답없음 현상 회피 루틴 추가
                    if let nowLastSenderCmd = Queue.last?.cmd {
                        if nowLastSenderCmd != LastSender.cmd {
                            mEmergencyCnt += 1
                            Log.i(CommSender.tag, msg:"응답없음 횟수 \(mEmergencyCnt) [\(nowLastSenderCmd)] [\(LastSender.cmd)]")
                            if mEmergencyCnt > 100 {
                                mBle?.emergencyReconnect()
                                mEmergencyCnt = 0
                            }
                        }else {
                            mEmergencyCnt += 1
                            Log.i(CommSender.tag, msg:"응답없음 횟수 \(mEmergencyCnt) [\(nowLastSenderCmd)] [\(LastSender.cmd)]")
                            if mEmergencyCnt > 100 {
                                mBle?.emergencyReconnect()
                                mEmergencyCnt = 0
                            }
                        }
                    } else {
                        mEmergencyCnt = 0
                        Log.i(CommSender.tag, msg:"큐에 쌓인 명령어 없어서 초기화 \(mEmergencyCnt) [\(LastSender.cmd)]")
                    }
                    
                    
                    
                    print("5")
                    Thread.sleep(forTimeInterval: 0.05)
                    continue
                }
                cancelTimer()
                if Queue.count != 0 {
                    Queue.removeFirst()
                }
                
                CommSender.busy = false
                continue
            }
            print("6")
            CommSender.busy = true
            notifySync(true)
            
            cancelTimer()
            // 메인 쓰레드가 아닌 타이머는 루프에 추가해야 돌아감.
            DispatchQueue.main.async(execute: {
                self.mTimer = Timer.scheduledTimer(timeInterval: self.m_timeout/1000, target: self, selector: #selector(self.process), userInfo: nil, repeats: false)
            })
            isTimerCancel = false
            
            print("7")
            if let msg = Queue.first {
                LastSender = msg
                sendBluetoothCmd(LastSender.0, action: LastSender.2, time: LastSender.1, index: LastSender.4)
                print("8 cmd->\(LastSender.cmd)")
            }
            print("9")
            //0.05
            Thread.sleep(forTimeInterval: 0.05)
        }
        print("stop......................")
    }
    
    func compare(_ cmd: BluetoothCommand) -> Bool {
        return CommSender.busy && LastSender.resp ? cmd == LastSender.0 : false
    }
    
    func resetBusy() {
        print("resetBusy")
        if Queue.count > 0 {
            Queue.removeFirst()
        }
        
        // 규창 17.03.16 밴드 응답없음 현상 회피 카운트 초기화
        mEmergencyCnt = 0
        cancelTimer()

        CommSender.busy = false
    }
    
    fileprivate func sendBluetoothCmd(_ cmd: BluetoothCommand, action: RequestAction = .start, time: Int64 = 0, index: NoticeIndex = .empty) {
        // Int64(NSDate().timeIntervalSince1970)*1000
        if mBle!.getConnectionState() == .state_DISCONNECTED {
            return
        }
        
        let product = DeviceBaseScan.SELECTED_DEVICE_NAME
        
        switch cmd {
        case .state:
            mBle!.requestState()
        case .activity:
            mBle!.requestActivity(action, time: time)
        case .stepCount_Calorie:
            Log.i(CommSender.tag, msg:"칼로리랑 요청했다치고...")
            mBle!.requestStepCount_Calorie(time) // 해당 날의 총 스탭수를 줌.
        case .battery:
            if product == ProductCode.fitness.bluetoothDeviceName {
                mBle!.requestBattery()
            } else if product == ProductCode.coach.bluetoothDeviceName {
                mBle!.requestBatteryProductCoach()
            }
        case .acc:
            if product == ProductCode.fitness.bluetoothDeviceName {
                mBle!.requestAcc(action)
            } else if product == ProductCode.coach.bluetoothDeviceName {
                mBle!.requestAcc(ProductCoach: action)
            }
        case .userData:
            mBle!.sendUserData()
        case .rtc:
            mBle!.sendRTC()
        case .sleep:
            mBle!.requestSleep(action, time: time)
        case .stress:
            mBle!.requestStress(action, time: time)
        case .version:
            if product == ProductCode.fitness.bluetoothDeviceName {
                mBle!.requestVersion()
            } else if product == ProductCode.coach.bluetoothDeviceName {
                mBle!.requestVersionProductCoach()
            }
        case .coachCalorie:
            mBle!.sendCalorie(IntCalorie: Int(time))
        case .noticeONOFF:
            mBle!.sendNoticeONOFF(action,  index: index)
        default:
            break
        }
    }
    
    
    
    //규창 171030 이전 피쳐 요구로 인한 명령문 추가
    fileprivate func sendBluetoothCmd(_ cmd: BluetoothCommand, action: RequestAction = .start, firsttime: Int64 = 0, lasttime: Int64 = 0, index: NoticeIndex = .empty) {
        // Int64(NSDate().timeIntervalSince1970)*1000
        if mBle!.getConnectionState() == .state_DISCONNECTED {
            return
        }
        
        let product = DeviceBaseScan.SELECTED_DEVICE_NAME
        
        switch cmd {
        case .pastFeatureRequest:
            mBle!.sendpastFeatureRequest(reqtimeFirst: firsttime, reqtimeLast: lasttime)
        default:
            break
        }
    }
}
