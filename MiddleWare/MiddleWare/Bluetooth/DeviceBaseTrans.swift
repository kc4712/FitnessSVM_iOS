//
//  DeviceBaseTrans.swift
//  Swift_MW_AART
//
//  Created by 양정은 on 2016. 6. 30..
//  Copyright © 2016년 심규창. All rights reserved.
//

import Foundation
import CoreBluetooth

class DeviceBaseTrans: DeviceBaseScan {
    let mDatabase = Database.getInstance()
    
    var m_Characteristic:CBCharacteristic?
    var discoveredPeripheral: CBPeripheral?

    func getDataFrame(_ peripheral: CBPeripheral, didUpdateValueFor characteristic: CBCharacteristic, error: Error?){}
    
    func sendRTC() {
        let mCal = MWCalendar.getInstance();
        let tz: TimeZone! = TimeZone(identifier: "UTC");
        mCal.setTimeZone(tz);
        mCal.date = Date();
        
        let offset = pB.getTimeZoneOffset()
        var weekday = mCal.weekday - 1
        if weekday == 0 {
            weekday = 7
        }
        
        let cmd = BluetoothCommand.rtc.rawValue
        
        
        Log.i("SendRTC", msg:"offset????\(offset) weekday????\(weekday)")
        /*
         let frame = Data(bytes: UnsafePointer<UInt8>([UInt8(cmd & 0xff),
         UInt8((cmd >> 8) & 0xff),
         UInt8((mCal.year) & 0xff),
         UInt8((mCal.year >> 8) & 0xff),
         UInt8((mCal.year >> 8) & 0xff),
         UInt8((mCal.year >> 8) & 0xff),
         UInt8((mCal.day) & 0xff),
         UInt8((mCal.day >> 8) & 0xff),
         UInt8((mCal.hour) & 0xff),
         UInt8((mCal.hour >> 8) & 0xff),
         UInt8((mCal.minute) & 0xff),
         UInt8((mCal.minute >> 8) & 0xff),
         UInt8((mCal.second) & 0xff),
         UInt8((mCal.second >> 8) & 0xff),
         UInt8((weekday) & 0xff),
         UInt8((weekday >> 8) & 0xff),
         UInt8((offset) & 0xff),
         UInt8((offset >> 8) & 0xff)] as [UInt8]), count: 18)*/
        
        //171010 규창 Swift4 대응하면서 생긴 너무 많은 인수로 인한 컴파일러 추론 에러... 수정
        let byteCmd1:UInt8 = UInt8(cmd & 0xff)
        let byteCmd2:UInt8 = UInt8((cmd >> 8) & 0xff)
        
        let byteYear1:UInt8 = UInt8((mCal.year) & 0xff)
        let byteYear2:UInt8 = UInt8((mCal.year >> 8) & 0xff)
        
        let byteMonth1:UInt8 = UInt8((mCal.month) & 0xff)
        let byteMonth2:UInt8 = UInt8((mCal.month >> 8) & 0xff)
        
        let byteDay1:UInt8 = UInt8((mCal.day) & 0xff)
        let byteDay2:UInt8 = UInt8((mCal.day >> 8) & 0xff)
        
        let byteHour1:UInt8 = UInt8((mCal.hour) & 0xff)
        let byteHour2:UInt8 = UInt8((mCal.hour >> 8) & 0xff)
        
        let byteMin1:UInt8 = UInt8((mCal.minute) & 0xff)
        let byteMin2:UInt8 = UInt8((mCal.minute >> 8) & 0xff)
        
        let byteSec1:UInt8 = UInt8((mCal.second) & 0xff)
        let byteSec2:UInt8 = UInt8((mCal.second >> 8) & 0xff)
        
        let byteWeekday1:UInt8 = UInt8((weekday) & 0xff)
        let byteWeekday2:UInt8 = UInt8((weekday >> 8) & 0xff)
        
        let byteOffset1:UInt8 = UInt8((offset) & 0xff)
        let byteOffset2:UInt8 = UInt8((offset >> 8) & 0xff)
        
        let frame = Data(bytes: UnsafePointer<UInt8>([
            byteCmd1,
            byteCmd2,
            byteYear1,
            byteYear2,
            byteMonth1,
            byteMonth2,
            byteDay1,
            byteDay2,
            byteHour1,
            byteHour2,
            byteMin1,
            byteMin2,
            byteSec1,
            byteSec2,
            byteWeekday1,
            byteWeekday2,
            byteOffset1,
            byteOffset2
            ] as [UInt8]), count: 18)
        
        pB.write(discoveredPeripheral, data: frame, forCharacteristic: m_Characteristic, type: CBCharacteristicWriteType.withResponse)
        
    }
    
