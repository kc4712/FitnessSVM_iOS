//
//  Per.swift
//  Swift_MW_AART
//
//  Created by 양정은 on 2016. 7. 1..
//  Copyright © 2016년 심규창. All rights reserved.
//

import Foundation

class PeripheralBase: NSObject {
    var set_vibrateLock:Bool = false;
    fileprivate var motionVibrate:[Int] = [200, 100, 200, 100, 200, 2000 /*dummy*/]
    
    let mBle: BluetoothLEManager = BluetoothLEManager.getInstance()
    
    fileprivate var thread: Thread? = nil;
    
    func startVibrate() {
        if set_vibrateLock {
            return;
        }
        
        if thread == nil {
            thread = Thread(target: self, selector: #selector(vibrate), object: nil);
            thread!.start();
            
            set_vibrateLock = true
        }
    }
    
    func stopVibrate() {
        set_vibrateLock = false
        if thread == nil {
            return
        }
        
        thread!.cancel()
        thread = nil
    }
    
    @objc fileprivate func vibrate() {
        let product = DeviceBaseScan.SELECTED_DEVICE_NAME
        
        for i in 0..<motionVibrate.count {
            if i % 2 == 0 {
                if product == ProductCode.fitness.bluetoothDeviceName {
                    mBle.requestVibrate(RequestAction.start)
                } else if product == ProductCode.coach.bluetoothDeviceName {
                    mBle.requestVibrate(ProductCoach: RequestAction.start)
                }
            } else {
                if product == ProductCode.fitness.bluetoothDeviceName {
                    mBle.requestVibrate(RequestAction.end)
                } else if product == ProductCode.coach.bluetoothDeviceName {
                    mBle.requestVibrate(ProductCoach: RequestAction.end)
                }
            }
            
            Thread.sleep(forTimeInterval: TimeInterval(motionVibrate[i]/1000))
        }
        
        set_vibrateLock = false
    }
}
