//
//  ProductCode.swift
//  coach+
//
//  Created by 양정은 on 2016. 7. 21..
//  Copyright © 2016년 Company Green Comm. All rights reserved.
//

import Foundation

public enum ProductCode: Int {
    case coach, fitness
    
    public var productName: String {
        switch self {
        case .coach:
            return "Coach"
        case .fitness:
            return "Fitness"
        }
    }
    
    public var bluetoothDeviceName: String {
        switch self {
        case .coach:
            return "C"
        case .fitness:
            return "F"
        }
    }
    
    public var dfuBluetoothDeviceName: String {
        switch self {
        case .coach:
            return "C1_DfuT"
        case .fitness:
            return "F1_DfuT"
        }
    }
    
    public var productCode: Int {
        switch self {
        case .coach:
            return 200003
        case .fitness:
            return 220004
        }
    }
    
    // young
    public static func checkProduct(_ deviceName: String?) -> ProductCode {
        if (deviceName?.hasPrefix(ProductCode.fitness.bluetoothDeviceName))! {
            return .fitness;
        }
        return .coach;
    }
}