    func requestAcc(_ action: RequestAction) {
        let cmd = BluetoothCommand.acc.rawValue
        let frame = Data(bytes: UnsafePointer<UInt8>([UInt8(cmd & 0xff),
            UInt8((cmd >> 8) & 0xff),
            UInt8((action.rawValue) & 0xff),
            UInt8((action.rawValue >> 8) & 0xff)] as [UInt8]), count: 4)
        pB.write(discoveredPeripheral, data: frame, forCharacteristic: m_Characteristic, type: CBCharacteristicWriteType.withResponse)
    }
    
    func requestAcc(ProductCoach action: RequestAction) {
        let cmd = BluetoothCommand.acc.rawValue
        let frame = Data(bytes: UnsafePointer<UInt8>([UInt8(cmd & 0xff),
            UInt8((action.rawValue) & 0xff),
            0] as [UInt8]), count: 3)
        pB.write(discoveredPeripheral, data: frame, forCharacteristic: m_Characteristic, type: CBCharacteristicWriteType.withResponse)
    }
    
    func sendUserData() {
        let sex = mDatabase.Profile.sex
        let age = mDatabase.Profile.age
        let height = Int(mDatabase.Profile.height)
        let weight = Int(mDatabase.Profile.weight)
        let cmd = BluetoothCommand.userData.rawValue
        
        //규창 171010 Swift4 마이그레이션 너무 긴 연산자로 인한 컴파일러 추론에러
        /*let frame = Data(bytes: UnsafePointer<UInt8>([UInt8(cmd & 0xff),
            UInt8((cmd >> 8) & 0xff),
            UInt8((sex) & 0xff),
            UInt8((sex >> 8) & 0xff),
            UInt8((age) & 0xff),
            UInt8((age >> 8) & 0xff),
            UInt8((height) & 0xff),
            UInt8((height >> 8) & 0xff),
            UInt8((weight) & 0xff),
            UInt8((weight >> 8) & 0xff)] as [UInt8]), count: 10)*/
        
        let byteCmd1:UInt8 = UInt8(cmd & 0xff)
        let byteCmd2:UInt8 = UInt8((cmd >> 8) & 0xff)
        let byteSex1:UInt8 = UInt8((sex) & 0xff)
        let byteSex2:UInt8 = UInt8((sex >> 8) & 0xff)
        let byteAge1:UInt8 = UInt8((age) & 0xff)
        let byteAge2:UInt8 = UInt8((age >> 8) & 0xff)
        let byteHeight1:UInt8 = UInt8((height) & 0xff)
        let byteHeight2:UInt8 = UInt8((height >> 8) & 0xff)
        let byteWeight1:UInt8 = UInt8((weight) & 0xff)
        let byteWeight2:UInt8 = UInt8((weight >> 8) & 0xff)
        
        let frame = Data(bytes: UnsafePointer<UInt8>([
            byteCmd1,
            byteCmd2,
            byteSex1,
            byteSex2,
            byteAge1,
            byteAge2,
            byteHeight1,
            byteHeight2,
            byteWeight1,
            byteWeight2] as [UInt8]), count: 10)
        pB.write(discoveredPeripheral, data: frame, forCharacteristic: m_Characteristic, type: CBCharacteristicWriteType.withResponse)
    }
    
    func requestVibrate(_ action: RequestAction) {
        let cmd = BluetoothCommand.vibrate.rawValue
        let frame = Data(bytes: UnsafePointer<UInt8>([UInt8(cmd & 0xff),
            UInt8((cmd >> 8) & 0xff),
            UInt8((action.rawValue) & 0xff),
            UInt8((action.rawValue >> 8) & 0xff)] as [UInt8]), count: 4)
        pB.write(discoveredPeripheral, data: frame, forCharacteristic: m_Characteristic, type: CBCharacteristicWriteType.withResponse)
    }
    
