//
//  DeviceRecord.swift
//  MiddleWare
//
//  Created by 양정은 on 2016. 3. 23..
//  Copyright © 2016년 그린콤 김영일. All rights reserved.
//

import CoreBluetooth
import Foundation

open class DeviceRecord: Hashable {
    fileprivate var peripheral: CBPeripheral;
    fileprivate var name: String;
    fileprivate var rssi: NSNumber;
    
    open var hashValue: Int {
        return name.hashValue;
    }
    
    open var getPeripheral: CBPeripheral {
        get {
            return self.peripheral;
        }
        set {
            self.peripheral = newValue;
        }
    }
    
    open var getName: String {
        get {
            return self.name;
        }
        set {
            self.name = newValue;
        }
    }
    
    open var getRssi: NSNumber {
        get {
            return self.rssi;
        }
        set {
            self.rssi = newValue;
        }
    }
    
    init(peripheral: CBPeripheral, name: String, rssi: NSNumber) {
        self.peripheral = peripheral;
        self.name = name;
        self.rssi = rssi;
    }
}

public func == (lhs: DeviceRecord, rhs: DeviceRecord) -> Bool {
    return lhs.getName == rhs.getName;
}
