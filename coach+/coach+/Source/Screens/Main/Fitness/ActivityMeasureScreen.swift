//
//  ActivityMeasureScreen.swift
//  CoachPlus
//
//  Created by 양정은 on 2016. 7. 28..
//  Copyright © 2016년 Company Green Comm. All rights reserved.
//

import Foundation
import MiddleWare

class ActivityMeasureScreen: BaseViewController, BaseProtocol {
    fileprivate let datas = ActivityInfo()
    
    @IBAction func ButtonList(_ sender: UIBarButtonItem) {
        let query = WebQuery(queryCode: .ListExercise, request: datas, response: datas)
        query.start()
    }
    
    @IBOutlet var image_end: UIImageView!
    
    @IBOutlet var m_btn_start_end: UIButton!
    @IBOutlet var m_progressImage: UIImageView!
    @IBOutlet var image_main: UIImageView!
    //활동측정_01.png , 활동측정_02.png, 상단_이미지(이건 에셋 이미지)
    fileprivate var imageArray: [UIImage] = []
    
    fileprivate var isStart = false
    fileprivate var success = false
    
    fileprivate static var now: Date?
    
    fileprivate var isWait = false
    
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
    
    fileprivate func changeImageMain(_ imgMain: Bool) {
        image_main.isHidden = imgMain ? false : true
        image_end.isHidden = imgMain
        m_progressImage.isHidden = imgMain
    }
    
    @IBAction func m_buttonAction(_ sender: UIButton) {
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
        
        if Preference.PeripheralState != Int32(StatePeripheral.idle.rawValue) && Preference.PeripheralState != Int32(StatePeripheral.activity.rawValue) {
            showPopup(Common.ResString("state_not_idle"))
            return
        }
        
        let sql = SQLHelper.getInstance()
        
        if !isStart {
            changeImageMain(false)
            sender.setTitle(Common.ResString("measure_end"), for: UIControlState())
            startAnimation()
            
            setNavigationBar(false)
            
            Preference.PeripheralState = Int32(StatePeripheral.activity.rawValue)
            
            ActivityMeasureScreen.now = Date()
            let time = Int64(ActivityMeasureScreen.now!.timeIntervalSince1970 * 1000)
            _ = sql?.addIndexTime(Int32(BluetoothCommand.activity.rawValue), start_time: time)
            
            MiddleWare.sendActivityMeasure(true, time: time)
//            performSegue(withIdentifier: "SG_End_Measure", sender: nil)
            isStart = true
            //start button
        } else {
            changeImageMain(true)
            sender.setTitle(Common.ResString("measure_start"), for: UIControlState())
            
            setNavigationBar(true)
            
            Preference.PeripheralState = Int32(StatePeripheral.idle.rawValue)
            
            MiddleWare.sendActivityMeasure(false)
            
            let time = Int64(ActivityMeasureScreen.now!.timeIntervalSince1970 * 1000)
            let end_time = Int64(Date().timeIntervalSince1970 * 1000)
            
            _ = sql?.updateIndexTime(time, end_time: end_time)
            
            MiddleWare.sendActivityInfo(time)
            isStart = false
            //end button
        }
    }
    
    override func viewDidLoad() {
        MiddleWare.sendRequestState()
        
        datas.Label = CourseLabel.activity.rawValue
        datas.setSuccess(success)
        
        setImageViewProperty()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        TabBarCenter.selecter = self
        createDispatchforLoading()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        TabBarCenter.selecter = nil
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if Preference.PeripheralState == Int32(StatePeripheral.activity.rawValue) {
            // 첫화면인데, 상태는 활동 측정 시작 했음.
            loadData()
        }
    }
    
    fileprivate func setNavigationBar(_ enable: Bool) {
        navigationItem.rightBarButtonItem?.isEnabled = enable
    }
    
    @objc fileprivate func moveListScreen() {
        performSegue(withIdentifier: "SG_List_Measure", sender: nil)
    }
    
    fileprivate func setImageViewProperty() {
        let len = 5
        
        for i in 0...len {
            let imageName = String(format: "활동측정_측정_%02d.png", i)
            if let image = UIImage(named: imageName) {
                imageArray.append(image)
            }
        }
        
        m_progressImage.animationImages = imageArray
        m_progressImage.animationRepeatCount = 0
        m_progressImage.animationDuration = 6
        m_progressImage.image = imageArray[0]
    }
    
