//
//  DeveiceBaseScan.swift
//  MiddleWare
//
//  Created by 양정은 on 2016. 3. 21..
//  Copyright © 2016년 그린콤 김영일. All rights reserved.
//

import CoreBluetooth
import Foundation

class DeviceBaseScan: SharedBase {
    fileprivate static let tag = DeviceBaseScan.className;
    
    /** 핸들러 대신 사용할 스캔 전용 타이머 **/
    fileprivate let mTimer: MWTimer = MWTimer();
    
    fileprivate let SCAN_PERIOD: TimeInterval = 4500;
    let DEF_RSSI: NSNumber = -100;
    
    fileprivate static var mConnectionState = ConnectStatus.state_DISCONNECTED;
    
    var mScanning: Bool = false;
    
    //fileprivate enum RETRIEVEStatus:Int32
    //{
    //    case NONE = 0, START = 1, END = 2
    //}
    
    //var mRetrieveStatus:Int32
    
    fileprivate var scanMode = ScanMode.auto;
    
    override init() {
        //mRetrieveStatus = RETRIEVEStatus.NONE.rawValue
        arList = Set<DeviceRecord>();
        super.init();
    }
    
    /** Delegation **/
    var pB: pBluetooth!
    
    /** Abstract **/
    func startScanTimer() {}
    func cancelScanTimer() {}
    //func connect(name: String) -> Bool {return true;}
    
    func setScanMode(_ scanMode: ScanMode) {
        self.scanMode = scanMode;
    }
    
    func getScanMode() -> ScanMode {
        return scanMode;
    }
    
    /**
     * 현재 블루투스 연결 상태 정보를 반환한다. 연결 상태에 아무런 변화도 이루어지지 않았을 경우, 기본은 STATE_DISCONNECTED 이다.
     * @return 블루투스 연결 상태 정보. (0:STATE_DISCONNECTED, 1:STATE_CONNECTING, 2:STATE_CONNECTED)
     */
    func getConnectionState() -> ConnectStatus {
        return DeviceBaseScan.mConnectionState;
    }
    
    func getDevice(_ name: String) -> CBPeripheral? {
        var discoveredPeripheral: CBPeripheral?;
        
        for dev in arList {
            if dev.getName == name {
                discoveredPeripheral = dev.getPeripheral;
                break;
            }
        }
        
        return discoveredPeripheral;
    }
    
    func isConnect() -> Bool {
        if DeviceBaseScan.mConnectionState == ConnectStatus.state_DISCONNECTED {return false;}
        if DeviceBaseScan.mConnectionState == ConnectStatus.state_EXIT {return false;}
        return true;
    }
    
    var centralManager: CBCentralManager?
    
    func isValidAdapter() -> Bool {
        return centralManager != nil ? true : false;
    }
    
    func isRetrieveConnectedPeripherals() -> Bool {
        if let connectedPeripheral = centralManager?.retrieveConnectedPeripherals(withServices: [DeviceUUID.CB_RX_SERVICE_UUID]) {
            if !connectedPeripheral.isEmpty {
                return true
            }
        }
        return false
    }
    
    func raiseConnectionFailed() {
        MWNotification.postNotification(MWNotification.Bluetooth.FailedConnection);
    }
    
    func raiseConnectionState(_ state: ConnectStatus) {
        DeviceBaseScan.mConnectionState = state;
        MWNotification.postNotification(MWNotification.Bluetooth.RaiseConnectionState);
    }
    
    /**
     * BI name
     */
    static var SELECTED_DEVICE_NAME: String {
        return MWControlCenter.m_productCode.bluetoothDeviceName
    }
    
    static var DEVICE_NAME_START_DFUT: String {
        return MWControlCenter.m_productCode.dfuBluetoothDeviceName
    }
    
    var arList: Set<DeviceRecord>!;
    //private HashMap<String, DeviceRecord> arList = new HashMap<>();
    
    //var reset_active = true;
    
    func requestConnect(retrieve peripheral: CBPeripheral) {
        stopScan();
        
        Log.d(DeviceBaseScan.tag, msg: "retrieve connect......");
        
        pB.connect(retrieve: peripheral);
    }
    