    func requestVibrate(ProductCoach action: RequestAction) {
        let cmd = BluetoothCommand.vibrate.rawValue
        let frame = Data(bytes: UnsafePointer<UInt8>([UInt8(cmd & 0xff),
            UInt8((action.rawValue) & 0xff)] as [UInt8]), count: 2)
        pB.write(discoveredPeripheral, data: frame, forCharacteristic: m_Characteristic, type: CBCharacteristicWriteType.withResponse)
    }
    
    func requestDataClear() {
        let cmd = BluetoothCommand.dataClear.rawValue
        let frame = Data(bytes: UnsafePointer<UInt8>([UInt8(cmd & 0xff),
            UInt8((cmd >> 8) & 0xff)] as [UInt8]), count: 2)
        pB.write(discoveredPeripheral, data: frame, forCharacteristic: m_Characteristic, type: CBCharacteristicWriteType.withResponse)
    }
    
    func requestVersion() {
        let cmd = BluetoothCommand.version.rawValue
        let frame = Data(bytes: UnsafePointer<UInt8>([UInt8(cmd & 0xff),
            UInt8((cmd >> 8) & 0xff)] as [UInt8]), count: 2)
        pB.write(discoveredPeripheral, data: frame, forCharacteristic: m_Characteristic, type: CBCharacteristicWriteType.withResponse)
    }
    
    func requestVersionProductCoach() {
        let cmd = BluetoothCommand.version.rawValue
        let frame = Data(bytes: UnsafePointer<UInt8>([UInt8(cmd & 0xff),
            1, 0] as [UInt8]), count: 3)
        pB.write(discoveredPeripheral, data: frame, forCharacteristic: m_Characteristic, type: CBCharacteristicWriteType.withResponse)
    }
    
    func requestStepCount_Calorie(_ time: Int64) {
        
        let ret = DataControlBase.getConvertedTime(time)
        Log.i("DeviceBaseTrans", msg: "스텝 칼로리 요청 \(time) \(ret)");
        let cmd = BluetoothCommand.stepCount_Calorie.rawValue
        
        //규창 171011 Swift4 마이그레이션 컴파일 에러는 없으나 실제 테스트중에 BLE로 스텝 요청 전송이 되지 않는다..
        //너무 긴 연산자로 인한 컴파일러 추론에러가 나는 것이 아닐까?
        
        /*let frame = Data(bytes: UnsafePointer<UInt8>([UInt8(cmd & 0xff),
            UInt8((cmd >> 8) & 0xff),
            UInt8((ret) & 0xff),
            UInt8((ret >> 8) & 0xff),
            UInt8((ret >> 16) & 0xff),
            UInt8((ret >> 24) & 0xff)] as [UInt8]), count: 6)*/
 
        let byteCmd1:UInt8 = UInt8(cmd & 0xff)
        let byteCmd2:UInt8 = UInt8((cmd >> 8) & 0xff)
        let byteRet1:UInt8 = UInt8(ret & 0xff)
        let byteRet2:UInt8 = UInt8((ret >> 8) & 0xff)
        let byteRet3:UInt8 = UInt8((ret >> 16) & 0xff)
        let byteRet4:UInt8 = UInt8((ret >> 24) & 0xff)
        let frame = Data(bytes: UnsafePointer<UInt8>([
            byteCmd1,
            byteCmd2,
            UInt8(byteRet1),
            UInt8(byteRet2),
            UInt8(byteRet3),
            UInt8(byteRet4)] as [UInt8]), count: 6)
        Log.i("DeviceBaseTrans", msg: "??? \(frame as NSData)");
        Log.i("DeviceBaseTrans", msg: "??? \(byteRet1) \(byteRet2) \(byteRet3) \(byteRet4)");
        //discoveredPeripheral!.writeValue(frame , for: m_Characteristic!, type: CBCharacteristicWriteType.withResponse)
        pB.write(discoveredPeripheral, data: frame, forCharacteristic: m_Characteristic, type: CBCharacteristicWriteType.withResponse)
    }
    
