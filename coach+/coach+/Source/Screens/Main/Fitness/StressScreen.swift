//
//  StressScreen.swift
//  CoachPlus
//
//  Created by 양정은 on 2016. 7. 29..
//  Copyright © 2016년 Company Green Comm. All rights reserved.
//

import Foundation
import MiddleWare

class StressScreen: BaseViewController, BaseProtocol {
    
    var select_mode = 1 // 1: fitness, 2:normal
    fileprivate var popup_exit = false
    fileprivate var isCancel = false
    
    fileprivate var mTimer: Timer?
    fileprivate var counter = 0
    fileprivate let limit = 120
    
    @IBOutlet var m_label_counter: UILabel!
    @IBOutlet var m_img_counter: UIImageView!
    @IBOutlet var m_background_counter: UIView!
    
    fileprivate var photoArray: [UIImage] = []
    
    // 기본 폰트 크기:14, 색:898989
    @IBOutlet var m_StressTxt: UILabel!
    // 이미지뷰는 아직 준비되지 않음.
    @IBOutlet var m_warnningLabel: UILabel!
    @IBOutlet var m_Stress_ResultTxt: UILabel!
    
    @IBOutlet var m_mainImage: UIImageView!
    @IBOutlet var ButtonOutlet: UIButton!
    
    fileprivate let mc: MWControlCenter = MWControlCenter.getInstance()
    fileprivate var isStart = false
    
    fileprivate var now: Date?
    
    fileprivate var isWait = false
    fileprivate var success = false
    
    fileprivate var mDispatchQ: DispatchQueue?
    fileprivate var mDispatchWorkItem: DispatchWorkItem?
    