    fileprivate func dismissCallback() {
        if success {
            showPopup(Common.ResString("success_connect"))
        } else {
            showPopup(Common.ResString("fail_connect_device_confirm"))
        }
        isWait = false
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
        case MWNotification.Bluetooth.StatePeripheral:
            let state = MiddleWare.State
            if state == .activity && Preference.PeripheralState != Int32(StatePeripheral.activity.rawValue) {
                loadData()
            }
        case MWNotification.Bluetooth.ActivityInform:
            let sql = SQLHelper.getInstance()
            
            let act = MiddleWare.ActivityData
            let data = ActivityData(index: 0, label: CourseLabel.activity.rawValue, calorie: Double(act.act_calorie), start_date: 1, end_date: 2, intensityL: Int32(act.intensityL), intensityM: Int32(act.intensityM), intensityH: Int32(act.intensityH), intensityD: Int32(act.intensityD), maxHR: Int32(act.maxHR), minHR: Int32(act.minHR), avgHR: Int32(act.avgHR), upload: SQLHelper.NONSET_UPLOAD)
            
            let start_time = confirm(.activity, userInfo: notification.userInfo)
            if start_time != 0 {
                let sql_data = sql?.getIndexTime(start_time)
                data.StartDate = ((sql_data?.1)!/1000*1000)
                data.EndDate = ((sql_data?.2)!/1000*1000)
                
                let duplicate = sql?.getActivityData(start_time)
                if duplicate == nil {
                    _ = sql?.addConsume(data)
                }
                
                _ = sql?.deleteIndexTime((sql_data?.1)!)
                
                let Low = (1, act.intensityL)
                let Mid = (2, act.intensityM)
                let High = (3, act.intensityH)
                let Danger = (4, act.intensityD)
                let arr = [Low, Mid, High, Danger]
                let result = arr.sorted(by: {$0.1 > $1.1})
                
                Preference.ActivityState = Int32(result[0].0)
                
                if duplicate == nil {
                    let transfer = DataTransfer()
                    transfer.start()
                }
                
                moveToResultScreen()
            } else {
                showPopup(Common.ResString("error_measure"))
                return
            }
        default:
            break
        }
    }
    
    fileprivate func confirm(_ in_cmd: BluetoothCommand, userInfo: [AnyHashable: Any]?) -> Int64 {
        var cmd: BluetoothCommand = .activity
        var start_time: Int64 = 0
        
        if let dic = userInfo {
            if let dic_cmd = dic["cmd"] as? NSNumber {
                if let tmp = BluetoothCommand(rawValue: dic_cmd.uint16Value) {
                    cmd = tmp
                }
            }
            if let dic_start_time = dic["start_time"] as? NSNumber {
                start_time = dic_start_time.int64Value
            }
        }
        
        if in_cmd != cmd {
            return 0
        }
        
        return start_time
    }
    
    fileprivate func loadData() {
        isStart = true
        let sql = SQLHelper.getInstance()
        
        changeImageMain(false)
        m_btn_start_end.setTitle(Common.ResString("measure_end"), for: UIControlState())
        
        Preference.PeripheralState = Int32(StatePeripheral.activity.rawValue)
        
        let save_time = sql?.getIndexTime(BLCmdLabel: Int32(BluetoothCommand.activity.rawValue))
        ActivityMeasureScreen.now = Date(timeIntervalSince1970: Double((save_time?.1)!)/1000)
        
        setNavigationBar(false)
        startAnimation()
    }
    
    fileprivate func startAnimation() {
        if !m_progressImage.isAnimating {
            m_progressImage.startAnimating()
        }
    }
    
    func moveToResultScreen() {
        let date = NSNumber(value: Int64(ActivityMeasureScreen.now!.timeIntervalSince1970)*1000)
        print("date -> \(date)")
        performSegue(withIdentifier: "SG_Result_Measure", sender: date) // 날짜 정보를 전달해야함.
    }
    
    func success(_ queryCode: QueryCode) {
        DispatchQueue.main.async(execute: {
            () -> () in
            self.moveListScreen()
        })
    }
    
    func getCurrentChildViewController() -> UIViewController {
        return self
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "SG_Result_Measure" {
            if let dest = segue.destination as? ActivityResultScreen {
                if let date = sender as? NSNumber {
                    dest.m_start_date = date.int64Value
                }
            }
        }
    }
}