    func requestActivity(_ action: RequestAction, time: Int64) {
        let ret = DataControlBase.getConvertedTime(time)
        let cmd = BluetoothCommand.activity.rawValue
        //규창 171010 Swift4 마이그레이션 너무 긴 연산자로 인한 컴파일러 추론에러
        /*let frame = Data(bytes: UnsafePointer<UInt8>([UInt8(cmd & 0xff),
            UInt8((cmd >> 8) & 0xff),
            UInt8((action.rawValue) & 0xff),
            UInt8((action.rawValue >> 8) & 0xff),
            UInt8((ret) & 0xff),
            UInt8((ret >> 8) & 0xff),
            UInt8((ret >> 16) & 0xff),
            UInt8((ret >> 24) & 0xff)] as [UInt8]), count: 8)*/
        
        let byteCmd1:UInt8 = UInt8(cmd & 0xff)
        let byteCmd2:UInt8 = UInt8((cmd >> 8) & 0xff)
        let byteAction1:UInt8 = UInt8((action.rawValue) & 0xff)
        let byteAction2:UInt8 = UInt8((action.rawValue >> 8) & 0xff)
        let byteRet1:UInt8 = UInt8((ret) & 0xff)
        let byteRet2:UInt8 = UInt8((ret >> 8) & 0xff)
        let byteRet3:UInt8 = UInt8((ret >> 16) & 0xff)
        let byteRet4:UInt8 = UInt8((ret >> 24) & 0xff)
        
        let frame = Data(bytes: UnsafePointer<UInt8>([
            byteCmd1,
            byteCmd2,
            byteAction1,
            byteAction2,
            byteRet1,
            byteRet2,
            byteRet3,
            byteRet4] as [UInt8]), count: 8)
    
        pB.write(discoveredPeripheral, data: frame, forCharacteristic: m_Characteristic, type: CBCharacteristicWriteType.withResponse)
    }
    
    func requestSleep(_ action: RequestAction, time: Int64) {
        let ret = DataControlBase.getConvertedTime(time)
        let cmd = BluetoothCommand.sleep.rawValue
        //규창 171010 Swift4 마이그레이션 너무 긴 연산자로 인한 컴파일러 추론에러
        /*let frame = Data(bytes: UnsafePointer<UInt8>([UInt8(cmd & 0xff),
            UInt8((cmd >> 8) & 0xff),
            UInt8((action.rawValue) & 0xff),
            UInt8((action.rawValue >> 8) & 0xff),
            UInt8((ret) & 0xff),
            UInt8((ret >> 8) & 0xff),
            UInt8((ret >> 16) & 0xff),
            UInt8((ret >> 24) & 0xff)] as [UInt8]), count: 8)*/
        let byteCmd1:UInt8 = UInt8(cmd & 0xff)
        let byteCmd2:UInt8 = UInt8((cmd >> 8) & 0xff)
        let byteAction1:UInt8 = UInt8((action.rawValue) & 0xff)
        let byteAction2:UInt8 = UInt8((action.rawValue >> 8) & 0xff)
        let byteRet1:UInt8 = UInt8((ret) & 0xff)
        let byteRet2:UInt8 = UInt8((ret >> 8) & 0xff)
        let byteRet3:UInt8 = UInt8((ret >> 16) & 0xff)
        let byteRet4:UInt8 = UInt8((ret >> 24) & 0xff)
        
        let frame = Data(bytes: UnsafePointer<UInt8>([
            byteCmd1,
            byteCmd2,
            byteAction1,
            byteAction2,
            byteRet1,
            byteRet2,
            byteRet3,
            byteRet4] as [UInt8]), count: 8)
        
        pB.write(discoveredPeripheral, data: frame, forCharacteristic: m_Characteristic, type: CBCharacteristicWriteType.withResponse)
    }
    