    func requestConnect(_ name: String, rssi: NSNumber) {
        stopScan();
        
        Log.d(DeviceBaseScan.tag, msg: "connect......");
//        if rssi.int32Value < DEF_RSSI.int32Value {
//            Log.d(DeviceBaseScan.tag, msg: "->not connect, because high rssi");
//            raiseConnectionFailed();
//            return;
//        }
        
        pB.connect(name);
    }
    
    func requestConnect(_ name: String) -> Bool {
        stopScan();
        
        return pB.connect(name);
    }
    
    func getScanResult() {
        if mScanning == false {
            return;
        }
        //Log.d(tag,"11111");
        stopScan();
        
        let DBName = Preference.getBluetoothName();
        var DBNameFlag=false;
        if DBName != nil {
            DBNameFlag=true;
        }
        //Log.d(tag,"22222");
        // 한번도 접속한적이 없는 경우, 새기기를 찾는 경우.
        //let len = DeviceBaseScan.DEVICE_NAME_START_PLANNER.length;
        //var multiDeviceFlag=false;
        var equalName=false;
        //var getDevCount=0;
        var rssi: NSNumber = 0;
        var name: String = "";
        if DBNameFlag {
            //Log.d(tag,"44444");
            // DB에 블루투스 정보가 있는경우.
            for dev in arList {
                //Log.i(tag, "arList Inform name:"+dev.getName());
                let getDevName = dev.getName;
                if getDevName.isEmpty {
                    continue;
                }
                if getDevName.length < DeviceBaseScan.SELECTED_DEVICE_NAME.length {
                    continue;
                }
                
                let tmp_name = getDevName.substringToIndex(DeviceBaseScan.SELECTED_DEVICE_NAME.length);
                let tmp_name_dfu = getDevName.substringToIndex(DeviceBaseScan.DEVICE_NAME_START_DFUT.length);
                
                
                if tmp_name == DeviceBaseScan.SELECTED_DEVICE_NAME {
                    name = getDevName;
                    if(name == DBName) {
                        //reset_active = true;
                        rssi = dev.getRssi;
                        equalName=true;
                        break;
                    }
                } else if tmp_name_dfu == DeviceBaseScan.DEVICE_NAME_START_DFUT {
                    name = getDevName;
                    if name == DBName {
                        //reset_active = false;
                        equalName=true;
                        break;
                    }
                }
            }
        }
        
        if equalName == true && name != "" && DBNameFlag == true {
            //if(mConnectionState == STATE_DISCONNECTED && isConnected == false) {
            if isConnect() == false {
                Log.d(DeviceBaseScan.tag, msg: "connect....exist");
//                if rssi.int32Value < DEF_RSSI.int32Value {
//                    Log.d(DeviceBaseScan.tag, msg: "->not connect, because high rssi");
//                    raiseConnectionFailed();
//                    return;
//                }
                pB.connect(name);
            }
        } else {
            if isConnect() == false {
                Log.d(DeviceBaseScan.tag, msg: "connect....failed");
                raiseConnectionFailed();
            }
        }
        mScanning = false;
    }
    
    func scan() {
        //centralManager?.scanForPeripheralsWithServices([CBUUID(string: DeviceUUID.RX_SERVICE_UUID)], options: [CBCentralManagerScanOptionAllowDuplicatesKey : NSNumber(bool: true)])
       // centralManager!.scanForPeripheralsWithServices([DeviceUUID.transferServiceUUID], options: ["CBCentralManagerScanOptionAllowDuplicatesKey": false])
        //mRetrieveStatus = RETRIEVEStatus.NONE.rawValue
        centralManager!.scanForPeripherals(withServices: [DeviceUUID.transferServiceUUID, DeviceUUID.DFU_SERVICE_UUID], options:[CBCentralManagerScanOptionAllowDuplicatesKey:false])
        print("Scanning started")
    }
    
    func stopScan() {
        print("Stop Scan");
        centralManager!.stopScan();
    }
    
