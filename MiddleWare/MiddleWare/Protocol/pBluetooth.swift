//
//  BluetoothProtocol.swift
//  Swift_MW_AART
//
//  Created by 양정은 on 2016. 6. 30..
//  Copyright © 2016년 심규창. All rights reserved.
//

import Foundation
import CoreBluetooth

protocol pBluetooth: pTimeZone {
    func write(_ discoveredPeripheral: CBPeripheral?, data: Data, forCharacteristic: CBCharacteristic?, type: CBCharacteristicWriteType)
    func connect(_ name: String) -> Bool
    func connect(retrieve peripheral: CBPeripheral) -> Bool
    func isLiveApp() -> Bool
}