    func sendNoticeONOFF(_ action: RequestAction, index: NoticeIndex) {
        let cmd = BluetoothCommand.noticeONOFF.rawValue
        
        let platform = 1 // ios
        //규창 171010 Swift4 마이그레이션 너무 긴 연산자로 인한 컴파일러 추론에러
        /*let frame = Data(bytes: UnsafePointer<UInt8>([UInt8(cmd & 0xff),
                                                      UInt8((cmd >> 8) & 0xff),
                                                      UInt8((platform) & 0xff),
                                                      UInt8((platform >> 8) & 0xff),
                                                      UInt8((index.rawValue) & 0xff),
                                                      UInt8((index.rawValue >> 8) & 0xff),
                                                      UInt8((action.rawValue) & 0xff),
                                                      UInt8((action.rawValue >> 8) & 0xff)] as [UInt8]), count: 8)*/
        let byteCmd1:UInt8 = UInt8(cmd & 0xff)
        let byteCmd2:UInt8 = UInt8((cmd >> 8) & 0xff)
        let bytePlatform1:UInt8 = UInt8((platform) & 0xff)
        let bytePlatform2:UInt8 = UInt8((platform >> 8) & 0xff)
        let byteIndex1:UInt8 = UInt8((index.rawValue) & 0xff)
        let byteIndex2:UInt8 = UInt8((index.rawValue >> 8) & 0xff)
        let byteAction1:UInt8 = UInt8((action.rawValue) & 0xff)
        let byteAction2:UInt8 = UInt8((action.rawValue >> 8) & 0xff)
        
        let frame = Data(bytes: UnsafePointer<UInt8>([
            byteCmd1,
            byteCmd2,
            bytePlatform1,
            bytePlatform2,
            byteIndex1,
            byteIndex2,
            byteAction1,
            byteAction2] as [UInt8]), count: 8)
        
        pB.write(discoveredPeripheral, data: frame, forCharacteristic: m_Characteristic, type: CBCharacteristicWriteType.withResponse)
    }
    
    func requestStress(_ action: RequestAction, time: Int64) {
        let ret = DataControlBase.getConvertedTime(time)
        let cmd = BluetoothCommand.stress.rawValue
        //규창 171010 Swift4 마이그레이션 너무 긴 연산자로 인한 컴파일러 추론에러
        /*let frame = Data(bytes: UnsafePointer<UInt8>([UInt8(cmd & 0xff),
            UInt8((cmd >> 8) & 0xff),
            UInt8((action.rawValue) & 0xff),
            UInt8((action.rawValue >> 8) & 0xff),
            UInt8((ret) & 0xff),
            UInt8((ret >> 8) & 0xff),
            UInt8((ret >> 16) & 0xff),
            UInt8((ret >> 24) & 0xff)] as [UInt8]), count: 8)*/
        let byteCmd1:UInt8 = UInt8(cmd & 0xff)
        let byteCmd2:UInt8 = UInt8((cmd >> 8) & 0xff)
        let byteAction1:UInt8 = UInt8((action.rawValue) & 0xff)
        let byteAction2:UInt8 = UInt8((action.rawValue >> 8) & 0xff)
        let byteRet1:UInt8 = UInt8((ret) & 0xff)
        let byteRet2:UInt8 = UInt8((ret >> 8) & 0xff)
        let byteRet3:UInt8 = UInt8((ret >> 16) & 0xff)
        let byteRet4:UInt8 = UInt8((ret >> 24) & 0xff)
        
        let frame = Data(bytes: UnsafePointer<UInt8>([
            byteCmd1,
            byteCmd2,
            byteAction1,
            byteAction2,
            byteRet1,
            byteRet2,
            byteRet3,
            byteRet4] as [UInt8]), count: 8)
        
        
        pB.write(discoveredPeripheral, data: frame, forCharacteristic: m_Characteristic, type: CBCharacteristicWriteType.withResponse)
    }
    
    func requestState() {
        let cmd = BluetoothCommand.state.rawValue
        let frame = Data(bytes: UnsafePointer<UInt8>([UInt8(cmd & 0xff),
            UInt8((cmd >> 8) & 0xff)] as [UInt8]), count: 2)
        pB.write(discoveredPeripheral, data: frame, forCharacteristic: m_Characteristic, type: CBCharacteristicWriteType.withResponse)
    }
    
    func requestBattery() {
        let cmd = BluetoothCommand.battery.rawValue
        let frame = Data(bytes: UnsafePointer<UInt8>([UInt8(cmd & 0xff),
            UInt8((cmd >> 8) & 0xff)] as [UInt8]), count: 2)
        pB.write(discoveredPeripheral, data: frame, forCharacteristic: m_Characteristic, type: CBCharacteristicWriteType.withResponse)
    }
    