    /**
     * BLE device 스캔 시작, 중지.
     * @param enable true: 시작, false: 중지.
     */
    func scanLeDevice(_ enable: Bool) {
        Log.d(DeviceBaseScan.tag, msg: "scanLeDevice : \(enable)");
        mTimer.cancel();
        if enable {
            
            //규창 17.01.24 기존에 DB에 기기 정보가 있고, 페어링도 되있다면 스캔을 할 이유는 없다.
            //retrieveConnectedPeripherals는 UUID와 기기정보를 iOS에 저장해 스캔이라는 쓰루풋이 높은 행위를 하지 않고 스캔 전에 사용하는 케이스가 많다.
            let saveName = Preference.getBluetoothName();
            //Log.i(BluetoothLEManager.tag, msg: "saveName: \(saveName)")
            if saveName != nil {
                //Log.i(DeviceBaseScan.tag, msg: "Start mRetrieveStatus = \(mRetrieveStatus)")
                //Log.i(BluetoothLEManager.tag, msg: "iOS has saveName \(saveName)");
                
                //if mRetrieveStatus == RETRIEVEStatus.NONE.rawValue {
                //    mRetrieveStatus = RETRIEVEStatus.START.rawValue
                //    let popTime = DispatchTime.now() + Double(Int64(5 * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)
                //    DispatchQueue.main.asyncAfter(deadline: popTime){
                //        if self.mRetrieveStatus == RETRIEVEStatus.NONE.rawValue {
                //            Log.i(DeviceBaseScan.tag, msg: "In Timer mRetrieveStatus = \(self.mRetrieveStatus)")
                //            return
                //        }
                //        self.mRetrieveStatus = RETRIEVEStatus.END.rawValue
                //        Log.i(DeviceBaseScan.tag, msg: "In Timer mRetrieveStatus = \(self.mRetrieveStatus)")
                //    }
                //}
                
                if let connectedPeripheral = centralManager?.retrieveConnectedPeripherals(withServices: [DeviceUUID.CB_RX_SERVICE_UUID]) {
                    Log.i(BluetoothLEManager.tag, msg: "connectedPeripheral: \(connectedPeripheral)")
                    for retrieve in connectedPeripheral {
                        Log.w(BluetoothLEManager.tag, msg: "from system get device : \(String(describing: retrieve.name)). \(retrieve)");
                        if saveName == retrieve.name {
                            // 장치 정보와 페어링 정보가 일치하는 경우. 그냥 접속.
                            print("matched device name. connect!!")
                            requestConnect(retrieve: retrieve)
                            //mRetrieveStatus = RETRIEVEStatus.NONE.rawValue
                            return
                        }
                        print("not matched device name. break...  need reset pairing device")
                    }
                    /*if !connectedPeripheral.isEmpty {
                     if let retrieve = connectedPeripheral.first {
                     Log.w(BluetoothLEManager.tag, msg: "from system get device : \(retrieve.name).");
                     if saveName == retrieve.name {
                     // 장치 정보와 페어링 정보가 일치하는 경우. 그냥 접속.
                     print("matched device name. connect!!")
                     requestConnect(retrieve: retrieve)
                     return
                     }
                     print("not matched device name. break...  need reset pairing device")
                     }
                     }*/
                }
                //if mRetrieveStatus == RETRIEVEStatus.START.rawValue || mRetrieveStatus == RETRIEVEStatus.NONE.rawValue {
                //    Log.i(DeviceBaseScan.tag, msg: "Escape mRetrieveStatus = \(mRetrieveStatus)")
                //    return
                //}
            }
            
            
            
            arList.removeAll();
            // Stops scanning after a pre-defined scan period.

            mTimer.start(SCAN_PERIOD, repeats: false) {
                if self.scanMode == ScanMode.auto {
                    self.getScanResult(); // 스캔 시작 후, 시간이 끝나면 실행하도록 구현해야함.
                } else {
                    self.stopScan();
                    self.mScanning = false;
                    
                    MWNotification.postNotification(MWNotification.Bluetooth.EndOfScanList);
                }
            }
            
            mScanning = true;
            scan();
        } else {
            mScanning = false;
            stopScan();
            //raiseDeviceList();
        }
    }

    
    override func dispose() {
        super.dispose();
        DeviceBaseScan.mConnectionState = ConnectStatus.state_EXIT;
    }
}
