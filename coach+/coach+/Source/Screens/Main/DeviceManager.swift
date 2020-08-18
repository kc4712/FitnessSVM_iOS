//
//  DeviceManager.swift
//  DevBaseTool
//
//  Created by 김영일 이사 on 2016. 5. 20..
//  Copyright © 2016년 그린콤 김영일. All rights reserved.
//

import Foundation;
import UIKit;
import MiddleWare;

class DeviceManager : UITableViewController, BaseProtocol
{
    fileprivate var mc: MWControlCenter!;
    fileprivate var m_battery: (status: Int16, voltage: Int16) = (0, 0);

    @IBOutlet weak var sms_switch: UISwitch!
    @IBOutlet weak var phone_switch: UISwitch!
    @IBOutlet weak var sms_notice: UITableViewCell!
    @IBOutlet weak var phone_notice: UITableViewCell!
    @IBOutlet weak var Image_Battery: UIImageView!
    @IBOutlet weak var Label_ConStat: UILabel!
    @IBOutlet weak var Label_DevName: UILabel!

    @IBOutlet var Image_Connect: UIImageView!
    
    @IBOutlet weak var Label_Votage: UILabel!
    
    fileprivate var m_connect = false
    fileprivate var notice_phoneONOFF = false
    fileprivate var notice_smsONOFF = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("Load: 추천운동 화면");
        
        // 테이블 뷰 하단의 빈 라인 제거
        tableView.tableFooterView = UIView(frame: CGRect.zero);
        
        // 미들웨어 인스턴스 연결
        mc = MWControlCenter.getInstance()
        
