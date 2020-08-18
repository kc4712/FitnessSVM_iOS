//
//  BleManager.swift
//  Swift_Middleware
//
//  Created by 심규창 on 2016. 6. 10..
//  Copyright © 2016년 심규창. All rights reserved.
//

import Foundation
import CoreBluetooth
import iOSDFULibrary

private let mBluetoothLEManager = BluetoothLEManager();
// F1_DfuT, C1_DfuT

class BluetoothLEManager: TimerBase, CBCentralManagerDelegate, CBPeripheralDelegate, pBluetooth, DFUServiceDelegate, LoggerDelegate, DFUProgressDelegate {

    
    fileprivate static let tag = BluetoothLEManager.className
    fileprivate static let DEBUG = true
    var nNF:pNordicFormat?
    var sensorData1 = [Double]()
    var sensorData2 = [Double]()
    
    //규창 피처 기능 추가
    fileprivate var readyFeature1 = false
    fileprivate var readyFeature2 = false
    fileprivate var readyFeature3 = false
    var FeatureDicSet:[Dictionary<String, Any>] = []//= Array(repeating: 0, count: 10)
    var FeatureDic:[String:Any] =
        ["KEY_TIME"             : 0    ,
         "KEY_NORM_VAR"         : 0.0  ,
         "KEY_X_VAR"            : 0.0  ,
         "KEY_Y_VAR"            : 0.0  ,
         "KEY_Z_VAR"            : 0.0  ,
         "KEY_X_MEAN"           : 0.0  ,
         "KEY_Y_MEAN"           : 0.0  ,
         "KEY_Z_MEAN"           : 0.0  ,
         "KEY_NORM_MEAN"        : 0.0  ,
         "KEY_NSTEP"            : 0    ,
         "KEY_JUMP_ROPE_SWING"  : 0    ,
         "KEY_SMALL_SWING"      : 0    ,
         "KEY_LARGE_SWING"      : 0    ,
         "KEY_PRESS_VAR"        : 0.0  ,
         "KEY_ACCMULATED_STEP"  : 0    ,
         "KEY_DISPLAY_STEP"     : 0    ,
         "KEY_PRESS"            : 0.0  ,
         "KEY_PULSE"            : 0    ]
    
    fileprivate var readyPastFeature1 = false
    fileprivate var readyPastFeature2 = false
    fileprivate var readyPastFeature3 = false
    var PastFeatureDicSet:[Dictionary<String, Any>] = []//= Array(repeating: 0, count: 10)
    var PastFeatureDic:[String:Any] =
        ["KEY_TIME"             : 0    ,
         "KEY_NORM_VAR"         : 0.0  ,
         "KEY_X_VAR"            : 0.0  ,
         "KEY_Y_VAR"            : 0.0  ,
         "KEY_Z_VAR"            : 0.0  ,
         "KEY_X_MEAN"           : 0.0  ,
         "KEY_Y_MEAN"           : 0.0  ,
         "KEY_Z_MEAN"           : 0.0  ,
         "KEY_NORM_MEAN"        : 0.0  ,
         "KEY_NSTEP"            : 0    ,
         "KEY_JUMP_ROPE_SWING"  : 0    ,
         "KEY_SMALL_SWING"      : 0    ,
         "KEY_LARGE_SWING"      : 0    ,
         "KEY_PRESS_VAR"        : 0.0  ,
         "KEY_ACCMULATED_STEP"  : 0    ,
         "KEY_DISPLAY_STEP"     : 0    ,
         "KEY_PRESS"            : 0.0  ,
         "KEY_PULSE"            : 0    ]
    var PastFeature_10min:[Dictionary<String, Any>] = []//(repeating: Any, count: 10)
    var PastFeatureDic_10min:[String:Any] =
        ["KEY_TIME"             : 0    ,
         "KEY_NORM_VAR"         : 0.0  ,
         "KEY_X_VAR"            : 0.0  ,
         "KEY_Y_VAR"            : 0.0  ,
         "KEY_Z_VAR"            : 0.0  ,
         "KEY_X_MEAN"           : 0.0  ,
         "KEY_Y_MEAN"           : 0.0  ,
         "KEY_Z_MEAN"           : 0.0  ,
         "KEY_NORM_MEAN"        : 0.0  ,
         "KEY_NSTEP"            : 0    ,
         "KEY_JUMP_ROPE_SWING"  : 0    ,
         "KEY_SMALL_SWING"      : 0    ,
         "KEY_LARGE_SWING"      : 0    ,
         "KEY_PRESS_VAR"        : 0.0  ,
         "KEY_ACCMULATED_STEP"  : 0    ,
         "KEY_DISPLAY_STEP"     : 0    ,
         "KEY_PRESS"            : 0.0  ,
         "KEY_PULSE"            : 0    ]
    //규창 -- 코치 노말 스트레스 용
    var pStress_N:pStressNormal?
    let mStressNManger = StressNManager.getInstance()
    
    var url:URL?
    
    
    
    //규창 -- dfu 라이브러리를 사용하기 위해 선언한  델리게이트
    fileprivate var selectedFirmware: DFUFirmware?
    fileprivate var initiator: DFUServiceInitiator?
    
    // And somewhere to store the incoming data
    fileprivate var controller: DFUServiceController?
    fileprivate var delegate:DFUServiceDelegate?
    
    //An optional progress delegate will be called only during upload. It notifies about current upload percentage and speed.
    
    fileprivate var progressDelegate:DFUProgressDelegate?
    //The logger is an object that should print given messages to the user. It is optional.
 
    
    fileprivate var logger:LoggerDelegate?
    
    
    func logWith(_ level: LogLevel, message: String){
        print("\(level): \(message)")
    }
    
    func didStateChangedTo(_ state: DFUState) {
        print("DfuState: \(state)")
        switch(state){
        case .aborted:
            /*
             규창 --- 16.11.09 펌웨어 업그레이드 예외처리 Completed(), Aborted()
             델리게이트로 두 함수를 호출할 경우 FitnessMW에서 연결 회복할 수 있도록 CentralManager를 넘겨받을 수 있음.
             .Disconnect시엔 본 라이브러리에서 CentralManager를 물고 다른 처리를 요구 하기 때문에 위 두 함수중
             Abort를 호출하여 우리쪽으로 CentralManager를 넘김
             
             여기서는 CentralManaer연결을 초기화 하여 새로 맺음 참고는 Completed()
             */
            
            MWControlCenter.flagDFU = false
            let mgr = FileManager.default
            do {
                try mgr.removeItem(at: url!)
                url = nil
            } catch {
            }
            
            //규창 -- 성공했다면 사용중인 BLE, DFU에 사용된 모든 객체 초기화
            //controller!.restart()
            controller = nil
            selectedFirmware = nil
            initiator = nil
            delegate = nil
            progressDelegate = nil
            logger = nil
            //규창 -- 연결해제 후 새로 연결을 맺음
            print("Aborted")
            self.raiseDisconnect()
            let popTime = DispatchTime.now() + Double(Int64(60 * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)
            DispatchQueue.main.asyncAfter(deadline: popTime){
                self.centralManager = CBCentralManager(delegate: self, queue: nil, options: nil);
                self.pB = self
                //규창 -- 새로 연결 맺은 후 이상한데 연결되는것 방지
                self.raiseDisconnect()
                self.startBluetooth()
            }
            //규창 16.11.09 --- 펌웨어 업데이트 상태 정의
            MWNotification.postNotification(MWNotification.Bluetooth.FirmUpFaild);
        case .signatureMismatch:
            print("signatureMismatch")
        case .connecting:
            print("Connecting")
        case .starting:
            print("Starting")
        case .enablingDfuMode:
            print("EnablingDfuMode")
        case .uploading:
            print("Uploading")
        case .validating:
            print("Validating")
        case .disconnecting:
            print("Disconnecting")
        case .operationNotPermitted:
            print("operationNotPermitted")
        case .failed:
            MWControlCenter.flagDFU = false
            let mgr = FileManager.default
            do {
                try mgr.removeItem(at: url!)
                url = nil
            } catch {
            }
            //규창 -- 성공했다면 사용중인 BLE, DFU에 사용된 모든 객체 초기화
            //controller!.restart()
            controller = nil
            selectedFirmware = nil
            initiator = nil
            delegate = nil
            progressDelegate = nil
            logger = nil
            //규창 -- 연결해제 후 새로 연결을 맺음
            print("Failed")
            self.raiseDisconnect()
            let popTime = DispatchTime.now() + Double(Int64(60 * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)
            DispatchQueue.main.asyncAfter(deadline: popTime){
                self.centralManager = CBCentralManager(delegate: self, queue: nil, options: nil);
                self.pB = self
                //규창 -- 새로 연결 맺은 후 이상한데 연결되는것 방지
                self.raiseDisconnect()
                self.startBluetooth()
            }
            //규창 16.11.09 --- 펌웨어 업데이트 상태 정의
            MWNotification.postNotification(MWNotification.Bluetooth.FirmUpFaild);
        case .completed:
            
            //규창 -- 펌웨어 업데이트가 완료되어 DFU모드 플래그를 원상복구
            MWControlCenter.flagDFU = false
            let mgr = FileManager.default
            do {
                try mgr.removeItem(at: url!)
                url = nil
            } catch {
            }
            
            //규창 -- 성공했다면 사용중인 BLE, DFU에 사용된 모든 객체 초기화
            //controller!.restart()
            controller = nil
            selectedFirmware = nil
            initiator = nil
            delegate = nil
            progressDelegate = nil
            logger = nil
            //규창 -- 연결해제 후 새로 연결을 맺음
            print("Completed")
            self.raiseDisconnect()
            let popTime = DispatchTime.now() + Double(Int64(20 * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)
            DispatchQueue.main.asyncAfter(deadline: popTime){
                self.centralManager = CBCentralManager(delegate: self, queue: nil, options: nil);
                self.pB = self
                //규창 -- 새로 연결 맺은 후 이상한데 연결되는것 방지
                self.raiseDisconnect()
                self.startBluetooth()
            }
            //규창 16.11.09 --- 펌웨어 업데이트 상태 정의
            MWNotification.postNotification(MWNotification.Bluetooth.FirmUpComplete);
        
        }
    }
    func didErrorOccur(_ error: DFUError, withMessage message: String){
        print("Error \(error.rawValue): \(message)")
        logWith(LogLevel.error, message: message)
    }
    
    func onUploadProgress(_ part: Int, totalParts: Int, progress: Int, currentSpeedBytesPerSecond: Double, avgSpeedBytesPerSecond: Double){
        print("part:\(part)/totalParts:\(totalParts), progress:\(progress)%, Speed : \(String(format:"%.1f", avgSpeedBytesPerSecond/1024)) Kbps")
        
        
        /*
         let dic: [String:AnyObject] = ["cmd" : NSNumber(value: sender.LastSender.cmd.rawValue as UInt16), "start_time" : NSNumber(value: sender.LastSender.time as Int64)]
        Log.i(BluetoothLEManager.tag , msg: "칼로리:\(act_calorie), 강도L:\(intensityL) M:\(intensityM) H:\(intensityH) D:\(intensityD), 심박MIN:\(minHR), MAX:\(maxHR), AVG:\(avgHR)")
        MWNotification.postNotification(MWNotification.Bluetooth.ActivityInform, info: dic)
         */
        
        //규창 16.11.09 --- 펌웨어 업데이트 상태 정의
        let dic: [String:AnyObject] = ["progress": NSNumber(value:progress)]
        MWNotification.postNotification(MWNotification.Bluetooth.FirmUpProgress, info: dic)
        //print("Speed : \(String(format:"%.1f", avgSpeedBytesPerSecond/1024)) Kbps, pt. \(part)/\(totalParts)")
    }
    
    class func getInstance() -> BluetoothLEManager {
        return mBluetoothLEManager;
    }
    
    override init() {
        super.init()
        centralManager = CBCentralManager(delegate: self, queue: nil, options: [CBCentralManagerOptionShowPowerAlertKey : true, CBCentralManagerOptionRestoreIdentifierKey : "Coach+"]);
        
        pB = self
    }
    deinit{
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "FireVid"), object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "FireOnSensor"), object:nil)
        Log.i(BluetoothLEManager.tag, msg: "BluetoothLEManager 해제")
    }
    