    fileprivate func createDispatchforLoading() {
        mDispatchQ = DispatchQueue.global(qos: .background)
        mDispatchWorkItem = DispatchWorkItem {
            self.success = self.mc.getConnectionState() == .state_DISCONNECTED ? false : true
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
    
    @IBAction func ButtonAction(_ sender: UIButton) {
        if mc.getConnectionState() == ConnectStatus.state_DISCONNECTED {
            mc.tryConnectionBluetooth()
            showLoadingPopup(Common.ResString("connecting_device"))
            isWait = true
            if mDispatchQ != nil && mDispatchWorkItem != nil {
                let popTime = DispatchTime.now() + Double(Int64(4 * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)
                mDispatchQ?.asyncAfter(deadline: popTime, execute: mDispatchWorkItem!)
            }
            return
        }
        
        if mc.isBusySender {
            showPopup(Common.ResString("device_initial_wating"))
            return
        }
        
        if select_mode == 1 {
            if Preference.PeripheralState != Int32(StatePeripheral.idle.rawValue) && Preference.PeripheralState != Int32(StatePeripheral.stress.rawValue) {
                showPopup(Common.ResString("state_not_idle"))
                return
            }
        }
        
        if !isStart {
            m_StressTxt.isHidden = false
            m_Stress_ResultTxt.isHidden = true
            
            isCancel = false
            popup_exit = true
//            sender.setBackgroundImage(UIImage(named: "버튼_02.png"), for: UIControlState())
            sender.setTitle(Common.ResString("measure_cancel"), for: UIControlState())
            
            m_warnningLabel.isHidden = false
            m_mainImage.image = UIImage(named: "스트레스_측정시작.png")
            
            if select_mode == 1 {
                //규창 --- 16.10.24 fitness스트레스 측정 Firm -> App 대치
                //now = Date()
                //let time = Int64(now!.timeIntervalSince1970 * 1000)
                //mc.sendStressMeasure(true, time: time)
                mc.sendStressMeasure(true)
            } else {
                mc.sendNomalCoachStressMeasure(true)
            }
            
            Preference.PeripheralState = Int32(StatePeripheral.stress.rawValue)
            
            isStart = true
            
            counter = 0
            mTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(process), userInfo: nil, repeats: true)
            
            m_StressTxt.text = Common.ResString("stress_measure_loading")
            m_label_counter.text = String(counter)
            startAnimationPhoto()
        } else {
            isCancel = true
            popup_exit = false
            ButtonOutlet.setTitle(Common.ResString("measure_start"), for: UIControlState())
            
            if select_mode == 1 {
                mc.sendStressMeasure(false)
            } else {
                mc.sendNomalCoachStressMeasure(false)
            }
            
            Preference.PeripheralState = Int32(StatePeripheral.idle.rawValue)
            
            m_warnningLabel.isHidden = true
            m_mainImage.image = UIImage(named: "스트레스_측정중.png")
            m_StressTxt.text = Common.ResString("stress_measure_empty")
            stopAnimationPhoto()
            
            isStart = false
            
            cancel()
//            process()
        }
    }
    
    @objc func process() {
        if counter < limit {
            counter += 1
            m_label_counter.text = String(counter)
            m_StressTxt.text = Common.ResString("stress_measure_loading")
            return
        }
        
        if popup_exit {
            showPopup(Common.ResString("stress_measure_exit"))
        }
//        ButtonOutlet.setBackgroundImage(UIImage(named: "버튼_01.png"), for: UIControlState())
        ButtonOutlet.setTitle(Common.ResString("measure_start"), for: UIControlState())
        
        
        if select_mode == 1 {
            //규창 --- 16.10.24 fitness스트레스 측정 Firm -> App 대치
            //let time = Int64(now!.timeIntervalSince1970 * 1000)
            
//            let end_time = Int64(NSDate().timeIntervalSince1970 * 1000)
            
            mc.sendStressMeasure(false)
//            let sql = SQLHelper.getInstance()
//            sql.updateIndexTime(time, end_time: end_time)
            
            //mc.sendStressInfo(time)
        } else {
            mc.sendNomalCoachStressMeasure(false)
        }
        
        Preference.PeripheralState = Int32(StatePeripheral.idle.rawValue)
        
        m_warnningLabel.isHidden = true
        m_mainImage.image = UIImage(named: "스트레스_측정중.png")
//        m_StressTxt.text = Common.ResString("stress_measure_empty")
        
        isStart = false
        
        stopAnimationPhoto()
        cancel()
    }
    
    fileprivate func getCounter() -> String {
        return " \(limit - counter)"
    }
    
    fileprivate func setImageViewProperty() {
        for i in 0..<(120/10) {
            let imageName = String(format: "coachplus_stress_count_%02d.png", i*5)
            if let image = UIImage(named: imageName) {
                photoArray.append(image)
            }
        }
        
        m_img_counter.animationImages = photoArray
        m_img_counter.animationRepeatCount = 0
        m_img_counter.animationDuration = 120
        m_img_counter.image = photoArray[0]
    }
    
    fileprivate func startAnimationPhoto() {
        if !m_img_counter.isAnimating {
            m_background_counter.isHidden = false
            m_img_counter.startAnimating()
            m_label_counter.text = String(0)
        }
    }
    
    fileprivate func stopAnimationPhoto() {
        if m_img_counter.isAnimating {
            m_background_counter.isHidden = true
            m_img_counter.stopAnimating()
            m_label_counter.text = String(120)
        }
    }
    
    override func viewDidLoad() {
        m_StressTxt.text = Common.ResString("stress_measure_empty")
        ButtonOutlet.setTitle(Common.ResString("measure_start"), for: UIControlState())
        
        setImageViewProperty()
        mc.sendRequestState()
    }
    
    override func viewWillAppear(_ animated: Bool) {
//        if mc.Stress != 0 {
//            setScreen()
//        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        createDispatchforLoading()
        TabBarCenter.selecter = self
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        TabBarCenter.selecter = nil
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        let nc = NotificationCenter.default;
        nc.removeObserver(self)
        
        cancel()
        
        if isStart {
            Preference.PeripheralState = Int32(StatePeripheral.idle.rawValue)
            mc.sendStressMeasure(false)
        }
    }
    
    func run(_ notification: Notification) {
        print("\(className) ************************ \(notification.name)")
        switch notification.name.rawValue {
        case MWNotification.Bluetooth.RaiseConnectionState:
            if isWait {
                if mc.getConnectionState() == .state_CONNECTED {
                    cancelDispatch()
                    createDispatchforLoading()
                    success = true
                    dismissLoadingPopup(dismissCallback)
                    return
                }
            }
            
            if mc.getConnectionState() == .state_DISCONNECTED {
                if isStart {
                    showPopup(Common.ResString("raise_disconnect"))
                    
                    popup_exit = false
                    process()
                }
            }
        case MWNotification.Bluetooth.StressInform:
            fallthrough
        case MWNotification.Bluetooth.NormalStressErrorInform:
            fallthrough
        case MWNotification.Bluetooth.NormalStressInform:
            if isStart && !isCancel {
                setScreen()
            }
//        case MWNotification.Bluetooth.NormalStressErrorInform:
//            popup_exit = false
//            showPopup(Common.ResString("fail_stress"))
        default:
            break
        }
    }
    
    fileprivate func setScreen() {
        m_StressTxt.isHidden = true
        m_Stress_ResultTxt.isHidden = false
        if select_mode == 1 {
            if let stress = StressIdentifier(rawValue: mc.StressNResult) {
                m_Stress_ResultTxt.text = String(stress.toString)
                m_Stress_ResultTxt.textColor = stress.getColor
                Preference.StressState = Int32((stress.rawValue))
            } else {
                let dummy = StressIdentifier.normal
                m_Stress_ResultTxt.text = String(dummy.toString)
                m_Stress_ResultTxt.textColor = dummy.getColor
                Preference.StressState = Int32((dummy.rawValue))
            }
        } else {
            if let stress = StressIdentifier(rawValue: mc.StressNResult) {
                print("들어오긴하니!!!!!!!!!!!!!!!!!!!!!")
                m_Stress_ResultTxt.text = String(stress.toString)
                m_Stress_ResultTxt.textColor = stress.getColor
                Preference.StressState = Int32((stress.rawValue))
            } else {
                print("값 없음.")
                let dummy = StressIdentifier.normal
                m_Stress_ResultTxt.text = String(dummy.toString)
                m_Stress_ResultTxt.textColor = dummy.getColor
                Preference.StressState = Int32((dummy.rawValue))
            }
        }
        
    }
    
    fileprivate func cancel() {
        if mTimer != nil {
            mTimer?.invalidate()
            mTimer = nil
        }
    }
    
    func getCurrentChildViewController() -> UIViewController {
        return self
    }
}
