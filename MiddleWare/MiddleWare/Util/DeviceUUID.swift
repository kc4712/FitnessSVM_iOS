//
//  DeviceUUID.swift
//  Swift_Middleware
//
//  Created by 심규창 on 2016. 6. 9..
//  Copyright © 2016년 심규창. All rights reserved.
//

import Foundation


import Foundation
import CoreBluetooth

class DeviceUUID {
    
    //static let DFU_SERVICE_UUID:NSArray = ["0x000015301212EFDEl", "0x1523785FEABCD123l"]
    //static let DFU_CONTROL_POINT_UUID:NSArray = ["0x000015311212EFDEl", "0x1523785FEABCD123l"];
    //static let DFU_PACKET_UUID:NSArray = ["0x000015321212EFDEl", "0x1523785FEABCD123l"];
    //static let DFU_VERSION:NSArray = ["0x000015341212EFDEl", "0x1523785FEABCD123l"];
    static let CLIENT_CHARACTERISTIC_CONFIG:NSArray = ["0x0000290200001000l", "0x800000805f9b34fbl"];
    static let SERVICE_CHANGED_UUID:NSArray = ["0x00002A0500001000l", "0x800000805F9B34FBl"];
    
    static let DFU_SERVICE_UUID = CBUUID(string: "00001530-1212-EFDE-1523-785FEABCD123")
    static let DFU_CONTROL_POINT_UUID = CBUUID(string: "00001531-1212-EFDE-1523-785FEABCD123")
    static let DFU_PACKET_UUID = CBUUID(string: "00001532-1212-EFDE-1523-785FEABCD123")
    static let DFU_VERSION = CBUUID(string: "00001534-1212-EFDE-1523-785FEABCD123")
    
    
    static let CCCD = "00002902-0000-1000-8000-00805f9b34fb"
    static let RX_SERVICE_UUID = "6e400001-b5a3-f393-e0a9-e50e24dcca9e"
    static let RX_CHAR_UUID = "6e400002-b5a3-f393-e0a9-e50e24dcca9e"
    static let TX_CHAR_UUID = "6e400003-b5a3-f393-e0a9-e50e24dcca9e"
    
    //String을 CBUUID로 변환
    static let CB_RX_SERVICE_UUID = CBUUID(string: RX_SERVICE_UUID)
    static let CB_TX_CHAR_UUID = CBUUID(string: TX_CHAR_UUID)
    static let CB_RX_CHAR_UUID = CBUUID(string: RX_CHAR_UUID)
    
    static let transferServiceUUID = CBUUID(string: RX_SERVICE_UUID)
}