    //static func getDataTime() -> long {return 0;}
    
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        print("\(#line) \(#function)")
        
        setCentralState(state: central)
        //scan()
    }
    
    func centralManager(_ central: CBCentralManager, willRestoreState dict: [String : Any]) {
        Log.i(BluetoothLEManager.tag, msg: "willRestoreState")
    }
   
    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {
        /* 
         규창 16.12.28 스캔시 안정적으로 rssi 값이 확보 되지 않으면 스캔에 잡히지 않도록 처리
         접속 후 감도값 -100넘을 때의 접속해제 루틴에 걸리는 신호감도 상황에서 접속요청-접속-서비스확인-페어링 행위를 하게 되면 접속이 완료되도
         밴드가 앱의 요청에 응답 안하는 현상(앱은 동기화 중 팝업이 뜨거나, 컨텐츠 시작, 종료가 정상적으로 안되는 등)발생
        */
        if abs(RSSI.int32Value) > 85 {
            return
        }
        Log.i(BluetoothLEManager.tag, msg: "Discovered peripheral:\(String(describing: peripheral.name)) ADV:\(String(describing: advertisementData["kCBAdvDataLocalName"])) at \(abs(RSSI.int32Value))")
        /////////////////
    
        
        //규창 17.01.24 기존에 DB에 기기 정보가 있고, "앱"을 통해 iOS와 페어링이 되있다면 스캔을 할 이유는 없다.
        //retrieveConnectedPeripherals는 UUID와 기기정보를 iOS에 저장해 스캔이라는 쓰루풋이 높은 행위를 하지 않고, 빠른 접속을 위해 사용한다고 한다.
        //17.01.24 까지 조사했을 동안 스캔까지 콜백 받아놓은 상태에서 retrieve를 호출하는 코어블루투스를 랩핑해서 사용하는 라이브러리, 예제는 발견하지 못했다 
        //아래 retrieve를 주석 처리해도 상관없는게 스캔해봤자 페어링 중에는 우리 기기 스캔리스트에 안 올라온다.
        //1회 주기에 스캔 실패하면 스캔 중지했다가 다시 스캔하면서 스캔 여는 단계에서 retrieve루틴에 걸려서 페어링된 기기와 접속한다.
        
        
        // 장치의 기본 정보 확인
        let saveName = Preference.getBluetoothName();
        Log.i(BluetoothLEManager.tag, msg: "saveName: \(String(describing: saveName))")
        /*if saveName != nil {
            if let connectedPeripheral = centralManager?.retrieveConnectedPeripherals(withServices: [DeviceUUID.CB_RX_SERVICE_UUID]) {
                Log.i(BluetoothLEManager.tag, msg: "connectedPeripheral: \(connectedPeripheral)")
                for retrieve in connectedPeripheral {
                    Log.w(BluetoothLEManager.tag, msg: "from system get device : \(retrieve.name). \(retrieve)");
                    if saveName == retrieve.name {
                        // 장치 정보와 페어링 정보가 일치하는 경우. 그냥 접속.
                        print("matched device name. connect!!")
                        requestConnect(retrieve: retrieve)
                        return
                    }
                    print("not matched device name. break...  need reset pairing device")
                }
                //if !connectedPeripheral.isEmpty {
                //    if let retrieve = connectedPeripheral.first {
                //        Log.w(BluetoothLEManager.tag, msg: "from system get device : \(retrieve.name).");
                //        if saveName == retrieve.name {
                //            // 장치 정보와 페어링 정보가 일치하는 경우. 그냥 접속.
                //            print("matched device name. connect!!")
                //            requestConnect(retrieve: retrieve)
                //            return
                //        }
                //        print("not matched device name. break...  need reset pairing device")
                //    }
                //}
            }
        }*/
        
        guard let name = advertisementData["kCBAdvDataLocalName"] as? String else {
        //guard let name = peripheral.name else {
            return;
        }
        // 장치 명칭이 없는 경우 리턴
        //if name == nil {return;}
        // 검색된 장치가 리스트에 없으면 추가한다.
        // set은 중복을 허용하지 않음.
        //if arList.contains(addr) == true {return;}
        let rec = DeviceRecord(peripheral: peripheral, name: name, rssi: RSSI);
        arList.insert(rec);
        if getScanMode() == ScanMode.manual {
            MWNotification.postNotification(MWNotification.Bluetooth.GenerateScanList);
            return;
        }
        
        // 이미 연결이 성립된 경우 리턴
        if isConnect() == true {return;}
        // 저장된 장치 주소가 없는 경우 리턴
        if saveName == nil {return;}
        
/* 
 규창 --- 멋대로 이름 찾아 접속
         DFU모드<->서비스모드 전환이 빠르지 않아 접속, 스캔시 현재 이름과 UUID비교 후 서로 틀리면 IOS가 디바이스 이름과 UUID를 갱신해야함
         저장된 장치 주소와 검색된 장치 주소가 동일하지 않으면 리턴
 */
        let dfu = (name == DeviceBaseScan.DEVICE_NAME_START_DFUT && MWControlCenter.flagDFU)

        if !(saveName == name) {
            if !dfu {
                return;
            }
        }
        
        //if !(saveName == name) {peripheral.delegate?.peripheralDidUpdateName!(peripheral);}
        //if !(peripheral.name != name) {peripheral.delegate?.peripheralDidUpdateName!(peripheral)}
        
        // 장치 명칭이 플래너 장치 형식이면 연결요청
        let tmp_name = name.substringToIndex(DeviceBaseScan.SELECTED_DEVICE_NAME.length);
        let tmp_name_dfu = name.substringToIndex(DeviceBaseScan.DEVICE_NAME_START_DFUT.length);
        
        Log.i(BluetoothLEManager.tag, msg: "뭘로 들어갈래? name\(name) tmp_name \(String(describing: tmp_name)), tmp_name_dfu\(String(describing: tmp_name_dfu))")
        if tmp_name == DeviceBaseScan.SELECTED_DEVICE_NAME {
            //reset_active = true;
            Log.i(BluetoothLEManager.tag, msg: "Service로 들어가라")
            requestConnect(name, rssi: RSSI);
            return;
        } else if tmp_name_dfu == DeviceBaseScan.DEVICE_NAME_START_DFUT && MWControlCenter.flagDFU {
            //reset_active = false;
            Log.i(BluetoothLEManager.tag, msg: "DFU로 들어가라")
            requestConnect(name, rssi: RSSI);
        }
    }
    
    
    
    
    func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
        Log.i(BluetoothLEManager.tag, msg: "Peripheral Connected")
        
        // Stop scanning
        //centralManager?.stopScan()
        //Log.i(BluetoothLEManager.tag, msg: "Scanning stopped")
        
        // Make sure we get the discovery callbacks
        peripheral.delegate = self
        
        Log.i(BluetoothLEManager.tag, msg: "Connected to GATT server.");
        // connection이 이루어진 후, stack에 600ms의 여유시간을 준다.
        usleep(600000);
        
        // Search only for services that match our UUID
        // peripheral.discoverServices([transferServiceUUID])
        //peripheral.discoverServices([DeviceUUID.transferServiceUUID])
        peripheral.discoverServices(nil);
        
        //getService = false;
        
        // Attempts to discover services after successful connection.
        Log.i(BluetoothLEManager.tag, msg: "Attempting to start service discovery:");
        
        Log.d(BluetoothLEManager.tag, msg: "Connection to Clear buffer");
    
        scanLeDevice(false);
        //cancelScanTimer(); // 처음 붙는 경우만 쓸모 있음. 추후 동작에는 불필요해보임.
        
        sender.start()
        