        let product = mc.getSelectedProduct()
        switch product {
        case .coach:
            sms_notice.isHidden = true
            phone_notice.isHidden = true
        case .fitness:
            sms_notice.isHidden = false
            phone_notice.isHidden = false
            phone_switch.addTarget(self, action: #selector(switchPhoneNotice), for: .valueChanged)
            sms_switch.addTarget(self, action: #selector(switchSmsNotice), for: .valueChanged)
        }
        
        setSwitch()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        TabBarCenter.selecter = nil
        rotateImage(false)
        saveSwitch()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        TabBarCenter.selecter = self
        if mc.getConnectionState() == .state_CONNECTED {
            mc.sendBatteryRequest()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        updateConnect();
        updateBattery();
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if ((indexPath as NSIndexPath).row == 2) {
            if !Label_DevName.isHidden {
                return
            }
            if Preference.getBluetoothName() != nil {
                if !Image_Connect.isRotating {
                    mc.tryConnectionBluetooth()
                    rotateImage(true)
                }
            }
        }
    }
    
    fileprivate func setSwitch() {
        notice_phoneONOFF = Preference.NoticePhoneONOFF
        notice_smsONOFF = Preference.NoticeSmsONOFF
        
        if notice_phoneONOFF {
            phone_switch.setOn(true, animated: false)
        } else {
            phone_switch.setOn(false, animated: false)
        }

        if notice_smsONOFF {
            sms_switch.setOn(true, animated: false)
        } else {
            sms_switch.setOn(false, animated: false)
        }
    }
    
    fileprivate func saveSwitch() {
        Preference.NoticePhoneONOFF = notice_phoneONOFF
        Preference.NoticeSmsONOFF = notice_smsONOFF
    }
    
    @objc fileprivate func switchPhoneNotice(sender: UISwitch) {
        notice_phoneONOFF = sender.isOn
        if notice_phoneONOFF {
            print("phone noti on")
            mc!.appendSender((.noticeONOFF, 0, .start, false, .phone))
        } else {
            print("phone noti off")
            mc!.appendSender((.noticeONOFF, 0, .end, false, .phone))
        }
    }
    
    @objc fileprivate func switchSmsNotice(sender: UISwitch) {
        notice_smsONOFF = sender.isOn
        if notice_smsONOFF {
            print("sms noti on")
            mc!.appendSender((.noticeONOFF, 0, .start, false, .sms))
        } else {
            print("sms noti off")
            mc!.appendSender((.noticeONOFF, 0, .end, false, .sms))
        }
    }
    
    fileprivate func rotateImage(_ rotate: Bool) {
        if rotate {
            Image_Connect.startRotate()
        } else {
            Image_Connect.stopRotate()
        }
    }
    
    func run(_ notification: Notification) {
        if notification.name.rawValue == MWNotification.Bluetooth.Battery {
            updateBattery()
        } else if notification.name.rawValue == MWNotification.Bluetooth.RaiseConnectionState {
            updateConnect()
            updateBattery()
        } else if notification.name.rawValue == MWNotification.Bluetooth.FailedConnection {
            if Image_Connect.isRotating {
                rotateImage(false)
            }
        }
    }
    
    // 밧데리 알림 수신
    func updateBattery() {
        print("밧데리 알림 수신");
        if (mc == nil) {
            return;
        }

        // 미연결
        if (m_connect == false) {
            Image_Battery.image = UIImage(named: "배터리_없음.png");
            Label_Votage.text = Common.ResString("device_disconnect")
            return;
        }

        // status= 0:미연결, 1:미충전, 2:충전중, 3:충전완료. voltage=남은 용량(%)
        m_battery = mc.Battery
        print("밧데리 [상태: \(m_battery.status)], [충전: \(m_battery.voltage)]");
        
        // 충전중
        if (m_battery.status == 2) {
            Image_Battery.image = UIImage(named: "배터리_충전중.png");
            Label_Votage.text = Common.ResString("device_charging")
            return;
        } else if (m_battery.status == 3) {
            // 충전완료
            Image_Battery.image = UIImage(named: "배터리_충전완료.png");
            Label_Votage.text = "100%";
            return;
        }
        
        Label_Votage.text = "\(m_battery.voltage)%";

        //규창 16.12.27 배터리 잔량 표기 수정
        switch (m_battery.voltage) {
        case 0 ... 25:
            Image_Battery.image = UIImage(named: "배터리_01.png");
        case 26 ... 50:
            Image_Battery.image = UIImage(named: "배터리_02.png");
        case 51 ... 75:
            Image_Battery.image = UIImage(named: "배터리_03.png");
        case 76 ... 100:
            Image_Battery.image = UIImage(named: "배터리_04.png");
        default:
            Image_Battery.image = UIImage(named: "배터리_04.png");
        }
        /*
        switch (m_battery.voltage) {
        case 0 ... 15:
            Image_Battery.image = UIImage(named: "배터리_없음.png");
        case 16 ... 37:
            Image_Battery.image = UIImage(named: "배터리_01.png");
        case 38 ... 59:
            Image_Battery.image = UIImage(named: "배터리_02.png");
        case 60 ... 81:
            Image_Battery.image = UIImage(named: "배터리_03.png");
        case 82 ... 100:
            Image_Battery.image = UIImage(named: "배터리_04.png");
        default:
            Image_Battery.image = UIImage(named: "배터리_04.png");
        }*/
    }
    
    func updateConnect() {
        // 연결상태 확인
        let conn = mc.getConnectionState();
        if  (conn == .state_CONNECTED) {
            if Image_Connect.isRotating {
                rotateImage(false)
            }
            m_connect = true;
            Label_ConStat.text = Common.ResString("device_connected")
            if let devName = Preference.getBluetoothName() {
                Label_DevName.text = devName;
                Image_Connect.image = UIImage(named: "연결.png")
            }
            else {
                Label_DevName.text = "";
                Image_Connect.image = UIImage(named: "연결_찾을수없음.png")
            }
            Image_Connect.isHidden = true;
            Label_DevName.isHidden = false;
            
            phone_switch.isEnabled = true
            sms_switch.isEnabled = true
        }
        else {
            m_connect = false;
            if (conn == .state_CONNECTING) {
                Label_ConStat.text = Common.ResString("device_connecting")
            }
            else {
                Label_ConStat.text = Common.ResString("device_connect")
            }
            Image_Connect.isHidden = false;
            Label_DevName.isHidden = true;
            
            phone_switch.isEnabled = false
            sms_switch.isEnabled = false
        }
    }
    
    func getCurrentChildViewController() -> UIViewController {
        return self
    }
}