    func requestBatteryProductCoach() {
        let cmd = BluetoothCommand.battery.rawValue
        let frame = Data(bytes: UnsafePointer<UInt8>([UInt8(cmd & 0xff),
            1,
            0] as [UInt8]), count: 3)
        pB.write(discoveredPeripheral, data: frame, forCharacteristic: m_Characteristic, type: CBCharacteristicWriteType.withResponse)
    }
    
    func sendCalorie(_ calorie: Float) {
        let cal = Int(calorie * 1000)
        let cmd = BluetoothCommand.coachCalorie.rawValue
        let frame = Data(bytes: UnsafePointer<UInt8>([UInt8(cmd & 0xff),
            UInt8((cmd >> 8) & 0xff),
            UInt8((cal) & 0xff),
            UInt8((cal >> 8) & 0xff),
            UInt8((cal >> 16) & 0xff),
            UInt8((cal >> 24) & 0xff)] as [UInt8]), count: 6)
        pB.write(discoveredPeripheral, data: frame, forCharacteristic: m_Characteristic, type: CBCharacteristicWriteType.withResponse)
    }
    
    func sendCalorie(IntCalorie calorie: Int) {
        let cal = calorie
        let cmd = BluetoothCommand.coachCalorie.rawValue
        let frame = Data(bytes: UnsafePointer<UInt8>([UInt8(cmd & 0xff),
            UInt8((cmd >> 8) & 0xff),
            UInt8((cal) & 0xff),
            UInt8((cal >> 8) & 0xff),
            UInt8((cal >> 16) & 0xff),
            UInt8((cal >> 24) & 0xff)] as [UInt8]), count: 6)
        pB.write(discoveredPeripheral, data: frame, forCharacteristic: m_Characteristic, type: CBCharacteristicWriteType.withResponse)
    }
    
    
    //규창 171016 피쳐데이터 전송 명령
    func requestFeature(reqtime: Int64){
        let format = DateFormatter()
        format.dateFormat = "yyyy/MM/dd HH:mm"
        let formatTime = Date(timeIntervalSince1970: TimeInterval(reqtime/1000))
        var timeString = format.string(from: formatTime as Date)
        timeString.removeLast()
        timeString.append("0")
        
        let time10MIN:Date = format.date(from: timeString)!
        
        let LongTo10MIN:Int64 = Int64(time10MIN.timeIntervalSince1970) * 1000
        Log.i("DevBaseTranse", msg: "피쳐 요청 시간:\(format.string(from: format.date(from: timeString)!)) \(LongTo10MIN) \(reqtime)");
        /*if format.string(from: formatTime as Date) == "00" {
            
        }else if format.string(from: formatTime as Date) == "10" {
            
        }else if format.string(from: formatTime as Date) == "20" {
        }else if format.string(from: formatTime as Date) == "30" {
        }else if format.string(from: formatTime as Date) == "40" {
        }else if format.string(from: formatTime as Date) == "50" {
        }*/
        //Log.i("DevBaseTranse", msg: "피쳐 요청 시간:\(format.string(from: formatTime as Date))");
        for i in 0..<10 {
        let cmd = BluetoothCommand.featureSet1.rawValue
        //let ret = 9360428//DataControlBase.getConvertedTime(time)
        //let ret = DataControlBase.getConvertedTime(time)
        let ret = DataControlBase.getConvertedTime(LongTo10MIN) - Int32(10) + Int32(i)
        let byteCmd1:UInt8 = UInt8(cmd & 0xff)
        let byteCmd2:UInt8 = UInt8((cmd >> 8) & 0xff)
        let byteRet1:UInt8 = UInt8(ret & 0xff)
        let byteRet2:UInt8 = UInt8((ret >> 8) & 0xff)
        let byteRet3:UInt8 = UInt8((ret >> 16) & 0xff)
        let byteRet4:UInt8 = UInt8((ret >> 24) & 0xff)
        let frame = Data(bytes: UnsafePointer<UInt8>([
            byteCmd1,
            byteCmd2,
            UInt8(byteRet1),
            UInt8(byteRet2),
            UInt8(byteRet3),
            UInt8(byteRet4)] as [UInt8]), count: 6)
        Log.i("DeviceBaseTrans", msg: "요청한 피쳐시간 ---- \(time) \(ret)");
        
        pB.write(discoveredPeripheral, data: frame, forCharacteristic: m_Characteristic, type: CBCharacteristicWriteType.withResponse)
        }
        
    }
    
