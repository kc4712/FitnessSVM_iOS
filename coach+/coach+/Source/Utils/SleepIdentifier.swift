//
//  SleepIdentifier.swift
//  CoachPlus
//
//  Created by 양정은 on 2016. 8. 11..
//  Copyright © 2016년 Company Green Comm. All rights reserved.
//

import Foundation

public enum SleepIdentifier: Int16 {
    case enough = 1, normal, few, lack
    
    var toString: String {
        var str = ""
        switch self {
        case .enough:
            str = Common.ResString("enough")
        case .normal:
            str = Common.ResString("normal")
        case .few:
            str = Common.ResString("few")
        case .lack:
            str = Common.ResString("lack")
        }
        
        return str
    }
    
    var getColor: UIColor {
        var color: UIColor
        switch self {
        case .enough:
            color = Common.makeColor(0xED, 0x6D, 0x2D)
        case .normal:
            color = Common.makeColor(0xF2, 0xE3, 0x4D)
        case .few:
            color = Common.makeColor(0xCB, 0xD0, 0x24)
        case .lack:
            color = Common.makeColor(0xD0, 0x1B, 0x1B)
        }
        
        return color
    }
}