//        sender.append((.State, 0, .Start, true))
//        sender.append((.State, 1, .Start, true))
//        sender.append((.State, 2, .Start, true))
//        sender.append((.State, 3, .Start, true))
//        sender.append((.State, 4, .Start, true))
//        sender.append((.State, 5, .Start, true))
//        sender.append((.State, 6, .Start, true))
//        sender.append((.State, 7, .Start, true))
//        sender.append((.State, 8, .Start, true))
//        sender.append((.State, 9, .Start, true))
        
        if DeviceBaseScan.SELECTED_DEVICE_NAME == ProductCode.fitness.bluetoothDeviceName {
            sender.append((.state, 0, .start, true, .empty))
            sender.append((.userData, 0, .start, false, .empty)) // no resp
            sender.append((.rtc, 0, .start, false, .empty)) // no resp
            sender.append((.battery, 0, .start, true, .empty))
            startTimer(GetStepCalorieTimer, delay: 0, period: 60000);
            sender.append((.noticeONOFF, 0, Preference.NoticePhoneONOFF ? RequestAction.start : RequestAction.end, false, .phone))
            sender.append((.noticeONOFF, 0, Preference.NoticeSmsONOFF ? RequestAction.start : RequestAction.end, false, .sms))
            sender.append((.version, 0, .start, true, .empty))
        } else if DeviceBaseScan.SELECTED_DEVICE_NAME == ProductCode.coach.bluetoothDeviceName {
//            sender.append((.UserData, 0, .Start, false)) // no resp
//            sender.append((.RTC, 0, .Start, false)) // no resp
            sender.append((.battery, 0, .start, true, .empty))
            sender.append((.version, 0, .start, true, .empty))
            mDatabase.HeartRateStable = 0
        }
        
        raiseConnectionState(ConnectStatus.state_CONNECTED);
        
        cancelConnectTimer();
        startRssiTimer();
        
        /*if(Preference.getConnectedTime()==0) {
            Preference.putConnectedTime(Int32(DataControlBase.getConvertedTime(MWCalendar.currentTimeMillis())));
        }*/
    }
    
    func centralManager(_ central: CBCentralManager, didDisconnectPeripheral peripheral: CBPeripheral, error: Error?) {
        Log.i(BluetoothLEManager.tag, msg: "Peripheral Disconnected")
        Log.i(BluetoothLEManager.tag, msg: "Disconnected from GATT server.");
        discoveredPeripheral = nil
        
        raiseDisconnect()
    }
    
    func centralManager(_ central: CBCentralManager, didFailToConnect peripheral: CBPeripheral, error: Error?) {
        Log.i(BluetoothLEManager.tag, msg: "Failed to connect to \(peripheral). (\(error!.localizedDescription))")
        
        cleanup()
    }
    
    func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?) {
        if let error = error {
            Log.i(BluetoothLEManager.tag, msg: "Error discovering services: \(error.localizedDescription)")
            cleanup()
            Log.i(BluetoothLEManager.tag, msg: "\(DeviceUUID.RX_SERVICE_UUID)")
            return
        }
        
        // Discover the characteristic we want...
        
        // Loop through the newly filled peripheral.services array, just in case there's more than one.
        for service in peripheral.services! {
//규창 DFU모드<->서비스모드 전환이 빠르지 않아 접속, 스캔시 현재 이름과 UUID비교 후 서로 틀리면 IOS가 디바이스 이름과 UUID를 갱신해야함
            if (service.uuid.isEqual(DeviceUUID.CB_RX_SERVICE_UUID))
            {
                Log.i(BluetoothLEManager.tag, msg: "Servicediscover")
                //peripheral.discoverCharacteristics([DeviceUUID.transferServiceUUID], forService: service as CBService)
                peripheral.discoverCharacteristics(nil, for: service as CBService)
                print("\(DeviceUUID.RX_SERVICE_UUID)")
            }
            if (service.uuid.isEqual(DeviceUUID.DFU_SERVICE_UUID) && peripheral.name == DeviceBaseScan.DEVICE_NAME_START_DFUT)
            {
                Log.i(BluetoothLEManager.tag, msg: "DFUdiscover")
                //peripheral.discoverCharacteristics([DeviceUUID.transferServiceUUID], forService: service as CBService)
                peripheral.discoverCharacteristics(nil, for: service as CBService)
                print("\(DeviceUUID.DFU_SERVICE_UUID)")
            }
            if (service.uuid.isEqual(DeviceUUID.CB_RX_SERVICE_UUID) && peripheral.name == DeviceBaseScan.DEVICE_NAME_START_DFUT)
            {
                Log.i(BluetoothLEManager.tag, msg: "ServiceUUID&DFUname \(service.uuid) \(String(describing: peripheral.name))")
                peripheral.delegate?.peripheralDidUpdateName!(peripheral)
                
            }
            if (service.uuid.isEqual(DeviceUUID.DFU_SERVICE_UUID) && peripheral.name == DeviceBaseScan.DEVICE_NAME_START_DFUT) {
                Log.i(BluetoothLEManager.tag, msg: "DFUUUID&ServiceNAMEl\(service.uuid) \(String(describing: peripheral.name))")
                peripheral.delegate?.peripheralDidUpdateName!(peripheral)
            }
            //else{
            //    peripheral.delegate?.peripheralDidUpdateName!(peripheral)
            //}
        }
    }
    
    func peripheral(_ peripheral: CBPeripheral, didReadRSSI RSSI: NSNumber, error: Error?) {
        //규창 RSSI읽기위한 용도
        //MWControlCenter.thisRSSI = RSSI
        //Log.i(BluetoothLEManager.tag, msg: "thisRSSI: \(MWControlCenter.thisRSSI) \(RSSI)")
        //규창 RSSI읽기위한 용도
        if isRssiDisconnect(RSSI) {
            disconnectReasonRSSI();
        }
    }
    
    
    func peripheral(_ peripheral: CBPeripheral, didDiscoverCharacteristicsFor service: CBService, error: Error?) {
        // Deal with errors (if any)
        if let error = error {
            Log.i(BluetoothLEManager.tag, msg: "Error discovering services: \(error.localizedDescription)")
            cleanup()
            return
        }
        // Again, we loop through the array, just in case.
        //if(service.UUID .isEqual([DeviceUUID.transferServiceUUID])){
        for characteristic in service.characteristics as [CBCharacteristic]! {
            // And check if it's the right one
            peripheral.readValue(for: characteristic)
            peripheral.setNotifyValue(true, for: characteristic)
            if characteristic.uuid == DeviceUUID.CB_TX_CHAR_UUID {
                // If it is, subscribe to it
                Log.i(BluetoothLEManager.tag, msg: "FOund TXCHAR \(characteristic.uuid)")
                m_Characteristic = characteristic
                //mDeviceBaseTrans?.sendSerial()
            }
            else if characteristic.uuid == DeviceUUID.CB_RX_CHAR_UUID {
                //peripheral.discoverDescriptors(for: characteristic)
                m_Characteristic = characteristic
                Log.i(BluetoothLEManager.tag, msg: "FOund RXCHAR \(characteristic.uuid)")
                //mDeviceBaseTrans?.sendSerial()
            }

            //규창 --- DFU UUID판별 코드
            else if characteristic.uuid == DeviceUUID.DFU_PACKET_UUID {
                // If it is, subscribe to it
                print("FOund DFU_PACKET_UUID \(characteristic.uuid)")
            }
            else if characteristic.uuid == DeviceUUID.DFU_CONTROL_POINT_UUID {
                print("FOund DFU_CONTROL_POINT_UUID \(characteristic.uuid)")
                discoveredPeripheral = peripheral
                update()
            }
                
            else if characteristic.uuid == DeviceUUID.DFU_VERSION {
                print("FOund DFU_VERSION \(characteristic.uuid)")
                peripheral.setNotifyValue(true, for: characteristic)

            }
        }
        
        sender.isReady = true
        //}
        // Once this is complete, we just need to wait for the data to come in.
    }
    
    func peripheral(_ peripheral: CBPeripheral, didUpdateValueFor characteristic: CBCharacteristic, error: Error?) {
        if let error = error {
            Log.i(BluetoothLEManager.tag, msg: "Error discovering services: \(error.localizedDescription)")
            return
        }
        Log.i(BluetoothLEManager.tag, msg: "didUpdateValueFor = \(peripheral) \(characteristic)")
        //DispatchQueue.main.async {
            self.getDataFrame(peripheral, didUpdateValueFor: characteristic, error: error)
        //}
        
    }
    
    
    /** Call this when things either go wrong, or you're done with the connection.
     *  This cancels any subscriptions if there are any, or straight disconnects if not.
     *  (didUpdateNotificationStateForCharacteristic will cancel the connection if a subscription is involved)
     */
    func cleanup() {
        // Don't do anything if we're not connected
        // self.discoveredPeripheral.isConnected is deprecated
        if discoveredPeripheral?.state != CBPeripheralState.connected { // explicit enum required to compile here?
            return
        }
        
        // See if we are subscribed to a characteristic on the peripheral
        if let services = discoveredPeripheral?.services as [CBService]? {
            for service in services {
                if let characteristics = service.characteristics as [CBCharacteristic]? {
                    for characteristic in characteristics {
                        if characteristic.uuid.isEqual([CBUUID(string: DeviceUUID.TX_CHAR_UUID)]) && characteristic.isNotifying {
                            discoveredPeripheral?.setNotifyValue(false, for: characteristic)
                            // And we're done.
                            return
                        }
                    }
                }
            }
        }
        
        // If we've got this far, we're connected, but we're not subscribed, so we just disconnect
        centralManager?.cancelPeripheralConnection(discoveredPeripheral!)
    }
    
    func setCentralState(state: CBCentralManager) {
        switch state.state {
        case .poweredOff:
            Log.i(BluetoothLEManager.tag, msg: "powered off")
            raiseDisconnect()
        case .poweredOn:
            Log.i(BluetoothLEManager.tag, msg: "powered on")
            if isLiveApp() {
                if mScanning {
                    scanLeDevice(false)
                }
                scanLeDevice(true)
            }
        case .resetting:
            Log.i(BluetoothLEManager.tag, msg: "Resetting")
        case .unauthorized:
            Log.i(BluetoothLEManager.tag, msg: "Unauthorized")
        case .unsupported:
            Log.i(BluetoothLEManager.tag, msg: "Unsupported")
        case .unknown:
            Log.i(BluetoothLEManager.tag, msg: "Unknown")
        }
    }
    
    override func startBluetooth() -> Int32 {
        startScanTimer();
        Log.d(BluetoothLEManager.tag, msg: "startBluetooth");
        
        return BluetoothLEManager.SUCCESS;
    }
    
    func stopBluetooth() {
        Log.d(BluetoothLEManager.tag, msg: "stopBluetooth");
        
        cancelScanTimer();
        //cancelRssiTimer();
        cancelConnectTimer();
        
        scanLeDevice(false);
        
//        if getConnectionState() != ConnectStatus.STATE_DISCONNECTED {
            disconnect()
//        }
    }
    
    func connect() {
        print("Connecting to peripheral \(String(describing: discoveredPeripheral))")
        
        
        centralManager?.connect(discoveredPeripheral!, options: [CBConnectPeripheralOptionNotifyOnDisconnectionKey:true])
        //centralManager?.connect(discoveredPeripheral!, options: nil);
    }
    //===============================================================================================================
    fileprivate func disconnect() {
        if discoveredPeripheral?.state != CBPeripheralState.connected { // explicit enum required to compile here?
            return;
        }
        
        Log.d(BluetoothLEManager.tag, msg: "disconnect!!!!")
        centralManager?.cancelPeripheralConnection(discoveredPeripheral!);
    }
    
    
    // 이하는 coach+용으로 새로 추가될 기능
    //********************************************//
    override func setIsLiveApp(_ isLiveApp: Bool) {
        self.isLiveAppFlag = isLiveApp;
        /*if(!isEnabled()) {
         // 블루투스 사용이 불가한 경우.
         stopBluetooth();
         return;
         }*/
        
        scanLeDevice(false);
        if(isLiveApp) {
            // 앱 O
            /**
             * 앱 실행되면, live-timer, connect-timer 중지. scan-timer 동작.
             */

            cancelConnectTimer();
            startScanTimer();
        } else {
            cancelScanTimer();
            startConnectTimer(); // live timer 시작은 데이터를 받으면서 진행해야함. 그래야 데이터 받는 시간과 disconnect를 동기화 가능.
        }
    }
    
    /**
     * 블루투스 시작 성공
     */
    static let SUCCESS: Int32 = 0;
    /**
     * 블루투스 시작 실패
     */
    static let FAILED: Int32 = 1;
    
    fileprivate var isLiveAppFlag = false
    fileprivate var timeZoneOffset: Int16 = 0
    func getTimeZoneOffset() -> Int16 {
        return timeZoneOffset
    }
    
    func setTimeZoneOffset(Init offset : Int16) {
        if timeZoneOffset == offset {
            return;
        }
        
        timeZoneOffset = offset;
    }
    
    func setTimeZoneOffset(_ offset : Int16) {
        if timeZoneOffset == offset {
            return;
        }
        
        Global_Calendar!.setTimeZone(TimeZone.current);
        // time zone 변경 올때마다 rtc 전송해야함. 연결 되어 있지 않으면???->한번 연결 하자.
        if discoveredPeripheral == nil && getConnectionState() != ConnectStatus.state_CONNECTED {
            if isLiveAppFlag {
                startBluetooth();
            } else {
                tryBluetooth();
            }
        } else {
            // 연결되어있으면? 그냥 바로 rtc 전송. 이 경우, 밴드의 처리를 어떻게 할 것인가에 따라 달라질듯...
            //밴드가 모든 데이터를 다 처리한다 그러면, 연결 도중 rtc를 전송. 데이터를 reset 한다면, re connect
            /** 펌웨어 처리 부분. 나중에 수정해야함. 현재는 들어갈일 없음.**/
            disconnect();
            //waitUntilDisconnected();
            
            cancelScanTimer();
            if getScanMode() == .auto {
                if isLiveApp() {
                    startBluetooth()
                } else {
                    startConnectTimer()
                }
            }
        }
        
        timeZoneOffset = offset;
    }
    
    func isLiveApp() -> Bool {
        return isLiveAppFlag;
    }
    
    override func tryBluetooth() -> Int32 {
        if !isConnect() {
            if discoveredPeripheral?.state == CBPeripheralState.connected { // explicit enum required to compile here?
                centralManager!.cancelPeripheralConnection(discoveredPeripheral!);
                
                discoveredPeripheral = nil;
                m_Characteristic = nil;
                mBluetoothDeviceName = nil;
            }
            Log.d(BluetoothLEManager.tag, msg: "tryBluetooth->scan");
            scanLeDevice(true);
        }
        
        return BluetoothLEManager.SUCCESS;
    }
    
    func connect(retrieve peripheral: CBPeripheral) -> Bool {
        // We want to directly connect to the device, so we are setting the
        // autoConnect parameter to false.
        //mBluetoothGatt = device.connectGatt(mContext, true, mGattCallback);
        raiseConnectionState(ConnectStatus.state_CONNECTING);
        let discoveredPeripheral = peripheral
        
        Log.i(BluetoothLEManager.tag, msg: "Connecting to retrieveperipheral \(discoveredPeripheral)");
        if discoveredPeripheral.state != CBPeripheralState.connected {
            if discoveredPeripheral != self.discoveredPeripheral {
                // Save a local copy of the peripheral, so CoreBluetooth doesn't get rid of it
                self.discoveredPeripheral?.delegate = discoveredPeripheral.delegate;
                self.discoveredPeripheral = discoveredPeripheral;
            }
            
            centralManager?.connect(self.discoveredPeripheral!, options:[CBConnectPeripheralOptionNotifyOnDisconnectionKey:true]);
            //centralManager?.connect(self.discoveredPeripheral!, options:nil);
            mBluetoothDeviceName = discoveredPeripheral.name!;
            setScanMode(ScanMode.auto)
            Log.d(BluetoothLEManager.tag, msg: "Trying to create a new connection. : \(String(describing: mBluetoothDeviceName))");
        } else {
            Log.d(BluetoothLEManager.tag, msg: "already create a connection.");
            raiseConnectionState(ConnectStatus.state_CONNECTED);
            //reconnect = true;
        }
        //mBluetoothDeviceAddress = address;
        
        //Log.i(tag,bt_connected);
        
        return true;
    }
    
    func connect(_ name: String) -> Bool {
        guard let discoveredPeripheral = getDevice(name) else {
            Log.w(BluetoothLEManager.tag, msg: "Device not found.  Unable to connect.");
            return false;
        }
        
        // We want to directly connect to the device, so we are setting the
        // autoConnect parameter to false.
        //mBluetoothGatt = device.connectGatt(mContext, true, mGattCallback);
        raiseConnectionState(ConnectStatus.state_CONNECTING);
        
        Log.i(BluetoothLEManager.tag, msg: "Connecting to peripheral \(discoveredPeripheral)");
        if discoveredPeripheral.state != CBPeripheralState.connected {
            if discoveredPeripheral != self.discoveredPeripheral {
                // Save a local copy of the peripheral, so CoreBluetooth doesn't get rid of it
                self.discoveredPeripheral?.delegate = discoveredPeripheral.delegate;
                self.discoveredPeripheral = discoveredPeripheral;
            }
            
            centralManager?.connect(self.discoveredPeripheral!, options:[CBConnectPeripheralOptionNotifyOnDisconnectionKey:true]);
            //centralManager?.connect(self.discoveredPeripheral!, options: nil);
            mBluetoothDeviceName = name;
            setScanMode(ScanMode.auto)
            Log.d(BluetoothLEManager.tag, msg: "Trying to create a new connection. : \(String(describing: mBluetoothDeviceName))");
        } else {
            Log.d(BluetoothLEManager.tag, msg: "already create a connection.");
            raiseConnectionState(ConnectStatus.state_CONNECTED);
            //reconnect = true;
        }
        //mBluetoothDeviceAddress = address;
        
        //Log.i(tag,bt_connected);
        
        return true;
    }
    
    func startTimer(_ timer: MWTimer, delay: TimeInterval) {
        timer.start(delay, repeats: false)
    }
    
    func startTimer(_ timer: MWTimer, delay: TimeInterval, period: TimeInterval) {
        timer.start(delay, period: period)
    }
    
    fileprivate func disconnectReasonRSSI() {
        Log.d(BluetoothLEManager.tag, msg: "disconnectReasonRSSI");
        disconnect()
    }
    
    fileprivate func raiseDisconnect() {
        Log.i(BluetoothLEManager.tag, msg: "raise Disconnected")
        sender.isReady = false
        sender.cancel()

        GetStepCalorieTimer.cancel()
        cancelRssiTimer()
        //cancelScanTimer()
        
        discoveredPeripheral = nil;
        m_Characteristic = nil;
        
        raiseConnectionState(ConnectStatus.state_DISCONNECTED);
        
        //접속을 어떻게 할것인지..바로 접속? 아니면, 접속을 얼마동안 지속하고 안되면 딜레이 증가???
        if getScanMode() == .auto {
            if isLiveApp() {
                startBluetooth()
            } else {
                startConnectTimer()
            }
        }
    }
    
    func write(_ discoveredPeripheral: CBPeripheral?, data: Data, forCharacteristic: CBCharacteristic?, type: CBCharacteristicWriteType) {
        if discoveredPeripheral == nil || forCharacteristic == nil {
            return
        }
        
        if BluetoothLEManager.DEBUG {
            Log.i(BluetoothLEManager.tag, msg: "*****write start len:\(data.count)*****");
            var tmpString: String = "";
            
            var byte: [UInt8] = [UInt8](repeating: 0, count: data.count);
            
            (data as NSData).getBytes(&byte, length: byte.count);
            for b in byte {
                tmpString += String(b, radix: 16) + " ";
            }
            Log.i(BluetoothLEManager.tag, msg: tmpString);
            Log.i(BluetoothLEManager.tag, msg: "*****write end*****\n");
        }
        discoveredPeripheral!.writeValue(data , for: forCharacteristic!, type: type)
    }
    
    fileprivate func getString(_ frame: [UInt8], loc: Int, len: Int) -> String {
        var local = frame
        local.removeSubrange(0..<loc)
        
        return String(bytes: local, encoding: String.Encoding.utf8)!
    }
    
    fileprivate func getDataInt(_ frame: [UInt8], loc: Int, len: Int) -> Int32 {
        var ret: Int32 = 0
        for i in loc..<loc+len {
            ret |= Int32(Int32(frame[i] & 0xff) << Int32(8*(i-loc)))
        }
        
        return ret
    }
    
    fileprivate func getDataShort(_ frame: [UInt8], loc: Int, len: Int) -> Int16 {
        var ret: Int16 = 0
        for i in loc..<loc+len {
            ret |= Int16(Int16(frame[i] & 0xff) << Int16(8*(i-loc)))
        }
        
        return ret
    }
    
    override func getDataFrame(_ peripheral: CBPeripheral, didUpdateValueFor characteristic: CBCharacteristic, error: Error?) {
        
        let tmp = characteristic.uuid;
        if tmp == DeviceUUID.CB_TX_CHAR_UUID {
            guard let nsDATA = characteristic.value else {
                return
            }
            
            let fLen = nsDATA.count // MemoryLayout<UInt8>.size
            var getFrame = [UInt8](repeating: 0, count: fLen)
            Log.i(BluetoothLEManager.tag, msg: "nsDATA = \(peripheral.maximumWriteValueLength(for: CBCharacteristicWriteType.withoutResponse)) \(String(describing: String(data:nsDATA, encoding: String.Encoding.utf8)))")
            //nsDATA.copyBytes(to:&getFrame, count: fLen * MemoryLayout<UInt8>.size)
            (nsDATA as NSData).getBytes(&getFrame, length: fLen)

            
            var temp_cmd: UInt16 = 0
            let product = DeviceBaseScan.SELECTED_DEVICE_NAME
            if product == ProductCode.fitness.bluetoothDeviceName {
                //규창 171018 Swift4 컨버팅 이후 밴드와의 첫 연결 이후 characteristic.value의 0번지에서 255라는 값이 응답되고 있음,
                //이로 인해 아래의 루틴에서 앱 크러시가 나므로 일단은 앱단에서 예외처리
                if getFrame.count <= 1{
                    Log.i(BluetoothLEManager.tag, msg:"error getFrame.count enough filled \(getFrame.count)")
                    return
                }
                temp_cmd = UInt16(getFrame[0]) | UInt16(getFrame[1] & 0xff) << 8
            } else if product == ProductCode.coach.bluetoothDeviceName {
                temp_cmd = UInt16(getFrame[0])
                if temp_cmd == BluetoothCommand.coachReceiveAcc.rawValue {
                   temp_cmd = BluetoothCommand.acc.rawValue
                }
            }
            
            guard let cmd = BluetoothCommand(rawValue: temp_cmd) else {
                return
            }
            
            if sender.compare(cmd) {
                sender.resetBusy()
            }
            
            if BluetoothLEManager.DEBUG {
                //규창 RSSI읽기위한 용도
                //peripheral.readRSSI()
                Log.i(BluetoothLEManager.tag, msg: "*****read start len:\(nsDATA.count) rssi:\(MWControlCenter.thisRSSI)*****");
                var tmpString: String = "";
                for b in getFrame {
                    tmpString += String(b, radix: 16) + " ";
                }
                Log.i(BluetoothLEManager.tag, msg: tmpString);
                Log.i(BluetoothLEManager.tag, msg: "*****read end*****\n");
            }
            
            switch cmd {
            case .battery:
                if product == ProductCode.fitness.bluetoothDeviceName {
                    mDatabase.Battery.status = getDataShort(getFrame, loc: 2, len: 2)
                    mDatabase.Battery.voltage = getDataShort(getFrame, loc: 4, len: 2)
                } else if product == ProductCode.coach.bluetoothDeviceName {
                    mDatabase.Battery.status = Int16(getFrame[3])
                    mDatabase.Battery.voltage = Int16(getFrame[6])
                }
                
                MWNotification.postNotification(MWNotification.Bluetooth.Battery)
            case .acc:
                var x1 = 0.0
                var y1 = 0.0
                var z1 = 0.0
                var hr1: Int16 = 0
                
                var x2 = 0.0
                var y2 = 0.0
                var z2 = 0.0
                var hr2: Int16 = 0
                if product == ProductCode.fitness.bluetoothDeviceName {
                    x1 = Double(getDataShort(getFrame, loc: 2, len: 2)) / 100 * 2
                    y1 = Double(getDataShort(getFrame, loc: 4, len: 2)) / 100 * 2
                    z1 = Double(getDataShort(getFrame, loc: 6, len: 2)) / 100 * 2
                    hr1 = getDataShort(getFrame, loc: 8, len: 2)
                    
                    x2 = Double(getDataShort(getFrame, loc: 10, len: 2)) / 100 * 2
                    y2 = Double(getDataShort(getFrame, loc: 12, len: 2)) / 100 * 2
                    z2 = Double(getDataShort(getFrame, loc: 14, len: 2)) / 100 * 2
                    hr2 = getDataShort(getFrame, loc: 16, len: 2)
                } else if product == ProductCode.coach.bluetoothDeviceName {
                    x1 = Double(getDataShort(getFrame, loc: 2, len: 2)) / 100 * 2
                    y1 = Double(getDataShort(getFrame, loc: 4, len: 2)) / 100 * 2
                    z1 = Double(getDataShort(getFrame, loc: 6, len: 2)) / 100 * 2
                    
                    x2 = Double(getDataShort(getFrame, loc: 10, len: 2)) / 100 * 2
                    y2 = Double(getDataShort(getFrame, loc: 12, len: 2)) / 100 * 2
                    z2 = Double(getDataShort(getFrame, loc: 14, len: 2)) / 100 * 2
                    hr1 = Int16(getFrame[18])
                    hr2 = Int16(getFrame[19])
                }
                
                sensorData1 = [Double(x1), Double(y1), Double(z1), Double(hr1)]
                sensorData2 = [Double(x2), Double(y2), Double(z2), Double(hr2)]
                nNF?.onSensor(sensorData1)
                
                
                Log.i(BluetoothLEManager.tag, msg: "\(sensorData1)")
                Log.i(BluetoothLEManager.tag, msg: "\(sensorData2)")
                //규창 --- 코치 노말 스트레스측정 추가
                if mStressNManger?.isMeasuring == true {
                    //mStressNManger.isMeasuring = true
                    //Log.i(BluetoothLEManager.tag, msg: "\(sensorData1)")
                    pStress_N?.onstressHr(sensorData1[3])
                    //mStressNManger.isMeasuring = false
                }
                let delay = DispatchTime.now() + Double(Int64(0.05 * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)
                DispatchQueue.main.asyncAfter(deadline: delay) {
                    self.nNF?.onSensor(self.sensorData2)
                    if self.mStressNManger?.isMeasuring == true {
                        //self.mStressNManger.isMeasuring = true
                        //Log.i(BluetoothLEManager.tag, msg: "\(self.sensorData2)")
                        self.pStress_N?.onstressHr(self.sensorData2[3])
                        //self.mStressNManger.isMeasuring = false
                    }
                }
                
            case .stepCount_Calorie:
                mDatabase.Step = getDataShort(getFrame, loc: 2, len: 2)
                mDatabase.TotalActivityCalorie = Double(getDataInt(getFrame, loc: 4, len: 4)) / 1000
                mDatabase.TotalSleepCalorie = Double(getDataInt(getFrame, loc: 8, len: 4)) / 1000
                mDatabase.TotalDailyCalorie = Double(getDataInt(getFrame, loc: 12, len: 4)) / 1000
                mDatabase.TotalCoachCalorie = Double(getDataInt(getFrame, loc: 16, len: 4)) / 1000
                MWNotification.postNotification(MWNotification.Bluetooth.StepCountNCalorie)
                
                //규창 171016 피쳐데이터 요청
                requestFeature(reqtime: MWCalendar.currentTimeMillis())
            case .activity:
                let act_calorie = Double(getDataInt(getFrame, loc: 2, len: 4)) / 1000
                let intensityL = getDataShort(getFrame, loc: 6, len: 2)
                let intensityM = getDataShort(getFrame, loc: 8, len: 2)
                let intensityH = getDataShort(getFrame, loc: 10, len: 2)
                let intensityD = getDataShort(getFrame, loc: 12, len: 2)
                let minHR = getDataShort(getFrame, loc: 14, len: 2)
                let maxHR = getDataShort(getFrame, loc: 16, len: 2)
                let avgHR = getDataShort(getFrame, loc: 18, len: 2)
                mDatabase.ActivityData = (act_calorie, intensityL, intensityM, intensityH, intensityD, minHR, maxHR, avgHR)
                
                let dic: [String:AnyObject] = ["cmd" : NSNumber(value: sender.LastSender.cmd.rawValue as UInt16), "start_time" : NSNumber(value: sender.LastSender.time as Int64)]
                Log.i(BluetoothLEManager.tag , msg: "칼로리:\(act_calorie), 강도L:\(intensityL) M:\(intensityM) H:\(intensityH) D:\(intensityD), 심박MIN:\(minHR), MAX:\(maxHR), AVG:\(avgHR)")
                MWNotification.postNotification(MWNotification.Bluetooth.ActivityInform, info: dic)
            case .sleep:
                let rolled = getDataShort(getFrame, loc: 2, len: 2)
                let awaken = getDataShort(getFrame, loc: 4, len: 2)
                let stabilityHR = getDataShort(getFrame, loc: 6, len: 2)
                mDatabase.SleepData = (rolled, awaken, stabilityHR)
                Log.i(BluetoothLEManager.tag , msg: "뒤척임:\(rolled), 일어남:\(awaken), 안정심박:\(stabilityHR)")
                let dic: [String:AnyObject] = ["cmd" : NSNumber(value: sender.LastSender.cmd.rawValue as UInt16), "start_time" : NSNumber(value: sender.LastSender.time as Int64)]
                mDatabase.HeartRateStable = stabilityHR
                
                MWNotification.postNotification(MWNotification.Bluetooth.SleepInform, info: dic)
            case .stress:
                //규창 --- 16.10.24 fitness스트레스 측정 Firm -> App 대치
                
                //mDatabase.Stress = getDataShort(getFrame, loc: 2, len: 2)
                //MWNotification.postNotification(MWNotification.Bluetooth.StressInform)
                var x1 = 0.0
                var y1 = 0.0
                var z1 = 0.0
                var hr1: Int16 = 0
                
                var x2 = 0.0
                var y2 = 0.0
                var z2 = 0.0
                var hr2: Int16 = 0
                if product == ProductCode.fitness.bluetoothDeviceName {
                    x1 = Double(getDataShort(getFrame, loc: 2, len: 2)) / 100 * 2
                    y1 = Double(getDataShort(getFrame, loc: 4, len: 2)) / 100 * 2
                    z1 = Double(getDataShort(getFrame, loc: 6, len: 2)) / 100 * 2
                    hr1 = getDataShort(getFrame, loc: 8, len: 2)
                    
                    x2 = Double(getDataShort(getFrame, loc: 10, len: 2)) / 100 * 2
                    y2 = Double(getDataShort(getFrame, loc: 12, len: 2)) / 100 * 2
                    z2 = Double(getDataShort(getFrame, loc: 14, len: 2)) / 100 * 2
                    hr2 = getDataShort(getFrame, loc: 16, len: 2)
                } else if product == ProductCode.coach.bluetoothDeviceName {
                    x1 = Double(getDataShort(getFrame, loc: 2, len: 2)) / 100 * 2
                    y1 = Double(getDataShort(getFrame, loc: 4, len: 2)) / 100 * 2
                    z1 = Double(getDataShort(getFrame, loc: 6, len: 2)) / 100 * 2
                    
                    x2 = Double(getDataShort(getFrame, loc: 10, len: 2)) / 100 * 2
                    y2 = Double(getDataShort(getFrame, loc: 12, len: 2)) / 100 * 2
                    z2 = Double(getDataShort(getFrame, loc: 14, len: 2)) / 100 * 2
                    hr1 = Int16(getFrame[18])
                    hr2 = Int16(getFrame[19])
                }
                
                sensorData1 = [Double(x1), Double(y1), Double(z1), Double(hr1)]
                sensorData2 = [Double(x2), Double(y2), Double(z2), Double(hr2)]
                //pStress_N?.onstressHr(sensorData1[3])
                Log.i(BluetoothLEManager.tag, msg: "???\(sensorData1)")
                Log.i(BluetoothLEManager.tag, msg: "???\(sensorData2)")
                //규창 --- 코치 노말 스트레스 측정
                if mStressNManger?.isMeasuring == true {
                    //mStressNManger.isMeasuring = true
                    Log.i(BluetoothLEManager.tag, msg: "\(sensorData1)")
                    pStress_N?.onstressHr(sensorData1[3])
                    //mStressNManger.isMeasuring = false
                }
                let delay = DispatchTime.now() + Double(Int64(0.05 * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)
                DispatchQueue.main.asyncAfter(deadline: delay) {
                    //self.pStress_N?.onstressHr(self.sensorData2[3])
                    if self.mStressNManger?.isMeasuring == true {
                        //self.mStressNManger.isMeasuring = true
                        //Log.i(BluetoothLEManager.tag, msg: "\(self.sensorData2)")
                        self.pStress_N?.onstressHr(self.sensorData2[3])
                        //self.mStressNManger.isMeasuring = false
                    }
                }
                
            case .state:
                mDatabase.State = getDataShort(getFrame, loc: 2, len: 2)
                if getFrame.count > 4 {
                    mDatabase.HeartRateStable = getDataShort(getFrame, loc: 4, len: 2)
                }
                
                MWNotification.postNotification(MWNotification.Bluetooth.StatePeripheral)
            case .version:
                if product == ProductCode.fitness.bluetoothDeviceName {
                    if mDatabase.Version == "" && mDatabase.Version == nil{
                        let vLen = getDataShort(getFrame, loc: 2, len: 2)
                        
                        mDatabase.Version = getString(getFrame, loc: 4, len: Int(vLen)) // ascii
                    }
                } else if product == ProductCode.coach.bluetoothDeviceName {
                    let vLen = getFrame[2]
                    mDatabase.Version = getString(getFrame, loc: 4, len: Int(vLen)) // ascii
                }
                print("version -> \(mDatabase.Version)")
                MWNotification.postNotification(MWNotification.Bluetooth.FirmVersion)
                
            case .featureSet1:
                let norm_var = Double(getDataInt(getFrame, loc: 6, len: 4))/100000//10000000.0
                let x_var = Double(getDataShort(getFrame, loc: 10, len: 2))/1000
                let y_var = Double(getDataShort(getFrame, loc: 12, len: 2))/1000
                let z_var = Double(getDataShort(getFrame, loc: 14, len: 2))/1000
                let x_mean = Double(getDataShort(getFrame, loc: 16, len: 2))/1000
                let y_mean = Double(getDataShort(getFrame, loc: 18, len: 2))/1000
                
                
                
                FeatureDic.updateValue(getDataInt(getFrame, loc: 2, len: 4), forKey: BehaviorManager.KEY_TIME)
                FeatureDic.updateValue(Double(getDataInt(getFrame, loc: 6, len: 4))/100000 , forKey: BehaviorManager.KEY_NORM_VAR)
                FeatureDic.updateValue(Double(getDataShort(getFrame, loc: 10, len: 2))/1000 , forKey:  BehaviorManager.KEY_X_VAR)
                FeatureDic.updateValue(Double(getDataShort(getFrame, loc: 12, len: 2))/1000 , forKey: BehaviorManager.KEY_Y_VAR)
                FeatureDic.updateValue(Double(getDataShort(getFrame, loc: 14, len: 2))/1000 , forKey: BehaviorManager.KEY_Z_VAR)
                FeatureDic.updateValue(Double(getDataShort(getFrame, loc: 16, len: 2))/1000 , forKey: BehaviorManager.KEY_X_MEAN)
                FeatureDic.updateValue(Double(getDataShort(getFrame, loc: 18, len: 2))/1000 , forKey: BehaviorManager.KEY_Y_MEAN)
                
                
                Log.i(BluetoothLEManager.tag , msg:" featureSet1 \(getDataInt(getFrame, loc: 2, len: 4)) norm_var:\(norm_var) x_var:\(x_var) y_var:\(y_var) z_var:\(z_var) x_mean:\(x_mean) y_mean:\(y_mean)");
                
                readyFeature1 = true
            case .featureSet2:
                let z_mean = Double(getDataShort(getFrame, loc: 2, len: 2))/1000
                let norm_mean = Double(getDataShort(getFrame, loc: 4, len: 2))/1000
                Log.i(BluetoothLEManager.tag , msg:" featureSet2 z_mean:\(z_mean) norm_mean:\(norm_mean)");
                FeatureDic.updateValue(Double(getDataShort(getFrame, loc: 2, len: 2))/1000 , forKey: BehaviorManager.KEY_Z_MEAN)
                FeatureDic.updateValue(Double(getDataShort(getFrame, loc: 4, len: 2))/1000 , forKey: BehaviorManager.KEY_NORM_MEAN)
                FeatureDic.updateValue(getDataShort(getFrame, loc: 6, len: 2) , forKey: BehaviorManager.KEY_NSTEP)
                FeatureDic.updateValue(getDataShort(getFrame, loc: 8, len: 2) , forKey: BehaviorManager.KEY_JUMP_ROPE_SWING)
                FeatureDic.updateValue(getDataShort(getFrame, loc: 10, len: 2) , forKey: BehaviorManager.KEY_SMALL_SWING)
                FeatureDic.updateValue(getDataShort(getFrame, loc: 12, len: 2) , forKey: BehaviorManager.KEY_LARGE_SWING)
                FeatureDic.updateValue(Double(getDataShort(getFrame, loc: 14, len: 2)) , forKey: BehaviorManager.KEY_PRESS_VAR)
                //규창 171020 밴드 부팅후 스텝은 디스플레이 스텝값 그대로 이용....// 171024 ------- 사용가능...
                FeatureDic.updateValue(getDataShort(getFrame, loc: 16, len: 2) , forKey: BehaviorManager.KEY_ACCMULATED_STEP)
                FeatureDic.updateValue(getDataShort(getFrame, loc: 18, len: 2) , forKey: BehaviorManager.KEY_DISPLAY_STEP)
                
                
                readyFeature2 = true
                //Log.i(BluetoothLEManager.tag , msg:" featureSet2 norm_mean:\(norm_mean) nStep:\(nStep) jumping_rope_count:\(jumping_rope_count) small_swing_count:\(small_swing_count) large_swing_count:\(large_swing_count) press_diff:\(press_diff) day_step:\(day_step) pressure:\(pressure) hb_1min:\(hb_1min)");
            case .featureSet3:
                let press = Double(getDataInt(getFrame, loc: 2, len: 4))/100
                Log.i(BluetoothLEManager.tag , msg:" featureSet3 press:\(press)");
                
                FeatureDic.updateValue(Double(getDataInt(getFrame, loc: 2, len: 4))/100, forKey:BehaviorManager.KEY_PRESS)
                FeatureDic.updateValue(getDataShort(getFrame, loc: 6, len: 2) , forKey: BehaviorManager.KEY_PULSE)
                
                readyFeature3 = true
            
                
                
            case .pastFeatureSet1:
                let norm_var = Double(getDataInt(getFrame, loc: 6, len: 4))/100000//10000000.0
                let x_var = Double(getDataShort(getFrame, loc: 10, len: 2))/1000
                let y_var = Double(getDataShort(getFrame, loc: 12, len: 2))/1000
                let z_var = Double(getDataShort(getFrame, loc: 14, len: 2))/1000
                let x_mean = Double(getDataShort(getFrame, loc: 16, len: 2))/1000
                let y_mean = Double(getDataShort(getFrame, loc: 18, len: 2))/1000
                
                
                
                PastFeatureDic.updateValue(getDataInt(getFrame, loc: 2, len: 4), forKey: BehaviorManager.KEY_TIME)
                PastFeatureDic.updateValue(Double(getDataInt(getFrame, loc: 6, len: 4))/100000 , forKey: BehaviorManager.KEY_NORM_VAR)
                PastFeatureDic.updateValue(Double(getDataShort(getFrame, loc: 10, len: 2))/1000 , forKey:  BehaviorManager.KEY_X_VAR)
                PastFeatureDic.updateValue(Double(getDataShort(getFrame, loc: 12, len: 2))/1000 , forKey: BehaviorManager.KEY_Y_VAR)
                PastFeatureDic.updateValue(Double(getDataShort(getFrame, loc: 14, len: 2))/1000 , forKey: BehaviorManager.KEY_Z_VAR)
                PastFeatureDic.updateValue(Double(getDataShort(getFrame, loc: 16, len: 2))/1000 , forKey: BehaviorManager.KEY_X_MEAN)
                PastFeatureDic.updateValue(Double(getDataShort(getFrame, loc: 18, len: 2))/1000 , forKey: BehaviorManager.KEY_Y_MEAN)
                
                
                Log.i(BluetoothLEManager.tag , msg:"PastfeatureSet1 \(getDataInt(getFrame, loc: 2, len: 4)) norm_var:\(norm_var) x_var:\(x_var) y_var:\(y_var) z_var:\(z_var) x_mean:\(x_mean) y_mean:\(y_mean)");
                
                
                
                readyPastFeature1 = true
            case .pastFeatureSet2:
                let z_mean = Double(getDataShort(getFrame, loc: 2, len: 2))/1000
                let norm_mean = Double(getDataShort(getFrame, loc: 4, len: 2))/1000
                Log.i(BluetoothLEManager.tag , msg:"PastfeatureSet2 z_mean:\(z_mean) norm_mean:\(norm_mean)");
                PastFeatureDic.updateValue(Double(getDataShort(getFrame, loc: 2, len: 2))/1000 , forKey: BehaviorManager.KEY_Z_MEAN)
                PastFeatureDic.updateValue(Double(getDataShort(getFrame, loc: 4, len: 2))/1000 , forKey: BehaviorManager.KEY_NORM_MEAN)
                PastFeatureDic.updateValue(getDataShort(getFrame, loc: 6, len: 2) , forKey: BehaviorManager.KEY_NSTEP)
                PastFeatureDic.updateValue(getDataShort(getFrame, loc: 8, len: 2) , forKey: BehaviorManager.KEY_JUMP_ROPE_SWING)
                PastFeatureDic.updateValue(getDataShort(getFrame, loc: 10, len: 2) , forKey: BehaviorManager.KEY_SMALL_SWING)
                PastFeatureDic.updateValue(getDataShort(getFrame, loc: 12, len: 2) , forKey: BehaviorManager.KEY_LARGE_SWING)
                PastFeatureDic.updateValue(Double(getDataShort(getFrame, loc: 14, len: 2)) , forKey: BehaviorManager.KEY_PRESS_VAR)
                //규창 171020 밴드 부팅후 스텝은 디스플레이 스텝값 그대로 이용....// 171024 ------- 사용가능...
                PastFeatureDic.updateValue(getDataShort(getFrame, loc: 16, len: 2) , forKey: BehaviorManager.KEY_ACCMULATED_STEP)
                PastFeatureDic.updateValue(getDataShort(getFrame, loc: 18, len: 2) , forKey: BehaviorManager.KEY_DISPLAY_STEP)
                
                
                readyPastFeature2 = true
            //Log.i(BluetoothLEManager.tag , msg:" featureSet2 norm_mean:\(norm_mean) nStep:\(nStep) jumping_rope_count:\(jumping_rope_count) small_swing_count:\(small_swing_count) large_swing_count:\(large_swing_count) press_diff:\(press_diff) day_step:\(day_step) pressure:\(pressure) hb_1min:\(hb_1min)");
            case .pastFeatureSet3:
                let press = Double(getDataInt(getFrame, loc: 2, len: 4))/100
                Log.i(BluetoothLEManager.tag , msg:"PastfeatureSet3 press:\(press)");
                
                PastFeatureDic.updateValue(Double(getDataInt(getFrame, loc: 2, len: 4))/100, forKey:BehaviorManager.KEY_PRESS)
                PastFeatureDic.updateValue(getDataShort(getFrame, loc: 6, len: 2) , forKey: BehaviorManager.KEY_PULSE)
                
                readyPastFeature3 = true
                
            case .pastFeatureSetComplete:
                //피쳐가 전부 전송이 완료되면 피쳐를 시간순으로 정렬한다
                let sortedArray = (PastFeatureDicSet as NSArray).sortedArray(using: [NSSortDescriptor(key: "KEY_TIME", ascending: true)]) as! [[String:AnyObject]]
                
                
                //PastFeature_10min = Array(repeating: PastFeatureDic_10min, count: 10)
                var allCnt = 0
                PastFeature_10min = Array(repeating: PastFeatureDic_10min, count: 10)
                PastFeatureDic_10min =
                    ["KEY_TIME"             : 0    ,
                     "KEY_NORM_VAR"         : 0.0  ,
                     "KEY_X_VAR"            : 0.0  ,
                     "KEY_Y_VAR"            : 0.0  ,
                     "KEY_Z_VAR"            : 0.0  ,
                     "KEY_X_MEAN"           : 0.0  ,
                     "KEY_Y_MEAN"           : 0.0  ,
                     "KEY_Z_MEAN"           : 0.0  ,
                     "KEY_NORM_MEAN"        : 0.0  ,
                     "KEY_NSTEP"            : 0    ,
                     "KEY_JUMP_ROPE_SWING"  : 0    ,
                     "KEY_SMALL_SWING"      : 0    ,
                     "KEY_LARGE_SWING"      : 0    ,
                     "KEY_PRESS_VAR"        : 0.0  ,
                     "KEY_ACCMULATED_STEP"  : 0    ,
                     "KEY_DISPLAY_STEP"     : 0    ,
                     "KEY_PRESS"            : 0.0  ,
                     "KEY_PULSE"            : 0    ]
                for i in 0..<sortedArray.count {
                    let timetoString:String = String(sortedArray[i][BehaviorManager.KEY_TIME] as! Int32)
                    var nowtime:Bool = false
                    Log.w(BehaviorManager.tag, msg: " \(String(describing: sortedArray[i][BehaviorManager.KEY_TIME])) \(timetoString) \(String(describing: timetoString.last)) \(timetoString.count) \(PastFeature_10min.count)")
                    //피쳐 10분치를 선별하는 루틴으로 배열 인덱스 0~9와 피쳐시간 값끝까지리의 분을 검사하고 10개 배열에 채워넣는다.
                    if timetoString == "-1" {
                        Log.i(BluetoothLEManager.tag, msg: "마이너스 1들어있음? \(i)")
                        continue
                    }
                    if timetoString == "0" {
                        Log.i(BluetoothLEManager.tag, msg: "0 들어있음? \(i)")
                        continue
                    }
                    if timetoString.last == "0" {
                        //PastFeature_10min.insert(sortedArray[i], at: 0)
                        PastFeature_10min[0] = sortedArray[i]
                        var timechk:Int32 = 10
                        if( i+1 < sortedArray.count ) {
                            timechk = (sortedArray[i+1][BehaviorManager.KEY_TIME] as! Int32) - (sortedArray[i][BehaviorManager.KEY_TIME] as! Int32)
                        }
                        if(timechk < 10){
                            nowtime = true
                        }
                    }
                    if timetoString.last == "1" {
                        PastFeature_10min[1] = sortedArray[i]
                        var timechk:Int32 = 10
                        if( i+1 < sortedArray.count ) {
                            timechk = (sortedArray[i+1][BehaviorManager.KEY_TIME] as! Int32) - (sortedArray[i][BehaviorManager.KEY_TIME] as! Int32)
                        }
                        if(timechk < 9){
                            nowtime = true
                        }
                    }
                    if timetoString.last == "2" {
                        PastFeature_10min[2] = sortedArray[i]
                        var timechk:Int32 = 10
                        if( i+1 < sortedArray.count ) {
                            timechk = (sortedArray[i+1][BehaviorManager.KEY_TIME] as! Int32) - (sortedArray[i][BehaviorManager.KEY_TIME] as! Int32)
                        }
                        if(timechk < 8){
                            nowtime = true
                        }
                    }
                    if timetoString.last == "3" {
                        PastFeature_10min[3] = sortedArray[i]
                        var timechk:Int32 = 10
                        if( i+1 < sortedArray.count ) {
                            timechk = (sortedArray[i+1][BehaviorManager.KEY_TIME] as! Int32) - (sortedArray[i][BehaviorManager.KEY_TIME] as! Int32)
                        }
                        if(timechk < 7){
                            nowtime = true
                        }
                    }
                    if timetoString.last == "4" {
                        PastFeature_10min[4] = sortedArray[i]
                        var timechk:Int32 = 10
                        if( i+1 < sortedArray.count ) {
                            timechk = (sortedArray[i+1][BehaviorManager.KEY_TIME] as! Int32) - (sortedArray[i][BehaviorManager.KEY_TIME] as! Int32)
                        }
                        if(timechk < 6){
                            nowtime = true
                        }
                    }
                    if timetoString.last == "5" {
                        PastFeature_10min[5] = sortedArray[i]
                        var timechk:Int32 = 10
                        if( i+1 < sortedArray.count ) {
                            timechk = (sortedArray[i+1][BehaviorManager.KEY_TIME] as! Int32) - (sortedArray[i][BehaviorManager.KEY_TIME] as! Int32)
                        }
                        if(timechk < 5){
                            nowtime = true
                        }
                    }
                    if timetoString.last == "6" {
                        PastFeature_10min[6] = sortedArray[i]
                        var timechk:Int32 = 10
                        if( i+1 < sortedArray.count ) {
                            timechk = (sortedArray[i+1][BehaviorManager.KEY_TIME] as! Int32) - (sortedArray[i][BehaviorManager.KEY_TIME] as! Int32)
                        }
                        if(timechk < 4){
                            nowtime = true
                        }
                    }
                    if timetoString.last == "7" {
                        PastFeature_10min[7] = sortedArray[i]
                        var timechk:Int32 = 10
                        if( i+1 < sortedArray.count ) {
                            timechk = (sortedArray[i+1][BehaviorManager.KEY_TIME] as! Int32) - (sortedArray[i][BehaviorManager.KEY_TIME] as! Int32)
                        }
                        if(timechk < 3){
                            nowtime = true
                        }
                    }
                    if timetoString.last == "8" {
                        PastFeature_10min[8] = sortedArray[i]
                        var timechk:Int32 = 10
                        if( i+1 < sortedArray.count ) {
                            timechk = (sortedArray[i+1][BehaviorManager.KEY_TIME] as! Int32) - (sortedArray[i][BehaviorManager.KEY_TIME] as! Int32)
                        }
                        if(timechk < 2){
                            nowtime = true
                        }
                    }
                    if timetoString.last == "9" {
                        PastFeature_10min[9] = sortedArray[i]
                        var timechk:Int32 = 10
                        if( i+1 < sortedArray.count ) {
                            timechk = (sortedArray[i+1][BehaviorManager.KEY_TIME] as! Int32) - (sortedArray[i][BehaviorManager.KEY_TIME] as! Int32)
                        }
                        if(timechk < 1){
                            nowtime = true
                        }
                    }
                    
                    
                    if (!nowtime) {
                        allCnt = 0
                       
                        var Emptyindex:[Int] = []
                        
                        //배열 10개를 검사하며, 피쳐의 시간값이 연속적이지 않다면 배열내에 비어있는 시간값이 존재하게 된다.
                        for j in 0..<10 {
                            if let emptyCheck:Int32 = PastFeature_10min[j][BehaviorManager.KEY_TIME] as? Int32 {
                            Log.i(BluetoothLEManager.tag, msg:"피쳐 확인 \(String(describing: PastFeature_10min[j][BehaviorManager.KEY_TIME])) \(emptyCheck)")
                                PastFeatureDic_10min = PastFeature_10min[j]
                                
                            }else{
                                //비어있는 시간이 생긴다면 해당 시간값을 배열로 넣는다.
                                Log.i(BluetoothLEManager.tag, msg:"내부 10개 피쳐 확인 \(String(describing: PastFeature_10min[j][BehaviorManager.KEY_TIME]))")
                                Emptyindex.append(j)
                            }
                            /*if(emptyCheck == 0){
                                Log.i(BluetoothLEManager.tag, msg:"내부 10개 피쳐 확인 \(String(describing: PastFeature_10min[j][BehaviorManager.KEY_TIME]))")
                                Emptyindex.append(j)
                            }else{
                                //빈 피쳐를 채워넣을 피쳐데이터
                                PastFeatureDic_10min = PastFeature_10min[j]
                            }*/
                        }
                        
                        //규창 171107 피쳐10개씩 선별하고 빈시간을 채워넣는 루틴
                        //빈 시간은 2개에다 10개중 마지막으로 찾아진 피쳐를 똑같이 넣는다.
                        if (Emptyindex.count <= 2 ) {
                            for j in 0..<Emptyindex.count {
                                var timeString:String = String(PastFeatureDic_10min[BehaviorManager.KEY_TIME] as! Int32)
                                timeString.removeLast()
                                timeString.append(String(Emptyindex[j]))
                                Log.i(BluetoothLEManager.tag, msg:"빈 피쳐의 인덱스 \(Emptyindex[j])")
                                PastFeatureDic_10min[BehaviorManager.KEY_TIME] = Int32(timeString)
                                //PastFeature_10min.insert(PastFeatureDic_10min, at: Emptyindex[j])
                                
                                PastFeature_10min[Emptyindex[j]] = PastFeatureDic_10min
                                
                            }
                        
                            for j in 0..<10 {
                                Log.i(BluetoothLEManager.tag, msg:"피쳐 다 차있는지 확인 \(String(describing: PastFeature_10min[j][BehaviorManager.KEY_TIME]))")
                            }
                            MWControlCenter.getInstance().setPLResult(result: BehaviorManager.getInstance().onReceiveFeature(feature: PastFeature_10min))
                            //PastFeatureDicSet.removeAll()
                            //var FeatureData: (actIndex: Int32, start_date: Int64, intensity: Double, calorie: Double, speed: Double, heartrate: Int32, step: Int32, swing: Int32, press_var: Double, coach_intensity: Double) {
                            mDatabase.FeatureData = MWControlCenter.getInstance().getPLResult()
                            let check:Int64 = 946684800000
                            if mDatabase.FeatureData.start_date != check {
                                MWNotification.postNotification(MWNotification.Bluetooth.PastFeatureDataComplete)
                            }else {
                                MWNotification.postNotification(MWNotification.Bluetooth.FeatureDataError)
                            }
                        }
                        
                        
                        
                        
                        Emptyindex.removeAll()
                        
                        PastFeature_10min.removeAll()
                        PastFeatureDic_10min.removeAll()
                        PastFeature_10min = Array(repeating: PastFeatureDic_10min, count: 10)
                        PastFeatureDic_10min =
                            ["KEY_TIME"             : 0    ,
                             "KEY_NORM_VAR"         : 0.0  ,
                             "KEY_X_VAR"            : 0.0  ,
                             "KEY_Y_VAR"            : 0.0  ,
                             "KEY_Z_VAR"            : 0.0  ,
                             "KEY_X_MEAN"           : 0.0  ,
                             "KEY_Y_MEAN"           : 0.0  ,
                             "KEY_Z_MEAN"           : 0.0  ,
                             "KEY_NORM_MEAN"        : 0.0  ,
                             "KEY_NSTEP"            : 0    ,
                             "KEY_JUMP_ROPE_SWING"  : 0    ,
                             "KEY_SMALL_SWING"      : 0    ,
                             "KEY_LARGE_SWING"      : 0    ,
                             "KEY_PRESS_VAR"        : 0.0  ,
                             "KEY_ACCMULATED_STEP"  : 0    ,
                             "KEY_DISPLAY_STEP"     : 0    ,
                             "KEY_PRESS"            : 0.0  ,
                             "KEY_PULSE"            : 0    ]
                    }
                    allCnt = allCnt+1
                    
                }
                let popTime = DispatchTime.now() + Double(Int64(3 * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)
                DispatchQueue.main.asyncAfter(deadline: popTime){
                    Log.w(BehaviorManager.tag, msg: "MW에서 수집한 과거!!!피쳐 잔여 갯수 확인 \(self.PastFeatureDicSet.count)")
                    self.PastFeatureDicSet.removeAll()
                    self.PastFeature_10min.removeAll()
                    self.PastFeatureDic_10min.removeAll()
                    MWNotification.postNotification(MWNotification.Bluetooth.PastFeatureDataALLComplete)
                }
                
            case .featureError:
                Log.i(BluetoothLEManager.tag , msg:"피쳐가 없거나 에러가 발생했을 경우 MW는 앱단에 이 시간대 피쳐를 아무거나 채우거나 요청하지 말도록 요청해야한다")
            default:
                return
            }
            
            
            
            if(readyFeature1 == true && readyFeature2 == true && readyFeature3 == true) {
                
                FeatureDicSet.append(FeatureDic)
                readyFeature1 = false
                readyFeature2 = false
                readyFeature3 = false
                Log.w(BehaviorManager.tag, msg: "MW에서 수집한 피쳐 갯수 확인 \(FeatureDicSet.count)")
                if (FeatureDicSet.count == 10){
                    Log.w(BehaviorManager.tag, msg: "onReceiveFeature()")
                    MWControlCenter.getInstance().setPLResult(result: BehaviorManager.getInstance().onReceiveFeature(feature: FeatureDicSet))
                    FeatureDicSet.removeAll()
                    //var FeatureData: (actIndex: Int32, start_date: Int64, intensity: Double, calorie: Double, speed: Double, heartrate: Int32, step: Int32, swing: Int32, press_var: Double, coach_intensity: Double) {
                    mDatabase.FeatureData = MWControlCenter.getInstance().getPLResult()
                    let check:Int64 = 946684800000
                    if mDatabase.FeatureData.start_date != check {
                        MWNotification.postNotification(MWNotification.Bluetooth.FeatureDataComplete)
                    }else {
                        MWNotification.postNotification(MWNotification.Bluetooth.FeatureDataError)
                    }
                    
                }
                /*Log.w(BehaviorManager.tag, msg: "onReceiveFeature()")
                Log.w(BehaviorManager.tag, msg: " \(String(describing: FeatureDic.index(forKey: BehaviorManager.KEY_TIME)))")
                Log.w(BehaviorManager.tag, msg: " \(String(describing: FeatureDic.index(forKey: BehaviorManager.KEY_NORM_VAR)))")
                Log.w(BehaviorManager.tag, msg: " \(String(describing: FeatureDic.index(forKey: BehaviorManager.KEY_X_VAR)))")
                Log.w(BehaviorManager.tag, msg: " \(String(describing: FeatureDic.index(forKey: BehaviorManager.KEY_Y_VAR)))")
                Log.w(BehaviorManager.tag, msg: " \(String(describing: FeatureDic.index(forKey: BehaviorManager.KEY_Z_VAR)))")
                Log.w(BehaviorManager.tag, msg: " \(String(describing: FeatureDic.index(forKey: BehaviorManager.KEY_X_MEAN)))")
                Log.w(BehaviorManager.tag, msg: " \(String(describing: FeatureDic.index(forKey: BehaviorManager.KEY_Y_MEAN)))")
                Log.w(BehaviorManager.tag, msg: " \(String(describing: FeatureDic.index(forKey: BehaviorManager.KEY_Z_MEAN)))")
                Log.w(BehaviorManager.tag, msg: " \(String(describing: FeatureDic.index(forKey: BehaviorManager.KEY_NORM_MEAN)))")
                Log.w(BehaviorManager.tag, msg: " \(String(describing: FeatureDic.index(forKey: BehaviorManager.KEY_NSTEP)))")
                Log.w(BehaviorManager.tag, msg: " \(String(describing: FeatureDic.index(forKey: BehaviorManager.KEY_JUMP_ROPE_SWING)))")
                Log.w(BehaviorManager.tag, msg: " \(String(describing: FeatureDic.index(forKey: BehaviorManager.KEY_SMALL_SWING)))")
                Log.w(BehaviorManager.tag, msg: " \(String(describing: FeatureDic.index(forKey: BehaviorManager.KEY_LARGE_SWING)))")
                Log.w(BehaviorManager.tag, msg: " \(String(describing: FeatureDic.index(forKey: BehaviorManager.KEY_PRESS_VAR)))")
                Log.w(BehaviorManager.tag, msg: " \(String(describing: FeatureDic.index(forKey: BehaviorManager.KEY_ACCMULATED_STEP)))")
                Log.w(BehaviorManager.tag, msg: " \(String(describing: FeatureDic.index(forKey: BehaviorManager.KEY_DISPLAY_STEP)))")
                Log.w(BehaviorManager.tag, msg: " \(String(describing: FeatureDic.index(forKey: BehaviorManager.KEY_PRESS)))")
                Log.w(BehaviorManager.tag, msg: " \(String(describing: FeatureDic.index(forKey: BehaviorManager.KEY_PULSE)))")*/
                
            }
            
            if(readyPastFeature1 == true && readyPastFeature2 == true && readyPastFeature3 == true) {
                
                PastFeatureDicSet.append(PastFeatureDic)
                readyPastFeature1 = false
                readyPastFeature2 = false
                readyPastFeature3 = false
            
                
                Log.w(BehaviorManager.tag, msg: "MW에서 수집한 과거!!! 피쳐 갯수 확인 \(PastFeatureDicSet.count)")
                
                /*let PastFeatureDicSetSort = PastFeatureDicSet.sorted(by: {
                    (($0 as Dictionary<String, AnyObject>)["KEY_TIME"] as? Double)! < (($1 as! Dictionary<String, AnyObject>)["KEY_TIME"] as? Double)!
                })*/
                /*if (PastFeatureDicSet.count == 10){
                    Log.w(BehaviorManager.tag, msg: "Past!!! onReceiveFeature()")
                    MWControlCenter.getInstance().setPLResult(result: BehaviorManager.getInstance().onReceiveFeature(feature: PastFeatureDicSet))
                    PastFeatureDicSet.removeAll()
                    //var FeatureData: (actIndex: Int32, start_date: Int64, intensity: Double, calorie: Double, speed: Double, heartrate: Int32, step: Int32, swing: Int32, press_var: Double, coach_intensity: Double) {
                    mDatabase.FeatureData = MWControlCenter.getInstance().getPLResult()
                    let check:Int64 = 946684800000
                    if mDatabase.FeatureData.start_date != check {
                        MWNotification.postNotification(MWNotification.Bluetooth.PastFeatureDataComplete)
                    }else {
                        MWNotification.postNotification(MWNotification.Bluetooth.FeatureDataError)
                    }
                    
                }*/
            }
        }
    }
    
    
    
//규창 --- DFU용으로 새로 추가
    func peripheral(_ peripheral: CBPeripheral, didDiscoverIncludedServicesFor service: CBService, error: Error?) {
        print("discoverIncludeService \(peripheral) \(service)")
        
        
    }
    func peripheralDidUpdateName(_ peripheral: CBPeripheral){
        Log.i(BluetoothLEManager.tag, msg: "peripheralDidUpdateName \(peripheral)")
        //과거 서비스 디버깅용
        //peripheral.discoverIncludedServices([DeviceUUID.transferServiceUUID, DeviceUUID.CB_RX_SERVICE_UUID], forService: peripheral.services![0])
        
        //writeChar 참고
        //if discoveredPeripheral == nil || forCharacteristic == nil {
        //  return
        //}
        if peripheral.services == nil {
            return
        }
        peripheral.delegate?.peripheral!(peripheral, didModifyServices: peripheral.services!)
        //centralManager!.cancelPeripheralConnection(peripheral)
    }
    func peripheral(_ peripheral: CBPeripheral, didModifyServices invalidatedServices: [CBService]) {
        Log.i(BluetoothLEManager.tag, msg:"didModifyServices \(peripheral) \(invalidatedServices) \(peripheral.state.rawValue)")
        Log.i(BluetoothLEManager.tag, msg: "peripheral.service \(String(describing: peripheral.services))")
        
        //let iOSversion = UIDevice.current.systemVersion
        let iOSversion = NSFoundationVersionNumber
        
        Log.i(BluetoothLEManager.tag, msg: "iOSversion\(iOSversion) 10:\(NSFoundationVersionNumber_iOS_9_x_Max), 9:\(NSFoundationVersionNumber_iOS_9_0))")
        //규창 iOS9, 10에 따라 didModifyServices 콜백의 동작이 다름 iOS9는 연결끊고 새로 연결 iOS10은 discoverService를 시작
        if NSFoundationVersionNumber >= Double(NSFoundationVersionNumber_iOS_9_x_Max){
            peripheral.discoverServices(nil)
        }else if NSFoundationVersionNumber >= Double(NSFoundationVersionNumber_iOS_9_x_Max) && peripheral.name == "C1_DfuT" || peripheral.name == "F1_DfuT"{
            self.raiseDisconnect()
            //self.cancelScanTimer()
            self.startBluetooth()
        }else if Double(NSFoundationVersionNumber_iOS_9_x_Max) > NSFoundationVersionNumber {
            self.raiseDisconnect()
            //self.cancelScanTimer()
            self.startBluetooth()
        }else {
            self.raiseDisconnect()
            //self.cancelScanTimer()
            self.startBluetooth()
        }
    }
    
    func peripheral(_ peripheral: CBPeripheral, didUpdateNotificationStateFor characteristic: CBCharacteristic, error: Error?) {
        Log.i(BluetoothLEManager.tag, msg:"didUpdateNotificationStateFor \(peripheral) \(characteristic) \(error) ")
    }
    
    func peripheral(_ peripheral: CBPeripheral, didWriteValueFor characteristic: CBCharacteristic, error: Error?) {
        Log.i(BluetoothLEManager.tag, msg:"didWriteValueFor \(peripheral) \(characteristic) \(error) ")
    }
    
    
    
    
    func sendReset() {
        /*if discoveredPeripheral?.state != CBPeripheralState.Connected { // explicit enum required to compile here?
            Log.i(BluetoothLEManager.tag, msg: "discoveredPeripheral?.state\(discoveredPeripheral?.state)*****");
            return
        }*/
        let resetCmd:String = "reset boot"
        let data:Data = resetCmd.data(using: String.Encoding.utf8)!
        
        pB.write(discoveredPeripheral!, data: data, forCharacteristic: m_Characteristic, type: CBCharacteristicWriteType.withResponse)
        Log.i(BluetoothLEManager.tag, msg: "리셋 부트 명령 날림")
        
        
        let popTime = DispatchTime.now() + Double(Int64(5 * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)
        DispatchQueue.main.asyncAfter(deadline: popTime){
            MWControlCenter.flagDFU = true
            self.raiseDisconnect()
            self.cancelScanTimer()
            self.startBluetooth()
        }
        
        //규창 16.11.17 밴드가 부트모드일때 접속을 못하거나 연결을 실패했을 경우 Service모드로 들어가게 하기 위함
        let popTimeFailedDFU = DispatchTime.now() + Double(Int64(200 * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)
        DispatchQueue.main.asyncAfter(deadline: popTimeFailedDFU){
            if MWControlCenter.flagDFU == true{
                Log.i(BluetoothLEManager.tag, msg: "밴드한테 부트모드 진입 명령 날려놓고 DFU로 접속 못할 경우의 예외처리!!!")
                MWControlCenter.flagDFU = false
                let mgr = FileManager.default
                do {
                    try mgr.removeItem(at: self.url!)
                    self.url = nil
                } catch {
                }
                //self.raiseDisconnect()
                //self.cancelScanTimer()
                //self.startBluetooth()
                MWNotification.postNotification(MWNotification.Bluetooth.FirmUpFaild);
            }
        }
    }
    
//규창 --- DFU LIB진입 함수
    func update() {
        // DFU LIB는 NSURL을 받아서 작동하도록 되있으며, firmware그룹&폴더내의 펌웨어를 입력하여 업데이트
        
        //let url = NSURL(fileURLWithPath:NSBundle.mainBundle().pathForResource("HB_Restore", ofType: "hex")!)
        //let url = NSURL(fileURLWithPath:NSBundle.mainBundle().pathForResource("cm_0.0.7.5", ofType: "hex")!)
        //print(url)
        // Hex 파일로 업데이트 하기 때문에 헥스파일의 Url을 입력 그리고 Dat파일은 없으므로 nil 타입은 애플리케이셔 타입
        if url != nil && MWControlCenter.flagDFU == true {
            if discoveredPeripheral!.name == DeviceBaseScan.DEVICE_NAME_START_DFUT {
                if MWControlCenter.m_productCode == ProductCode.fitness {
                    selectedFirmware = DFUFirmware(urlToZipFile: url!)
                    print("피트니스일 경우 루틴에서 URL\(String(describing: url))")
                }
                if MWControlCenter.m_productCode == ProductCode.coach {
                    selectedFirmware = DFUFirmware(urlToBinOrHexFile: url!, urlToDatFile: nil, type: DFUFirmwareType.application)
                    print("코치일 경우 루틴에서 URL\(String(describing: url))")
                }
            }
            
            print("discoveredPeripheral:\(String(describing: discoveredPeripheral))")
            //DFUServiceInitiator를 초기화 하면 connectPeripheral부터는 LIB내의 센트럴 매니저에서 이어 받아 처리한다
            initiator = DFUServiceInitiator(centralManager: centralManager!, target: discoveredPeripheral!).withFirmwareFile(selectedFirmware!)
            initiator!.forceDfu = false  //기본값은 false
            initiator!.logger = self
            initiator!.delegate = self
            initiator!.progressDelegate = self
            raiseDisconnect()
            cancelScanTimer()
            cleanup()
            controller =  initiator!.start()
        } else if url == nil || MWControlCenter.flagDFU == false {
            Log.i(BluetoothLEManager.tag, msg: "URL이 없거나 MW가 펌웨어 업데이트모드가 아니어서 진행 불가!!!!!")
            MWControlCenter.flagDFU = false
            let mgr = FileManager.default
            do {
                try mgr.removeItem(at: url!)
                url = nil
            } catch {
            }
        
            //규창 -- 연결해제 후 새로 연결을 맺음
            let popTime = DispatchTime.now() + Double(Int64(60 * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)
            DispatchQueue.main.asyncAfter(deadline: popTime){
                self.raiseDisconnect()
                self.cancelScanTimer()
                self.startBluetooth()
            }
            //규창 16.11.09 --- 펌웨어 업데이트 상태 정의
            MWNotification.postNotification(MWNotification.Bluetooth.FirmUpFaild);
            //return
        }
        
    }
    
    // 규창 17.03.16 밴드 응답없음 현상 발생시 연결해제 후 재 연결!!!!!
    func emergencyReconnect() {
        
        Log.i(BluetoothLEManager.tag, msg:"Reconnect Reason: No Response")
        raiseDisconnect()
        cancelScanTimer()
        cleanup()
        centralManager = nil
        centralManager = CBCentralManager(delegate: self, queue: nil, options: nil);
        let popTime = DispatchTime.now() + Double(Int64(5 * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)
        DispatchQueue.main.asyncAfter(deadline: popTime){
            self.startBluetooth()
        }
    }
    
}