    //규창 171016 피쳐데이터 전송 명령
    func sendpastFeatureRequest(reqtimeFirst: Int64, reqtimeLast: Int64){
        /*let format = DateFormatter()
        format.dateFormat = "yyyy/MM/dd HH:mm"
        let formatTime = Date(timeIntervalSince1970: TimeInterval(reqtimeFirst/1000))
        var timeString = format.string(from: formatTime as Date)
        timeString.removeLast()
        timeString.append("0")
        
        let time10MIN:Date = format.date(from: timeString)!
        
        let LongTo10MIN:Int64 = Int64(time10MIN.timeIntervalSince1970) * 1000
        Log.i("DevBaseTranse", msg: "피쳐 요청 시간:\(format.string(from: format.date(from: timeString)!)) \(LongTo10MIN) \(reqtime)");*/
        /*if format.string(from: formatTime as Date) == "00" {
         
         }else if format.string(from: formatTime as Date) == "10" {
         
         }else if format.string(from: formatTime as Date) == "20" {
         }else if format.string(from: formatTime as Date) == "30" {
         }else if format.string(from: formatTime as Date) == "40" {
         }else if format.string(from: formatTime as Date) == "50" {
         }*/
        //Log.i("DevBaseTranse", msg: "피쳐 요청 시간:\(format.string(from: formatTime as Date))");
        //for i in 1..<11 {
            let cmd = BluetoothCommand.pastFeatureRequest.rawValue
            //let ret = 9360428//DataControlBase.getConvertedTime(time)
            //let ret = DataControlBase.getConvertedTime(time)
            let rettoday = DataControlBase.getConvertedTime(MWCalendar.getInstance().convertToday())
        var retfirst:Int32 = 0
            if(reqtimeFirst == 0){
                retfirst = 0// - Int32(i)
            }else {
                retfirst = DataControlBase.getConvertedTime(MWCalendar.getInstance().convert10MIN(time: reqtimeFirst))// - Int32(i)
            }
            let retlast = DataControlBase.getConvertedTime(MWCalendar.getInstance().convert10MIN(time: reqtimeLast))// - Int32(i)
            let byteCmd1:UInt8 = UInt8(cmd & 0xff)
            let byteCmd2:UInt8 = UInt8((cmd >> 8) & 0xff)
            let byteRet1:UInt8 = UInt8(retfirst & 0xff)
            let byteRet2:UInt8 = UInt8((retfirst >> 8) & 0xff)
            let byteRet3:UInt8 = UInt8((retfirst >> 16) & 0xff)
            let byteRet4:UInt8 = UInt8((retfirst >> 24) & 0xff)
            let byteRet5:UInt8 = UInt8(retlast & 0xff)
            let byteRet6:UInt8 = UInt8((retlast >> 8) & 0xff)
            let byteRet7:UInt8 = UInt8((retlast >> 16) & 0xff)
            let byteRet8:UInt8 = UInt8((retlast >> 24) & 0xff)
            let byteToday1:UInt8 = UInt8(rettoday & 0xff)
            let byteToday2:UInt8 = UInt8((rettoday >> 8) & 0xff)
            let byteToday3:UInt8 = UInt8((rettoday >> 16) & 0xff)
            let byteToday4:UInt8 = UInt8((rettoday >> 24) & 0xff)
            
            
            let frame = Data(bytes: UnsafePointer<UInt8>([
                byteCmd1,
                byteCmd2,
                UInt8(byteRet1),
                UInt8(byteRet2),
                UInt8(byteRet3),
                UInt8(byteRet4),
                UInt8(byteRet5),
                UInt8(byteRet6),
                UInt8(byteRet7),
                UInt8(byteRet8),
                UInt8(byteToday1),
                UInt8(byteToday2),
                UInt8(byteToday3),
                UInt8(byteToday4)] as [UInt8]), count: 14)
            Log.i("DeviceBaseTrans", msg: "요청한 피쳐시간 ---- \(rettoday) \(reqtimeFirst) \(retfirst) \(reqtimeLast) \(retlast)");
            
            pB.write(discoveredPeripheral, data: frame, forCharacteristic: m_Characteristic, type: CBCharacteristicWriteType.withResponse)
        //}
        
    }
    
}
